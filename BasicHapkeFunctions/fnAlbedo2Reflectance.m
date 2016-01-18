function reflectance = fnAlbedo2Reflectance(w,mu0,mu);
%%
%fnAlbedo2Reflectance.m
% This function is used to do the forward calculation according to the Hapke
% Model and and calculate the reflectance coefficient given the single
% scattering albedo- but additionally also considers the effect of the
% Macroscopic roughness
%
% N.B. : - this model uses the H-Function defined in Bethany's Presentation
%
%------------------------------------------------------------------------------%
% INPUT
%------------------------------------------------------------------------------%
% w              : - single scattering albedo
% mu0            : - cosine of the incidence angle
% mu             : - cosine of the emission angle
%------------------------------------------------------------------------------%
% OUTPUT
%------------------------------------------------------------------------------%
% reflectance    : - the reflectance from the Hapke Function
%------------------------------------------------------------------------------%
%
% Reference      : - "Theory of Reflectance and Emittance Spectroscopy", Bruce 
%                           Hapke, ISBN: 9780521883498
%
%
% Author's Name  : - Arun M Saranathan
% Date           : - 01/24/2014
%----------------------------------------------------------------------------------------------------%


%%
%now at each wavelength find the refelctance
for i=1:size(w,2)
    %find the H-function which is a function of either mu0 or mu and w(lambda)
    H_mu0 = fnHfunction_v1(w(i), mu0);
    H_mu   = fnHfunction_v1(w(i), mu);  
    
    %if P(g) = 1 and b(g) = 0, S(theta) = 0 then according to Cord we have that
    %the reflectance coefficient is 
%     p_g = funPhaseFunctionCal(0.40,0.15,30);

    p_g = 1;
    R(i) =  ( (w(i)/(4*(mu+mu0))) * (p_g -1 + (H_mu0*H_mu)) );
    
    %convert from reflectance coefficient to reflectance
    reflectance(i) = (R(i) ) ;
end



return;
