function [ net ] = RunFromGivenPath_NN( path, NodeNum, flag )
%flag: d-DTW, m-MVIP, k-kshape, l-landmark, f-feature set(MVIP),
%o-objective features(MVIP)

if nargin == 1
    NodeNum = 10;
    flag = 'f';
elseif nargin == 2
    flag = 'f';
end

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);

if flag == 'd'
    train_data = data(:, 2);
elseif flag == 'm'
    train_data = data(:, 1);
elseif flag == 'k'
    train_data = data(:, 4);
elseif flag == 'l'
    train_data = data(:, 3);
elseif flag == 'f'
    train_data = data(:, [1, 5:end-1]);
elseif flag == 'o'
    train_data = data(:, [1, 5:end-7]);
end

label_train = data(:, end);

% fit = glmnet(X,y);
net = feedforwardnet(NodeNum);
 net.layers{2}.transferFcn = 'tansig'; % output mapping method. Default: purelin--linear mapping. If using tansig, the input and output should be in [0,1]
% train the net
net = train(net, train_data', label_train'/4);

end
