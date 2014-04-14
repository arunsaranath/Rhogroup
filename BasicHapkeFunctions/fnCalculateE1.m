function E1_x = fnCalculateE1(theta,x);
%%
%fnHapkeRoughnessFactor.m
% This function changes the angle as per the macroscopic roughness factor
% defined as per eqn 12.45b in hapke
%------------------------------------------------------------------------------%
% INPUT
%------------------------------------------------------------------------------%
% theta  
% x
%------------------------------------------------------------------------------%
% OUTPUT
%------------------------------------------------------------------------------%
% E1_x
% Reference : - "Theory of Reflectance and Emittance Spectroscopy", Bruce 
%                           Hapke, ISBN: 9780521883498
%------------------------------------------------------------------------------%
%
% Author's Name         : - Arun M Saranathan
% Date                  : - 02/28/2014
%------------------------------------------------------------------------------%
%%

temp = cotd(theta) * cotd(x);

E1_x = exp(-2*temp/pi);


end