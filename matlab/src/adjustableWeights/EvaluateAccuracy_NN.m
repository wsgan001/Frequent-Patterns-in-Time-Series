function [ avgCorr ] = EvaluateAccuracy_NN( net, measurement )
%flag: d-DTW, m-MVIP, k-kshape, l-landmark, f-feature set(MVIP),
%o-objective features(MVIP)

if nargin == 1
    measurement = 's';
    flag = 'f';
elseif nargin == 2
    flag = 'f';
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
            %features = TestSet(:,1:(end-1));
            if flag == 'd'
                features = TestSet(:, 2);
            elseif flag == 'm'
                features = TestSet(:, 1);
            elseif flag == 'k'
                features = TestSet(:, 4);
            elseif flag == 'l'
                features = TestSet(:, 3);
            elseif flag == 'f'
                features = TestSet(:, [1, 5:end-1]);
            elseif flag == 'o'
                features = TestSet(:, [1, 5:end-7]);
            end
            
            %CalculatedSimilarity = glmnetPredict(net,features,lambda);
            CalculatedSimilarity = net(features')'*4;
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

