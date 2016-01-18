clear all
close all
clc
%load your image 
str1= 'E:\IMAGES\CRISM\MTRDR\FRT000199C7\';
str2='FRT000199C7_07_IF166L_TRR3_SYS_fix_65sGone_b115_358_despiked_ratioed.img';
fnameIn = strcat(str1, str2);
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
x_loc=221;
y_loc=436;
[Y ~]=pickROI(fnameIn,opt,x_loc,y_loc,1,1);
Y_corr=zeros(3,3,bands);
%%
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
        size_spk=size(x,2);
        spike_loc(track,1:size_spk)=x;
        track=track+1;
        
        %remove the spikiy bands and interpolate over them
        nspky_bands=(1:231);
        full_bands=(1:231);
        nspky_bands(x)=[];
        im_spectra_nspky=im_spectra(nspky_bands);
        Y_corr(i,j,:)=interp1(nspky_bands,im_spectra_nspky,full_bands);
    end
end
clear line line11 track size_spk line i j
%%

spectra_corr_pix=squeeze(Y(2,2,:));
spectra_comp_pix=squeeze(Y(1,1,:));
corr_spectra_pix=squeeze(Y_corr(2,2,:));
spike_loc_corr_pix=unique(spike_loc(5,:));
spike_loc_corr_pix=spike_loc_corr_pix(2:end);
spike_loc_corr_pix1=unique(spike_loc(8,:));
spike_loc_corr_pix1=spike_loc_corr_pix1(2:end);
xax=(1:bands);



figure()
plot(xax,spectra_corr_pix,'g-')
hold all
plot(xax(spike_loc_corr_pix),spectra_corr_pix(spike_loc_corr_pix),'r+')
plot(xax,corr_spectra_pix,'b-')
% plot(xax,squeeze(Y(1,1,:)),'r-')
% plot(xax(spike_loc_corr_pix1),spectra_comp_pix(spike_loc_corr_pix1),'r+')
hold off


%%
%now correct when the spectra for the spiky regions with the those
%neighbors that have no spikes
spike_pos=unique(spike_loc(5,:));spike_pos=spike_pos(2:end);
Y_rshpk=reshape(Y,9,231);
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
    
    if(spike_position(3)==182)
             spike_position
    end
   
    if(~isempty(Corr_spectra))
         
        Y_spectra_n_corr(spike_position(3))=...
                        (Corr_spectra(2)/Corr_spectra(1))*...
                                       Y_spectra_n_corr(spike_position(3)-1);
    end
end

figure()
plot(xax,spectra_corr_pix,'g-')
hold all
plot(xax(spike_loc_corr_pix),spectra_corr_pix(spike_loc_corr_pix),'r+')
plot(xax,corr_spectra_pix,'b-')
plot(xax,Y_spectra_n_corr,'r-')
hold off

%%
% var=1;
% yline=y_loc-1;
% for i=1:3
%     figure()
%     hold all
%     xline=x_loc-1;
%     for j=1:3
%         spike_loc_p=unique(spike_loc(var,:));
%         spike_loc_p=spike_loc_p(2:end);
%         y_spex=squeeze(Y(j,i,:));
%         plot(xax,y_spex)
%         plot(xax(spike_loc_p),y_spex(spike_loc_p),'r+');
%         xline=xline+1;
%         var=var+1;
%     end
%     hold off
%     s=sprintf('plots for sample %d all lines',yline);
%     hleg1=legend(s);
%     yline=yline+1;    
% end
%%
%write in this file



