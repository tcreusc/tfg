 %% Main
% Simplement per fer correr els tests
addpath Test

clc; clear;

dataFile = 'dades.m';
test = Test(dataFile);
test.runAnalyses();
test.check();

% ForcesComputer i DOFFixer tenen nod3dof