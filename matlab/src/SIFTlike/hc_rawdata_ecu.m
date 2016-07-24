function [ result,Dist,c ] = hc_rawdata_ecu( ts,gt,clusternum )
%Using hierarchical clustering, rawdata_ecu.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The cross table result.

if nargin <3
    clusternum=6;
end

[rnum, ~]=size(ts);

Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        Dist(index)=norm(ts(i,:)-ts(j,:));
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',clusternum);

result = crosstab(c, gt);

end