function [im_dpix_mean im_mask C]=dark_avg_pixel_mod(fnameIn,opt)
%% 
%-------------------------------------------------------------------------%
%the function can only be called as : -
% [im_dpix_mean im_mask C]=dark_avg_pixel_mod(fnameIn,opt)
%
%Inputs
%fnameIn : -  is the ADDRESS of the Image for which we are calculating 
%             average dark pixel
% opt    : - Option for kind of image :- 1 if not cropped
%                                        2 is is  cropped
%
%Outputs
% im_dpix_mean : - mean dark pixel in the image
% im_mask      : - mask indicating the location of the dark pixel
% C            : - index of dark pixels
%-------------------------------------------------------------------------%
%%
%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[rim,cim,bands]=size(im_uc);

%initialize the mask
im_mask=ones(rim,cim);
%%
%pick all those points of low intensity-in the band where maximum occurs
%the band in which the maximum value occurs
ll=max(max(im_uc));
ll=squeeze(ll);
[~,idx]=sort(ll,'descend');
idx=idx(1);

%from this band pick only the darkest pixels
im_uc_bandmax=im_uc(:,:,idx);
lim=min(min(im_uc_bandmax))+0.03;
A=find(im_uc_bandmax<(lim));

%rewrite this set into row_no and column no.
col_nomax=ceil(A./rim);
temp=col_nomax-1;
sub_no=temp.*rim;
row_nomax=A-sub_no;
bmax_coords=[row_nomax col_nomax];

%pick all those points of low intensity-in the band where minimum occurs
%the band in which the maximum value occurs
ll=min(min(im_uc));
ll=squeeze(ll);
[~,idx]=sort(ll,'ascend');
idx=idx(1);

%from this band pick only the darkest pixels
im_uc_bandmin=im_uc(:,:,idx);
lim=min(min(im_uc_bandmin))+0.06;
A=find(im_uc_bandmin<(lim));

%rewrite this set into row_no and column no.
col_nomin=ceil(A./rim);
temp=col_nomin-1;
sub_no=temp.*rim;
row_nomin=A-sub_no;
bmin_coords=[row_nomin col_nomin];

% pick only those pixels that have low value in both these or are
% consistently low values
[C] = intersect(bmax_coords,bmin_coords,'rows');

[r,~]=size(C);
%%
%pick out these dark pixel spectra
for i=1:r
    im_uc_dpix(:,i)                = squeeze ( im_uc(C(i,1),C(i,2),:) ) ;
    im_mask(C(i,1),C(i,2))         = 0 ;
end
im_uc_dpix=im_uc_dpix';
im_dpix_mean=mean(im_uc_dpix);

end