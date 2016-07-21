function [ ranking ] = SimRank_PIPthr_dtw( query,dataset,PIPthr )
%query: query time series
%dataset: time series dataset
%PIPthr: for getPIPs_threshold
%ranking: each row for each row of dataset, value = 1 means most similar

addpath('./getPIPs')
addpath('./matchingPIPs')
addpath('./PIPsIndicator')

if nargin<3
    PIPthr=0.15;
end

[rnum, ~]=size(dataset);

%% PIPinfo
%tic
PIPinfoQ = getPIPs_threshold(query, PIPthr);%query's info
%size(PIPinfoQ)

PIPinfoD=cell(rnum,1);%dataset's info
for i=1:rnum
    PIPinfoD{i,1}=getPIPs_threshold(dataset(i,:), PIPthr);
end
%toc

%% get indicators of PIPs
%tic
[IndicatorQ,~] = getIndicator( query, PIPinfoQ );%query's info

IndicatorD=cell(rnum,1);%dataset's info
for i=1:rnum
    [ tmp,~ ] = getIndicator( dataset(i,:), PIPinfoD{i,1} );
    IndicatorD{i,1}=tmp;
end
%toc

%% dynamic computing
%tic
Dist=zeros(rnum,2);
for i=1:rnum
    costmat=getCostmat(IndicatorQ,IndicatorD{i,1});
    [~,tmp]=dtwMatch(costmat);
    Dist(i,1)=tmp;
    Dist(i,2)=i;
end
%toc

%% return results
Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end
