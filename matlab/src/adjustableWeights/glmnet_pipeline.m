function [ avgCorr, fit ] = glmnet_pipeline

%From generate train and test sets to evaluate the accuracy.

%% delete previous files
fprintf('Delete previous files...\n');
delete('./datasetForLinearRegression/*.csv')

%% generate train set and test set files
fprintf('Generate datasets...\n');
GenerateTrainAndTestSet();

%% Learning process
fprintf('Learn theta...\n');
%[ theta, mu, sigma ] = RunFromGivenPath( './datasetForLinearRegression/TrainSet.csv' );
[ fit ] = RunFromGivenPath_glmnet( './datasetForLinearRegression/TrainSet.csv' );

%% Test process
fprintf('Evaluate on test datasets...\n');
%[ avgCorr, Correlation ] = EvaluateAccuracy( theta, mu, sigma, TestIndex' );
[ avgCorr ] = EvaluateAccuracy_glmnet( fit );

end
