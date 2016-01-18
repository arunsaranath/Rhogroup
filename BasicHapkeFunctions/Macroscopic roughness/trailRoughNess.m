clear all
close all
clc
%%
% incAngle             = 30;
% refAngle             = 15;
% phaseAngle           = 75;

% % dbstop in fnHapkeRoughnessFactor.m
% [mu0_Mod,mu_Mod, S_theta] = fnHapkeRoughnessFactor...
%                                                       (30,15,75, 30);

%% 
load anglesMap_Fractal.mat
%%
% load the roughness terrain generated before
load thetaVar.mat

thetaVar = thetaVar - min(min(thetaVar));
thetaVar = thetaVar / max(max(thetaVar));
thetaVar = thetaVar * 89;
%%
mu0_Mod = zeros(470,314);
mu_Mod = mu0_Mod; 
S_theta = mu0_Mod;

for i=1:470
    parfor j=1:314
        incAngle      = acosd(mu0(i,j));
        refAngle      = acosd(mu(i,j));
        phaseAngle    = 75;
        tic,
%         dbstop in fnHapkeRoughnessFactor.m
        [mu0_Mod(i,j),mu_Mod(i,j), S_theta(i,j)] = fnHapkeRoughnessFactor...
                                  (incAngle,refAngle,phaseAngle, thetaVar(i,j));
        toc        
    end
end