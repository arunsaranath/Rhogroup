function[noiseRowMean, noiseRowSmooth] = colNoiseProfileCorr(fNameOrig, fNameDeNoised)
%%
%colNoiseProfileCalc.m
% This function attempts to calculate the noise profile for each individual
% column and remove that profile from each column
%  ------------------------------------------------------------------------------------------------------  
%  Input Parameters
%  ------------------------------------------------------------------------------------------------------
%  fnameOrig                  :- Address of the original image
%  fnameDeNoised        :- Address of the de-noised image
% -------------------------------------------------------------------------------------------------------
% Output Parameters
% -------------------------------------------------------------------------------------------------------
% fnameOut              :- name out image to be saved based on options chosen
% -------------------------------------------------------------------------------------------------------

%Function Created :- 01 / 02 / 2014
%Author's Name     :- Arun M Saranathan
%-------------------------------------------------------------------------------------------------------%

%read in both the original and denoised image
imOrig = enviread(fNameOrig);
[imDeNoised,info] = enviread(fNameDeNoised);
[r,c,b] = size(imOrig);

%now find the noise profile in each band
% figure()
for i=1:b
    imNoiseProfile(:,:,i) = squeeze(imOrig(:,:,i)) - squeeze(imDeNoised(:,:,i)) ;
    %calculate the mean Row Noise Profile
    noiseRowMean(i,:) = mean(squeeze(imNoiseProfile(:,:,i)));
    
    
    
    %now find a smooth approximation to of this noise - neglecting the 2- noisy
    %bands in the end
    spline1 = spap2(1,15,(1:c-2),noiseRowMean(i,1:c-2)); 
    coeffs=spline1.coefs;
    
    %interpret the signal over the range of the colkumns
    temp = fnval(spline1,(1:c-2));
    noiseRowSmooth(i,:) = [temp temp(end) temp(end)];
    
%     plot(noiseRowMean(i,:))
%     hold all
%     plot(noiseRowSmooth(i,:))
%     
%     pause(0.8)
%     hold off
end

%now re-add the smoothed column score
imMod = zeros(size(imDeNoised));
for i=1:r
    for j =1:b
        tempRow = squeeze(imOrig(i,:,j));
        %now add back the noise 
        tempRow = tempRow - noiseRowSmooth(j,:);
        
        imMod(i,:,j) = tempRow;
    end
end
%now write this image in dcRemImage
fNameOut = regexprep(fNameDeNoised,'.img','_colNoiseRem.img');

i = enviwrite2(imMod,fNameOut,info);
end