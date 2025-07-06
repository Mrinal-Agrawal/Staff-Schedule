% Staff Scheduling using TLBO
clear; clc;

% Input Data
numDays = 7; % Planning horizon (days)
numEmployees = 10; % Total number of employees
coverage = [4, 4, 4, 4, 4, 4, 4]; % Daily employee requirements

blockDuration = 3; % Max days in one work block
restDuration = 2; % Max days of rest after a block
maxSpecialDays = 2; % Max workdays on special days (e.g., weekends)

% TLBO Parameters
Np = 20; % Population size
T = 100; % Number of generations

% Initialize Population (Valid binary encoding)
lb = zeros(1, numEmployees * numDays);
ub = ones(1, numEmployees * numDays);
prob = @FitnessFunc;
etac = 0.9;
etam = 0.4;
Pc = 0.4;
Pm = 0.7;
[bestsol,bestfitness] = GeneticAlgorithm(prob,lb,ub,Np,T,etac,etam,Pc,Pm);
