%This is a test for one dimension of the seasonal feature.
%Pretty good results! Distinguish cyclic time series from others totally!

clear;
clc;

load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;

%normalization/scaling
ts_norm = ts;
for i=1:600
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
    %ts_norm(i,:)=ts(i,:)/mean(ts(i,:));
end

%The maximum amplitude of frequent spectrum (except the first two points and the last two points)
max_fre = zeros(600,1);
for i=1:600
    amp_tmp=abs(fft(ts_norm(i,:)));
    max_fre(i) = max(amp_tmp(3:58));%delete the direct current part and the lowest frequency part(second & penult points)
end

fre_mean=zeros(6,1);
fre_std=fre_mean;
fre_max=fre_mean;
fre_min=fre_max;
for i=0:5
    fre_mean(i+1) = mean( max_fre((1+i*100):(100+i*100)) );
    fre_std(i+1) = std( max_fre((1+i*100):(100+i*100)) );
    fre_max(i+1) = max( max_fre((1+i*100):(100+i*100)) );
    fre_min(i+1) = min( max_fre((1+i*100):(100+i*100)) );
end

%The histogram of the maximum amplitude of frequent spectrum of different
%kinds of time series.
figure
ax1=subplot(231);
histogram(max_fre(1:100));
title('1.Normal')

ax2=subplot(232);
histogram(max_fre(101:200));
title('2.Cyclic')

ax3=subplot(233);
histogram(max_fre(201:300));
title('3.Increasing trend')

ax4=subplot(234);
histogram(max_fre(301:400));
title('4.Decreasing trend')

ax5=subplot(235);
histogram(max_fre(401:500));
title('5.Upward shift')

ax6=subplot(236);
histogram(max_fre(501:600));
title('6.Downward shift')

axis([ax1 ax2 ax3 ax4 ax5 ax6],[10 45 0 35]);
%axis([ax1 ax2 ax3 ax4 ax5 ax6],[800 2800 0 35]);