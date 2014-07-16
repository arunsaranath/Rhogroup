clear all
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_ratioed.img';
opt=2;

tic,
    [im_dspk]=img_despiker2(fnameIn,opt);
    clc
toc
%%
[im_uc,info]=enviread(fnameIn);
%%
xax=1:231;
figure()
plot(xax,squeeze(im_dspk(257,518,:)),'b-')
hold all
plot(xax,squeeze(im_uc(257,518,:)),'r-')
%%
fnameOut=...
 'new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_despiked_2.img';
info_out=info;

i=enviwrite2(im_dspk,fnameOut,info_out);