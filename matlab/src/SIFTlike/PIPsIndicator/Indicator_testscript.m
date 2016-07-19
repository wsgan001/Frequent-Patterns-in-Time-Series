%Indicator test script

clear;
addpath('../getPIPs');

tsindex=10;
PIPnum=15;
PIPthr=0.05;
sw=5; %smoothing window

%{
%SC dataset
%load('../../../data/gt_sc.mat');
load('../../../data/synthetic_control.mat');
ts = synthetic_control;
%}

%UCR dataset
datasetname='Wine';
TEST=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',datasetname,'/',datasetname,'_TEST']);
TRAIN=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',datasetname,'/',datasetname,'_TRAIN']);
ts=[TEST(:,2:end);TRAIN(:,2:end)];

%%
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

%%
figure
plot(ts(tsindex,:));

[ PIPindex,PIPinfo ] = getPIPs_num( ts_smooth(tsindex,:),PIPnum );
%[ PIPindex,PIPinfo ] = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
[ Indicator,PIPindex ] = getIndicator( ts_smooth(tsindex,:), PIPinfo );

[ PIPindex2,PIPinfo2 ] = getPIPs_num( ts_smooth(1,:),PIPnum );
%[ PIPindex,PIPinfo ] = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
[ Indicator2,PIPindex2 ] = getIndicator( ts_smooth(1,:), PIPinfo2 );

costmat=getCostmat(Indicator,Indicator2)
