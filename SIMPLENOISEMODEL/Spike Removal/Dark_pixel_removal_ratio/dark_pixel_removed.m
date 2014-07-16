fnameIn='C:\Users\arunsaranathhome\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;

%read image

[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[rim,cim,bands]=size(im_uc);

%find the darkest avg pixel
[im_dpix_mean]=dark_avg_pixel(fnameIn,opt);
Y_dp=repmat(im_dpix_mean,(rim*cim),[]);
Y_dp=Y_dp';
%convert cube into matrix 
Y=cube2mat(im_uc,'row'); 

%subtract dark pixel from all pixels
Y_drem=Y-Y_dp;

clear im_uc Y Y_dp

im_drem=mat2cube(Y_drem,rim,cim,'row');

fnameOut=...
 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_removed.img';
info_out=info;

i=enviwrite2(im_drem,fnameOut,info_out);