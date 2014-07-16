function Y_spectra_corr=corr_Spectra(Y,bands)
        
    %for each of the 9 spectra in the ROI find spike locations
    spike_loc=zeros(9,50);
    track=1;
    for i=1:3
        for j=1:3
            im_spectra=squeeze(Y(i,j,:));
            %calculate distance to next band and previous band
            im_spectra_d=abs(im_spectra(1:(end-1))-im_spectra(2:(end)));
            im_spectra_td=im_spectra_d(1:(end-1))+im_spectra_d(2:(end));
            % spike only if the change if much quicker than others or much more
            % than average set limit at 2.5 times normal
            lim=2*(mean(im_spectra_td));
    
            %pull out those wavelengths where there are spikes
            im_spectra_td(im_spectra_td<lim)=0;
            line=find(im_spectra_td>0);
                
            x_rx=2:(bands-1);
            x_rx=x_rx(line);
    %         x_rxn=x_rx-1;
    %         x_rxp=x_rx+1;
            x=[x_rx];% x_rxn x_rxp];
            x=unique(x);
        
            %save these values in a matrix
            size_spk=size(x,2);
            spike_loc(track,1:size_spk)=x;
            track=track+1;
        end
    end

    %count how many times spike occurs in the neighbourhood. If it occurs in 
    %most of the pixels it's a global effect so dont correct for it
    all_spike_loc=spike_loc(:);
    all_spike_loc=unique(all_spike_loc);all_spike_loc=all_spike_loc(2:end);
    count_spike_loc=histc(spike_loc(:),all_spike_loc);
    global_spikes_idx=find(count_spike_loc>5);
    global_spikes_loc=all_spike_loc(global_spikes_idx)';
    gs_p1=global_spikes_loc+1;
    gs_s1=global_spikes_loc-1;
    global_spikes_loc=[gs_s1 global_spikes_loc gs_p1];
    global_spikes_loc=unique(global_spikes_loc);
    spike_loc_rem_glo=spike_loc;
    for i=1:9
        % find intersection between spike locations for each pixel in the ROI
        % and the global pixels
        [~,ia,~]=intersect(spike_loc(i,:),global_spikes_loc);
        spike_loc_rem_glo(i,ia)=0;    
    end

    %forming spike sets from these wavelengths
    for i=1:9
        spike_loc_pix=spike_loc_rem_glo(i,:);
        spike_loc_pix=unique(spike_loc_pix);spike_loc_pix=spike_loc_pix(2:end);
        x_p1=spike_loc_pix+1;
        x_s1=spike_loc_pix-1;
        spike_loc_pix=[x_s1 spike_loc_pix x_p1];spike_loc_pix=unique(spike_loc_pix);
    
        %break the wavelengths into spike sets
        spike_diff=spike_loc_pix(2:end)-spike_loc_pix(1:(end-1));
        spike_temp=find(spike_diff~=1);
        spike_p1=spike_temp+1;
        c=size(spike_loc_pix,2);
        if(c~=1)
            spike_end=[1 spike_temp spike_p1 c];spike_end=unique(spike_end);
            temp=spike_loc_pix(spike_end);
            temp=reshape(temp,2,[]);    
            spike_vert{i,1}=temp';
        else
            spike_vert{i,1}=[];
        end
    end
    
    %no of spikes in the middle pixel
    n_spk=size(spike_vert{5,1},1);
    %removing the spikes from the middle spectra
    check_order=[2 8 4 6 1 7 3 9];
    pix_pos=[1 2;3 2;2 1;2 3;1 1;3 1;1 3;3 3];
    spike_vert_5=spike_vert{5,1};
    Y_spectra_corr=squeeze(Y(2,2,:));
    for i=1:n_spk
        flag=1;var=1;
        spike_set=spike_vert_5(i,:);
        %find a neighbouring pixel that does not have this spike
        while(flag)
            C=intersect(spike_vert{check_order(var),1},spike_set,'rows'); 
            if(size(C,1)==0)
                flag=0;
                pix_sel=pix_pos(var,:);
                Corr_spectra=squeeze(Y(pix_sel(1),pix_sel(2),:));
            end
            var=var+1;
        end
    
        %correct for these wavelengths
        if(spike_set(1)==1)
            spike_set(1)=spike_set(1)+1;
        end
        for i=spike_set(1):spike_set(2)
             count_temp=i;
             Y_spectra_corr(count_temp)=(Corr_spectra(count_temp)/...
                 Corr_spectra(count_temp-1))*Y_spectra_corr(count_temp-1);
        end
    end
end      