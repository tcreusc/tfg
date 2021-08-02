
Pmax = 5.8054e+05;
F1 =  -3.0527e+05;

% Cas 1 - Immediately before 1-6 breaks
fdata = [
    1, 1, F1;
    2, 1, Pmax/2;
    ];

% Cas 2 - After 1-6 breaks
fdata = [
    1, 1, 0;
    2, 1, Pmax;
    ];

%Forces i nodes fixats
fixnod = [
    4, 1, 0;
    4, 2, 0;
    4, 3, 0; % s'han d'imposar els tres DOFs...
    5, 1, 0;
    5, 2, 0;
    5, 3, 0; % s'han d'imposar els tres DOFs...
    ];

