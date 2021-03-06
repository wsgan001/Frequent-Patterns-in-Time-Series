function [ result,Dist,c ] = hc_dtw( ts,gt,clusternum,wl)
%Using hierarchical clustering and DTW to cluster given time series data set.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The result.

if (nargin==3)
    wl=Inf;
end

addpath('../../lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

[rnum, tslength]=size(ts);

Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        xindex=linspace(1,tslength,tslength)';
        Dist(index)=dtw([xindex/tslength,ts(i,:)'],...
                        [xindex/tslength,ts(j,:)'],wl);
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',clusternum);

result = crosstab(c, gt);

end
