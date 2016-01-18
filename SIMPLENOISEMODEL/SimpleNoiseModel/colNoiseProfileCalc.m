function [fnameOut, meanColSmooth] = colNoiseProfileCalc(fnameIn,writeOption, imageName)
%%
%colNoiseProfileCalc.m
% This function attempts to calculate the noise profile for each individual
% column and remove that profile from each column
%  ------------------------------------------------------------------------------------------------------  
%  Input Parameters
%  ------------------------------------------------------------------------------------------------------
%  fnameIn        :- Address of image
% writeOption   :- Whether the image should be written or not
% imageName :- Name of the Image
% -------------------------------------------------------------------------------------------------------
% Output Parameters
% -------------------------------------------------------------------------------------------------------
% fnameOut              :- name out image to be saved based on options chosen
% colnoiseProfile     :- the noiseProfile being Subtracted from each column
% -------------------------------------------------------------------------------------------------------

%Function Created :- 08 / 21 / 2013
%Author's Name     :- Arun M Saranathan

%read the image
[im,info]  = enviread(fnameIn);

%the size of the image is 
[lines,samples,bands] = size(im) ;

%calculate the average column-spectra
meanCol = imgAvg(fnameIn,2);

meanColDespiked = zeros(size(meanCol));
for i=1:samples
    %perform a despiking
%     dbstop in despikeSpectra.m
     [meanColDespiked(:,i)] = despikeSpectra(meanCol(:,i));
end

%calculate the smoothed average column spectra
wvl =  wvl_CRISM_Crop();
for i=1:samples
    %perform a spline approximation of this spectra
    spline1 = spap2(1,20,wvl,meanColDespiked(:,i)); 
    coeffs=spline1.coefs;
    
    %interpret the signal over the range of the wavelength
    meanColSmooth(:,i) = fnval(spline1,wvl);    
    clc
end

%calculate the noise profile for each column
noiseProfile =  meanCol - meanColSmooth ;
% noiseProfile(abs(noiseProfile) < 0.003) = 0;

%create modified image
im_Mod = zeros(lines,samples,bands);
%subtract this average from each pixel in the image
for j=1:samples
    temp = noiseProfile(:,j);
    for i=1:lines
            mult = mean(squeeze(im(i,j,:))) / mean(meanCol(:,j));
            im_Mod(i,j,:) = squeeze(im(i,j,:)) - (mult*temp);
    end
end

%file title
 fnameOut  = regexprep(imageName,'.img','_colAvg20.img');
 fnameOut  = strcat('dcRemImage/',fnameOut);
 %write the image
if(writeOption == 0)  
%     dbstop in enviwrite2.m
    i = enviwrite2(im_Mod,fnameOut,info);
end

end