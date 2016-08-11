addpath('../')
clear;

%% parameter
Datasets = [cellstr('ChlorineConcentration'), 'CinC_ECG_torso',  'DiatomSizeReduction', 'ECGFiveDays', 'FacesUCR', ... 
        'Haptics', 'InlineSkate', 'ItalyPowerDemand', 'MALLAT', 'MedicalImages', 'SonyAIBORobotSurface', ...
        'SonyAIBORobotSurfaceII', 'Symbols', 'TwoLeadECG', 'WordsSynonyms', 'Cricket_X', 'Cricket_Y', 'Cricket_Z',...
        'uWaveGestureLibrary_X', 'uWaveGestureLibrary_Y', 'uWaveGestureLibrary_Z', '50words', 'Adiac', 'Beef',    ...
        'CBF', 'Coffee', 'ECG200', 'FaceAll', 'FaceFour', 'Fish', 'Gun_Point', 'Lighting2', 'Lighting7', 'Plane', ...
        'OliveOil', 'OSULeaf', 'SwedishLeaf', 'Synthetic_control', 'Trace', 'Two_Patterns', 'Wafer', 'Yoga', 'Car'...
        'StarLightCurves', 'NonInvasiveFatalECG_Thorax1','NonInvasiveFatalECG_Thorax2'];
PIPthr=0.15;

%% computation
for i = 1:3
    display(['Dataset being processed: ', num2str(i)]);
    
    %% load dataset
    datasetName=Datasets{i};
    load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_k-Shape_Matlab/',datasetName,'_Data.mat']);
    load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_k-Shape_Matlab/',datasetName,'_Class.mat']);
    
    %% preprocessing
    %normalization/scaling
    [rnum,cnum]=size(dataset);
    %{
    ts_norm = dataset;
    for j=1:rnum
        ts_norm(j,:)=(dataset(j,:)-mean(dataset(j,:)))/ std(dataset(j,:));
    end
    %}
    ts_norm = (zscore(dataset'))';

    %smoothing
    wts = [0.25,0.5,0.25];
    ts_smooth=zeros(rnum,cnum-2);
    for j=1:rnum
        ts_smooth(j,:) = conv(ts_norm(j,:),wts,'valid'); 
    end
    
    %% clustering
    classNum=length(unique(classes));
    [idx,C]=kmedoids(ts_smooth,classNum,'Distance',@MVIPDist);
    
    %% save results
    save(['./kmedoids-MVIP_results/',datasetName,'.mat'],'idx','C');
end