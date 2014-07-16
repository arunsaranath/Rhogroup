function [Y count]=pickROI(fnameIn,opt,xloc,yloc,roi_size,fig)

%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[~,~,bands]=size(im_uc);
%pick all the appropriate pixels
x_line=(xloc-roi_size):1:(xloc+roi_size);
y_line=(yloc-roi_size):1:(yloc+roi_size);

count=1+(2*roi_size);

%pick out appropriate pixels
Y=zeros(count,count,bands);
for i=1:count
    yy=y_line(i);
    for j=1:count
        xx=x_line(j);
        Y(j,i,:)=im_uc(xx,yy,:);
    end
end
xax=1:bands;
if(fig==1)
    for i=1:count
        figure()
        hold all
        for j=1:count
            plot(xax,squeeze(Y(j,i,:)))            
        end
        s=sprintf('pixels for detector no %d',y_line(i));
        legend(s);
        hold off
    end
end

end