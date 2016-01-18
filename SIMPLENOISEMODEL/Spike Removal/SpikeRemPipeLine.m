clear all
close all
clc

%%
%spike removal pipeline
%input :- address of the Image
fnameInFull='E:\IMAGES\CRISM\MSL\FRT0000B6F1_LA\LA_image\FRT0000B6F1_07_IF165L_TRR3_LA.img';

%if full image then opt=1 if cropped image opt=2;
opt=1;

%read the image
[im_uc,info]=enviread(fnameInFull);
wavelength_full=CRISM_full();
%crop out only the required bands
if(opt==1)
    im=im_uc(:,:,18:248);
    wavelength = wavelength_full(18:248);
end

figure()
imagesc(im(:,:,6));

%give name under which file is to be written
fnameOut=regexprep(fnameInFull,'.img','_flipped.img')

infod=info;
infod.bands=231;
%write the image
i=enviwrite2(im,fnameOut,infod);
clear im_uc wavelength_full im info infod 
%%
%now read this cropped-despiked image
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked.img';
graphic=1;
fnameIn = strcat(str1, str2);
%call a function to find the average dark pixel value
[im_dpix_mean im_mask C]=dpix_ratio_new(fnameIn,graphic);
%%
%applying a smoothing-spline to the mean dark pixel spectra
spline1 = spap2(1,5,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);

figure()
plot(wavelength',im_dpix_mean);
hold on
plot(wavelength',yy','r--');
hold off
xlabel('wavelength(microns)');ylabel('reflectance');
legend('average dark pixel','estimated slope')

