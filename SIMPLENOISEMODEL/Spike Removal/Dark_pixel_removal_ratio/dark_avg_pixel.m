function [im_dpix_mean]=dark_avg_pixel(imageName,headerName,opt)
%read whole image
[im_uc,~]=enviread(imageName,headerName);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[rim,~,bands]=size(im_uc);
%%
%pick all those points of low intensity-in the first band
im_uc_band1=im_uc(:,:,1);
lim=min(min(im_uc_band1))+0.0085;
A=find(im_uc_band1<lim);
%rewrite this set into row_no and column no.
col_no1=ceil(A./rim);
temp=col_no1-1;
sub_no=temp.*rim;
row_no1=A-sub_no;
b1_coords=[row_no1 col_no1];


%pick all those points of low intensity-in the last band
im_uc_bandp=im_uc(:,:,bands);
lim=min(min(im_uc_bandp))+0.03;
A=find(im_uc_bandp<lim);
%rewrite this set into row_no and column no.
col_nop=ceil(A./rim);
temp=col_nop-1;
sub_no=temp.*rim;
row_nop=A-sub_no;
bp_coords=[row_nop col_nop];


[C] = intersect(b1_coords,bp_coords,'rows');

%pick all those points of low intensity-in the band where maximum occurs
%the band in which the maximum value occurs
ll=max(max(im_uc));
ll=squeeze(ll);
[~,idx]=sort(ll,'descend');
idx=idx(1);

im_uc_bandmax=im_uc(:,:,idx);
lim=min(min(im_uc_bandmax))+0.03;
A=find(im_uc_bandmax<(lim));
%rewrite this set into row_no and column no.
col_nomax=ceil(A./rim);
temp=col_nomax-1;
sub_no=temp.*rim;
row_nomax=A-sub_no;
bmax_coords=[row_nomax col_nomax];


[C] = intersect(C,bmax_coords,'rows');

%pick all those points of low intensity-in the band where minimum occurs
%the band in which the maximum value occurs
ll=min(min(im_uc));
ll=squeeze(ll);
[~,idx]=sort(ll,'ascend');
idx=idx(1);

im_uc_bandmin=im_uc(:,:,idx);
lim=min(min(im_uc_bandmin))+0.03;
A=find(im_uc_bandmin<(lim));
%rewrite this set into row_no and column no.
col_nomin=ceil(A./rim);
temp=col_nomin-1;
sub_no=temp.*rim;
row_nomin=A-sub_no;
bmin_coords=[row_nomin col_nomin];


[C] = intersect(C,bmin_coords,'rows');

[r,~]=size(C);
%%
%pick out these dark pixel spectra
for i=1:r
    im_uc_dpix(:,i)=im_uc(C(i,1),C(i,2),:);
end
im_uc_dpix=im_uc_dpix';
%%
im_dpix_mean=mean(im_uc_dpix);

end

