%clustering test

clear;
clc;

%% parameter
WinLen=6;%sliding whindow length
PIPthr=0.15;
%UCRdataset='yoga';%good
%UCRdataset='wafer';%good
%UCRdataset='50words';%not so good
UCRdataset='uWaveGestureLibrary_X';

%% similarity ranking parameters
queryno=1;
TopN2show=[5,20];

%% load dataset
%sc dataset
%{
load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;
[rnum,cnum]=size(ts);
%}

%UCR dataset

TEST = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TEST']);
TRAIN = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TRAIN']);

dataall = [TEST;TRAIN];
[rnum, cnum] = size(dataall);
gt = dataall(:,1);
ts = dataall(:,2:cnum);

%plot to show a global picture
figure
hold on
for i=1:rnum
    plot(ts(i,:))
end
title('all raw data')
hold off

%% preprocessing
%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
    %ts_norm(i,:)=ts(i,:)/mean(ts(i,:));
end

%smoothing
%WinLen=6;%sliding whindow length
wts = [1/(2*WinLen);repmat(1/WinLen,WinLen-1,1);1/(2*WinLen)];
for i=1:rnum
    ts_smooth(i,:) = conv(ts_norm(i,:),wts,'valid');   
end
%[~,cnum_smooth]=size(ts_smooth);

%% clustering
%{
[ result,Dist,c ] = hc_PIPthr_dtw( ts_smooth,gt,PIPthr );
result
%}

%% similarity ranking
query=ts_smooth(queryno,:);

%% similarity ranking - PIPthr_dtw
tic
[ ranking ] = SimRank_PIPthr_dtw( query,ts_smooth,PIPthr );
toc

%raw data
%{
for topn=TopN2show
    figure
    hold on
    for i=2:topn
        plot(ts(ranking(i),:));
    end
    plot(ts(ranking(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['raw data top ',num2str(topn),' - PIPthr\_dtw'])
end
%}

%after smoothing
for topn=TopN2show
    figure
    hold on
    for i=2:topn
        plot(ts_smooth(ranking(i),:));
    end
    plot(ts_smooth(ranking(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - PIPthr\_dtw'])
end

%% similarity ranking - comparison - smoothing data based dtw
tic
[ ranking_comp ] = SimRank_rawdata_dtw( query,ts_smooth );
toc

%raw data
%{
for topn=TopN2show
    figure
    hold on
    for i=2:topn
        plot(ts(ranking_comp(i),:));
    end
    plot(ts(ranking_comp(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['raw data top ',num2str(topn),' - all points based dtw'])
end
%}

%after smoothing
for topn=TopN2show
    figure
    hold on
    for i=2:topn
        plot(ts_smooth(ranking_comp(i),:));
    end
    plot(ts_smooth(ranking_comp(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - all points based dtw'])
end