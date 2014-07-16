function [fnameOut , noiseProfile] = noiseProfileCalc(imgName, headerName, imageName,opt, scale, display)

%%
%  noiseProfileCalc.m
%  this function calculates the noise profile and subtracts the noise profile
%  ------------------------------------------------------------------------------------------------  
%  Input Parameters
%  ------------------------------------------------------------------------------------------------
%  imgName        :- Name/Address of image
%  headerName  :- Name/Address of header
%  imageName   
%  opt                   :- are we using the average spectra or the average dark
%              = 1       :- average image spectra
%              = 2       :- average dark pixel spectra
%  scale               :- the multiplier for the for the noise profile
%              = 1       :- the multiplier in this case is 1
%              = 2       :- the multiplier in this case is the ratio between
%                          the average pixel and the pixel at hand
%  display            :- whether plotting or not
%              = 0       :- dont display
%              = 1       :- display
% --------------------------------------------------------------------------------------------------
% Output Parameters
% --------------------------------------------------------------------------------------------------
% fnameOut         :- name out image to be saved based on options chosen
% noiseProfile     :- the noiseProfile being Subtracted
% ---------------------------------------------------------------------------------------------------
%
%Function Created :- 08 / 18 / 2013
%Author's Name     :- Arun M Saranathan

%read in the image
[im,info]  = enviread(imgName, headerName);
im = im(:,:,1:231);

%the size of the image is 
[lines,samples,bands] = size(im) ;


%choose average spectra or average dark spectra
if (opt == 1)
    %calculate the average for each band
    avgSpectra = zeros(bands,1);
    fnameOut  = regexprep(imageName,'.img','_bandAvg.img');
    %avg image spectra
    for i=1:bands
        avgSpectra(i,1) = mean(mean(squeeze(im(:,:,i)))) ;        
    end
    avgSpectra = avgSpectra';
%choose average dark pixel spectra
else
    [avgSpectra]=dark_avg_pixel(imgName,headerName,2);
    fnameOut  = regexprep(imageName,'.img','_darkAvg.img');
end

wavelength =  wvl_CRISM_Crop();
wvl = wavelength;
spline1 = spap2(1,30,wavelength,avgSpectra); 
coeffs=spline1.coefs;
avgSpectraSmooth = fnval(spline1,wavelength);

noiseProfile =  avgSpectra - avgSpectraSmooth ;

temp11 = regexprep(fnameOut,'_',' ');
temp1 = strcat('avgImageSpectra\',temp11);
temp1 = regexprep(temp1,'.img','.jpg');
if(display==1)
    fig = figure();
    subplot(2,1,1)
    plot(wvl, avgSpectra)
    hold all
    plot(wvl, avgSpectraSmooth)
     xlabel('wavelength');ylabel('I/F value')
    str = sprintf('difference between noisy and smoothed average %s',temp11);
    title(str)
    subplot(2,1,2)
    plot(wvl,noiseProfile)
    xlabel('wavelength');ylabel('I/F noise profile')
    str = sprintf('Noise profile for %s',temp1);
    title(str)
    saveas(fig,temp1)
end

im_Mod = zeros(lines,samples,bands);
%subtract this average from each pixel in the image
for i=1:lines
    for j=1:samples
            if(scale == 1)
                mult = 1;
                if((i==1) && (j==1))
                    fnameOut  = regexprep(fnameOut,'.img','_noCoeff.img');
                end
            else
                mult = mean(squeeze(im(i,j,:))) / mean(avgSpectra);
                if((i==1) && (j==1))
                    fnameOut  = regexprep(fnameOut,'.img','_Coeff.img');
                end
            end
             
            im_Mod(i,j,:) = squeeze(im(i,j,:)) - (mult*noiseProfile');
    end
end

fnameOut = strcat('dcRemImage\',fnameOut);

i = enviwrite2(im_Mod,fnameOut,info);

end
