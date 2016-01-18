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
% meanCol = imgAvg(im,2);
% %%
% spectra = meanCol(:,17);
row =185;
col = 42;
spectra = squeeze(im(row,col,:));
% dbstop in  despikeSpectra.m
[spectraDespiked] = despikeSpectra(spectra);
%%
%now generate a 10-spectel wide boxcar window
w =  rectwin(10) ;

%now convolve the spectra with the boxcar function to get
%the filtered spectra:- spectraF
spectraF = ncfilter(spectraDespiked',w);

w1 = rectwin(40);
spectraF1 = ncfilter(spectraDespiked',w1);

wvl =  wvl_CRISM_Crop();
spline1 = spap2(1,30,wvl,spectraDespiked); 
coeffs=spline1.coefs;
spectraSmooth = fnval(spline1,wvl);
%%
figure()
plot(wvl,spectraDespiked,'b-') 
hold all
plot(wvl,spectraSmooth,'g-.')
plot(wvl,spectraF,'r--')
plot(wvl,spectraF1,'k--')