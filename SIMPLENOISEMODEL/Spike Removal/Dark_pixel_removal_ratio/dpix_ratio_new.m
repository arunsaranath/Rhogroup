function [im_dpix_mean im_mask C]=dpix_ratio_new(fnameIn,graphic)
% Finding the average dark pixel from the despiked image which has a frame
% of zeros 1 col on each side and 1 row on each side

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
%create the mask:- for all the points in C the mask value is 0
%else mask value is 1

%get the locations of the dark pixels
%rewrite this set into row_no and column no.
col_nomax=ceil(idx./rim);
temp=col_nomax-1;
sub_no=temp.*rim;
row_nomax=idx-sub_no;

% find any which are in the first row or column and throw it out because
% the pixels in these bands are not despiked and the low may be beacuse of
% a spike
idx1= find(row_nomax==1);
idx2= find(col_nomax==1);
idx = [idx1 idx2];
idx =unique(idx);
if(~isempty(idx))
    row_nomax(idx)=[];
    col_nomax(idx)=[];
end
C=[row_nomax' col_nomax'];

%replace dark pixel cooridnates by 0
im_mask=ones(lines,samples);
for i=1:size(C,1)
    temp1=C(i,1);temp2=C(i,2);
    im_mask(temp1,temp2)=0;
end
clear temp temp1 temp2
%write the mask
infod=info;
infod.bands=1;
%name for the mask
fnameMOut=regexprep(fnameIn,'.img','_mask.img');
%write this as the mask
i=enviwrite2(im_mask,fnameMOut,infod);
%%
%performing the ratioing and write the ratioed image
Y_dpix_mean = repmat(im_dpix_mean,1,size(Y,2));
Y_ratio = Y./Y_dpix_mean;
im_ratio = mat2cube(Y_ratio,478,600,'row');

% for i=1:bands
%    temp1=zeros(478,1) ;
%    temp = [temp1 squeeze(im_ratio_nfrm(:,:,i)) temp1];
%    %row above and below   
%    temp2=zeros(1,600);
%    temp = [temp2;temp;temp2];
%    
%    im_ratio(:,:,i)=temp;
% end
clear im_ratio_nfrm temp1 temp2

%give a name for the ratioed image
fnameROut=regexprep(fnameIn,'.img','_ratioed.img');
%write this as the ratioed image
i=enviwrite2(im_ratio,fnameROut,info);
%%%---------------------------------------------------------------------%%%
% %%
% %%%             PERFORM despiking                                     %%%
% 
% 
% %%
% %slope remultiplying
% %estimate slope
% %applying a smoothing-spline to the mean dark pixel spectra
% spline1 = spap2(1,5,wavelength,im_dpix_mean); 
% coeffs=spline1.coefs;
% yy = fnval(spline1,wavelength);
% 
% %plot to check how the slope fits the average dark pixel
% if (graphic==1)
%     figure()
%     plot(wavelength',im_dpix_mean);
%     hold on
%     plot(wavelength',yy','r--');
%     hold off
% end
% 
% % %now multiply all the ratioed pixels by this slope
% % slope_mat = repmat(yy',1,size(Y,2));
% % Y_slope = Y_ratio.*slope_mat;
% % % convert from matrix to cube
% % im_slope_nfrm = mat2cube(Y_slope,476,598,'row');
% % %add frame back
% % for i=1:bands
% %    temp1=zeros(476,1) ;
% %    temp = [temp1 squeeze(im_slope_nfrm(:,:,i)) temp1];
% %    %row above and below   
% %    temp2=ones(1,600);
% %    temp = [temp2;temp;temp2];
% %    
% %    im_slope(:,:,i)=temp;
% % end
% % clear im_slope_nfrm temp1 temp2
% % 
% % %give a name for the ratioed image
% % fnameSOut=regexprep(fnameIn,'.img','_ratioed_sloperm.img');
% % %write this as the ratioed image
% % i=enviwrite2(im_slope,fnameSOut,info);
end