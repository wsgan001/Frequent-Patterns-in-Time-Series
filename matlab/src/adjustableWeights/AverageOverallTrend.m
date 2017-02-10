function [ Dist ] = AverageOverallTrend( query, dataset, PIPnum )
% Extract 5 VIPs and follow the same process of overall trend to compare the distance

addpath('./getPIPs')
addpath('./matchingPIPs')
addpath('./PIPsIndicator')

if nargin<3
    PIPnum=5;
end

[rnum, ~]=size(dataset);

%% Smooth - using Gaussion kernel
wsize = max(2, size(query,2) * 0.1);
stdev = 100;
query = smoothts(query, 'g', wsize, stdev);
dataset = smoothts(dataset, 'g', wsize, stdev);

% zscore normalization
query = zscore(query')';
dataset = zscore(dataset')';

%% PIPinfo
PIPinfoQ = getPIPs_num(query, PIPnum);%query's info

PIPinfoD=cell(rnum,1);%dataset's info
for i=1:rnum
    PIPinfoD{i,1}=getPIPs_num(dataset(i,:), PIPnum);
end

%% get indicators of PIPs
% new features and add weights
[IndicatorQ,~] = getIndicator( query, PIPinfoQ );%query's info

IndicatorD=cell(rnum,1);%dataset's info
for i=1:rnum
    [ tmp,~ ] = getIndicator( dataset(i,:), PIPinfoD{i,1} );
    IndicatorD{i,1}=tmp;
end

%% dynamic computing
Dist=zeros(rnum,1);
for i=1:rnum
    costmat=getCostmat(IndicatorQ,IndicatorD{i,1});
    [~,tmp]=dtwMatch(costmat);
    Dist(i,1)=tmp;
end

end
