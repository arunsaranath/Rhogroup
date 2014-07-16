function [im_dspk]=img_despiker_indep(fnameIn,opt)

%read whole image
[im_uc,~]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
%size of the image
[lines,samples,bands]=size(im_uc);
im_dspk=zeros(lines,samples,bands);

if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool open 4
end

parfor j=2:(samples-1)
    for i=2:(lines-1)
        tic,
        im_spectra=squeeze(im_uc(i,j,:));
        %calculate distance to next band and previous band
        im_spectra_d=abs(im_spectra(2:(end))-im_spectra(1:(end-1)));
        im_spectra_si=im_spectra(2:(end))-im_spectra(1:(end-1));
        im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));
        % spike only if the change if much quicker than others or much more
        % than average set limit at 2.5 times normal
        lim=1.25*(mean(im_spectra_td));
        
        %pull out those wavelengths where there are spikes
        im_spectra_td(im_spectra_td<lim)=0;
        line=find(im_spectra_td>0);
                
        x_rx=2:(bands-1);
        x_rx=x_rx(line); 
%         x_rxn=x_rx-1;
%         x_rxp=x_rx+1;
        x=x_rx;% x_rxn x_rxp];
        x=unique(x);
        
        [~,c]=size(x);
        for k=1:c
            pos=x(k);
            if(sign(im_spectra_si(pos-1))~=sign(im_spectra_si(pos)))
                if(abs(im_spectra_si(pos-1))<=abs(im_spectra_si(pos)))
                    if(abs(im_spectra_si(pos-1))<=(0.25*abs(im_spectra_si(pos))))
                        x(k)=0;
                    end
                else
                    if(abs(im_spectra_si(pos))<=(0.1*abs(im_spectra_si(pos-1))))
                        x(k)=0;
                    end
                end
            else
                x(k)=0;
            end
        end
        x=unique(x);
        x=x(2:end);
        %save these values in a matrix
%         size_spk=size(x,2);
%         spike_loc(track,1:size_spk)=x;
%         track=track+1;
        
        %remove the spikiy bands and interpolate over them
        nspky_bands=(1:231);
        full_bands=(1:231);
        nspky_bands(x)=[];
        im_spectra_nspky=im_spectra(nspky_bands);
        im_dspk(i,j,:)=interp1(nspky_bands,im_spectra_nspky,full_bands);
        toc
    end    
end
matlabpool close
end