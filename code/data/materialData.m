% Material properties
E = 200e9; % Pa

% Cross-section parameters
d = 110e-3; % m
tA = 5e-3; % m
a = 25e-3; % m
b = 75e-3; % m
tB = 3e-3; % m

% Mat parameters
Dext = d+tA/2;
Dint = d-tA/2;

AA = pi*((Dext/2)^2 - (Dint/2)^2);
IzA = pi/4*((Dext/2)^4 - (Dint/2)^4);

AB = 2*a*tB+tB*(b-tB);
IzB = 1/4*( ( (b-tB)^3*tB + 2*tB^3*a)/3 + 2*b^2*tB*a);


% Other data
T = 15e3; % N
Vto = 70; % m/s
dto = 65; % m
Mt = 15800; % kg
sig_rot = 230e6; % MPa
g = 9.81; % m/s2
