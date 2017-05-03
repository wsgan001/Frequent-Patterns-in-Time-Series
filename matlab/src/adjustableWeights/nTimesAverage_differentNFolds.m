% 10 times average correlation between linear regression and users
% linear regression with regularization
% test different k

clear;clc;

Average_cvglmnet = zeros(7,1);

n=10;

for i =1:n
    fprintf(['round ', num2str(i), '...\n']);
    
    %% delete previous files
    fprintf('Delete previous files...\n');
    delete('./datasetForLinearRegression/*.csv')
    
    %% generate train set and test set files
    fprintf('Generate datasets...\n');
    GenerateTrainAndTestSet();
    
    %% cvglmnet
    % Learning process
    fprintf('cvglmnet - Learn theta...\n');
    [ fit5 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv',  5);
    [ fit8 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv',  8);
    [ fit10 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv', 10);
    [ fit12 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv', 12);
    [ fit15 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv', 15);
    [ fit17 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv',  17);
    [ fit20 ] = RunFromGivenPath_cvglmnet( './datasetForLinearRegression/TrainSet.csv',  20);

    % Test process
    fprintf('cvglmnet - Evaluate on test datasets...\n');
    tmp = zeros(size(Average_cvglmnet));
    tmp(1) = EvaluateAccuracy_cvglmnet( fit5 );
    tmp(2) = EvaluateAccuracy_cvglmnet( fit8 );
    tmp(3) = EvaluateAccuracy_cvglmnet( fit10 );
    tmp(4) = EvaluateAccuracy_cvglmnet( fit12 );
    tmp(5) = EvaluateAccuracy_cvglmnet( fit15 );
    tmp(6) = EvaluateAccuracy_cvglmnet( fit17 );
    tmp(7) = EvaluateAccuracy_cvglmnet( fit20 );
    
    for j=1:size(Average_cvglmnet,1)
        Average_cvglmnet(j) = Average_cvglmnet(j) + tmp(j)/n;
    end
    
end

fprintf('nfold: 5, 8, 10, 12, 15, 17, 20.../n')
Average_cvglmnet
