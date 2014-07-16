clear all
% close all
clc

%read image
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\';
str2='FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
fnameIn = strcat(str1, str2);
opt=2;

%find the dark pixel
[im_dpix_mean im_mask C]=dark_avg_pixel_mod(fnameIn,opt);

%plot the dark pixel
wavelength=wvl_94F6();
%%
%applying a smoothing-spline to this spectra
spline1 = spap2(1,30,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);
    
figure()
plot(wavelength,im_dpix_mean,'b-');
hold on
plot(wavelength,yy,'r--');
hold off    
str=sprintf('Least Squares Spline with degree 6');
legend('Original average dark pixel',str)

%read original image
fnameIn='E:\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;

[im_orig,~]=enviread(fnameIn);
if(opt==1)
    im_orig=im_uc(:,:,115:359);
end
%%
mat = [wavelength' im_dpix_mean' yy' ];
xlswrite('dark_pixel_most_smooth', mat);
%%
%read ratioed image
fnameIn='E:\IMAGES\CRISM\MTRDR\FRT000094F6\new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_ratioed_darkZero_despiked.img';
opt=2;

[im_ratio,~]=enviread(fnameIn);
if(opt==1)
    im_ratio=im_uc(:,:,115:359);
end
%%
loc_mat=[288 434;278 407;249 380;107 71;287 464; 282 415; 269 400];
for i=1:7
    xloc=loc_mat(i,1);yloc=loc_mat(i,2);
    % for the pixel selected multiply by the slope and consider the effect
    Y_slop_rm = squeeze(im_ratio(xloc,yloc,:));
    Y_slop_rm = Y_slop_rm .* yy';

    % pick out the pixels of interest
    figure()
    subplot(1,3,1)
    plot(wavelength,squeeze(im_orig(xloc,yloc,:)),'b--');
    str=sprintf('the original pixel at %d and %d',xloc,yloc);
    title(str)
    xlabel('wavelength(micrometers)');ylabel('reflectance')
    subplot(1,3,2)
    plot(wavelength,squeeze(im_ratio(xloc,yloc,:)),'r--');
    str=sprintf('the ratioed  pixel at %d and %d',xloc,yloc);
    title(str)
    xlabel('wavelength(micrometers)');ylabel('ratioed by  mean dark pixel')
    subplot(1,3,3)
    plot(wavelength,Y_slop_rm,'g--');
    title('the ratioed pixel with slope remultiplied at xloc and yloc')
    str=sprintf('the ratioed pixel with slope remultiplied at %d and %d'...
                                                               ,xloc,yloc);
    title(str)
    xlabel('wavelength(micrometers)');
    ylabel('ratioed pixel remultiplied by estimated slope for dark pixel')
end