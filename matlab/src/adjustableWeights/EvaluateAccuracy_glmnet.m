function [ avgCorr, Correlation ] = EvaluateAccuracy_glmnet( fit, index )

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('../../lib/glmnet_matlab/');

Correlation = zeros(1,size(index,2));
for i = 1:size(index,2)
    TestSet = csvread(['/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/adjustableWeights/datasetForLinearRegression/TestQuery',num2str(index(i)),'.csv']);
    TruthSimilarity = TestSet(:,end);
    features = TestSet(:,1:(end-1));
 
    CalculatedSimilarity = glmnetPredict(fit,features,0.01);
    
    Correlation(i) = spearman(TruthSimilarity, CalculatedSimilarity);
end

avgCorr = mean(Correlation);

end

