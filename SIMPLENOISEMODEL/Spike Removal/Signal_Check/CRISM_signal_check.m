function [fnameIn opt] = CRISM_signal_check(img)

%load your image 
switch(img)
    case 1
        fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_ratioed.img';
        opt=2;
    case 2
        fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT0000A819\FRT0000A819_07_IF165J_TER3_despike_cropb115-b358_no65k.img';
        opt=2;
    case 3
        fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000199C7\FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone.img';
        opt=1;
end

%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[r c p]=size(im_uc);
Y=cube2mat(im_uc,'row'); 
Y=Y';

[~, Y_score]=princomp(Y);

%pick the first three principal components
Y_img=Y_score(:,1:3);
Y_img=Y_img';
Y_img_rs=mat2cube(Y_img,r,c,'row');

%set minimum to 0
Y_img_rs=Y_img_rs-min(min(min(Y_img_rs)));
Y_img_rs=Y_img_rs/max(max(max(Y_img_rs)));


%look at the whole space
fig=figure();
a = axes;
im= image(Y_img_rs);
axis image;

set(a,'ButtonDownFcn','disp(''axes button down'')')


set(im,'HitTest','off');

%now set an image button down fcn
set(im,'ButtonDownFcn',{@plot_point})
%now set an image button down fcn
set(fig,'KeyPressFcn',@KeyPress);


%the image funtion will not fire until hit test is turned on
set(im,'HitTest','on'); %now image button function will work
colormap(gray)
end



function plot_point(gcbo,eventdata,handles)
    global PiX_Chosen
    %the value of the click
    x=get(gca,'Currentpoint');
    x=ceil(x);
    x=x(1,1:2);
    %points clicked by mouse
    PiX_Chosen=x;
    
    
    %read image
    fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_ratioed.img';
    %read whole image
    [im_uc,info]=enviread(fnameIn);
    opt=2;
    if(opt==1)
        im_uc=im_uc(2:449,32:631,115:359);
    end
    [~,~,bands]=size(im_uc);
    %pull out spectra
    spectra=im_uc(x(2),x(1),:);
    spectra=squeeze(spectra);
        
    [~,~,p]=size(im_uc);
    xax=(1047.199951:6.55:2648.340088);
    xax=xax(1:p);
    figHandles = findall(0,'Type','figure');
    figure()
    hold all
    grid on
    h=plot(xax,spectra);
    s=sprintf('pixel @ x=%d and y=%d',x(2),x(1));
    hleg1 = legend(s);
end

function KeyPress(~,event)
    global PiX_Chosen
    x=PiX_Chosen;
    c = event.Character;
    switch c
        case 'w'
            x=x-[0 1];
        case 'a'
            x=x-[1 0];
        case 's'
            x=x+[0 1];
        case 'd'
            x=x+[1 0];    
    end
    %set this a the (new) previous value
    PiX_Chosen=x;
    
    %read image
    fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_dark_pixel_ratioed.img';
    %read whole image
    [im_uc,info]=enviread(fnameIn);
    opt=2;
    if(opt==1)
        im_uc=im_uc(2:449,32:631,115:359);
    end
    %pull out spectra
    spectra=im_uc(x(2),x(1),:);
    spectra=squeeze(spectra);
    
    [~,~,p]=size(im_uc);
    xax=(1047.199951:6.55:2648.340088);
    xax=xax(1:p);
    
    figHandles = findall(0,'Type','figure');
    curr_fig2plot=max(figHandles);
    figure(curr_fig2plot)
    hold all
    grid on
    h=plot(xax,spectra);
    [~,~,~,Outm]=legend;
    s=sprintf('pixel @ x=%d and y=%d',x(2),x(1));
    hleg2 = legend(Outm,s);
end
