clear all
close all
clc
%%
%the address of the image
folderName   = 'C:\Users\arunsaranath\SkyDrive\SimpleNoiseModel\dcRemImage\' ;
imageName  = 'FRT0001791F_07_IF165L_TRR3_BATCH_CAT_corr_cropf_bandAvg_Coeff.img';
headerName = 'FRT0001791F_07_IF165L_TRR3_BATCH_CAT_corr_cropf_bandAvg_Coeff.img.hdr';  

imgName  = strcat(folderName,imageName) ;
headerName = strcat(folderName,headerName);

%read in the image
[im,info]  = enviread(imgName, headerName);

%the size of the image is 
[lines,samples,bands] = size(im) ;

%calculate the average for each band
    avgSpectra = zeros(bands,1);   
    %avg image spectra
    for i=1:bands
        avgSpectra(i,1) = mean(mean(squeeze(im(:,:,i)))) ;        
    end
    avgSpectra = avgSpectra';
%%
%the size of the image is 
[lines,samples,bands] = size(im) ;

meanCol = imgAvg(im,2);
%%
wvl =  wvl_CRISM_Crop();
figure()
for i=1:lines
    subplot(2,1,1)
    plot(wvl,meanCol(:,i));
    drawnow
    subplot(2,1,2)
    plot(wvl,avgSpectra);
    pause(0.1)
end