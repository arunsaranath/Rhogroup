clear all
close all
clc
%load your image 
fnameIn='C:\Users\arunsaranath\SkyDrive\new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_despiked_2.img';
        opt=2;
%read whole image
[im_dspk,info]=enviread(fnameIn);

fnameIn='C:\Users\arunsaranath\SkyDrive\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_ratioed.img';
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);

figure()
plot((1:231),squeeze(im_dspk(257,518,:)));
hold all
plot((1:231),squeeze(im_uc(257,518,:)));
