% 10 times average correlation between linear regression and users
% linear regression - old MVIP; theta_0(2) = -1 (namely only  MVIP's weight is -1 in inital theta, others are 0)
% theta = [0,-1,0,...], mu=0, sigma=1;

clear;clc;

addpath('/Users/Steven/Documents/GitHub/machineLearning/supervisedLearning/linearRegressionInMultipleVariables');

LRAverage = 0;
MVIPCorr = 0;

theta = zeros(18,1);
theta(2) = -1;
mu = 0;
sigma = 1;

for i =1:10
    [ tmp, ~, ~, ~, ~, TestIndex ] = pipeline;
    LRAverage = LRAverage + 0.1*tmp;
    
    theta = zeros(18,1);
    theta(2) = -1;
    mu = 0;
    sigma = 1;
    [ tmp, ~ ] = EvaluateAccuracy( theta, mu, sigma, TestIndex );
    MVIPCorr = MVIPCorr + 0.1*tmp;
end

fprintf('Linear regression.../n')
LRAverage
fprintf('theta = [0,-1,0,...], mu=0, sigma=1.../n')
MVIPCorr