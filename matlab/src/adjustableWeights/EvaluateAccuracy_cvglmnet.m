function [ avgCorr ] = EvaluateAccuracy_cvglmnet( fit )

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('../../lib/glmnet_matlab/');
load('./datasetForLinearRegression/TestSet.mat');

queryUserPairNum = 0;
corrSum = 0;
for i = 1:20 % query
    for j = 1:8 % user
        allViz = allDataPoint{i,j};
        testSetIndex = testSetIndexUnderEachQueryUserPair{i,j};
        %if ~isempty(testSetIndex) %empty test set makes no sense
        if size(testSetIndex,2) > 1 % empty or only 1-point test set make no sense
            TestSet = allViz(testSetIndex,:);
            TruthSimilarity = TestSet(:,end);
            features = TestSet(:,1:(end-1));
            
            CalculatedSimilarity = cvglmnetPredict(fit,features,'lambda_min');
            
            queryUserPairNum = queryUserPairNum + 1;
            corrSum = corrSum + spearman(TruthSimilarity, CalculatedSimilarity);
        end
    end
end
avgCorr = corrSum / queryUserPairNum;

% for i = 1:size(index,2)
%     for j = 1:8 % for each 8 users under each query
%         TestSet = csvread(['/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/adjustableWeights/datasetForLinearRegression/TestQuery',num2str(index(i)),'_user',num2str(j),'.csv']);
%         TruthSimilarity = TestSet(:,end);
%         features = TestSet(:,1:(end-1));
%  
%         CalculatedSimilarity = glmnetPredict(fit,features,0.1);
%     
%         Correlation((i-1)*8+j) = spearman(TruthSimilarity, CalculatedSimilarity);
%     end
% end
% 
% avgCorr = mean(Correlation);
% 

end

