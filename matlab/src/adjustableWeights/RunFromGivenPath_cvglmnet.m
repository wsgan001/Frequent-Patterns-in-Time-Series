function [ fit ] = RunFromGivenPath_cvglmnet( path, nfolds )

if nargin == 1
    nfolds = 10;
end

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);
X = data(:, 1:end-1);
y = data(:, end);

fit = cvglmnet(X,y,[],[],[],nfolds);
size(X);

end

