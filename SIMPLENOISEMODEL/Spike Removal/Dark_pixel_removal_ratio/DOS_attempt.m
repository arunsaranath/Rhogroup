load your image 
fnameIn_in='C:\Users\arunsaranathhome\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,117:359);
end

%Pick Pixel-1(low value pixel)
Y_do=im_uc(256,474,:);
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
axis([1000 2700 0.1 0.2])
subplot(3,1,2)
plot(xax,Y_bright)
s=sprintf('bright pixel @ x=%d and y=%d',x,y);
hleg2=legend(s);
grid on
axis([1000 2700 0.27 0.37])
subplot(3,1,3)
plot(xax,Y_d_rem)
hleg3=legend('Bright Pixel with dark removed');
grid on
axis([1000 2700 0.14 0.24])

%%
% Pick a set of pixels
Y_set=im_uc(256:300,474,:);
Y_set=squeeze(Y_set);
Y_set=Y_set';
[~,c]=size(Y_set);

x=256;y=474;
figure(10)
hold all
grid on
for i=1:c
    h=plot(xax,Y_set(:,i));
    [~,~,~,Outm]=legend;
    s=sprintf('pixel @ x=%d and y=%d',x,y);
    if(isempty(Outm))
       hleg2 = legend(s);
    else
       hleg2 = legend(Outm,s);
    end
    x=x+1;
end
x=256;
title('original pixels from image')

%repeat Y_do
Y_do_set=repmat(Y_do,1,c);


Y_rem_set=Y_set-Y_do_set;

figure(11)
hold all
grid on
for i=1:c
    h=plot(xax,Y_rem_set(:,i));
    [~,~,~,Outm]=legend;
    s=sprintf('pixel @ x=%d and y=%d',x,y);
    if(isempty(Outm))
       hleg3 = legend(s);
    else
       hleg3 = legend(Outm,s);
    end
    x=x+1;
end
title('effect of dark-pixel removal(same pixel range as ROI)')
