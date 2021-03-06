clear;
%clc;
%% parameter
tsindex=1;
%PIPnum=15;
sw=6; %smoothing window
PIPthr=0.15;
%% dataset
%{
%SC dataset
%load('../../../data/gt_sc.mat');
load('../../../data/synthetic_control.mat');
ts = synthetic_control;
%}


%UCR dataset
datasetname='uWaveGestureLibrary_Z';
TEST=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',datasetname,'/',datasetname,'_TEST']);
TRAIN=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',datasetname,'/',datasetname,'_TRAIN']);
ts=[TEST(:,2:end);TRAIN(:,2:end)];


%% preprocessing
[rnum,~]=size(ts);
%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
end

%smoothing
%sw=10;
wts = [1/(2*sw);repmat(1/sw,sw-1,1);1/(2*sw)];
for i=1:rnum
    ts_smooth(i,:) = conv(ts_norm(i,:),wts,'valid');   
end

%% getPIPs
figure
plot(ts(tsindex,:));

%[ PIPindex,PIPinfo ] = getPIPs_num( ts_smooth(tsindex,:),PIPnum );
[ PIPindex,PIPinfo ] = getPIPs_threshold( ts_smooth(tsindex,:),PIPthr );
PIPindex
