function [ TestIndex ] = GenerateTrainAndTestSet
% generate train set and test set files
addpath('./getPIPs');
%addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike');

dataPath = '/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/data/';
querySet = [cellstr('WormsTwoClass-centroid2'),'Worms-centroid5','Worms-centroid4','Worms-centroid2','uWaveGestureLibrary_X-centroid6','50words-centroid7','50words-centroid6','WormsTwoClass-centroid1','Worms-centroid3','Worms-centroid1','uWaveGestureLibrary_Z-centroid3','uWaveGestureLibrary_Z-centroid2','uWaveGestureLibrary_Z-centroid1','uWaveGestureLibrary_Y-centroid5','uWaveGestureLibrary_Y-centroid4','uWaveGestureLibrary_Y-centroid3','ToeSegmentation2-centroid1','50words-centroid3','50words-centroid2','50words-centroid1'];

TrainSet = [];
TestSet = [];
[~,idx] = sort(rand(20,1));
TrainIndex = idx(1:10);
TestIndex = idx(11:20);
subjectiveFeatureSet = load('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/UserResults/SubjectiveImportanceOrderOfObjectiveFeatures/FeatureKeyWordFrequency.csv');

for i = 1:20 % query
    i
    % load query and dataset
    queryName = querySet{i};
    S = regexp(queryName, '-', 'split');
    datasetName = S{1};
    cName = S{2};
    query = csvread([dataPath, datasetName, '/', cName, '/query_original.csv']);
    dataset = csvread([dataPath, datasetName, '/', cName, '/DataCollection.csv']);
    scores = csvread(['/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/CleanedResults/',queryName,'.csv']);
    scores = scores(2:end,:);
    
    PIPinfo_query = getPIPs_threshold(query);
    TmpSet = [];
    for j = 1: size(dataset, 1) %viz
        vis = dataset(j, :);
        
        %% calculate the features of current query-vis pair
        % overall trend
        %overallTrend = MVIPDist(query, vis); new MVIP
        [~, overallTrend] = SimRank_PIPthr_dtw_adjustableWeights(zscore(query,0,2), zscore(vis,0,2));
        % ISSUE: In my google doc
        
        % smoothness/noise
        noise = NoiseStrength(query) - NoiseStrength(vis);
        %fprintf('/n noise: ')
        %size(noise)
        
        % average overall trend
        averageOverallTrend = AverageOverallTrend(query, vis);
        %fprintf('/n averageOverallTrend: ')
        %size(averageOverallTrend)
        
        % seasonality
        seasonality = Seasonality(query) - Seasonality(vis);
        %fprintf('/n seasonality: ')
        %size(seasonality)
        
        % Number of peaks
        PIPinfo_vis = getPIPs_threshold(vis);
        peakNum = NumberOfPeaks(PIPinfo_query, query) - NumberOfPeaks(PIPinfo_vis, vis);
%         fprintf('/n peakNum: ')
%         size(peakNum)
        
        % Relative (normalized) x, y positions of global max/min
        globalMaxMin = GlobalMaxMin(query) - GlobalMaxMin(vis);
%         fprintf('/n globalMaxMin: ')
%         size(globalMaxMin)
        
        % Global increasing / decreasing
        globalIncreDecre = GlobalIncrease(query) - GlobalIncrease(vis);
%         fprintf('/n globalIncreDecre: ')
%         size(globalIncreDecre)
        
        % Average distance between VIPs
        averageVIPDistance = AverageDistanceBetweenVIPs(PIPinfo_query, size(query,2)) - AverageDistanceBetweenVIPs(PIPinfo_vis, size(vis, 2));
%         fprintf('/n averageVIPDistance: ')
%         size(averageVIPDistance)
        
        % Regression global slope
        regressionSlope = RegressionSlope(query) - RegressionSlope(vis);
%         fprintf('/n regressionSlope: ')
%         size(regressionSlope)
        
        
        %% calculate the average similarity level of current query-vis pair
        averageSimilarity = mean(scores(j,:));
        
        %%
        objectiveFeatures = [overallTrend, noise, averageOverallTrend, seasonality, peakNum, globalMaxMin, globalIncreDecre, averageVIPDistance, regressionSlope];
        %{
        query_vis_tmp = [];
        for k = 1:8 % user 1 - user 8 under current query
            subjectiveFeatures = subjectiveFeatureSet((i-1)*8+k,:);
            if sum(subjectiveFeatures) > 0 %normalize weights
                subjectiveFeatures = subjectiveFeatures/sum(subjectiveFeatures);
            end
            query_vis_tmp = [query_vis_tmp;[objectiveFeatures,subjectiveFeatures]];
        end
        %}
        
        %% generate a new row
        TmpSet = [TmpSet;objectiveFeatures];
    end
    
    CombinedTmpSet = [];
    for k = 1:8 % user
        subjectiveFeatures = subjectiveFeatureSet((i-1)*8+k,:);
        if sum(subjectiveFeatures) > 0 %normalize weights
            subjectiveFeatures = subjectiveFeatures/sum(subjectiveFeatures);
        end
        query_user_dataPoint=[];
        for j = 1: size(dataset, 1)
            query_user_dataPoint = [query_user_dataPoint;[TmpSet(j,:),subjectiveFeatures,scores(j,k)]];
        end
        if ~ismember(i,TrainIndex)
            csvwrite(['./datasetForLinearRegression/TestQuery',num2str(i),'_user',num2str(k),'.csv'],query_user_dataPoint);
        end
        CombinedTmpSet = [CombinedTmpSet;query_user_dataPoint];
    end
    
    if ismember(i,TrainIndex)
        TrainSet = [TrainSet; CombinedTmpSet];
    else
        TestSet = [TestSet; CombinedTmpSet];
    end
    
end

%% write files
csvwrite('./datasetForLinearRegression/TrainSet.csv',TrainSet);
csvwrite('./datasetForLinearRegression/TestSet.csv',TestSet);

end

