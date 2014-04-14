function specLibAlbedo = fnReflectance2Albdeo_newH(R,mu0,mu,p_g,B_g);
%%
%fnReflectance2Albdeo_newH.m
% This function perfroms the reverse hapke equation to calculate the single scattering
% albedo from the the reflectances
%----------------------------------------------------------------------------------------------------%
% INPUT
%----------------------------------------------------------------------------------------------------%
% R      : - single scattering albedo
% mu0 : - cosine of the incidence angle
% mu   : - cosine of the emission angle
% p_g  : - phase function
% B_g  : - Backscatter function
%----------------------------------------------------------------------------------------------------%
% OUTPUT
%----------------------------------------------------------------------------------------------------%
% specLibAlbedo : - the single scattering albedo from the Hapke Function
%
% Reference : - "Theory of Reflectance and Emittance Spectroscopy", Bruce 
%                           Hapke, ISBN: 9780521883498
%
%
% Author's Name : - Arun M Saranathan
% Date                  : - 01/23/2014
%----------------------------------------------------------------------------------------------------%
%%
%if not already open matlab pool
sz = matlabpool('size');
if(sz == 0)
   matlabpool local 4 
end

%this function includes the effects of p(g) and B(g) in the calculation of the
%albedo
syms w
r0 = (1-sqrt(1-w))/(1+sqrt(1-w));
H_mu = 1/ ( 1 - w*mu * (r0 + ( (1-2*r0*mu)/2) * log((1+mu)/mu) ) );
H_mu0 = 1/ ( 1 - w*mu0 * (r0 + ( (1-2*r0*mu0)/2) * log((1+mu0)/mu0) ) );

eqn = ( w / (4*(mu0 + mu)) ) * (  H_mu0 * H_mu  -1 + p_g) ;

tic,
parfor i=1:size(R,2)
     i
    temp = double( solve(eqn== R(i) ) ) ;  
    W_m(i) = temp(1);
end
toc

if(sz ~= 0)
   matlabpool close
end

clear w eqn


specLibAlbedo  = W_m ;
return