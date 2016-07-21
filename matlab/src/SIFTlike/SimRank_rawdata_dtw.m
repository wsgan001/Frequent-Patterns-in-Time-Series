function [ ranking ] = SimRank_rawdata_dtw( query,dataset )
%query: query time series
%dataset: time series dataset
%PIPthr: for getPIPs_threshold
%ranking: each row for each row of dataset, value = 1 means most similar

addpath('./getPIPs')
addpath('./matchingPIPs')
addpath('./PIPsIndicator')
addpath('../../lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

[rnum, ~]=size(dataset);

Dist=zeros(rnum,2);
for i=1:rnum
    Dist(i,1)=dtw(query,dataset(i,:));
    Dist(i,2)=i;
end

Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end

