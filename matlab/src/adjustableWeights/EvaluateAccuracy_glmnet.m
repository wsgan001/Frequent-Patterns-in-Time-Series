function [ avgCorr, Correlation ] = EvaluateAccuracy_glmnet( fit, index )

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('../../lib/glmnet_matlab/');

Correlation = zeros(1,size(index,2)*8);
for i = 1:size(index,2)
    for j = 1:8 % for each 8 users under each query
        TestSet = csvread(['/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/adjustableWeights/datasetForLinearRegression/TestQuery',num2str(index(i)),'_user',num2str(j),'.csv']);
        TruthSimilarity = TestSet(:,end);
        features = TestSet(:,1:(end-1));
 
        CalculatedSimilarity = glmnetPredict(fit,features,0.1);
    
        Correlation((i-1)*8+j) = spearman(TruthSimilarity, CalculatedSimilarity);
    end
end

avgCorr = mean(Correlation);

end

