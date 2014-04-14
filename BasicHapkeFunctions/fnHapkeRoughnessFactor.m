function [mu0_Mod,mu_Mod, S_theta] = fnHapkeRoughnessFactor(incAngle,refAngle...
                                                            ,phaseAngle, theta);
%%
%fnHapkeRoughnessFactor.m
% This function changes the angle as per the macroscopic roughness factor
% defined as per the 12th chapter in hapke
%------------------------------------------------------------------------------%
% INPUT
%------------------------------------------------------------------------------%
% incAngle      : - the incidence angle
% refAngle      : - the emission  angle
% phaseAngle    : - the phase angle
% theta         : - the roughness angle there
%------------------------------------------------------------------------------%
% OUTPUT
%------------------------------------------------------------------------------%
% mu0_Mod       : - the cosine of the modified incidence angle
% mu_Mod        : - the cosine of the modified emission  angle
% S_theta       : - the multiplier S_theta
%
% Reference     : - "Theory of Reflectance and Emittance Spectroscopy", Bruce 
%                           Hapke, ISBN: 9780521883498
%------------------------------------------------------------------------------%
% Author's Name : - Arun M Saranathan
% Date          : - 02/28/2014
%------------------------------------------------------------------------------%
%%
% as the first step calculate the value if chiof theta according to eqn 12.45a
chi_theta = 1 / sqrt( 1 + ( pi*tand(theta)*tand(theta) ) ) ;

%calculate the angle psi using the relation ship between the angles
temp1 = cosd(incAngle) * cosd(refAngle);
temp2 = sind(incAngle) * sind(refAngle) * cosd(phaseAngle);

psi = acosd(temp1 - temp2);

clear temp1 temp2

mu0   =  cosd(incAngle);
mu    =  cosd(refAngle);
%% 
% the value of mu0_Mod0 and mu_Mod0
mu0_Mod0 = chi_theta * ( cosd(incAngle) + ( sind(incAngle) * tand(theta) *...
    (fnCalculateE2(theta,incAngle)/(2 - fnCalculateE1(theta,incAngle))) ) );

mu_Mod0 = chi_theta * (cosd(refAngle) + ( sind(refAngle) * tand(theta) *...
    (fnCalculateE2(theta,refAngle)/(2 - fnCalculateE1(theta,refAngle))) ) );

% now let's calculate the multiplies
f_psi = exp(-2 * tand(psi/2));

%%
% now recalculate mu0 and mu as per the equations
if (incAngle <= refAngle)
    %first doing the mu0
    num = ( (sind(psi/2))^2 * fnCalculateE2(theta,incAngle)) + ...
        (cosd(psi) * fnCalculateE2(theta,refAngle));
    
    den = 2 - fnCalculateE1(theta,refAngle) - ...
                                     (psi * fnCalculateE1(theta,incAngle)/180);
                                   
    mu0_Mod = chi_theta * ...
              ( cosd(incAngle) + ( sind(incAngle) * tand(theta) * num/den ) );
    
    clear num den
    
    %now doing the mu
    num = - ((sind(psi/2))^2 * fnCalculateE2(theta,incAngle)) + ...
        (1 * fnCalculateE2(theta,refAngle));
    
    den = 2 - fnCalculateE1(theta,refAngle) - ...
                                     (psi * fnCalculateE1(theta,incAngle)/180);
                                 
    mu_Mod = chi_theta * ...
              ( cosd(refAngle) + ( sind(refAngle) * tand(theta) * num/den ) );
    clear num den
    
    %now calculate the the S_theta
    mult1 = chi_theta / (1 - f_psi + (f_psi * chi_theta * mu0/mu0_Mod0));
    
    S_theta =  (mu_Mod/mu_Mod0) * (mu0/mu0_Mod0) * mult1 ;
    
else
    %first doing the mu0
    num = ((sind(psi/2))^2 * fnCalculateE2(theta,refAngle)) + ...
        (1 * fnCalculateE2(theta,incAngle));
    
    den = 2 - fnCalculateE1(theta,incAngle) - ...
                                     (psi * fnCalculateE1(theta,refAngle)/180);
                                   
    mu0_Mod = chi_theta * ...
              ( cosd(incAngle) + ( sind(incAngle) * tand(theta) * num/den ) );
    
    clear num den
    
    %now doing the mu
    num = - ((sind(psi/2))^2 * fnCalculateE2(theta,refAngle)) + ...
        (cosd(psi) * fnCalculateE2(theta,incAngle));
    
    den = 2 - fnCalculateE1(theta,incAngle) - ...
                                     (psi * fnCalculateE1(theta,refAngle)/180);
                                 
    mu_Mod = chi_theta * ...
              ( cosd(refAngle) + ( sind(refAngle) * tand(theta) * num/den ) );
    clear num den
    
    %now calculate the the S_theta
    mult1 = chi_theta / (1 - f_psi + (f_psi * chi_theta * mu/mu_Mod0));
    
    S_theta =  (mu_Mod/mu_Mod0) * (mu0/mu0_Mod0) * mult1 ;
end


return;                                                        