clear all
clc

%load your image 
imgname='FRT0000A819_07_IF165J_TER3_despike_cropb115-b358_no65k';
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT0000A819\FRT0000A819_07_IF165J_TER3_despike_cropb115-b358_no65k.img';
opt=2;

% find the average dark pixel and also the mask which covers the dark
% pixels
[im_dpix_mean im_mask dark_pix_loc]=dark_avg_pixel_mod(fnameIn,opt);

%read image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[lines,samples,bands]=size(im_uc);

%convert cube into matrix 
Y=cube2mat(im_uc,'row'); 


% divide each pixel by this dark pixel
%divide all pixels by dark pixels
Y_dp=repmat(im_dpix_mean,(lines*samples),[]);
Y_ddiv=Y./Y_dp';
%reshape into an image
im_ddiv=mat2cube(Y_ddiv,lines,samples,'row');

%%
%if not already open matlab pool
sz = matlabpool('size');
if(sz == 0)
   matlabpool local 4 
end

% now intialize the spike corrected image
im_uc_spk_corr=zeros(lines,samples,bands);

for i=2:(lines-1)    
    parfor j=2:(samples-1) 
        tic,
        %pick a ROI of the pixels and it's nearest neighbors
        Y=im_ddiv((i-1:i+1),(j-1:j+1),:);
        %perform despiking
        im_uc_spk_corr(i,j,:) = spikeLocFcn(Y,bands);
        toc
    end    
end
if(sz ~= 0)
   matlabpool close
end


%make sure header of the corrected image is the same as the header of the
%original image
info_spk_corr=info;

%%
%give name under which file is to be written
fnameOut=strcat('new_',imgname,'_ratioed','_despiked.img');

%write the image
i=enviwrite2(im_uc_spk_corr,fnameOut,info_spk_corr);


%%
%mask out
mnameOut=strcat(imgname,'_mask','.img');
info_mask = info;
info_mask.bands=1;

i=enviwrite2(im_mask,mnameOut,info_mask);
%%
% a sample with all entries as 0
ztemp=zeros(1,bands);
for i=1:size(dark_pix_loc,1)
    %address of i-th dark pixel
    add = dark_pix_loc(i,:);
    % now zero out the pixel at this address
    im_uc_spk_corr(add(1),add(2),:) =  ztemp ;
end

%%
%give name under which file is to be written
fnameOut=strcat('new_',imgname,'_ratioed','_darkZero','_despiked.img');

%write the image
i=enviwrite2(im_uc_spk_corr,fnameOut,info_spk_corr);