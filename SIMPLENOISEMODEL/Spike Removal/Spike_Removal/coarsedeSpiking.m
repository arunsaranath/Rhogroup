function fnameOut = coarsedeSpiking(fnameIn)

%read whole image
[im,info]=enviread(fnameIn);
%pick the size of the image
[lines,samples,bands]=size(im);

%create a modified image
im_mod = zeros(size(im));
for i=1:lines
    for j=1:samples
        tic,
            spectra = squeeze(im(i,j,:))  ;
      
          %now despike
          im_mod(i,j,:) = despikeSpectra(spectra);
       toc
    end
end

fnameOut  = regexprep(fnameIn,'.img','_crsdspk.img');

 i = enviwrite2(im_mod,fnameOut,info);

end