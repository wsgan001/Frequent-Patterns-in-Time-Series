% 10 times average correlation between linear regression and users
% linear regression with regularization

clear;clc;

LRAverage = 0; % The average correlation of linear regression 
%MVIPCorr = 0; 

n=10;

for i =1:n
    [ tmp, ~ ] = glmnet_pipeline;
    LRAverage = LRAverage + tmp/n;
end

fprintf('Linear regression with regularization.../n')
LRAverage
%fprintf('theta = [0,-1,0,...], mu=0, sigma=1.../n')
%MVIPCorr