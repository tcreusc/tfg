 %% Main
% Simplement per fer correr els tests

clc; clear;

dataFile = 'dades.m';
test = Test(dataFile);
test.runAnalyses();
test.check();