function [im_dspk]=img_despiker2(fnameIn,opt)

%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
%size of the image
[lines,samples,bands]=size(im_uc);
im_dspk=zeros(lines,samples,bands);
xax=1:bands;
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool open 4
end

%perform ROI analysis for each pixel
parfor j=2:(samples-1)
    for i=2:(lines-1)
        tic,
        x_line=(i-1):(i+1);
        y_line=(j-1):(j+1);
        
        %pick out appropriate pixels
        Y=zeros(3,3,bands);
        for k=1:3
            yy=y_line(k);
            for l=1:3
              xx=x_line(l);
              Y(l,k,:)=im_uc(xx,yy,:);
            end
        end
        
%         if((i==2)&&(j==78))
%             dbstop in corr_Spectra.m at 100
%         end
        
        %put these values into a new image
        im_dspk(i,j,:)=corr_Spectra(Y,bands);
        
        toc
    end
end

matlabpool close
end
