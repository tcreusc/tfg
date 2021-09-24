 %% Main
% Simplement per fer correr els tests
addpath Test

clc; clear;

file1 = 'dades_stiffness.m';
test = TestSolver().create('STIFFNESS', file1);
test.checkPassed(file1)

file2 = 'dades.m';
test2 = TestSolver().create('FEM', file2);
test2.checkPassed(file2)