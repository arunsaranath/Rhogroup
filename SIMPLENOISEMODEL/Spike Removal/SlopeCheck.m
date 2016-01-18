% close all
clear all
clc

xloc = 288;
yloc = 438;
%%
%read original image
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT00003E12\';
str2='FRT00003E12_07_IF166L_TRR3_SYS_fix_65sGone_b18_248_despiked.img';
fOnameIn = strcat(str1, str2);

%read actual image at this address
[im_orig,~] = enviread(fOnameIn) ;

%read ratioed image
%read the actual image
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT00003E12\';
str2='FRT00003E12_07_IF166L_TRR3_SYS_fix_65sGone_b18_248_despiked_ratioed.img';
fRnameIn = strcat(str1, str2);
%read actual image at this address
[im_ratio,~] = enviread(fRnameIn) ;

%read slope remultiplied image
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT00003E12\';
str2='FRT00003E12_07_IF166L_TRR3_SYS_fix_65sGone_b18_248_despiked_ratioed_despiked_sloperemult.img';
fSnameIn = strcat(str1, str2);

%read whole image
[im_slope,info]=enviread(fSnameIn);
%%
wavelength = wvl_94F6();
figure()
plot(wavelength',squeeze(im_orig(xloc,yloc,:)))
xlabel('wavelength(microns)');ylabel('reflectance')
title('pixel spectra in original image')
grid on
figure()
plot(wavelength',squeeze(im_ratio(xloc,yloc,:)))
title('pixel spectra in despiked ratioed image')
xlabel('wavelength(microns)');ylabel('Ratio to average dark pixel')
grid on

figure()
plot(wavelength',squeeze(im_slope(xloc,yloc,:)))
title('pixel spectra in despiked ratioed-slope remultiplied image')
grid on
xlabel('wavelength(microns)');ylabel('Ratio to average dark pixel-slope remultiplied')


temp = squeeze(im_ratio(xloc,yloc,:)) * 0.15 ;

figure()
plot(wavelength',squeeze(im_orig(xloc,yloc,:)),'b-')
hold on
plot(wavelength',squeeze(im_slope(xloc,yloc,:)),'r-')
plot(wavelength',temp,'g-')
xlabel('wavelength(microns)');ylabel('reflectance')
title('pixel spectra in original image')
grid on


figure()
plot(wavelength',temp,'b-');
hold on
plot(wavelength',squeeze(im_slope(xloc,yloc,:)),'r-')
xlabel('wavelength(microns)');ylabel('reflectance')
title('pixel spectra in ratioed vs slope remultiplied image')
legend('ratioed pixel','slope remultiplied pixel')
grid on
%%
mat = [wavelength' squeeze(im_orig(xloc,yloc,:)) temp squeeze(im_slope(xloc,yloc,:))];
xlswrite('concave2.xls', mat);
