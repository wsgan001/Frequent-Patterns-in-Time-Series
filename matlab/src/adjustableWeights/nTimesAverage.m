% n times average correlation between linear regression and users

clear;clc;

Average_glmnet = 0; % The average correlation of linear regression 
Average_cvglmnet = 0;
Average_m = 0;
Average_k = 0;
Average_d = 0;
Average_l = 0;

n=10;
measurement = 'd'; % s - spearman; d - directlyCompare
lambda = 0.1;

for i =1:n
    fprintf(['round ', num2str(i), '...\n']);
    
    %% delete previous files
    fprintf('Delete previous files...\n');
    delete('./datasetForLinearRegression/*.csv')
    
    %% generate train set and test set files
    fprintf('Generate datasets...\n');
    GenerateTrainAndTestSet();
    
    %% glmnet
    % Learning process
    fprintf('glmnet - Learn theta...\n');
    [ fit ] = RunFromGivenPath_glmnet( './datasetForLinearRegression/TrainSet.csv' );

    % Test process
    fprintf('glmnet - Evaluate on test datasets...\n');
    [ tmp ] = EvaluateAccuracy_glmnet( fit, lambda, measurement );
    
    Average_glmnet = Average_glmnet + tmp/n;
    
    %% cvglmnet
    % Learning process
    fprintf('cvglmnet - Learn theta...\n');
    [ fit ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv' );

    % Test process
    fprintf('cvglmnet - Evaluate on test datasets...\n');
    [ tmp ] = EvaluateAccuracy_cvglmnet( fit, measurement );
    
    Average_cvglmnet = Average_cvglmnet + tmp/n;
    
    %% metric
    [ avgCorr_m, avgCorr_k, avgCorr_d, avgCorr_l ] = EvaluateAccuracy_allMetric(measurement);
    Average_m = Average_m + avgCorr_m/n;
    Average_k = Average_k + avgCorr_k/n;
    Average_d = Average_d + avgCorr_d/n;
    Average_l = Average_l + avgCorr_l/n;
end

fprintf('glmnet.../n')
Average_glmnet
fprintf('cvglmnet.../n')
Average_cvglmnet
fprintf('mvip.../n')
Average_m
fprintf('k-shape.../n')
Average_k
fprintf('dtw.../n')
Average_d
fprintf('landmark.../n')
Average_l
%fprintf('theta = [0,-1,0,...], mu=0, sigma=1.../n')
%MVIPCorr