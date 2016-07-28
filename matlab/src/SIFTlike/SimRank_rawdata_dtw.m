function [ ranking ] = SimRank_rawdata_dtw( query,dataset,wl )
%query: query time series
%dataset: time series dataset
%wl: dtw window length
%ranking: each row for each row of dataset, value = 1 means most similar

if (nargin==2)
    wl=Inf;
end

addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

[rnum, tslength]=size(dataset);

Dist=zeros(rnum,2);
for i=1:rnum
    index=linspace(1,tslength,tslength)';
    %Dist(i,1)=dtw([index/tslength,query'],[index/tslength,dataset(i,:)'],wl);
    Dist(i,1)=dtw(query',dataset(i,:)',wl);%no X info
    %Dist(i,1)=dtw([index,query'],[index,dataset(i,:)'],wl);%no x-axis normalization
    Dist(i,2)=i;
end

Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end
