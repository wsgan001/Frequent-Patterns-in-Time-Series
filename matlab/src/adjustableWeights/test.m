load('./datasetForLinearRegression/TestSet.mat');

avgStd = zeros(17,1);
for i = 1:20
    for j = 1:8
        a = allDataPoint{i,j};
        a = a(:,1:end-1);
        avgStd = avgStd + std(a)';
    end
end

avgStd = avgStd / 160;
weights=[-2.0485;0;0;0;-0.0321;0;0;-242.1966;-0.5523;0;0;0;0;0;0;-0.0340;0];

avgStd.*weights