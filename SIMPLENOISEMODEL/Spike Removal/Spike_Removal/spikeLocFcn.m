function [Y_spectra_n_corr] = spikeLocFcn(Y,bands)
    
    %create a dummy to hold spike removed pixel values
    Y_corr=zeros(3,3,bands);
    %for each of the 9 spectra in the ROI find spike locations
    spike_loc=zeros(9,100);
    track=1;
    for i=1:3
        for j=1:3
            im_spectra=squeeze(Y(j,i,:));
            %calculate distance to next band and previous band
            im_spectra_d=abs(im_spectra(2:(end))-im_spectra(1:(end-1)));
            im_spectra_si=im_spectra(2:(end))-im_spectra(1:(end-1));
            im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));
            % spike only if the change if much quicker than others or much more
            % than average set limit at 1.25 times normal
            lim=1.15*(mean(im_spectra_td));
        
            %pull out those wavelengths where there are spikes
            im_spectra_td(im_spectra_td<lim)=0;
            line=find(im_spectra_td>0);
                
            x_rx=2:(bands-1);
            x_rx=x_rx(line); 
    %         x_rxn=x_rx-1;
    %         x_rxp=x_rx+1;
            x=x_rx;% x_rxn x_rxp];
            x =[2 x (bands-1)];
            x=unique(x);
           
            [~,c]=size(x);
           
            if(isempty(x))
                 noChangeFlag = 1;
            end
                for k=1:c
                    if(k==55)
                        aaaa=1;
                    end
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
            size_spk=size(x,2);
            spike_loc(track,1:size_spk)=x;
            track=track+1;
        
            %remove the spiky bands and interpolate over them
            nspky_bands=(1:bands);
            full_bands=(1:bands);
            nspky_bands(x)=[];
            im_spectra_nspky=im_spectra(nspky_bands);
            Y_corr(i,j,:)=interp1(nspky_bands,im_spectra_nspky,full_bands);
        end
    end
    
    spectra_corr_pix=squeeze(Y(2,2,:));
    spectra_comp_pix=squeeze(Y(1,1,:));
    corr_spectra_pix=squeeze(Y_corr(2,2,:));
    spike_loc_corr_pix=unique(spike_loc(5,:));
    spike_loc_corr_pix=spike_loc_corr_pix(2:end);
    spike_loc_corr_pix1=unique(spike_loc(8,:));
    spike_loc_corr_pix1=spike_loc_corr_pix1(2:end);
    xax=(1:bands);
   
    %now correct when the spectra for the spiky regions with the those
    %neighbors that have no spikes
    spike_pos=unique(spike_loc(5,:));spike_pos=spike_pos(2:end);
    Y_rshpk=reshape(Y,9,bands);
    Y_spectra_n_corr=corr_spectra_pix;
    %find number of spikes
    [~,nspk]=size(spike_pos);
    spike_corr_pref=[spike_loc(4,:);spike_loc(6,:);spike_loc(7,:);...
            spike_loc(3,:);spike_loc(1,:);spike_loc(9,:);spike_loc(2,:);...
            spike_loc(8,:);];

    Y_rshp=[Y_rshpk(4,:);Y_rshpk(6,:);Y_rshpk(7,:);Y_rshpk(3,:);...
                    Y_rshpk(1,:);Y_rshpk(9,:);Y_rshpk(2,:);Y_rshpk(8,:);];

    for i=1:nspk
        spike_position=spike_pos(i);
        spike_position=(spike_position-2):(spike_position+2);
        flag=1;
        var=1;
        while (flag)
            C=intersect(spike_corr_pref(var,:),spike_position);
    
            if(isempty(C))
                Corr_spectra=[Y_rshp(var,spike_position(3)-1) ...
                                            Y_rshp(var,spike_position(3))];
                flag=0;
            else
                var=var+1;
                if(var==7)
                    flag=0;
                    Corr_spectra=[];
                end
            end
        end    
        
   
        if(~isempty(Corr_spectra))
    
            Y_spectra_n_corr(spike_position(3))=...
                                      (Corr_spectra(2)/Corr_spectra(1))*...
                                     Y_spectra_n_corr(spike_position(3)-1);
        end
    end          
end