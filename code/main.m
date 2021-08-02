%% Main
% Simplement per fer correr els tests

clc; clear;

test = Test('materialData.m', 'geometricData.m', 'boundaryData.m');
display(test.status)