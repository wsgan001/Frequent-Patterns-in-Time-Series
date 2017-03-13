function [ ranking, DistInOriginalIndex ] = SimRank_rawdata_dtw( query,dataset,wl )
%query: query time series
%dataset: time series dataset
%wl: dtw window length
%ranking: row (time series) indexes in the original dataset. From the most similar to the least similar. Namely the first number is the row index of the most similar time series in original dataset.

if (nargin==2)
    wl=Inf;
end

%addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

[rnum, ~]=size(dataset);

Dist=zeros(rnum,2);
for i=1:rnum
    %index=linspace(1,tslength,tslength)';
    %Dist(i,1)=dtw([index/tslength,query'],[index/tslength,dataset(i,:)'],wl);
    if wl == Inf
        [Dist(i,1),~,~]=dtw(query',dataset(i,:)');
    else
        [Dist(i,1),~,~]=dtw(query',dataset(i,:)',wl);%no X info
    end
    %Dist(i,1)=dtw([index,query'],[index,dataset(i,:)'],wl);%no x-axis normalization
    Dist(i,2)=i;
end

DistInOriginalIndex = Dist(:,1);
Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end
