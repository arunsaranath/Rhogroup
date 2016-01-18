%load your image 
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(2:449,32:631,115:359);
end

%Pick Pixel-1(low value pixel)
Y_do=im_uc(260,474,:);
Y_do=squeeze(Y_do);

% Pick Bright Pixel
Y_bright=im_uc(284,474,:);
Y_bright=squeeze(Y_bright);

%remove Dark-object
Y_d_rem=Y_bright-Y_do;

[~,~,p]=size(im_uc);
xax=(1047.199951:6.55:2648.340088);
xax=xax(1:p);
figure
subplot(3,1,1)
plot(xax,Y_do)
hleg1 = legend('Dark Pixel');
grid on
% axis([1000 2700 0 0.1])
subplot(3,1,2)
plot(xax,Y_bright)
hleg2=legend('Bright Pixel at x=320,y=39');
grid on
% axis([1000 2700 0.27 0.37])
subplot(3,1,3)
plot(xax,Y_d_rem)
hleg3=legend('Bright Pixel with dark removed');
grid on
%axis([1000 2700 0.1 0.15])

%%
% Pick a set of pixels
Y_set=im_uc(254:306,474,:);
Y_set=squeeze(Y_set);
Y_set=Y_set';
[~,c]=size(Y_set);

%repeat Y_do
Y_do_set=repmat(Y_do,1,c);


Y_rem_set=Y_set-Y_do_set;

figure()
hold all
for i=1:c
    plot(xax,Y_rem_set(:,i))
end
grid on
title('effect of dark-pixel removal(same pixel range as ROI)')
