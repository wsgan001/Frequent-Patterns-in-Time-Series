function [ maxAccu, maxBucketIndex ] = spearman_optimun( truth, distance )
% Use optimum partiition of metrics' distances to get a bucket
% index(similarity levels) assignment with highest correlation under
% spearman with truth similarity
% input are column vectors

addpath('/Users/Steven/Documents/GitHub/User-Study-Data/UserStudy');

bucketIndex = distance;
vizIndex = (1:size(bucketIndex,1))';
Index = [bucketIndex, vizIndex];

maxAccu = -10;
maxBucketIndex = bucketIndex;

Index = sortrows(Index,1); % similar ones are on the top

n = size(distance,1); 
for i = 0:n
    if i > 0
        Index(1:i,1) = 4;
    end
        for j = i:n
            if j > i
                Index((i+1):j,1) = 3;
            end
                for k = j:n
                    if k > j
                        Index((j+1):k,1) = 2;
                    end
                    if k < n
                        Index((k+1):n,1) = 1;
                    end
                    tmp = sortrows(Index,2);
                    currentAccu = spearman( truth, tmp(:,1) );
                    if currentAccu > maxAccu
                        maxAccu = currentAccu;
                        maxBucketIndex = tmp(:,1);
                    end
                end
        end
end

end

