%find poor example of sc dataset 

%clustering test
addpath('../')
clear;
%clc;

%% parameter
PIPthr=0.05;
queryno=503;
WinLen=2;%sliding whindow length smooth 20
disp(['queryno=',num2str(queryno)])
TopN2show=[3,5,20,50,100];
topNaccu=100;%top N match accuracy

%% load dataset
%sc dataset
load('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/data/gt_sc.mat');
load('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;
[rnum,cnum]=size(ts);

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

%% similarity ranking
%topNaccu=50;%top N match accuracy
query=ts(queryno,:);
query_smooth=ts_smooth(queryno,:);

% For time complexity: n TS, m D for each TS, x for PIP number; n*logn for finally ranking
%%%%%PIPthr_dtw%%%%% - O(n*m + n*x^2 + n*logn)
class=fix((queryno-1)/100)+1;
disp(' ')
disp('Run time of PIPthr_dtw:')
tic
[ ranking_PIPthr_dtw ] = SimRank_PIPthr_dtw( query_smooth,ts_smooth,PIPthr );
toc
interval=ranking_PIPthr_dtw(1:topNaccu);
mismatch=interval(interval>(class*100) | interval<(class*100-99));
ranktmp=find(interval>(class*100) | interval<(class*100-99));
rank_ts=[ranktmp,mismatch]


%%%%%PIPthr_dtw2 only x,y%%%%% - O(n*m + n*x^2 + n*logn)
disp(' ')
disp('Run time of PIPthr_dtw_onlyxy:')
tic
[ ranking_PIPthr_dtw_onlyxy ] = SimRank_PIPthr_dtw_onlyxy( query_smooth,ts_smooth,PIPthr );
toc


%%%%%comparison - all-point dtw%%%%% - O(n*m^2 + n*logn)
dtwwl=Inf;
disp(' ')
disp('Run time of rawdata_dtw:')
tic
[ ranking_rawdata_dtw ] = SimRank_rawdata_dtw( query,ts, dtwwl);
toc

%sc accuracy
disp(' ');
accutmp=sum((fix((ranking_PIPthr_dtw(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp),'% - PIPthr_dtw']);
accutmp=sum((fix((ranking_PIPthr_dtw_onlyxy(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp),'% - PIPthr_dtw_onlyxy']);
accutmp=sum((fix((ranking_rawdata_dtw(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp),'% - all-point DTW']);

%% plot poor examples
tsindex=queryno;
for i=1:length(mismatch)
    
tsindex2=mismatch(i);
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/getPIPs');
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/PIPsIndicator');
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/matchingPIPs')
PIPinfo = getPIPs_threshold( ts_smooth(tsindex,:), PIPthr );
[ Indicator,PIPindex ] = getIndicator( ts_smooth(tsindex,:), PIPinfo );

PIPinfo2 = getPIPs_threshold( ts_smooth(tsindex2,:), PIPthr );
[ Indicator2,PIPindex2 ] = getIndicator( ts_smooth(tsindex2,:), PIPinfo2 );

costmat=getCostmat(Indicator,Indicator2);

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

end