clear all
close all
clc
%%
%read in the image
%the address of the image
folderName   = 'E:\IMAGES\CRISM\Bethany Images\FRT00017F45_07_IF167L_TRR3\' ;
imageName  = 'FRT00017F45_07_IF167L_TRR3_BATCH_CAT_corr_crop.img';
headerName = 'FRT00017F45_07_IF167L_TRR3_BATCH_CAT_corr_crop.img.hdr'; 
fnameIn  = strcat(folderName,imageName) ;

%read the image
[im,info]  = enviread(fnameIn);

%the size of the image is 
[lines,samples,bands] = size(im) ;

% %calculate the average column-spectra
meanCol = imgAvg(fnameIn,2);
%%
% spectra = meanCol(:,42);
row =28;
col = 42;
spectra = squeeze(im(row,col,:));
Y = im((row-1):(row+1),(col-1):(col+1),:);
[spectraDespiked] = despikeSpectra(spectra);
[spectraDespikedNeigh] = spikeLocFcn(Y,231);
%%
wvl =  wvl_CRISM_Crop();
figure()
plot(wvl,spectra,'b-')
hold all
plot(wvl,spectraDespiked,'r-.')
plot(wvl,spectraDespikedNeigh,'y-')
