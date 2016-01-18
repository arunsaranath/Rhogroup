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
colNo = 516;

Y = squeeze(im(:,colNo,:));

 %%
 %pick 4 subsets
% Y1 = Y(1:127, :);
% Y2 = Y(128:255, :);
% Y3 = Y(256:383,:);
% Y4 = Y(384:end,:);
%pick at random
idxSet = randperm(508);

Y1 = Y(idxSet(1:127),:);
Y2 = Y(idxSet(128:255),:); 
Y3 = Y(idxSet(256:383),:); 
Y4 = Y(idxSet(384:end),:); 
%%
%calculate means
Ymean(1,:) = mean(Y1);
Ymean(2,:) = mean(Y2);
Ymean(3,:) = mean(Y3);
Ymean(4,:) = mean(Y4);
%%
count =1;
for i=1:3
    for j=i+1:4
      Yratio(count,:)   = Ymean(i,:) ./ Ymean(j,:);
      count = count +1 ;
    end
end

%%
wvl =  wvl_CRISM_Crop();
figure()
plot(wvl,Yratio)
title('ratio')

figure()
plot(wvl,Ymean)
title('mean')

%%

for j=1:6
figure()
plot(wvl,(Ymean(2,:)./Yratio(j,:)))
hold all
plot(wvl,Ymean(2,:))
end
