%From generate train and test sets to evaluate the accuracy.
addpath('/Users/Steven/Documents/GitHub/machineLearning/supervisedLearning/linearRegressionInMultipleVariables');

%% delete previous files
fprintf('Delete previous files...\n');
delete('./datasetForLinearRegression/*.csv')

%% generate train set and test set files
fprintf('Generate datasets...\n');
[ TestIndex ] = GenerateTrainAndTestSet();

%% Learning process
fprintf('Learn theta...\n');
[ theta, mu, sigma ] = RunFromGivenPath( './datasetForLinearRegression/TrainSet.csv' );

%% Test process
fprintf('Evaluate on test datasets...\n');
[ avgCorr, Correlation ] = TestAccuracy( theta, mu, sigma, TestIndex' )
