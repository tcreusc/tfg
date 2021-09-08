%% Main
% Simplement per fer correr els tests

clc; clear;

[DFpathstr, DFfilename] = uigetfile('Data file');
dataFile = fullfile(DFfilename, DFpathstr);

analysis = Analysis(dataFile);
analysis.perform();
analysis.check();