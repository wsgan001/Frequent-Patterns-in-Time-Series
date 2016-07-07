function [ result ] = kmeans_fv( ts, gt, kc )
%kmeans + feature vector

if nargin==2
    kc = 6;
end

[fv, fv_norm] = getFv(ts);

c = kmeans(fv_norm,kc);

result = crosstab(c, gt);

figure;
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),60,gt,'filled');
title('Groundtruth')

figure;
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),60,c,'filled');
title('Results')

end