function [spectraDespiked] = despikeSpectra(spectra)
%colNoiseProfileCalc.m
% This function coarsely despike a single spectra
%  ------------------------------------------------------------------------------------------------------  
%  Input Parameters
%  ------------------------------------------------------------------------------------------------------
%  spectra        :- spectra to be despiked
% -------------------------------------------------------------------------------------------------------
% Output Parameters
% -------------------------------------------------------------------------------------------------------
% spectraDespiked :- the despiked spectra
% -------------------------------------------------------------------------------------------------------

%Function Created :- 08 / 23/ 2013
%Author's Name     :- Arun M Saranathan

%
bands = size(spectra,1);
 track=1;
%calculate distance to next band and previous band
spectra_d=abs(spectra(2:(end))-spectra(1:(end-1)));
spectra_si=spectra(2:(end))-spectra(1:(end-1));
spectra_td=spectra_d(1:(end-1))+spectra_d(2:(end));


% spike only if the change if much quicker than others or much more
% than average set limit at 1.25 times normal
lim=4*(mean(spectra_td));

%pull out those wavelengths where there are spikes
spectra_td(spectra_td<lim)=0;
line=find(spectra_td>0);
                
x_rx=2:(bands-1);
x_rx=x_rx(line); 
x=x_rx;
x=unique(x);

[~,c]=size(x);

if(~isempty(x))
for k=1:c
      pos=x(k);
%       if(sign(spectra_si(pos-1))~=sign(spectra_si(pos)))
               if(abs(spectra_si(pos-1))<=abs(spectra_si(pos)))
                        if(abs(spectra_si(pos-1))<=(0.5*abs(spectra_si(pos))))
                              x(k)=0;
                        end
               else
                         if(abs(spectra_si(pos))<=(0.5*abs(spectra_si(pos-1))))
                             x(k)=0;
                         end
               end
%        else
%               x(k)=0;
%       end
end
            
x=unique(x);
x=x(2:end);
%save these values in a matrix
size_spk=size(x,2);
spike_loc(track,1:size_spk)=x;
track=track+1;

%remove the spiky bands and interpolate over them
nspky_bands=(1:bands);
full_bands=(1:bands);
nspky_bands(x)=[];
spectra_nspky=spectra(nspky_bands);
spectra_nspky =  spectra_nspky' ;
spectraDespiked=interp1(nspky_bands,spectra_nspky,full_bands);
else
    spectraDespiked = spectra;
end
end