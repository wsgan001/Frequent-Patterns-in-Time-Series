function [ TestIndex ] = GenerateTrainAndTestSet
% generate train set and test set files
addpath('./getPIPs');

dataPath = '/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/data/';
querySet = [cellstr('WormsTwoClass-centroid2'),'Worms-centroid5','Worms-centroid4','Worms-centroid2','uWaveGestureLibrary_X-centroid6','50words-centroid7','50words-centroid6','WormsTwoClass-centroid1','Worms-centroid3','Worms-centroid1','uWaveGestureLibrary_Z-centroid3','uWaveGestureLibrary_Z-centroid2','uWaveGestureLibrary_Z-centroid1','uWaveGestureLibrary_Y-centroid5','uWaveGestureLibrary_Y-centroid4','uWaveGestureLibrary_Y-centroid3','ToeSegmentation2-centroid1','50words-centroid3','50words-centroid2','50words-centroid1'];

TrainSet = [];
TestSet = [];
[~,idx] = sort(rand(20,1));
TrainIndex = idx(1:10);
TestIndex = idx(11:20);

for i = 1:20
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
    for j = 1: size(dataset, 1)
        vis = dataset(j, :);
        
        %% calculate the features of current query-vis pair
        % overall trend
        overallTrend = MVIPDist(query, vis);
        
        % smoothness/noise
        noise = NoiseStrength(query) - NoiseStrength(vis);
        
        % average overall trend
        averageOverallTrend = AverageOverallTrend(query, vis);
        
        % seasonality
        seasonality = Seasonality(query) - Seasonality(vis);
        
        % Number of peaks
        PIPinfo_vis = getPIPs_threshold(vis);
        peakNum = NumberOfPeaks(PIPinfo_query, query) - NumberOfPeaks(PIPinfo_vis, vis);
        
        % Relative (normalized) x, y positions of global max/min
        globalMaxMin = GlobalMaxMin(query) - GlobalMaxMin(vis);
        
        % Global increasing / decreasing
        globalIncreDecre = GlobalIncrease(query) - GlobalIncrease(vis);
        
        % Average distance between VIPs
        averageVIPDistance = AverageDistanceBetweenVIPs(PIPinfo_query, size(query,2)) - AverageDistanceBetweenVIPs(PIPinfo_vis, size(vis, 2));
        
        % Regression global slope
        regressionSlope = RegressionSlope(query) - RegressionSlope(vis);
        
        
        %% calculate the average similarity level of current query-vis pair
        averageSimilarity = mean(scores(j,:));
        
        %% generate a new row
        TmpSet = [TmpSet;[overallTrend, noise, averageOverallTrend, seasonality, peakNum, globalMaxMin, globalIncreDecre, averageVIPDistance, regressionSlope, averageSimilarity]];
    end
    
    if ismember(i,TrainIndex)
        TrainSet = [TrainSet; TmpSet];
    else
        TestSet = [TestSet; TmpSet];
        csvwrite(['./datasetForLinearRegression/TestQuery',num2str(i),'.csv'],TmpSet);
    end
    
end

%% write files
csvwrite('./datasetForLinearRegression/TrainSet.csv',TrainSet);
csvwrite('./datasetForLinearRegression/TestSet.csv',TestSet);

end

