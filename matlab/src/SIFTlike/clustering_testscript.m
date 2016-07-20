%clustering test

clear;
clc;

%% parameter
WinLen=6;%sliding whindow length
PIPthr=0.15;
UCRdataset='yoga';

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
queryno=301;
tic
query=ts_smooth(queryno,:);
[ ranking ] = SimRank_PIPthr_dtw( query,ts_smooth,PIPthr );
toc

%plot for test
%{
figure
plot(ts(queryno,:));
title('raw query');
figure
hold on
for i=2:20
    plot(ts(ranking(i),:));
end
plot(ts(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('raw top 20')
figure
hold on
for i=2:50
    plot(ts(ranking(i),:));
end
plot(ts(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('raw top 50')
figure
hold on
for i=2:100
    plot(ts(ranking(i),:));
end
plot(ts(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('raw top 100')
%}

%after smoothing
figure
plot(ts_smooth(queryno,:));
title('smoothing query');
figure
hold on
for i=2:20
    plot(ts_smooth(ranking(i),:));
end
plot(ts_smooth(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('smoothing top 20')
figure
hold on
for i=2:50
    plot(ts_smooth(ranking(i),:));
end
plot(ts_smooth(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('smoothing top 50')
figure
hold on
for i=2:100
    plot(ts_smooth(ranking(i),:));
end
plot(ts_smooth(ranking(1),:),':or','MarkerFaceColor','r')
hold off
title('smoothing top 100')