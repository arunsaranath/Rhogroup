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

%read the image
[im,info]  = enviread(imgName);
%%
col = 356;
for j=1:600
    for i=2:508
        diff(i,:) = squeeze(im(i-1,j,:)) - squeeze(im(i,j,:));
    end
    meanDiff(j,:) = mean(diff);
end
%%
imMod = zeros(size(im));
for i=1:508
    for j=1:600
         imMod(i,j,:) = squeeze(im(i,j,:)) - meanDiff(j,:)';
    end
    clc
end
%%
fnameOut = regexprep(imgName,'.img','_avgDiff.img');
 i = enviwrite2(imMod,fnameOut,info);

%%
wvl =  wvl_CRISM_Crop();
figure()
for i=1:508
    hold all
    plot(wvl,diff(i,:));
%     axis([1.1 2.6 -0.05 0])
%     drawnow
%     pause(0.5)     
end
 
%%
meanDiff = mean(diff);

figure()
plot(wvl,meanDiff);
title('average difference')