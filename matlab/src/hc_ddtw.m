function [ result,Dist,c ] = hc_ddtw( ts,gt )
%Using hierarchical clustering and DTW to cluster given time series data set.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The result.

[rnum, cnum]=size(ts);

addpath('../lib/dynamic_time_warping_v2/dynamic_time_warping_v2.1');

%normalization/scaling
%{
for i=1:rnum
    ts(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
end
%}

%smoothin
%ts = smoothts(ts, 'e', 5);
ts = smoothts(ts);

%calculate derivative distance
ts_new = zeros(rnum,cnum-2);
for i=1:rnum
    for j=2:(cnum-1)
        ts_new(i,j-1) = ( (ts(i,j)-ts(i,j-1)) + ( (ts(i,j+1)-ts(i,j-1) )/2 ))/2;
    end
end

%Dist = pdist(ts,@dtw);
Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        Dist(index)=dtw(ts_new(i,:),ts_new(j,:));
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',6);

result = crosstab(c, gt);

end
