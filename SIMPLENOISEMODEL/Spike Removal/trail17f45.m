clear all
close all
clc
%%
fnameIn = 'C:\Users\arunsaranath\SkyDrive\SimpleNoiseModel\dcRemImage\FRT00017F45_07_IF167L_TRR3_BATCH_CAT_corr_crop_colAvg.img';

%read whole image
[im_uc,info]=enviread(fnameIn);
%pick the size of the image
[lines,samples,bands]=size(im_uc);
% %%
% i=195; j=403;
% Y=im_uc((i-1:i+1),(j-1:j+1),:);
% 
% [temp_corr] = spikeLocFcn(Y,bands) ;
% 
% temp = squeeze(im_uc(i,j,:));
% 
% figure()
% plot(temp)
% hold all
% plot(temp_corr)
%%
[im_uc_spk_corr] = despikingImages(fnameIn);

fnameOut = regexprep(fnameIn,'.img','_despike.img');
%%
enviwrite2(im_uc_spk_corr,fnameOut,info);



