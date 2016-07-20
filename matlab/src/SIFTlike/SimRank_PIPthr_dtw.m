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

%dataset's info
PIPinfoD=cell(rnum,1);
for i=1:rnum
    [ ~,tmp ] = getPIPs_threshold(dataset(i,:), PIPthr);
    PIPinfoD{i,1}=tmp;
end
IndicatorD=cell(rnum,1);
for i=1:rnum
    [ tmp,~ ] = getIndicator( dataset(i,:), PIPinfoD{i,1} );
    IndicatorD{i,1}=tmp;
end

%query's info
[~,PIPinfoQ] = getPIPs_threshold(query, PIPthr);
[IndicatorQ,~] = getIndicator( query, PIPinfoQ );

Dist=zeros(rnum,2);
for i=1:rnum
    costmat=getCostmat(IndicatorQ,IndicatorD{i,1});
    [~,tmp]=dtwMatch(costmat);
    Dist(i,1)=tmp;
    Dist(i,2)=i;
end

Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end

