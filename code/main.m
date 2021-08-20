%% Main
% Simplement per fer correr els tests

clc; clear;

[MDpathstr, MDfilename] = uigetfile('Material data file');
materialDataFile = fullfile(MDfilename, MDpathstr);

[GDpathstr, GDfilename] = uigetfile('Geometric data file');
geometricDataFile = fullfile(GDfilename, GDpathstr);

[BDpathstr, BDfilename] = uigetfile('Boundary data file');
boundaryDataFile = fullfile(BDfilename, BDpathstr);

test = Test(materialDataFile, geometricDataFile, boundaryDataFile);
display(test.status)