function [ Dist ] = MVIPDist( query, dataset, PIPthr )
% new MVIP based on new features

addpath('./getPIPs')
addpath('./matchingPIPs')
addpath('./PIPsIndicator')

if nargin<3
    PIPthr=0.15;
end

[rnum, ~]=size(dataset);

%% Smooth - using Gaussion kernel
wsize = max(2, round(size(query,2) * 0.1));
stdev = 100;
query = smoothts(query, 'g', wsize, stdev);
dataset = smoothts(dataset, 'g', wsize, stdev);

% zscore normalization
query = zscore(query')';
dataset = zscore(dataset')';

%% PIPinfo
PIPinfoQ = getPIPs_threshold(query, PIPthr);%query's info

PIPinfoD=cell(rnum,1);%dataset's info
for i=1:rnum
    PIPinfoD{i,1}=getPIPs_threshold(dataset(i,:), PIPthr);
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
