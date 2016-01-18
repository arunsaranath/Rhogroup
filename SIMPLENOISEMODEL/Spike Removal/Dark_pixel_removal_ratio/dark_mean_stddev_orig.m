%clear all
clc
%load your image 
% fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
% opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
%%
%pick all those points of low intensity
im_uc_band1=im_uc(:,:,1);
A=find(im_uc_band1<0.1400);
[rim,~,p]=size(im_uc);
%rewrite this set into row_no and column no.
col_no=ceil(A./rim);
temp=col_no-1;
sub_no=temp.*rim;
row_no=A-sub_no;
[r,~]=size(row_no);
% pick a thousand random numbers between 1 and 9148
% idx=randi([1 r],1000,1);
% idx=unique(idx);
% row_no=row_no(idx);
% col_no=col_no(idx);
% [r1,~]=size(col_no);
%%
%pick out these dark pixel spectra
for i=1:r
    im_uc_dpix(:,i)=im_uc(row_no(i),col_no(i),:);
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
xax=xax(1:p);
figure()
plot(xax,im_dpix_mean,xax,im_dpix_min,xax,im_dpix_max)
hleg1 = legend('Average Dark Pixel','Lowest Intensity Dark Pixel',...
    'Highest Intensity Dark Pixel');
grid on
title('Dark-Pixels Selected fro image FRT0000A819')
%%
 b=std2(im_uc_dpix);
bb=std(im_uc_dpix,0,1);

figure()
plot(xax,bb)
title('standard deviation for each band')

%%
Y_do=im_dpix_mean';

% Pick Bright Pixel
x=284;
y=474;
Y_bright=im_uc(x,y,:);
Y_bright=squeeze(Y_bright);

%remove Dark-object
Y_d_rem=Y_bright-Y_do;

figure
subplot(3,1,1)
plot(xax,Y_do)
hleg1 = legend('Dark Pixel');
grid on
axis([1000 2700 0.1 0.2])
subplot(3,1,2)
plot(xax,Y_bright)
s=sprintf('bright pixel @ x=%d and y=%d',x,y);
hleg2=legend(s);
grid on
axis([1000 2700 0.27 0.37])
subplot(3,1,3)
plot(xax,Y_d_rem)
hleg3=legend('Bright Pixel with dark removed');
grid on
axis([1000 2700 0.14 0.24])