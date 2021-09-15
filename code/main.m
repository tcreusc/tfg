%% Main
% Simplement per fer correr els tests

clc; clear;

% [DFpathstr, DFfilename] = uigetfile('Data file');
% dataFile = fullfile(DFfilename, DFpathstr);

dataFile = 'dades.m';
test = Test(dataFile);
test.runAnalyses();
test.check();