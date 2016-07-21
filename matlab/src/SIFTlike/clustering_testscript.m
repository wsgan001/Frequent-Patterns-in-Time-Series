%clustering test

clear;
%clc;

%% parameter
WinLen=10;%sliding whindow length
PIPthr=0.15;
%UCRdataset='yoga';%good
%UCRdataset='wafer';%good
%UCRdataset='50words';%not so good
%UCRdataset='HandOutlines';% 2 classes, 1370 TS, 2709 D
%UCRdataset='uWaveGestureLibrary_X';
UCRdataset='synthetic_control';

%% similarity ranking parameters
queryno=401;
TopN2show=[5,20,50];

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

%%%%%PIPthr_dtw%%%%%
tic
[ ranking ] = SimRank_PIPthr_dtw( query,ts_smooth,PIPthr );
toc

%%%%%comparison - smoothing data based dtw%%%%%
%dtwwl=round(cnum*0.1);
dtwwl=Inf;
tic
[ ranking_rawdata_dtw ] = SimRank_rawdata_dtw( query,ts_smooth, dtwwl);
toc

%%%%%comparison - smoothing data based euclidean%%%%%
tic
[ ranking_euc ] = SimRank_rawdata_Euc( query,ts_smooth );
toc

%visual results(after smoothing)
for topn=TopN2show
    figure
    
    subplot(221)
    hold on
    for i=2:topn
        plot(ts_smooth(ranking(i),:));
    end
    plot(ts_smooth(ranking(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - PIPthr\_dtw'])
    
    subplot(222)
    hold on
    for i=2:topn
        plot(ts_smooth(ranking_rawdata_dtw(i),:));
    end
    plot(ts_smooth(ranking_rawdata_dtw(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - all points based dtw'])
    
    subplot(223)
    hold on
    for i=2:topn
        plot(ts_smooth(ranking_euc(i),:));
    end
    plot(ts_smooth(ranking_euc(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - Euclidean'])
end
