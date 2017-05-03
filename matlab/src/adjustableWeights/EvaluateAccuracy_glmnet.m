function [ avgCorr ] = EvaluateAccuracy_glmnet( fit, lambda, measurement )

if nargin == 1
    lambda = 0.1;
    measurement = 's';
elseif nargin == 2
    measurement = 's';
end

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('../../lib/glmnet_matlab/');
load('./datasetForLinearRegression/TestSet.mat');

queryUserPairNum = 0;
accuSum = 0;
for i = 1:20 % query
    for j = 1:8 % user
        allViz = allDataPoint{i,j};
        testSetIndex = testSetIndexUnderEachQueryUserPair{i,j};
        %if ~isempty(testSetIndex) %empty test set makes no sense
        if size(testSetIndex,2) > 1 % empty or only 1-point test set make no sense
            TestSet = allViz(testSetIndex,:);
            TruthSimilarity = TestSet(:,end);
            features = TestSet(:,1:(end-1));
            
            CalculatedSimilarity = glmnetPredict(fit,features,lambda);
            CalculatedSimilarity = round(CalculatedSimilarity); % select a nearest bucket based on predicted scores
            
            queryUserPairNum = queryUserPairNum + 1;
            
            if measurement == 'd'
                accuSum = accuSum + directlyCompare(TruthSimilarity, CalculatedSimilarity);
            else
                accuSum = accuSum + spearman(TruthSimilarity, CalculatedSimilarity);
            end
        end
    end
end
avgCorr = accuSum / queryUserPairNum;

end

