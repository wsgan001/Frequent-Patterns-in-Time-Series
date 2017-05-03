% 10 times average correlation between linear regression and users
% linear regression without regularization
% test different lambda

clear;clc;

Average_glmnet = zeros(7,1);

n=10;

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
    [ fit ] = RunFromGivenPath_glmnet( './datasetForLinearRegression/TrainSet.csv');

    % Test process
    fprintf('glmnet - Evaluate on test datasets...\n');
    tmp = zeros(size(Average_glmnet));
    tmp(1) = EvaluateAccuracy_glmnet( fit, 0.01 );
    tmp(2) = EvaluateAccuracy_glmnet( fit, 0.02);
    tmp(3) = EvaluateAccuracy_glmnet( fit, 0.05 );
    tmp(4) = EvaluateAccuracy_glmnet( fit, 0.1);
    tmp(5) = EvaluateAccuracy_glmnet( fit, 0.2 );
    tmp(6) = EvaluateAccuracy_glmnet( fit, 0.5 );
    tmp(7) = EvaluateAccuracy_glmnet( fit, 1 );
    
    for j=1:size(Average_glmnet,1)
        Average_glmnet(j) = Average_glmnet(j) + tmp(j)/n;
    end
    
end

fprintf('different lambda: 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.../n')
Average_glmnet
