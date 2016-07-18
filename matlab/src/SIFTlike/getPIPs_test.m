clear;
clc;

%load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control;

[rnum,~]=size(ts);

%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
end

%smoothing
n=6;
wts = [1/(2*n);repmat(1/n,n-1,1);1/(2*n)];
for i=1:rnum
    ts_smooth(i,:) = conv(ts_norm(i,:),wts,'valid');   
end

[ PIPindex ] = getPIPs( ts_smooth(1,:),10 );
