function [ fit ] = RunFromGivenPath_glmnet( path, flag )
%flag: d-DTW, m-MVIP, k-kshape, l-landmark, f-feature set(MVIP),
%o-objective features(MVIP)

if nargin == 1
    flag = 'f';
end

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);

if flag == 'd'
    X = data(:, 2);
elseif flag == 'm'
    X = data(:, 1);
elseif flag == 'k'
    X = data(:, 4);
elseif flag == 'l'
    X = data(:, 3);
elseif flag == 'f'
    X = data(:, [1, 5:end-1]);
elseif flag == 'o'
    X = data(:, [1, 5:end-7]);
end

y = data(:, end);

fit = glmnet(X,y);
size(X);

end

