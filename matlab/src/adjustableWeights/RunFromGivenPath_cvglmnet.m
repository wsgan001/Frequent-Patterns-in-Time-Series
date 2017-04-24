function [ fit ] = RunFromGivenPath_cvglmnet( path )

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);
X = data(:, 1:end-1);
y = data(:, end);

fit = cvglmnet(X,y,[],[],[],4);
size(X);

end

