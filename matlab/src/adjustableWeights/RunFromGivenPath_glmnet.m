function [ fit ] = RunFromGivenPath_glmnet( path )

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);
X = data(:, 1:end-1);
y = data(:, end);

fit = glmnet(X,y);
size(X)

end

