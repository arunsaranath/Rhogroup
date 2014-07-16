%%
%now read this cropped-despiked image
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked.img';
graphic=0;
fnameIn = strcat(str1, str2);

[im_dpix_mean im_mask C]=dpix_ratio_new(fnameIn,graphic);
wavelength = wvl_94F6();
%slope remultiplying
%estimate slope
%applying a smoothing-spline to the mean dark pixel spectra
spline1 = spap2(1,5,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
yy = fnval(spline1,wavelength);

Y_rat_spk_corr = cube2mat(im_uc_spk_corr,'row');
Y_slope = repmat(yy',1,size(Y_rat_spk_corr,2));

Y_slope_rm =Y_rat_spk_corr .* Y_slope;
% convert from matrix to cube
im_slope = mat2cube(Y_slope_rm,478,600,'row');

str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked_ratioed.img';
fnameIn = strcat(str1, str2);
%give a name for the ratioed image
fnameSOut=regexprep(fnameIn,'.img','despiked_sloperm.img');
%write this as the ratioed image
i=enviwrite2(im_slope,fnameSOut,info);