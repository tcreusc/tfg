
% Geometric data
H1 = 0.22; % m
H2 = 0.36; % m
H3 = 0.48; % m
H4 = 0.55; % m
H5 = 2.1; % m
L1 = 0.9; % m
L2 = 0.5; % m
L3 = 0.5; % m
L4 = 2.5; % m
L5 = 4.2; % m

% Nodal coordinates
%  x(a,j) = coordinate of node a in the dimension j
x = [
      0,          H1; % Node 1
      0,       H1+H2; % Node 2
      0,    H1+H2+H3; % Node 3
      0, H1+H2+H3+H4; % Node 4
    -L1, H1+H2+H3+H4; % Node 5
];

% Nodal connectivities  
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [
    1, 2; % Element 1-2
    2, 3; % Element 2-3
    3, 4; % Element 3-4
    3, 5; % Element 3-5
];

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Section inertia of material m
mat = [% Young M.        Section A.    Inertia 
               E,               AA,        IzA;  % Material 1
               E,               AB,        IzB;  % Material 2
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [
    1; % Element 1-2 / Material 1 (A)
    1; % Element 2-3 / Material 1 (A)
    1; % Element 3-4 / Material 1 (A)
    2; % Element 3-5 / Material 2 (B)
];
