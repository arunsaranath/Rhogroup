clear all
close all
clc
%%
% %spike removal pipeline
% %input :- address of the Image
str1 = 'E:\IMAGES\CRISM\MTRDR\FRT00003E12_ENVI\';
str2 = 'FRT00003E12_07_IF166L_TRR3_SYS.img';
fnameInFull=strcat(str1,str2);

%read in the image
[imFull_flip,infoFull] = enviread(fnameInFull);
[lines,samples,bands]=size(imFull_flip);

%now flip this as the bands are arranged in reverse and throw away the last
%band as it's all 65K
for i=2:(bands)
    temp = bands - i + 1 ;
    im_uc(:,:,(i-1)) = imFull_flip(:,:,temp);
end



%write this image as the fnameIn no 65k abd b18-248
fnameCOut=regexprep(fnameInFull,'.img','_flip.img');

%write this as the cropped image with the 65k's gone
infod = infoFull;
infod.bands = 437;

i=enviwrite2(im_uc,fnameCOut,infod)