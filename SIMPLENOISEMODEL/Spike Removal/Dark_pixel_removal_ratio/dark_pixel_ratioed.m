clear all
close all
clc

str1= 'E:\IMAGES\CRISM\MTRDR\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358.img';
fnameIn = strcat(str1, str2);
opt=2;

%read image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[rim,cim,bands]=size(im_uc);

%find the darkest avg pixel
[im_dpix_mean]=dark_avg_pixel_mod(fnameIn,opt);
Y_dp=repmat(im_dpix_mean,(rim*cim),[]);
Y_dp=Y_dp';

%find the power of the dark signal
y_norm=norm(im_dpix_mean);
y_pow=y_norm/bands;

%
y_mean=mean(im_dpix_mean);
%convert cube into matrix 
Y=cube2mat(im_uc,'row'); 

%divide all pixels by dark pixels
Y_ddiv=Y./Y_dp;

im_ddiv=mat2cube(Y_ddiv,rim,cim,'row');

%%
i=108;
j=47;
figure()
plot((1:231),squeeze(im_uc(i,j,:)));
figure()
plot((1:231),squeeze(im_ddiv(i,j,:)));

