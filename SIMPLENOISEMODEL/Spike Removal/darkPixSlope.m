clear all
close all
clc
%%
fnameIn = 'E:\IMAGES\CRISM\MTRDR\FRT0000B072\FRT0000B072_07_IF166J_TER3_fix_65sGone_b18_248.img';
graphic =1;

%%
%read whole image
[im_uc,info]=enviread(fnameIn);
[lines,samples,bands] = size(im_uc);
%read wavelength range
wavelength = wvl_94F6();
%crop out the column and row of zeros
% im_uc = im_uc(2:(lines-1),2:(samples-1),:);
[rim,cim,~]=size(im_uc);
% convert into a matrix of spectra
Y=cube2mat(im_uc,'row');
%%
%now find the max values of each pixel
Y_max = max(Y);
lim = min(Y_max);
idx = find(Y_max <= (lim+0.0025));
%%
Y_dpix = Y(:,idx);
Y_dpix = Y_dpix';
im_dpix_mean = mean(Y_dpix);
im_dpix_mean=im_dpix_mean';
%%
if(graphic==1)
    % look to see if the dark pixels have similar shape
    figure()
    hold all
    for i=1:size(idx,2)
        plot(wavelength,Y(:,idx(i)));
    end
    plot(wavelength,im_dpix_mean,'r-','LineWidth',3);
    hold off
end
%%
wavelength =  wvl_94F6();
spline1 = spap2(1,25,wavelength,im_dpix_mean); 
coeffs=spline1.coefs;
darkPixSlope = fnval(spline1,wavelength);

%plot to check how the slope fits the average dark pixel
figure()
plot(wavelength',im_dpix_mean);
hold on
plot(wavelength',darkPixSlope','r--');
hold off
xlabel('wavelength(microns)');ylabel('reflectance')
legend('avg dark pixel','estimated slope')
%%
im_dpix_mean = im_dpix_mean' ;
savefile = 'C:\Users\arunsaranath\Dropbox\Rhogroup_Shared\B072_results\darkPix_Slope.mat';
save (savefile,'wavelength','im_dpix_mean','darkPixSlope')
