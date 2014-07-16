clear all
close all
clc
%load your image 
fnameIn='C:\Users\arunsaranath\Downloads\IMAGES\CRISM\MTRDR\FRT000094F6\FRT000094F6_07_IF166J_TER3_CAT_despike_cropMTRDR.img';
opt=2;
%read whole image
[im_uc,info]=enviread(fnameIn);
if(opt==1)
    im_uc=im_uc(:,:,115:359);
end
[lines,samples,bands]=size(im_uc);
%%
%pick all the spectra from the region of interest
tic,
x_loc=204;
y_loc=358;
[Y ~]=pickROI(fnameIn,opt,x_loc,y_loc,1,0);
Y_corr=zeros(3,3,bands);
Y_spk=zeros(3,3,bands);
%%
%for each of the 9 spectra in the ROI find spike locations
spike_loc=zeros(9,50);
track=1;
for i=1:3
    for j=1:3
        im_spectra=squeeze(Y(i,j,:));
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
                    if(abs(im_spectra_si(pos-1))<=(0.15*abs(im_spectra_si(pos))))
                        x(k)=0;
                    end
                else
                    if(abs(im_spectra_si(pos))<=(0.15*abs(im_spectra_si(pos-1))))
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
        
        %remove the spikiy bands and interpolate over them
        nspky_bands=(1:bands);
        full_bands=(1:bands);
        nspky_bands(x)=[];
        im_spectra_nspky=im_spectra(nspky_bands);
        Y_corr(i,j,:)=interp1(nspky_bands,im_spectra_nspky,full_bands);
        Y_spk(i,j,x)=Y(i,j,x);
    end
end
clear line line11 track size_spk line i j


%%

spectra_pix=squeeze(Y(2,2,:));
comp_pix_spectra=squeeze(Y(1,3,:));
corr_spectra_pix=squeeze(Y_corr(2,2,:));
spike_loc_corr_pix=unique(spike_loc(5,:));
spike_loc_corr_pix=spike_loc_corr_pix(2:end);
xax=(1:bands);
figure()
plot(xax,spectra_pix,'g-')
hold all
plot(xax(spike_loc_corr_pix),spectra_pix(spike_loc_corr_pix),'r+')
plot(xax,corr_spectra_pix,'b-')
% plot(xax,comp_pix_spectra,'r-')
hold off
%%
wavelength=wvl_94F6()';
pix_204_358=[wavelength spectra_pix corr_spectra_pix comp_pix_spectra];
xlswrite('pix.xls', pix_204_358);
%%
Y_rshp=reshape(Y,9,231);
Y_rshp(2,:)=Y_rshp(2,:)+0.025;
Y_rshp(3,:)=Y_rshp(3,:)+0.05;
Y_rshp(4,:)=Y_rshp(4,:)+0.075;
Y_rshp(5,:)=Y_rshp(5,:)+0.1;
Y_rshp(6,:)=Y_rshp(6,:)+0.115;
Y_rshp(7,:)=Y_rshp(7,:)+0.15;
Y_rshp(8,:)=Y_rshp(8,:)+0.175;
Y_rshp(9,:)=Y_rshp(9,:)+0.2;

Y_rshp=Y_rshp';

%
Y_spk_only=reshape(Y_spk,9,231);
Y_spk_only(2,:)=Y_spk_only(2,:)+0.025;
Y_spk_only(3,:)=Y_spk_only(3,:)+0.05;
Y_spk_only(4,:)=Y_spk_only(4,:)+0.075;
Y_spk_only(5,:)=Y_spk_only(5,:)+0.1;
Y_spk_only(6,:)=Y_spk_only(6,:)+0.115;
Y_spk_only(7,:)=Y_spk_only(7,:)+0.15;
Y_spk_only(8,:)=Y_spk_only(8,:)+0.175;
Y_spk_only(9,:)=Y_spk_only(9,:)+0.2;

Y_spk_only=Y_spk_only';
pix_all_spky=[wavelength Y_rshp Y_spk_only];
xlswrite('pix_all_spky.xls', pix_all_spky);
%%
Y_rshp_nspk=reshape(Y_corr,9,231);
Y_rshp_nspk(2,:)=Y_rshp_nspk(2,:)+0.025;
Y_rshp_nspk(3,:)=Y_rshp_nspk(3,:)+0.05;
Y_rshp_nspk(4,:)=Y_rshp_nspk(4,:)+0.075;
Y_rshp_nspk(5,:)=Y_rshp_nspk(5,:)+0.1;
Y_rshp_nspk(6,:)=Y_rshp_nspk(6,:)+0.115;
Y_rshp_nspk(7,:)=Y_rshp_nspk(7,:)+0.15;
Y_rshp_nspk(8,:)=Y_rshp_nspk(8,:)+0.175;
Y_rshp_nspk(9,:)=Y_rshp_nspk(9,:)+0.2;

Y_rshp_nspk=Y_rshp_nspk';

figure()
plot(wavelength,Y_rshp_nspk(:,5))
pix_no_spky=[wavelength Y_rshp_nspk];
xlswrite('pix_no_spky.xls', pix_no_spky);
% %%
% %count how many times spike occurs in the neighbourhood. If it occurs in 
% %most of the pixels it's a global effect so dont correct for it
% all_spike_loc=spike_loc(:);
% all_spike_loc=unique(all_spike_loc);all_spike_loc=all_spike_loc(2:end);
% count_spike_loc=histc(spike_loc(:),all_spike_loc);
% global_spikes_idx=find(count_spike_loc>=6);
% global_spikes_loc=all_spike_loc(global_spikes_idx)';
% gs_p1=global_spikes_loc+1;
% gs_s1=global_spikes_loc-1;
% global_spikes_loc=[gs_s1 global_spikes_loc gs_p1];
% global_spikes_loc=unique(global_spikes_loc);
% spike_loc_rem_glo=spike_loc;
% for i=1:9
%     % find intersection between spike locations for each pixel in the ROI
%     % and the global pixels
%     [~,ia,~]=intersect(spike_loc(i,:),global_spikes_loc);
%     spike_loc_rem_glo(i,ia)=0;    
% end
% 
% %%
% %forming spike sets from these wavelengths
% for i=1:9
%     spike_loc_pix=spike_loc_rem_glo(i,:);
%     spike_loc_pix=unique(spike_loc_pix);spike_loc_pix=spike_loc_pix(2:end);
%     x_p1=spike_loc_pix+1;
%     x_s1=spike_loc_pix-1;
%     spike_loc_pix=[x_s1 spike_loc_pix x_p1];spike_loc_pix=unique(spike_loc_pix);
% 
%     %break the wavelengths into spike sets
%     spike_diff=spike_loc_pix(2:end)-spike_loc_pix(1:(end-1));
%     spike_temp=find(spike_diff~=1);
%     spike_p1=spike_temp+1;
%     c=size(spike_loc_pix,2);
%     spike_end=[1 spike_temp spike_p1 c];spike_end=unique(spike_end);
%     temp=spike_loc_pix(spike_end);
%     temp=reshape(temp,2,[]);    
%     spike_vert{i,1}=temp';
% end
% %%
% %no of spikes in the middle pixel
% n_spk=size(spike_vert{5,1},1);
% %removing the spikes from the middle spectra
% check_order=[2 8 1 3 7 9 4 6];
% pix_pos=[2 1;2 3;1 1;1 3;1 3;3 3;1 2;3 2];
% spike_vert_5=spike_vert{5,1};
% Y_spectra_corr=squeeze(Y(2,2,:));
% for i=1:n_spk
%     flag=1;var=1;
%     spike_set=spike_vert_5(i,:);
%     neigh_pix_no=1;
%     %find a neighbouring pixel that does not have this spike
%     while(flag)
%         spike_loc_pix=spike_loc_rem_glo(check_order(var),:);
%         spike_loc_pix=unique(spike_loc_pix);spike_loc_pix=spike_loc_pix(2:end);
%         x_p1=spike_loc_pix+1;
%         x_s1=spike_loc_pix-1;
%         spike_loc_pix=[x_s1 spike_loc_pix x_p1];spike_loc_pix=unique(spike_loc_pix);
%         spike_wvl=spike_set(1):spike_set(2);
%         
%         
%         C=intersect(spike_loc_pix,spike_wvl); 
%         if(size(C,2)==0)
%             flag=0;pix_found=1;
%             pix_sel=pix_pos(var,:);
%             Corr_spectra=squeeze(Y(pix_sel(1),pix_sel(2),:));
%             neigh_pix_no=neigh_pix_no+1;
%             if(neigh_pix_no==9)
%                 flag=0;
%                 pix_found=0;
%             end
%         end
%         var=var+1;
%         
%     end
%     
%     if(spike_set(1)==1)
%         spike_set(1)=spike_set(1)+1;
%     end
%     
%     %correct for these wavelengths
%     if(pix_found==1)
%         for j=spike_set(1):spike_set(2)
%             count_temp=j;
%             Y_spectra_corr(count_temp)=(Corr_spectra(count_temp)/...
%                  Corr_spectra(count_temp-1))*Y_spectra_corr(count_temp-1);
%         end
%     end
% end
% toc
% %%
% x_line=x_loc-1;
% 
% fig=1;
% track=1;
% if (fig~=0)
%     for i=1:3
%         figure()
%         hold all
%         y_line=y_loc-1;
%         for j=1:3
%             temp=(spike_loc_rem_glo(track,:));
%             temp=unique(temp);temp=temp(2:end);
%             idx=temp(2:end);
%             y_spec=squeeze(Y(i,j,:));
%             plot(xax,y_spec)
%             [~,~,~,Outm]=legend;
%             s=sprintf('pixels for detector no %d and sample no %d',y_line,x_line);
%             hleg=legend(Outm,s);
%             plot(xax(idx),y_spec(idx),'r+')
%             [~,~,~,Outm]=legend;
%             s=sprintf('spikes for pixel at %d and sample no %d',y_line,x_line);
%             hleg=legend(Outm,s);
%             y_line=y_line+1;
%             track=track+1;
%         end
%         x_line=x_line+1;    
%         hold off
%     end
% end
% 
% %%
% 
% 
% figure()
% plot(xax,Y_spectra_corr);
% hold all
% plot(xax,squeeze(Y(2,2,:)));
% s=sprintf('spikes and correction for pixel at %d and sample no %d',y_loc,x_loc);
% hleg=legend(s);
% hold off
% % axis([0 250 1.75 2.25])
% 
% clear i ans gs_p1 gs_s1 i ia idx s im_spectra im_spectra_d im_spectra_td
% clear j lim opt p size_spk temp track x_line x_loc x_rx y_line y_loc
% clear c flag n_spk x x_p1 x_s1  rem_pix
