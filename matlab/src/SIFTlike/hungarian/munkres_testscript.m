%hungarian test script

clear;
addpath('../getPIPs');
addpath('../PIPsIndicator');

PIPnum=20;
PIPthr=0.05;%PIP threshold
sw=10; %smoothing window

%{
%SC dataset
%load('../../../data/gt_sc.mat');
tsindex=421;
tsindex2=422;
load('../../../data/synthetic_control.mat');
ts = synthetic_control;
%}

%UCR dataset
tsindex=7;
tsindex2=8;
%datasetname='Wine';
datasetname='yoga';
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
%figure
%plot(ts(tsindex,:));
[ PIPindex,PIPinfo ] = getPIPs_num( ts_smooth(tsindex,:),PIPnum );
%[ PIPindex,PIPinfo ] = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
[ Indicator,PIPindex ] = getIndicator( ts_smooth(tsindex,:), PIPinfo );

%figure
%plot(ts(tsindex2,:));
[ PIPindex2,PIPinfo2 ] = getPIPs_num( ts_smooth(tsindex2,:),PIPnum );
%[ PIPindex,PIPinfo ] = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
[ Indicator2,PIPindex2 ] = getIndicator( ts_smooth(tsindex2,:), PIPinfo2 );

costmat=getCostmat(Indicator,Indicator2);

%%
[assignment,cost] = munkres(costmat);
% draw match picture
figure
plot(ts_smooth(tsindex,:),'k');
hold on
plot(ts_smooth(tsindex2,:),'r');
for i=1:length(assignment)
    plot([PIPindex(i),PIPindex2(assignment(i))],...
        [ts_smooth(tsindex,PIPindex(i)),ts_smooth(tsindex2,PIPindex2(assignment(i)))]...
        ,':ob','MarkerFaceColor','g')
end
