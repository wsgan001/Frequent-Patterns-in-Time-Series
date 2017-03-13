% 10 times average correlation between linear regression and users
% linear regression with regularization

clear;clc;

LRAverage = 0; % The average correlation of linear regression 
%MVIPCorr = 0; 

for i =1:10
    [ tmp, ~, TestIndex ] = glmnet_pipeline;
    LRAverage = LRAverage + 0.1*tmp;
end

fprintf('Linear regression with regularization.../n')
LRAverage
%fprintf('theta = [0,-1,0,...], mu=0, sigma=1.../n')
%MVIPCorr