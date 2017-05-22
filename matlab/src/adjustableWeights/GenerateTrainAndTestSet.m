function [] = GenerateTrainAndTestSet () 
% generate train set and test set files
addpath('./getPIPs');
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike');
addpath('/Users/Steven/Documents/GitHub/k-Shape/Code/')
addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/Landmarks/')

dataPath = '/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/data/';
querySet = [cellstr('WormsTwoClass-centroid2'),'Worms-centroid5','Worms-centroid4','Worms-centroid2','uWaveGestureLibrary_X-centroid6','50words-centroid7','50words-centroid6','WormsTwoClass-centroid1','Worms-centroid3','Worms-centroid1','uWaveGestureLibrary_Z-centroid3','uWaveGestureLibrary_Z-centroid2','uWaveGestureLibrary_Z-centroid1','uWaveGestureLibrary_Y-centroid5','uWaveGestureLibrary_Y-centroid4','uWaveGestureLibrary_Y-centroid3','ToeSegmentation2-centroid1','50words-centroid3','50words-centroid2','50words-centroid1'];

TrainSet = [];
% TestSet = [];
% [~,idx] = sort(rand(20,1));
% TrainIndex = idx(1:10);
% TestIndex = idx(11:20);
subjectiveFeatureSet = load('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy/UserResults/SubjectiveImportanceOrderOfObjectiveFeatures/FeatureKeyWordFrequency.csv');

allDataPoint = cell(20,8);% 20 queries * 8 users, each cell includes all vizes under this query-user pair
testSetIndexUnderEachQueryUserPair = cell(20,8);

% the index of data points in the training set
randomAllIndex = randperm(2144);
trainingSetIndex = randomAllIndex(1:1501); % 1501 ~= 2144 * 0.7
currentIndex = 0;

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
        %overallTrend = MVIPDist_adjustableWeights(query, vis); %new MVIP
        overallTrend = MVIPOnlyXYDist(zscore(query,0,2), zscore(vis,0,2)); %old MVIP  
        %overallTrend = DTWone2set(query, vis); % new dtw
        %overallTrend = landmarks_one2set(query, vis); % Landmark
        %overallTrend = SBD_one2set(query, vis); % k-shape
        
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
    
%     CombinedTmpSet = [];
    for k = 1:8 % user
        currentTestIndex = [];
        subjectiveFeatures = subjectiveFeatureSet((i-1)*8+k,:);
        if sum(subjectiveFeatures) > 0 %normalize weights
            subjectiveFeatures = subjectiveFeatures/sum(subjectiveFeatures);
        end
        query_user_dataPoint=[];
        for j = 1: size(dataset, 1) %viz
            currentIndex = currentIndex + 1;
            
            currentDataPoint = [TmpSet(j,:),subjectiveFeatures,scores(j,k)];
            %{
            % use multiplication to combine paired subjective features and objective features
            subjectiveFeatures =  subjectiveFeatures/mean(subjectiveFeatures);% normalize
            TmpSet(j,1) = TmpSet(j,1) * subjectiveFeatures(1);
            TmpSet(j,2:4) = TmpSet(j,2:4) * subjectiveFeatures(2);
            TmpSet(j,5) = TmpSet(j,5) * subjectiveFeatures(1);
            TmpSet(j,6:9) = TmpSet(j,6:9) * subjectiveFeatures(3);
            TmpSet(j,10) = TmpSet(j,10) * subjectiveFeatures(4);
            TmpSet(j,11:14) = TmpSet(j,11:14) * subjectiveFeatures(5);
            TmpSet(j,15) = TmpSet(j,15) * subjectiveFeatures(6);
            currentDataPoint = [TmpSet(j,:),scores(j,k)];
            %}
            %currentDataPoint = [TmpSet(j,:),scores(j,k)]; % only objective features
            
            if ismember(currentIndex, trainingSetIndex)
                TrainSet = [TrainSet; currentDataPoint];
            else
                currentTestIndex = [currentTestIndex,j];
            end
            query_user_dataPoint = [query_user_dataPoint;currentDataPoint];
        end
        allDataPoint{i,k} = query_user_dataPoint;
        testSetIndexUnderEachQueryUserPair{i,k} = currentTestIndex;
        
%         if ~ismember(i,TrainIndex)
%             csvwrite(['./datasetForLinearRegression/TestQuery',num2str(i),'_user',num2str(k),'.csv'],query_user_dataPoint);
%         end
%         CombinedTmpSet = [CombinedTmpSet;query_user_dataPoint];
    end
    
%     if ismember(i,TrainIndex)
%         TrainSet = [TrainSet; CombinedTmpSet];
%     else
%         TestSet = [TestSet; CombinedTmpSet];
%     end
    
end

%% write files
csvwrite('./datasetForLinearRegression/TrainSet.csv',TrainSet);
%csvwrite('./datasetForLinearRegression/TestSet.csv',TestSet);
save('./datasetForLinearRegression/TestSet.mat','allDataPoint','testSetIndexUnderEachQueryUserPair');


end

