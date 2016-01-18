clear all
% close all
clc

%read original image
fnameIn='E:\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;

[im_orig,~]=enviread(fnameIn);
if(opt==1)
    im_orig=im_uc(:,:,115:359);
end
%place all these pixels in a matrix
Y_orig = cube2mat(im_orig,'col') ;

%read ratioed image
fnameIn='E:\IMAGES\CRISM\MTRDR\FRT000094F6\new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_ratioed_darkZero_despiked.img';
opt=2;

[im_ratio,~]=enviread(fnameIn);
if(opt==1)
    im_ratio=im_uc(:,:,115:359);
end
%place all these pixels in a matrix
Y_ratio = cube2mat(im_ratio,'col') ;

%%
%find the location dark pixel in the original image
fnameIn='E:\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
[~, mask, ~]=dark_avg_pixel_mod(fnameIn,opt);
%now find the location of the dark pixel
mask_row = cube2mat(mask,'col');
idx = find(mask_row == 0);

%remove these from both images
%remove dark pixel for original image
Y_orig_dp_rem = Y_orig();
Y_orig_dp_rem(:,idx)  = [];
%remove dark pixel for ratioed image
Y_ratio_dp_rem = Y_ratio();
Y_ratio_dp_rem(:,idx) = [];

%%
%perform princomp on original image
[coeff_orig,pca_orig]  =  princomp(Y_orig_dp_rem');

%perform princomp on ratioed image
[coeff_ratio,pca_ratio]  =  princomp(Y_ratio_dp_rem');
%%
%now sample 1 pixel in every 3
pca_orig_samp = pca_orig(1:3:end,:);
pca_ratio_samp = pca_ratio(1:3:end,:);
%%
%look at PC's 1 to 3
figure()
subplot(1,2,1)
scatter3(pca_orig_samp(:,1),pca_orig_samp(:,2),pca_orig_samp(:,3));
title('PCs 1 to 3 for original image 94F6')
subplot(1,2,2)
scatter3(pca_ratio_samp(:,1),pca_ratio_samp(:,2),pca_ratio_samp(:,3));
title('PCs 1 to 3 for ratioed image 94F6')

%look at PC's 4 to 6
figure()
subplot(1,2,1)
scatter3(pca_orig_samp(:,4),pca_orig_samp(:,5),pca_orig_samp(:,6));
title('PCs 4 to 6 for original image 94F6')
subplot(1,2,2)
scatter3(pca_ratio_samp(:,4),pca_ratio_samp(:,5),pca_ratio_samp(:,6));
title('PCs 4 to 6 for ratioed image 94F6')

%look at PC's 7 to 9
figure()
subplot(1,2,1)
scatter3(pca_orig_samp(:,7),pca_orig_samp(:,8),pca_orig_samp(:,9));
title('PCs 7 to 9 for original image 94F6')
subplot(1,2,2)
scatter3(pca_ratio_samp(:,7),pca_ratio_samp(:,8),pca_ratio_samp(:,9));
title('PCs 7 to 9 for ratioed image 94F6')

