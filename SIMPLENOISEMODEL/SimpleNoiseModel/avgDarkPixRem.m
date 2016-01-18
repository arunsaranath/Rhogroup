clear all
close all
clc
%%
%the address of the image
folderName   = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\' ;
imageName  = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
headerName = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img.hdr'; 

imgName  = strcat(folderName,imageName) ;
headerName = strcat(folderName,headerName);

%read in the image
[im,info]  = enviread(imgName, headerName);
[im_dpix_mean]=dark_avg_pixel(imgName,2);

%the size of the image is 
[lines,samples,bands] = size(im) ;

wavelength =  wvl_CRISM_Crop();
spline1 = spap2(1,25,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);

clear folderName headerName imgName
%%
wvl = wvl_CRISM_Crop();
fig = figure();
plot(wvl,im_dpix_mean,'r--')
hold on
plot(wvl,yy')
temp = regexprep(imageName,'_', '-');
str = strcat(' the average dark pixel is: -', temp);
title(str)
%%
im_Mod = zeros(lines,samples,bands);
%subtract this average from each pixel in the image
for i=1:lines
    for j=1:samples
            temp = squeeze(im(i,j,:));
            im_Mod(i,j,:) = temp - im_dpix_mean' + yy';
    end
end
%%
fnameOut = regexprep(imageName,'.img','_darkNoiseRem.img');
fnameOut = strcat('dcRemImage\',fnameOut);

i = enviwrite2(im_Mod,fnameOut,info);