function E2_x = fnCalculateE2(theta,x);
%%
%fnCalculateE2.m
% This function changes the angle as per the macroscopic roughness factor
% defined as per eqn 12.45c in hapke
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

temp = cotd(theta) * cotd(theta) * cotd(x) * cotd(x);

E2_x = exp(-temp/pi);
end