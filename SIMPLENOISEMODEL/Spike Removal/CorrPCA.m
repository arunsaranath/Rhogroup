tic,
clear all
close all
clc

%load your image 
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2; chunk=0;
%read whole image
[im_uc,info]=enviread(fnameIn);

if (opt==1)
%     load original_image.mat
    im_uc=im_uc(2:449,32:631,115:359);
    im=im_uc(201:300,301:400,:);
%     im_uc=im_uc(:,:,10:240);
%     im=im_uc(251:350,251:350,:);
else
    im=im_uc(201:300,301:400,:);
end
[r,c,bands]=size(im_uc);
%look at the whole space
figure()
imagesc(im_uc(:,:,1));colormap(gray)
%visualize band-1 of cut image
figure()
imagesc(im(:,:,1));colormap(gray)
Y=cube2mat(im_uc,'row'); 
Y1=cube2mat(im,'row');
%[r,c]=size(Y);
clear im_uc im
%%
%calculate correlation coefficient-across pixels
tic,
    R=corrcoef(Y1);
toc
figure()
imagesc(R);colormap(gray)
colorbar
%%
%calculate correlation coefficient-across bands
tic,
    R_bands=corrcoef(Y');
toc
figure()
imagesc(R_bands);colormap(gray)
colorbar

%%
%clear the correlation matrix. . .  to ensure space in the workspace
% tic,
%     save R.mat
%     clear R
% toc
%ATTEMPT PCA
[PCA_mat_COEFF PCA_mat_SCORE latent1]=princomp(Y');
l=cumsum(latent1)./sum(latent1);
%make it back into an image and compare the Principal components
im_PCA=mat2cube(PCA_mat_SCORE',r,c,'row');
%%

%make a video of the first 25-PCS
%plot the first principal-component and use as the base
p=figure();
imagesc(im_PCA(:,:,1));colormap('gray')

%Record size of the plot window
winsize=get(p,'Position');
%adjust size of window to include entire figure
winsize(1:2)=[0 0];
%set the number of frames
numframes=50;
%create matlab movie matrix
A=moviein(numframes,p,winsize);
%fix features of plot window
set(p,'NextPlot','replacechildren')
%plot all frames
for i=1:numframes
    imagesc(im_PCA(:,:,i)); %plot command
    %title('Image for the %d th PC',i);
    A(:,i)=getframe(p,winsize);
end
close(p)
%%
%plot-matrix to analyse the shape of data
%dbstop in plotmatrix.m
figure()
plotmatrix(PCA_mat_SCORE(:,1:15));
if(chunk==1)
    splitPlotMatrix(PCA_mat_SCORE(:,1:15),3)
end
%%
%ATTEMPT PCA-split scene
[PCA_mat1_COEFF PCA_mat1_SCORE latent]=princomp(Y1');
%make it back into an image and compare the Principal components
im1_PCA=mat2cube(PCA_mat1_SCORE',100,100,'row');

%%
%make a video of the first 25-PCS
%plot the first principal-component and use as the base
p1=figure();
imagesc(im1_PCA(:,:,1));colormap('gray')

%Record size of the plot window
winsize1=get(p1,'Position');
%adjust size of window to include entire figure
winsize1(1:2)=[0 0];
%set the number of frames
numframes=50;
%create matlab movie matrix
A_split=moviein(numframes,p1,winsize1);
%fix features of plot window
set(p1,'NextPlot','replacechildren')
%plot all frames
for i=1:numframes
    imagesc(im1_PCA(:,:,i)); %plot command
    %title('Image for the %d th PC',i);
    A_split(:,i)=getframe(p1,winsize1);
end
close(p1)
%%
%play movie-full scene
implay(A,0.5)
%play movie-cut scene
implay(A_split,0.5)
%%
figure()
subplot(3,3,1)
imagesc(im_PCA(:,:,1));colormap(gray);title('PC-1')
subplot(3,3,2)
imagesc(im_PCA(:,:,2));colormap(gray);title('PC-2')
subplot(3,3,3)
imagesc(im_PCA(:,:,3));colormap(gray);title('PC-3')
subplot(3,3,4)
imagesc(im_PCA(:,:,5));colormap(gray);title('PC-5')
subplot(3,3,5)
imagesc(im_PCA(:,:,7));colormap(gray);title('PC-7')
subplot(3,3,6)
imagesc(im_PCA(:,:,10));colormap(gray);title('PC-10')
subplot(3,3,7)
imagesc(im_PCA(:,:,11));colormap(gray);title('PC-11')
subplot(3,3,8)
imagesc(im_PCA(:,:,30));colormap(gray);title('PC-30')
subplot(3,3,9)
imagesc(im_PCA(:,:,45));colormap(gray);title('PC-45')
%%
figure()
subplot(3,3,1)
imagesc(im1_PCA(:,:,1));colormap(gray);
title('PC-1')
subplot(3,3,2)
imagesc(im1_PCA(:,:,2));colormap(gray);
title('PC-2')
subplot(3,3,3)
imagesc(im1_PCA(:,:,3));colormap(gray);
title('PC-3')
subplot(3,3,4)
imagesc(im1_PCA(:,:,5));colormap(gray);
title('PC-5')
subplot(3,3,5)
imagesc(im1_PCA(:,:,6));colormap(gray);
title('PC-6')
subplot(3,3,6)
imagesc(im1_PCA(:,:,7));colormap(gray);
title('PC-7')
subplot(3,3,7)
imagesc(im1_PCA(:,:,11));colormap(gray);
title('PC-11')
subplot(3,3,8)
imagesc(im1_PCA(:,:,12));colormap(gray);
title('PC-12')
subplot(3,3,9)
imagesc(im1_PCA(:,:,18));colormap(gray);
title('PC-18')
toc
%%
%Plot the different PCA axis
xax=1:bands;
figure()
% for i=1:10
    plot(xax,PCA_mat_COEFF(:,1),xax,PCA_mat_COEFF(:,2),xax,PCA_mat_COEFF(:,3))
    hold on
% end
hold off
