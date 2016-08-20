function [ Dist ] = MVIPOnlyNearbyPatternDist( query,dataset,PIPthr )

addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/getPIPs')
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/matchingPIPs')
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/PIPsIndicator')

if nargin<3
    PIPthr=0.15;
end

[rnum, ~]=size(dataset);

%% PIPinfo
PIPinfoQ = getPIPs_threshold(query, PIPthr);%query's info

PIPinfoD=cell(rnum,1);%dataset's info
for i=1:rnum
    PIPinfoD{i,1}=getPIPs_threshold(dataset(i,:), PIPthr);
end

%% get indicators of PIPs
[IndicatorQ,~] = getIndicator_onlynearbypattern( query, PIPinfoQ );%query's info

IndicatorD=cell(rnum,1);%dataset's info
for i=1:rnum
    [ tmp,~ ] = getIndicator_onlynearbypattern( dataset(i,:), PIPinfoD{i,1} );
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
