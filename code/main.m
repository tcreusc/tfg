 %% Main
% Simplement per fer correr els tests
addpath Test

clc; clear;

dataFile = 'dades.m';
%test = Test.create('FEM', dataFile);
test = TestSolver(dataFile);
test.runAnalyses();
test.check();

%%%
% test = TestSolver('STIFFNESS');