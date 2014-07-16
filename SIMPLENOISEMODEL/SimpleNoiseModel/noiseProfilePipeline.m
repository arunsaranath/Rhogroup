clear all
close all
clc
%%
%the address of the image
folderName   = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\' ;
imageName  = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
headerName = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img.hdr'; 


writeOption = 0;
fnameIn  = strcat(folderName,imageName) ;
headerName = strcat(folderName,headerName);
%%
% %calculate effect of removing the column noise profile
% dbstop in colNoiseProfileCalc.m
[fnameOut, colNoiseProfile] = colNoiseProfileCalc(fnameIn,writeOption,imageName);
%%
%perform despiking for the entire
fnameIn = fnameOut;
% coarse despiking
% dbstop in coarsedeSpiking.m
[fnameOut] = coarsedeSpiking(fnameIn);
fnameIn = fnameOut;
%%
%neighbor hood based despiking
 [im_uc_spk_corr]=despikingImages(fnameIn);
 %%
 [~,info] = enviread(fnameIn);
fnameOut  = regexprep(fnameIn,'.img','_dspk.img');

 %write the image
if(writeOption == 0)  
    i = enviwrite2(im_uc_spk_corr,fnameOut,info);
end