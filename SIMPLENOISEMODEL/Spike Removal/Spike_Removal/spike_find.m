clear all
%close all
clc
%load your image 
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_removed.img';
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[~,~,p]=size(im_uc);
% xax=(1047.199951:6.55:2648.340088);
xax=(1:p);

%%
im_spectra=squeeze(im_uc(289,466,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);
%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
figure()
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
%%
im_spectra=squeeze(im_uc(288,466,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')

%%
im_spectra=squeeze(im_uc(290,466,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
title('sample 466')
%%
im_spectra=squeeze(im_uc(288,465,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
figure()
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
%%
im_spectra=squeeze(im_uc(289,465,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
title('sample 465')
%%
im_spectra=squeeze(im_uc(290,465,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
%%
im_spectra=squeeze(im_uc(288,467,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
figure()
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
%%
im_spectra=squeeze(im_uc(289,467,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
%%
im_spectra=squeeze(im_uc(290,467,:));

im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));

lim=0.006;

im_spectra_td(im_spectra_td<lim)=0;

line=find(im_spectra_td>0);

%%
x_rx=2:(p-1);
x_rx=x_rx(line);
x_rxn=x_rx-1;
x_rxp=x_rx+1;
x=[x_rx x_rxn x_rxp];
x=unique(x);
plot(xax,im_spectra)
hold all
plot(xax(x),im_spectra(x),'r+')
title('sample 467')


