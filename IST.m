%%
clc
clear all
close all
format shortEng

T = 300; % [K]                              % Absolute Temperature
Lch = 180e-9; % [m]                         % Starting Channel Length
Lch_des = 16e-9; % [m]                      % Result Channel Length
Vdd = 3; % [V]                              % Supply Voltage
Vth = []; % [V]                             % Threshold Voltage
Na = 8e15; % [cm-2]                         % Channel Doping
Nd_LDD = 7e19; % [cm-2]                     % LDD Doping
Nd_SD = 4e20 ; % [cm-2]                     % S&D Doping
EOT = 3e-9; % [m]                           % Equivalent Oxide Thickness
er_SiO2 = 3.9;                              % Relative SiO2 Permittivity
er_Si = 11.8;                               % Relative Si Permittivity
er_HfO2 = 23;                               % Relative HfO2 Permittivity
eps = 8.845e-14; % [F/cm]                   % Absolute Free Space Permittivity
PhiM = 4.5; % [eV]                          % Metal Work Function
X = 4.05; % [eV]                            % Silicon Electron Affinity
ni = 1.08e10; % [cm-2]                      % Intrinsic Silicon Carrier Density
Cox = (eps*er_SiO2)/(EOT); % [F]       % Gate Oxide Capacitance
q = 1.602e-19; % [C]                        % Electron Elementay Charge
kB = 8.617e-5; % [eV/K]                     % Boltzmann Constant 
vt = kB*T; % [V]                            % Termal Voltage
Egap = 1.11; % [eV]                         % Silicon Enegy Gap
TBOX = 50e-9; % [m]                         % BOX Thickness
TSi = 10e-9; % [m]                          % Silicon Sheet Thickness
W_spacers = 60e-9;                          % Spacers Width
H_gate = 180e-9;                            % Gate Height
k_factor = Lch/Lch_des;                     % Scaling Factor

Vth_foo = @(Na) (PhiM - vt.*log(Na./ni) - X - 0.5*Egap) + 2*vt.*log(Na./ni) + (1/Cox).* ...
                sqrt(2*eps*er_Si*q.*Na.*2*vt.*log(Na./ni));

xd_SI_foo = @(Na) sqrt((2*er_Si*eps*2*vt*log(Na./ni))./(q.*Na))*1e-2;
Na_base = logspace(15,20,10000);
xd_SI_plot = xd_SI_foo(Na_base);
Vth_plot = Vth_foo(Na_base);

figure()
yyaxis left
semilogx(Na_base,xd_SI_plot/1e-9,'Linewidth',2.5);
yyaxis right
semilogx(Na_base,Vth_plot,'Linewidth',2.5);

xd_SI = xd_SI_foo(Na); 

Na_des = k_factor*Na;
Tox_des = EOT/(k_factor^(3/2));
Cox_des = Cox*(k_factor^(3/2));
xd_SI_des = xd_SI_foo(Na_des); 
TSi_des = min([xd_SI_des Lch_des/4]);



Vdd_des = Vdd/k_factor;
Vth_des = Vth/k_factor;


% figure()
% plot(Vgs,Ids,'Linewidth',2); hold on
% 
% gm = ((Vgs(end)-Vgs(end-200))/(Ids(end)-Ids(end-200)))^-1;
% Ids0 = (Vgs(end)*Ids(end-200) - Vgs(end-200)*Ids(end))/(Vgs(end)-Vgs(end-200));
% Ids_line = Ids0 + gm*Vgs;
% 
%  plot(Vgs,Ids_line,'Linewidth',2)

%%
clc
close all

%plot(VGS,IDS,'Linewidth',2)
hold on
IDS_sqrt = sqrt(IDS);
%plot(VGS,IDS_sqrt,'Linewidth',2)
plot(VGS(10:end-1),diff(sqrt(IDS(10:end))),'Linewidth',2);
hold on
max(diff(sqrt(IDS(10:end))))