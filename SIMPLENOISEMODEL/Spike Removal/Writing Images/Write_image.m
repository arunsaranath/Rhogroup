clear all
close all
clc
%load your image 
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked_ratioed.img';
fnameIn = strcat(str1, str2);
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[lines,samples,bands]=size(im_uc);

%%
%if not already open matlab pool
sz = matlabpool('size');
if(sz == 0)
   matlabpool local 4 
end

%initailize despike image to the original image. This was the pixels at the
%edge will have noisy spectra instead of all 0.
im_uc_spk_corr=im_uc;

%now perform despiking
for i=3:(lines-2)    
    parfor j=3:(samples-2)
       tic,
       %pick a ROI of the pixels and it's nearest neighbors
       Y=im_uc((i-1:i+1),(j-1:j+1),:);
       %perform despiking
       temp = spikeLocFcn(Y,bands);
       im_uc_spk_corr(i,j,:) = temp;
       toc
    end    
end

if(sz ~= 0)
   matlabpool close
end
%%

