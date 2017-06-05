function [ net ] = RunFromGivenPath_NN( path, NodeNum )

if nargin == 1
    NodeNum = 10;
end

addpath('../../lib/glmnet_matlab/');

fprintf('Loading data ...\n');
data = load(path);
train_data = data(:, 1:end-1);
label_train = data(:, end);

% fit = glmnet(X,y);
net = feedforwardnet(NodeNum);
 net.layers{2}.transferFcn = 'tansig'; % output mapping method. Default: purelin--linear mapping. If using tansig, the input and output should be in [0,1]
% train the net
net = train(net, train_data', label_train'/4);

end
