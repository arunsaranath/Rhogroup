clear all
close all
clc
%%
% %spike removal pipeline
% %input :- address of the Image
str1 = 'E:\IMAGES\CRISM\MSL\FRT0000B6F1_LA\CAT_corr_image\';
str2 =  'FRT0000B6F1_07_IF165L_TRR3_corr.img';
fnameInFull=strcat(str1,str2);

%read in the image
[imFull_flip,infoFull] = enviread(fnameInFull);
[lines,samples,bands]=size(imFull_flip);

%now flip this as the bands are arranged in reverse and throw away the last
%band as it's all 65K
for i=2:(bands)
    temp = bands - i + 1 ;
    im_uc(:,:,(i-1)) = imFull_flip(:,:,temp);
end

%throw away the frame of 65K
im_uc_crop = im_uc(2:(lines-1),32:(samples-9),18:248);
im_uc_crop (im_uc_crop > 1) = 0;

%write this image as the fnameIn no 65k abd b18-248
fnameCOut=regexprep(fnameInFull,'.img','_fix_65sGone_b18_248.img');
%%
%write this as the cropped image with the 65k's gone
infod = infoFull;
infod.lines   = (infoFull.lines) - 2;
infod.samples = (infoFull.samples) - 40;
infod.bands   = 231;

i=enviwrite2(im_uc_crop,fnameCOut,infod);
%%
%now perform one level of despiking
% dbstop in despikingImages.m
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358.img';
fnameCOut = strcat(str1,str2);
fHdrName = regexprep(fnameCOut,'.img','.img.hdr');
infod=read_envihdr(fHdrName);
[im_uc_dspk]=despikingImages(fnameCOut);

fnameDOut = regexprep(fnameCOut,'.img','_despiked.img');
i=enviwrite2(im_uc_dspk,fnameDOut,infod);
%%
%now perform ratioing
% dbstop in dpix_ratio_new at 19
[im_dpix_mean im_mask C]=dpix_ratio_new(fnameDOut,1);
%%
%now perform another despiking with the ratioed image
%give a name for the ratioed image
fnameROut=regexprep(fnameDOut,'.img','_ratioed.img');

[im_uc_rat_dspk]=despikingImages(fnameROut);

%now write the ratioed and despiked image 
fnameRDOut=regexprep(fnameROut,'.img','_despiked.img');
i=enviwrite2(im_uc_rat_dspk,fnameRDOut,infod);
%%
%now perform Slope Remultiplication
[im,info]= enviread(fnameRDOut);

%now make this into a matrix
Y = cube2mat(im,'row');

%slope remultiplying
%estimate slope
%applying a smoothing-spline to the mean dark pixel spectra
wavelength =  wvl_94F6();
spline1 = spap2(1,25,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);

%plot to check how the slope fits the average dark pixel
figure()
plot(wavelength',im_dpix_mean);
hold on
plot(wavelength',yy','r--');
hold off
xlabel('wavelength(microns)');ylabel('reflectance')
legend('avg dark pixel','estimated slope')
    
%%

%make a matrix of slopes which is of the same size
Y_slope = repmat(yy',1,size(Y,2));

%multiply the two
Y_slope_rm = Y .* Y_slope;

%now convert this into a cube
im_slope_rm = mat2cube(Y_slope_rm,478,600,'row');

%write this image
fnameRMOut=regexprep(fnameRDOut,'.img','_sloperemult.img');
i=enviwrite2(im_slope_rm,fnameRMOut,infod);