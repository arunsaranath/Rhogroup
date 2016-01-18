function spectraGZ = fnGenerateGrainAlbedo_v2(n,k,wavL,mingrainSize,...
                                                      maxgrainSize,gamma,beta);

%%
%fnGenerateGrainAlbedo_v2.m
% Use the formula based on optical constants to generate the single scattering
% albedo for different grain sizes.
%-----------------------------------------------------------------------------%
% INPUT
%-----------------------------------------------------------------------------%
% n                 : - the optical constant n
% k                 : - the optical constant k (vector)
% wavL              : - the wavelength range under consideration
% mingrainSize      : - the grainSize (min) at which we are finding the albedo
% maxgrainSize      : - the grainSize (max) at which we are finding the albedo
% gamma             : - constant in the formula for s_i
% beta              : - multiplier constant for irregular particles
%----------------------------------------------------------------------------------------------------%
% OUTPUT
%----------------------------------------------------------------------------------------------------%
% spectraGZ         : - the Single Scattering Albedo at this grain size
%
% Reference         : - "RADIATIVE TRANSFER MODELING FOR QUANTIFYING LUNAR 
%                        SURFACE MINERALS, PARTICLE SIZE AND SUBMICROSCOPIC
%                       IRON", Shuai Li, Masters Thesis
%
%
% Author's Name         : - Arun M Saranathan
% Date                  : - 01/23/2014
%----------------------------------------------------------------------------------------------------%
%%
%spherical particles
% d_corr = (2/3) * ( (n^2) - ( (1/n)  * ((n^2) -1)^(3/2) ) ) * grainSize ;

%irregular particles
d_corr = beta * grainSize;

%now the other factors change with wavelength
for i=1:size(wavL,1);
    %calculate the variable alpha
    alpha = (4* pi * n(i) * k(i)) / (wavL(i) * 10^(-6));
    %calculate theta
    theta = exp(-alpha * d_corr);
    %calculate s_e
    s_e = ( ((n(i)-1)^2 + (k(i))^2) / ((n(i)+1)^2 + (k(i))^2) ) + 0.05;
    %calculate s_i
    s_i = gamma - (4/ (n(i) * (n(i)+1)^2 ) );
    
    %now calculate the single scattering albedo as
    w(i) = s_e + (1-s_e) * ( ((1-s_i) * theta) / (1-(s_i * theta)) ) ;
end

spectraGZ = 1 * w;

return