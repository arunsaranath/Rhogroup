function [im_uc_spk_corr]=despikingImages(fnameIn)

%read whole image
[im,info]=enviread(fnameIn);
%pick the size of the image
[lines,samples,bands]=size(im);
%pad the image
im_uc = zeros(lines,samples,(bands+2));
im_uc(:,:,1) = im(:,:,1);
im_uc(:,:,2:(bands+1)) = im;
im_uc(:,:,end) = im(:,:,end);

fprintf('Despiking image-start')

% %if not already open matlab pool
% sz = matlabpool('size');
% if(sz == 0)
%    matlabpool local 2 
% end

%initailize despike image to the original image. This was the pixels at the
%edge will have noisy spectra instead of all 0.
im_uc_spk_corr=im_uc;

%now perform despiking
for i=2:(lines-1) 
    for j=2:(samples-1)
       tic,      
       %pick a ROI of the pixels and it's nearest neighbors
       Y=im_uc((i-1:i+1),(j-1:j+1),:);      
       %perform despiking
       temp = spikeLocFcn(Y,(bands+2));
       im_uc_spk_corr(i,j,:) = temp;       
       toc
    end 
end

%close matlabpool matlab pool
% sz = matlabpool('size');
% if(sz ~= 0)
%    matlabpool close
% end

end