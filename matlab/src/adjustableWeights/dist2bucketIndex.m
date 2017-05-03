function [ bucketIndex ] = dist2bucketIndex( distance )
% use kmeans to cluster a distance vector into 4 clusters(bucket), and then
% assign bucket index to these clusters based on their values.
% input: distance vector; output: bucket index vector

if size(distance,1) >=4

    clusterIndex = kmeans(distance, 4);
    clusterDistance = zeros(4,1);

    tmp = find(clusterIndex==1);
    clusterDistance(1) = distance(tmp(1));

    tmp = find(clusterIndex==2);
    clusterDistance(2) = distance(tmp(1));

    tmp = find(clusterIndex==3);
    clusterDistance(3) = distance(tmp(1));

    tmp = find(clusterIndex==4);
    clusterDistance(4) = distance(tmp(1));

    % less distance, more similar
    [~,sortedClusters] = sort(clusterDistance); % the first cluster index has the least distance
    clusterIndex(clusterIndex == sortedClusters(1)) = 14; % most similar
    clusterIndex(clusterIndex == sortedClusters(2)) = 13;
    clusterIndex(clusterIndex == sortedClusters(3)) = 12;
    clusterIndex(clusterIndex == sortedClusters(4)) = 11;

    bucketIndex = clusterIndex - 10;
else
    bucketIndex = distance;
    [~,index] = sort(distance);
    for i=1:size(distance,1)
        bucketIndex(index(i)) = 5-i;
    end
end
    
end

