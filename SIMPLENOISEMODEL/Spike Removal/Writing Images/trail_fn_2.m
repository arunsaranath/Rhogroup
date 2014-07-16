clear all
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;

tic,
    [im_dspk]=img_despiker_indep(fnameIn,opt);
    clc
toc

%%
[im_uc,info]=enviread(fnameIn);
%%
xloc=234;
yloc=365;
xax=1:231;
figure()
plot(xax,squeeze(im_uc(xloc,yloc,:)),'g-')
hold all
plot(xax,squeeze(im_dspk(xloc,yloc,:)),'b-')

%%
fnameOut=...
 'new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_despiked_2.img';
info_out=info;

i=enviwrite2(im_dspk,fnameOut,info_out);