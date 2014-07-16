clear all
close all
clc
%%
%read in the image
%the address of the image
folderName   = 'E:\IMAGES\CRISM\Bethany Images\17F45_precleaned\' ;
imageName  = 'FRT00017F45_07_IF167L_TRR3_LA_fix_65sGone_b18_248.img';
headerName = 'FRT00017F45_07_IF167L_TRR3_LA_fix_65sGone_b18_248.img.hdr'; 
fnameIn  = strcat(folderName,imageName) ;
%%
dbstop in colNoiseProfileCalc.m
[fnameOut, meanColSmooth] = colNoiseProfileCalc(fnameIn,0, imageName);
%%
%read the image
[im,info]  = enviread(fnameIn);

%the size of the image is 
[lines,samples,bands] = size(im) ;
%%
%lets despike a column and correct for it
col = 42;
for i=2:507
    Y = im((i-1):(i+1),(col-1):(col+1),:);
    
    colDespiked(:,i) = spikeLocFcn(Y,231);
end
%%
meanDespikedSpectra = mean(colDespiked');
%%
temp = squeeze(im(:,col,:));
meanSpectra = mean(temp);

%%
wvl =  wvl_CRISM_Crop();


figure()
plot(wvl, meanSpectra,'b-')
hold all
plot(wvl, meanDespikedSpectra,'r-')
%%
%do spline approximation
spline1 = spap2(1,20,wvl,meanSpectra); 
coeffs=spline1.coefs;

spline2 = spap2(1,20,wvl,meanDespikedSpectra); 
coeffs2=spline2.coefs;
   
%interpret the signal over the range of the wavelength
meanSmooth = fnval(spline1,wvl);

meanDespikedSmooth = fnval(spline2,wvl);
%%
figure()
plot(wvl,meanSpectra ,'b-')
hold all
plot(wvl,meanDespikedSpectra,'r--') 
plot(wvl,meanSmooth,'k-')
plot(wvl,meanDespikedSmooth,'g-.')
legend('Original Mean Spectra','Despiked Mean Spectra','Smoothed Mean Spectra',...
     'Smoothed Despiked Mean Spectra');
xlabel('wavelength');ylabel('reflectance')
title('Effect of despiking of Smoothing')
 