function [ result,Dist,c ] = hc_dtw( ts,gt,clusternum)
%Using hierarchical clustering and DTW to cluster given time series data set.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The result.

[rnum, ~]=size(ts);

addpath('../../lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

%normalization/scaling
%{
for i=1:rnum
    ts(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
end
%}

%Dist = pdist(ts,@dtw);
Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        Dist(index)=dtw(ts(i,:),ts(j,:));
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',clusternum);

result = crosstab(c, gt);

end
