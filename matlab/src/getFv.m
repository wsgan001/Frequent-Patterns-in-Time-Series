function [ fv, fv_norm ] = getFv( ts )
%Calculate the feature vector of time series
%Input: ts-time series matrix. Each row is a sequence of time series.
%Output: 
%fv-feature vector matrix. Each row is corresponding to the row of ts matrix.
%fv_norm-normalized feature vector.

[rnum,~]=size(ts);

%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
end

%%%feature 1 - seasonal%%%
%The maximum amplitude of frequent spectrum (except the first two points and the last two points)
max_fre = zeros(600,1);
for i=1:600
    amp_tmp=abs(fft(ts_norm(i,:)));
    max_fre(i) = max(amp_tmp(3:58));%delete the direct current part and the lowest frequency part(second & penult points)
end

%%%feature 2 - sigma slope%%%
%smoothing
n=6;
wts = [1/(2*n);repmat(1/n,n-1,1);1/(2*n)];
for i=1:rnum
    ts_smooth(i,:) = conv(ts_norm(i,:),wts,'valid');   
end
[~,cnum_smooth]=size(ts_smooth);

slope = zeros(rnum,cnum_smooth-1);
for i=1:rnum
    for j=1:(cnum_smooth-1)
        slope(i,j)=ts_smooth(i,j+1)-ts_smooth(i,j);
    end
end

f_trend = zeros(rnum, 1);
for i=1:rnum
    f_trend(i) = ts_smooth(i,cnum_smooth)-ts_smooth(i,1);
end

%%%feature 3 - (sigma slope)/max|slope_n|%%%
step=8;
slope_n = zeros(rnum,cnum_smooth-step);
for i=1:rnum
    for j=1:(cnum_smooth-step)
        slope_n(i,j) = ts_smooth(i,j+step)-ts_smooth(i,j);
    end
end
f_shift = zeros(60,1);
for i=1:rnum
    f_shift(i) = f_trend(i)/max(abs(slope_n(i,:)));
    %f_shift(i) = sign(f_shift(i)) * (abs(f_shift(i)))^2;
end

%(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
%merge all features
fv = [max_fre,f_trend,f_shift];
%normalization
fv_norm=fv;
[~,csize]=size(fv);
for i=1:csize
    fv_norm(:,i)=( (fv(:,i)) - mean(fv(:,i)) ) / std(fv(:,i));
end

%test
load('../data/gt_sc.mat');
gt = gt_sc;
figure;
%{
scatter3(fv_norm(1:100,1),fv_norm(1:100,2),fv_norm(1:100,3),60,gt,'filled');
hold on
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),60,gt,'filled');
hold on
scatter3(fv_norm(:,1),fv_norm(:,2),fv_norm(:,3),60,gt,'filled');
legend({'a','b','c'});
%}

for i=0:5
    scatter3(fv_norm(1+i*100:100+i*100,1),fv_norm(1+i*100:100+i*100,2),fv_norm(1+i*100:100+i*100,3),60,'filled');
    hold on
end
title('groundtruth');
legend({'1.Normal','2.Cyclic','3.Increasing trend','4.Decreasing trend',...
    '5.Upward shift','6.Downward shift'});

end

