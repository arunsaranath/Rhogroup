function [fnameIn opt] = CRISM_signal_check_orig

%load your image
% str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\';
% str2 = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
% fnameIn=strcat(str1,str2);
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\';
str2 = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
fnameIn=strcat(str1,str2);
opt=2;

%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end

% [r,c,bands]=size(im_uc);


%look at the whole space
fig=figure();
a = axes;
im= imagesc(im_uc(:,:,1));
axis image;

set(a,'ButtonDownFcn','disp(''axes button down'')')


set(im,'HitTest','off');

%now set an image button down fcn
set(im,'ButtonDownFcn',{@plot_point})
%now set an image button down fcn
set(fig,'KeyPressFcn',@KeyPress);


%the image funtion will not fire until hit test is turned on
set(im,'HitTest','on'); %now image button function will work
colormap(bone)
title('Band 1 of CRISM image FRT000094F6')

end



function plot_point(gcbo,eventdata,handles)
    global PiX_Chosen
    %the value of the click
    x=get(gca,'Currentpoint');
    x=ceil(x);
    x=x(1,1:2);
    %points clicked by mouse
    PiX_Chosen=x;
    
    
    %load your image
%     str1= 'E:\SpikeRem_Images\FRT000094F6\';
%     str2='new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_ratioed_despiked.img';
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\';
str2 = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
fnameIn=strcat(str1,str2);

opt=2;


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
   
    xax=wvl_94F6();
    figHandles = findall(0,'Type','figure');
    figure()
    hold all
%     grid on
    h=plot(xax,spectra,'LineWidth',2);
    s=sprintf('pixel @ x=%d and y=%d',x(2),x(1));
    hleg1 = legend(s);
    title('Mineral Spectra for Nontronite on Mars')
    grid on
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
    
    %load your image
%     str1= 'E:\SpikeRem_Images\FRT000094F6\';
%     str2='new_FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR_ratioed_despiked.img';
%     fnameIn = strcat(str1, str2);
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT000094F6\';
str2 = 'FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
fnameIn=strcat(str1,str2);

opt=2;

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
    
    xax=wvl_94F6();
    
    figHandles = findall(0,'Type','figure');
    curr_fig2plot=max(figHandles);
    figure(curr_fig2plot)
    hold all
%     grid on
    h=plot(xax,spectra,'LineWidth',2);
    [~,~,~,Outm]=legend;
    s=sprintf('pixel @ x=%d and y=%d',x(2),x(1));
    hleg2 = legend(Outm,s);
    grid on    
end
