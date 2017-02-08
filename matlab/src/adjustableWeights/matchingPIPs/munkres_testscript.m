%hungarian test script

clear;
addpath('../getPIPs');
addpath('../PIPsIndicator');

%PIPnum=20;
PIPthr=0.05;%PIP threshold
sw=2; %smoothing window
%UCRdataset='Wine';
UCRdataset='uWaveGestureLibrary_Z';
tsindex=1;
tsindex2=101;

%% dataset

%SC dataset
%load('../../../data/gt_sc.mat');
load('../../../data/synthetic_control.mat');
ts = synthetic_control;

%{
%UCR dataset
TEST=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',UCRdataset,'/',UCRdataset,'_TEST']);
TRAIN=load(['/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/',UCRdataset,'/',UCRdataset,'_TRAIN']);
ts=[TEST(:,2:end);TRAIN(:,2:end)];
%}

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
%[ PIPindex,PIPinfo ] = getPIPs_num( ts_smooth(tsindex,:),PIPnum );
PIPinfo = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
%[ Indicator,PIPindex ] = getIndicator( ts_smooth(tsindex,:), PIPinfo );
[ Indicator,PIPindex ] = getIndicator_onlyxy( ts_smooth(tsindex,:), PIPinfo );

%figure
%plot(ts(tsindex2,:));
%[ PIPindex2,PIPinfo2 ] = getPIPs_num( ts_smooth(tsindex2,:),PIPnum );
PIPinfo2 = getPIPs_threshold( ts_smooth(tsindex2,:), PIPthr );
%[ Indicator2,PIPindex2 ] = getIndicator( ts_smooth(tsindex2,:), PIPinfo2 );
[ Indicator2,PIPindex2 ] = getIndicator_onlyxy( ts_smooth(tsindex2,:), PIPinfo2 );

costmat=getCostmat(Indicator,Indicator2);

%%
%[assignmentPairs,cost] = munkresPairs(costmat);
[assignmentPairs,cost] = dtwMatch(costmat);
% draw match picture
figure
plot(ts_smooth(tsindex,:),'k');
hold on
plot(ts_smooth(tsindex2,:),'r');
for i=1:size(assignmentPairs,1)
    if (assignmentPairs(i,2)~=0)
        x1=PIPindex(assignmentPairs(i,1));
        x2=PIPindex2(assignmentPairs(i,2));
        y1=ts_smooth(tsindex,x1);
        y2=ts_smooth(tsindex2,x2);
        plot([x1,x2],[y1,y2],':ob','MarkerFaceColor','g')
    end
end
