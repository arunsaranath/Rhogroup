clear all
close all
clc
%load your image 
%spike removal pipeline
%input :- address of the Image
fnameInFull='E:\IMAGES\CRISM\MTRDR\FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone.img';

%if full image then opt=1 if cropped image opt=2;
opt=1;

%read the image
[im,info]=enviread(fnameInFull);
wavelength_full=CRISM_full();
%crop out only the required bands
if(opt==1)
    im_uc=im(:,:,18:248);
    wavelength = wavelength_full(18:248);
end
[lines,samples,bands]=size(im_uc);

clear im wavelength_full
%%
%allocate memory for the corrected image
im_uc_spk_corr=zeros(size(im_uc));
%%
%if not already open matlab pool
sz = matlabpool('size');
if(sz == 0)
   matlabpool local 2 
end
%%
for i=2:(lines-1)    
    parfor j=2:(samples-1)
%         [Y ~]=pickROI(fnameIn,opt,i,j,1,0);
        tic,
        %pick a ROI of the pixels and it's nearest neighbors
        Y=im_uc((i-1:i+1),(j-1:j+1),:);
        %perform despiking
        temp = spikeLocFcn(Y,bands);
        im_uc_spk_corr(i,j,:) = temp;
        toc        
    end    
end
%%
if(sz ~= 0)
   matlabpool close
end
%%
%give name under which file is to be written
fnameOut='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked.img';
infod=info;
infod.bands=231;

%write the image
i=enviwrite2(im_uc_spk_corr,fnameOut,infod);
