function [ result, accuracy ] = kmeans_fv( ts, gt, kc )
%kmeans + feature vector

[rnum,cnum] = size(ts);

if nargin==2
    kc = 6;
end

[fv, fv_norm] = getFv(ts);

c = kmeans(fv_norm,kc);

result = crosstab(c, gt);

%{
figure;
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),60,gt,'filled');
title('Groundtruth')
%}

pointSize = 40;

figure;
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),pointSize,gt,'filled');
title('Groundtruth')
xlabel('seasonal');
ylabel('in/de-creasing trend');
zlabel('shift');

figure;
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),pointSize,c,'filled');
title('Results')
xlabel('seasonal');
ylabel('in/de-creasing trend');
zlabel('shift');

%estimate accuracy
right=0;
for i=1:kc
    right=right+max(result(i,:));
end
accuracy = right / rnum;

end