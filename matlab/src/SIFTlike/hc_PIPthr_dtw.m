function [ result,Dist,c ] = hc_PIPthr_dtw( ts,gt,PIPthr )
%Using hierarchical clustering, getPIPs_threshold and dtwMatch.
%Input: time series data set. Every row represents a sequence of time series.
%Output: The cross table result.

addpath('./getPIPs')
addpath('./matchingPIPs')
addpath('./PIPsIndicator')

if nargin<3
    PIPthr=0.15;
end

[rnum, ~]=size(ts);

PIPinfo=cell(rnum,1);
for i=1:rnum
    [ ~,tmp ] = getPIPs_threshold(ts(i,:), PIPthr);
    PIPinfo{i,1}=tmp;
end
Indicator=cell(rnum,1);
for i=1:rnum
    [ tmp,~ ] = getIndicator( ts(i,:), PIPinfo{i,1} );
    Indicator{i,1}=tmp;
end

Dist = zeros(1,rnum*(rnum-1)/2);
index=1;
for i=1:(rnum-1)
    for j=(i+1):rnum
        %tic
        costmat=getCostmat(Indicator{i,1},Indicator{j,1});
        %size(costmat)
        %toc
        [~,tmp]=dtwMatch(costmat);
        Dist(index)=tmp;
        index=index+1;
        %toc
    end
end

tree = linkage(Dist);

dendrogram(tree);

c = cluster(tree,'maxclust',6);

result = crosstab(c, gt);

end