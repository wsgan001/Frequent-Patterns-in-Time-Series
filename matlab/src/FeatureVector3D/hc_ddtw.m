function [ result,Dist,c ] = hc_ddtw( ts,gt,clusternum,wl )
%Using hierarchical clustering and DTW to cluster given time series data set.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The result.

[rnum, cnum]=size(ts);

if (nargin==3)
    wl=Inf;
end

addpath('../../lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

ts = smoothts(ts);

%calculate derivative distance
ts_new = zeros(rnum,cnum-2);
for i=1:rnum
    for j=2:(cnum-1)
        ts_new(i,j-1) = ( (ts(i,j)-ts(i,j-1)) + ( (ts(i,j+1)-ts(i,j-1) )/2 ))/2;
    end
end

Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        xindex=linspace(1,(cnum-2),(cnum-2))';
        Dist(index)=dtw([xindex/(cnum-2),ts_new(i,:)'],...
                        [xindex/(cnum-2),ts_new(j,:)'],wl);
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',clusternum);

result = crosstab(c, gt);

end
