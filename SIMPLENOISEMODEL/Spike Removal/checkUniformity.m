clear all
close all
clc
%read in the superpixel representation
A = imread('out_chunk_cosine', 'ppm');
%find all the unique rows and hence uniue segments
temp_mat = cube2mat(A,'row');
temp_mat = temp_mat';
C = unique(temp_mat,'rows');
%the number of superpixels is
num_sup_pix = size(C,1);
%assign a different number to each superpixel
sup_pix = zeros((size(A,1)*size(A,2)),1);
for i=1:size(C,1)
    idx1 = find(temp_mat(:,1)==C(i,1));
    idx2 = find(temp_mat(:,2)==C(i,2));
    idx3 = find(temp_mat(:,3)==C(i,3));
    
    idx = intersect(idx1,idx2);
    idx = intersect(idx,idx3);
    
    sup_pix(idx) = i;
    
    clear idx idx1 idx2 idx3
end

%in image form
supImg = reshape(sup_pix,size(A,1),size(A,2));

clear A temp_mat C sup_pix i
%%
%read the actual image
str1= 'C:\Users\arunsaranathhome\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\';
str2='FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
fnameIn = strcat(str1, str2);
%read actual image at this address
[im,info] = enviread(fnameIn) ;
%%
supRow   = cube2mat(supImg,'row') ;
imRow    = cube2mat(im,'row');

%%
idx = find(supRow==981);

pix_grp1 = imRow(:,idx);

dist = pdist2(pix_grp1',pix_grp1','cosine');

dist(dist>0.000102) = 0;

[sDist, Midx] = sort(dist(:),'descend');
%%
Midx =Midx(1);
sDist=sDist(1);

xloc= rem(Midx,size(dist,1))
yloc = ceil(Midx/size(dist,1))
%%
figure()
plot(wavelength',pix_grp1(:,8),'LineWidth',2);
hold all
plot(wavelength',pix_grp1(:,12),'LineWidth',2);
hold off
title('Pixels with the largest Distance inside a segment 925 dist = 1.0192e-4')
