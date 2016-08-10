%clustering test
addpath('../')
clear;
%clc;

%% parameter
WinLen=2;%sliding whindow length smooth 20
PIPthr=0.15;
%UCRdataset='50words';%not so good 50 classes, 905 TS, 270 D
%UCRdataset='yoga';%good 2 classes, 3300 TS, 426 D
%UCRdataset='wafer';%good 2 classes, 7174 TS, 152 D
%UCRdataset='HandOutlines';% 2 classes, 1370 TS, 2709 D
%UCRdataset='uWaveGestureLibrary_X'; % not so good 8 classes, 4478 TS, 315 D
%UCRdataset='synthetic_control'2
UCRdataset='SmallKitchenAppliances';

ts1No=1;
ts2No=131;
disp(['ts1(java) = ',num2str(ts1No-1),', ts2(java) = ',num2str(ts2No-1)])

%% load dataset
%sc dataset

load('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/data/gt_sc.mat');
load('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;
[rnum,cnum]=size(ts);


%UCR dataset
%{
TEST = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TEST']);
TRAIN = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TRAIN']);
dataall = [TEST;TRAIN];
[~, cnum] = size(dataall);
gt = dataall(:,1);
ts = dataall(:,2:cnum);
[rnum,~]=size(ts);
%}

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
    %ts_smooth(i,:) = ts_norm(i,:);
end
%[~,cnum_smooth]=size(ts_smooth);
%% Distance
[ distance ] = Dist_PIPthr_dtw( ts_smooth(ts1No,:),ts_smooth(ts2No,:),PIPthr );
disp(['Distance = ',num2str(distance)])