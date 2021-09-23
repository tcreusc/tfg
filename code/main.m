 %% Main
% Simplement per fer correr els tests
addpath Test

clc; clear;

dataFile = 'dades.m';
%test = Test.create('FEM', dataFile);
test = TestSolver.create('FEM', dataFile);
test.compute();
% test.check();

%%%
% test = TestSolver('STIFFNESS');