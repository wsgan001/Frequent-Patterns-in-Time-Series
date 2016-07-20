function [ result,Dist,c ] = hc_PIPthr_dtw( ts,gt,PIPthr )
%Using hierarchical clustering, getPIPs_threshold and dtwMatch.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The cross table result.

if nargin<3
    PIPthr=0.02;
end

[rnum, ~]=size(ts);

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
        Dist(index)=PIP_based_dis_getPIPsthr_dtw(ts(i,:),ts(j,:),PIPthr);
        index=index+1;
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',6);

result = crosstab(c, gt);

end