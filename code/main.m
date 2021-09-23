 %% Main
% Simplement per fer correr els tests
addpath Test

clc; clear;

% dataFile = 'dades.m';
% test = TestSolver.create('FEM', dataFile);
% test.compute();
% test.check();

test = StiffnessTest();
test.checkPassed('dades_stiffness.m')

test = FEMTest();
test.checkPassed('dades.m')

%%%
% test = TestSolver('STIFFNESS');