clear all
clc

xloc = 320;
yloc = 310;
%%
%read original image
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358.img';
fOnameIn = strcat(str1, str2);
%read actual image at this address
[im_orig,~] = enviread(fOnameIn) ;

%read the despiked image
%now read this cropped-despiked image
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked.img';
fDnameIn = strcat(str1, str2);
%read actual image at this address
[im_despik,~] = enviread(fDnameIn) ;

wavelength = wvl_94F6();
figure()
plot(wavelength',squeeze(im_orig(xloc,yloc,:)))
xlabel('wavelength(microns)');ylabel('reflectance')
title('pixel spectra in original image')
grid on
figure()
plot(wavelength',squeeze(im_despik(xloc,yloc,:)))
title('pixel spectra in despiked image')
xlabel('wavelength(microns)');ylabel('reflectance')
grid on