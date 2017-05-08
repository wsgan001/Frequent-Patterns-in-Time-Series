function [ avgCorr_m, avgCorr_k, avgCorr_d, avgCorr_l ] = EvaluateAccuracy_allMetric(measurement)
% m for MVIP, d for DTW, k for K-shape, l for Landmark
% measurement: s - spearman; d - directlyCompare; S - spearman with optimum
% partition; D - directlyCompare with optimum partiition

if nargin == 0
    measurement = 's';
end

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike');
addpath('/Users/Steven/Documents/GitHub/k-Shape/Code/')
addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/Landmarks/')
load('./datasetForLinearRegression/TestSet.mat');

queryUserPairNum = 0;
accuSum_m = 0;
accuSum_k = 0;
accuSum_d = 0;
accuSum_l = 0;

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
            
            distance_m = MVIPOnlyXYDist(zscore(query,0,2), zscore(dataset(testSetIndex,:),0,2)); % distance
            CalculatedSimilarity_m = dist2bucketIndex( distance_m ); % bucket ranking by kmeans distance
            
            distance_k = SBD_one2set(query,dataset(testSetIndex,:));
            CalculatedSimilarity_k = dist2bucketIndex( distance_k );
            
            distance_d = DTWone2set(query,dataset(testSetIndex,:));
            CalculatedSimilarity_d = dist2bucketIndex( distance_d );
            
            distance_l = landmarks_one2set(query,dataset(testSetIndex,:));
            CalculatedSimilarity_l = dist2bucketIndex( distance_l );
            
            
            queryUserPairNum = queryUserPairNum + 1;
            if measurement == 'd' % directlyCompare
                accuSum_m = accuSum_m + directlyCompare(TruthSimilarity, CalculatedSimilarity_m);
                accuSum_k = accuSum_k + directlyCompare(TruthSimilarity, CalculatedSimilarity_k);
                accuSum_d = accuSum_d + directlyCompare(TruthSimilarity, CalculatedSimilarity_d);
                accuSum_l = accuSum_l + directlyCompare(TruthSimilarity, CalculatedSimilarity_l);
            elseif measurement == 'S' % spearman with optimum partition
                accuSum_m = accuSum_m + directlyCompare_optimun(TruthSimilarity, distance_m);
                accuSum_k = accuSum_k + directlyCompare_optimun(TruthSimilarity, distance_k);
                accuSum_d = accuSum_d + directlyCompare_optimun(TruthSimilarity, distance_d);
                accuSum_l = accuSum_l + directlyCompare_optimun(TruthSimilarity, distance_l);
            elseif measurement == 'D' % directlyCompare with optimum partiition
                accuSum_m = accuSum_m + spearman_optimun(TruthSimilarity, distance_m);
                accuSum_k = accuSum_k + spearman_optimun(TruthSimilarity, distance_k);
                accuSum_d = accuSum_d + spearman_optimun(TruthSimilarity, distance_d);
                accuSum_l = accuSum_l + spearman_optimun(TruthSimilarity, distance_l);
            else % spearman
                accuSum_m = accuSum_m + spearman(TruthSimilarity, CalculatedSimilarity_m);
                accuSum_k = accuSum_k + spearman(TruthSimilarity, CalculatedSimilarity_k);
                accuSum_d = accuSum_d + spearman(TruthSimilarity, CalculatedSimilarity_d);
                accuSum_l = accuSum_l + spearman(TruthSimilarity, CalculatedSimilarity_l);
            end
        end
    end
end
avgCorr_m = accuSum_m / queryUserPairNum;
avgCorr_k = accuSum_k / queryUserPairNum;
avgCorr_d = accuSum_d / queryUserPairNum;
avgCorr_l = accuSum_l / queryUserPairNum;

end