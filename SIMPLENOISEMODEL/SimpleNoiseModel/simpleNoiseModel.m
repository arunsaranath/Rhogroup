clear all
close all
clc
%%
%the address of the image
folderName   = 'E:\IMAGES\CRISM\Bethany Images\FRT00017F45_07_IF167L_TRR3\' ;
imageName  = 'FRT00017F45_07_IF167L_TRR3_BATCH_CAT_corr_crop.img';
headerName = 'FRT00017F45_07_IF167L_TRR3_BATCH_CAT_corr_crop.img.hdr'; 

imgName  = strcat(folderName,imageName) ;
headerName = strcat(folderName,headerName);

%read in the image
[im,info]  = enviread(imgName, headerName);
% dbstop in dark_avg_pixel.m
[im_dpix_mean]=dark_avg_pixel(imgName,headerName,2);

clear folderName headerName imgName
%%

%the size of the image is 
[lines,samples,bands] = size(im) ;

%calculate the average for each band
bandAvgSpectra = zeros(bands,1);

for i=1:bands
    bandAvgSpectra(i,1) = mean(mean(squeeze(im(:,:,i)))) ;
end

wavelength =  wvl_CRISM_Crop();
wvl = wavelength;
spline1 = spap2(1,25,wavelength,bandAvgSpectra); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);

%%
fig = figure();
plot(wvl,bandAvgSpectra)
hold all
plot(wvl,yy,'r--')
temp = regexprep(imageName,'_', '-');
str = strcat(' the constant spectral component for: -', temp);
title(str)
xlabel('wavelength'); ylabel('reflectance')
savFigName =  regexprep(imageName,'.img','.png');
temp1 = strcat('avgImageSpectra\',imageName);
temp1 = regexprep(temp1,'.img','.jpg');
saveas(fig,temp1)


%%
im_Mod = zeros(lines,samples,bands);
%subtract this average from each pixel in the image
for i=1:lines
    for j=1:samples
            temp = squeeze(im(i,j,:)) ;
            mult = mean(temp) / mean(bandAvgSpectra);
            im_Mod(i,j,:) =  temp - (mult*bandAvgSpectra) +(mult*yy');
    end
end
%%
fnameOut = regexprep(imageName,'.img','_dcRemslp_coeffMult.img');
fnameOut = strcat('dcRemImage\',fnameOut);

i = enviwrite2(im_Mod,fnameOut,info);