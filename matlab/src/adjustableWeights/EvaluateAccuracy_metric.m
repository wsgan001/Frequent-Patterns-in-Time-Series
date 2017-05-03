function [ avgCorr ] = EvaluateAccuracy_metric( metricType, measurement )
% m for MVIP, d for DTW, k for K-shape, l for Landmark

if nargin == 1
    measurement = 's';
end

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike');
addpath('/Users/Steven/Documents/GitHub/k-Shape/Code/')
addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/Landmarks/')
load('./datasetForLinearRegression/TestSet.mat');

queryUserPairNum = 0;
accuSum = 0;

dataPath = '/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/data/';
querySet = [cellstr('WormsTwoClass-centroid2'),'Worms-centroid5','Worms-centroid4','Worms-centroid2','uWaveGestureLibrary_X-centroid6','50words-centroid7','50words-centroid6','WormsTwoClass-centroid1','Worms-centroid3','Worms-centroid1','uWaveGestureLibrary_Z-centroid3','uWaveGestureLibrary_Z-centroid2','uWaveGestureLibrary_Z-centroid1','uWaveGestureLibrary_Y-centroid5','uWaveGestureLibrary_Y-centroid4','uWaveGestureLibrary_Y-centroid3','ToeSegmentation2-centroid1','50words-centroid3','50words-centroid2','50words-centroid1'];


for i = 1:20 % query
    queryName = querySet{i};
    S = regexp(queryName, '-', 'split');
    datasetName = S{1};
    cName = S{2};
    query = csvread([dataPath, datasetName, '/', cName, '/query_original.csv']);
    dataset = csvread([dataPath, datasetName, '/', cName, '/DataCollection.csv']);
    
    for j = 1:8 % user
        allViz = allDataPoint{i,j};
        testSetIndex = testSetIndexUnderEachQueryUserPair{i,j};
        if size(testSetIndex,2) > 1 % empty or only 1-point test set make no sense
            TestSet = allViz(testSetIndex,:);
            TruthSimilarity = TestSet(:,end);
            %features = TestSet(:,1:(end-1));
            
            %CalculatedSimilarity = glmnetPredict(fit,features,0.1);
            if metricType == 'm'
                %CalculatedSimilarity = -(MVIPDist_adjustableWeights(query,dataset(testSetIndex,:)));%distance = - similarity according to ranking
                %CalculatedSimilarity = -(MVIPOnlyXYDist(zscore(query,0,2), zscore(dataset(testSetIndex,:),0,2)));  
                distance = MVIPOnlyXYDist(zscore(query,0,2), zscore(dataset(testSetIndex,:),0,2)); % distance
                CalculatedSimilarity = dist2bucketIndex( distance ); % bucket ranking by kmeans distance
            elseif metricType == 'k'
                %CalculatedSimilarity = -(SBD_one2set(query,dataset(testSetIndex,:)));
                distance = SBD_one2set(query,dataset(testSetIndex,:));
                CalculatedSimilarity = dist2bucketIndex( distance );
            elseif metricType == 'd' %dtw
                %CalculatedSimilarity = -(DTWone2set(query,dataset(testSetIndex,:)));
                distance = DTWone2set(query,dataset(testSetIndex,:));
                CalculatedSimilarity = dist2bucketIndex( distance );
            elseif metricType == 'l' %landmarks
                %CalculatedSimilarity = -(landmarks_one2set(query,dataset(testSetIndex,:)));
                distance = landmarks_one2set(query,dataset(testSetIndex,:));
                CalculatedSimilarity = dist2bucketIndex( distance );
            end
            
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