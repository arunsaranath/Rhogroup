inAngle = 30;
refAngle = 10;
phaseAngle = 31.4749;
%%
% function [mu0_d, mu_d, S_theta] = fnMacroscopicRoughness...
%                                                  (inAngle,refAngle,phaseangle);

%the azimuth angle psi is
psi = acosd( ( cosd(phaseAngle) -   (cosd(inAngle)*cosd(refAngle)) )  / ...
                                             (sind(inAngle)*sind(refAngle)) );
 
%pick the angle THETA at random between 0 and pi/2
theta = rand() * 90;


chi_theta = (1 / sqrt(1 + (pi*tand(theta)*tand(theta)) ) );

%now modified incidence cosine is 
E2_i = exp ( - cotd(theta) * cotd(theta)*cotd(inAngle)*cotd(inAngle)/pi);

E2_e = exp( - cotd(theta) * cotd(theta)*cotd(refAngle)*cotd(refAngle)/pi);

E1_i = exp (- cotd(theta) *cotd(inAngle)/pi);

E1_e = exp (-cotd(theta) *cotd(refAngle)/pi);

% mu0_d = chi_theta(cosd(inAngle) + (sind(refAngle)));

temp1 =  tand(theta) * ( (cosd(psi) * E2_i) + ...
                                     (sind(psi/2) * sind(psi/2) * E2_e ) );
temp2 = 2 - exp (-2 * E1_i) - ((psi/180)* E1_e);                                   

mu0_d = chi_theta *( cosd(inAngle) + ( sind(inAngle) * (temp1/temp2) ) ) ;

temp3 =  tand(theta) * ( (cosd(psi) * E2_i) + ...
                                     (sind(psi/2) * sind(psi/2) * exp(-t12)) );
% 
% mu_d = (1 / sqrt(1 + (pi*tand(theta)*tand(theta)) ) )*(cosd(refAngle) + ...
%     ( sind(refAngle) *temp3/temp2 ) ) ;
% 
% 
% temp4 = tand(theta) * (cosd(psi) * exp(-t12)) ;
% temp5 = 2 - exp (-2 * t21)
% mu0_d0 = (1 / sqrt(1 + (pi*tand(theta)*tand(theta)) ) )*(cosd(inAngle) + ...
%     ( sind(inAngle) * (temp1/temp2) ) ) ;
% 
% 
% % S_theta = 
% % return