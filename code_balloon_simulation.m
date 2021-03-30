%% Estimation de la masse d'hélium
% Pour estimer le volume d'hélium, il faut s'assurer que la poussée Pa est
% supérieure au poids de l'ensemble (enveloppe+parachute+nacelle)
g=9.81; % constante de gravitation
rho_air=1.16; % masse volumique standard de l'air
rho_he=0.1657; % masse volumique standard de l'hélium
m_nacel=3; % masse de la nacelle [kg]
m_env=0.6;  % masse de l'enveloppe [kg]
m_para=2.4;  % masse de la parachute[kg]
m_gross=m_nacel+m_para+m_env;  % masse de l'ensemble(enveloppe+parachute+nacelle) 
gamma=0.1; % pourcentage d'inflation pour la Pa
% le Volume minimal necessaire:
Vmin=m_gross*(1+gamma)/(rho_air-rho_he); % volume minimal [m^3/Kg]
fprintf("Le volume minimal Hélium est de");
disp(Vmin);
rb=(3*Vmin/(4*pi))^(1/3);
db=2*rb;
% La masse minimale d'hélium
M_he=rho_he*Vmin; % masse minimale Hélium [Kg]
fprintf("La masse minimale Hélium est de");
disp(M_he);
%% Variation des masses volumiques de l'air et hélium en fonction de l'altitude
data=xlsread("balloon_properties.xlsx");
var_h=data(:,1);
p_air=data(:,5);
p_He=data(:,6);
var_VolHe=data(:,7);
figure
plot(var_h,p_air);
xlabel("Altitude [m]");
ylabel("Masse volumique [m^3/kg]");

hold on
plot(var_h,p_He);
legend("Air","Hélium");
%% Motion's Equations
%% Ascension model
% En direction verticale Z
% m_v*a_z = GI - m_gross*g - Dz avec GI net inflation, Dz le drag en Z
% m_v*a_z= g*(rho_air*Vb - M_he - m_gross) - Dz
% m_v = (m_gross + M_he + m_virt)  Masse totale + masse virtual
% m_virt = (Cm*rho_air*Vb)  masse virtuelle du au Lift
% Dz= (0.5*rho_air*Vrel^2*Ab*Cd) drag en direction Z
% Ab= Pi/4*db^2 aire section du ballon
Ab=(pi/4)*db^2;
% Cd coefficient de drag
Cd=0.5;
Cm=0.65;
% Vrel= (Vwind - Vz) vitesse relative vent - ballon
Vventz=0;
m_virt=Cm*rho_air*Vmin;

% En direction X
% m_v*a_x = Dx
% Dx = (0.5*rho_air*Vrel^2*Ab*Cd)
% Vrel= (Vwind - Vx)
Vventx=12;
% En direction Y
% m_v*a_y = Dy
% Dx = (0.5*rho_air*Vrel^2*Ab*Cd)
% Vrel= (Vwind - Vy)
Vventy=15;
% Résolution avec Simulink
%% Descente

% Vitesse terminale ( a l'impact)
% Vt=-sqrt((2*m_gross*g)/(rho_air*Ap*Cd))
% Ap: aire section parachute
% Cd: coefficient de drag