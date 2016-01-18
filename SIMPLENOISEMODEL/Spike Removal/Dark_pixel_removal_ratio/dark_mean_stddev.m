clear all
clc
%load your image 
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;

%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[rim,cim,bands]=size(im_uc);
%%
%pick all those points of low intensity-in the first band
im_uc_band1=im_uc(:,:,1);
lim=min(min(im_uc_band1))+0.03;
A=find(im_uc_band1<lim);
%rewrite this set into row_no and column no.
col_no1=ceil(A./rim);
temp=col_no1-1;
sub_no=temp.*rim;
row_no1=A-sub_no;
b1_coords=[row_no1 col_no1];
clear A temp row_no1 col_no1

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
clear A temp  row_nop col_nop

[C,ia,ib] = intersect(b1_coords,bp_coords,'rows');

%pick all those points of low intensity-in the band where maximum occurs
%the band in which the maximum value occurs
ll=max(max(im_uc));
ll=squeeze(ll);
[valx,idx]=sort(ll,'descend');
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
clear A temp  row_nop col_nop

[C,ia,ib] = intersect(C,bmax_coords,'rows');

%pick all those points of low intensity-in the band where minimum occurs
%the band in which the maximum value occurs
ll=min(min(im_uc));
ll=squeeze(ll);
[valx,idx]=sort(ll,'ascend');
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
clear A temp  row_nop col_nop ll lim

[C,ia,ib] = intersect(C,bmin_coords,'rows');

[r,~]=size(C);
%%
%pick out these dark pixel spectra
for i=1:r
    im_uc_dpix(:,i)=im_uc(C(i,1),C(i,2),:);
end
im_uc_dpix=im_uc_dpix';
%%
im_dpix_mean=mean(im_uc_dpix);

[~,idx]=sort(im_uc_dpix(:,1),'ascend');
im_dpix_min=im_uc_dpix(idx(1),:);

[~,idx]=sort(im_uc_dpix(:,1),'descend');
im_dpix_max=im_uc_dpix(idx(1),:);

%%
xax=(1047.199951:6.55:2648.340088);
xax=xax(1:bands);
figure()
plot(xax,im_dpix_mean,xax,im_dpix_min,xax,im_dpix_max)
hleg1 = legend('Average Dark Pixel','Lowest Intensity Dark Pixel',...
    'Highest Intensity Dark Pixel');
grid on
title('Dark-Pixels Selected fro image FRT000094F6')
%%
 b=std2(im_uc_dpix);
bb=std(im_uc_dpix,0,1);

figure()
plot(xax,bb)
title('standard deviation for each band')

%%
% Pick Bright Pixel
x=284;
y=474;
Y_bright=im_uc(x,y,:);
Y_bright=squeeze(Y_bright);
%look at the first 50 dark pixels
figure()
hold all
for i=1:50
    plot(xax,im_uc_dpix(i,:))
end
plot(xax,Y_bright)
axis([1000 2600 0 0.4])
hold off
grid on
title('50 darkest pixels and brightest')
