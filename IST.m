%%
clc
clear all
close all

T = 300;
Lch = 90e-9;
Lch_des = 16e-9;
Vdd = 3;
family = 2;
Vth = Vdd/family;
xj = 50e-9;
Na = 9.2e16;
Tox = 15e-9;
er_SiO2 = 3.9;
eps = 8.854e-12;
PhiM = 4.05;
X = 4.05;
PhiSi = @(PhiP) Eg/2 + PhiP + X;
ni = 1.02e10;
q = 1.62e-19;
kB = 8.8167e-5;
vt = kB*T;
Eg = 1.11;
Cox = (eps*er_SiO2*1e-2)/(Tox*1e2);
eSi = eps*3*er_SiO2;

Vth_foo = @(Na) PhiM - (Eg/2 + vt*log(Na/ni) + X) + 2*vt*log(Na/ni) + ...
    (1/Cox)*sqrt(2*eSi*q*Na*2*vt*log(Na/ni)) - Vth;

Na = fzero(Vth_foo,5e15);
Nd = 1e17;

PhiJ = vt*log((Na*Nd)/(ni^2));
xdepJ = sqrt((2*eSi*1e-2/(q*Na))*(0.7+Vdd))*1e-2;
Cdep = eSi/xdepJ;

TBOX = 100e-9;
TSi = 8.5e-9;
k_factor = Lch/Lch_des;

Na_des = k_factor*Na;
xj_des = xj/k_factor;
xdepJ_des = xdepJ/k_factor;
Tox_des = Tox/(k_factor^(3/2));
Cox_des = Cox*(k_factor^(3/2));
Vdd_des = Vdd/k_factor;
Vth_des = Vth/k_factor;



