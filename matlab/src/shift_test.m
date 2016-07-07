%This is a test for shift detecting.
%Assume that there is at most one shift in a time series sequence.

clear;
clc;

load('../data/gt_sc.mat');
load('../data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;
[rnum,cnum]=size(ts);

%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
    %ts_norm(i,:)=ts(i,:)/mean(ts(i,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%one example from each type.%%%%%%%%%%%%%%%%%%%%%%%%%
%{
normal=ts_norm(1,:);
cyclic=ts_norm(101,:);
increasing=ts_norm(201,:);
decreasing=ts_norm(301,:);
up=ts_norm(401,:);
down=ts_norm(501,:);

figure;
subplot(321);
plot(normal);
title('normal');
subplot(322);
plot(cyclic);
title('cyclic');
subplot(323);
plot(increasing);
title('increasing');
subplot(324)
plot(decreasing);
title('decreasing');
subplot(325)
plot(up);
title('up shift');
subplot(326);
plot(down);
title('down shift');

%smoothing
n=6;
wts = [1/(2*n);repmat(1/n,n-1,1);1/(2*n)];
normal_conv = conv(normal,wts,'valid');
%{
equal code
for i=1:54
    normal_conv(i)=1/12*normal(i)+1/6*sum(normal(i+1:i+5))+1/12*normal(i+6);
end
%}
cyclic_conv = conv(cyclic,wts,'valid');
increasing_conv = conv(increasing,wts,'valid');
decreasing_conv = conv(decreasing,wts,'valid');
up_conv = conv(up,wts,'valid');
down_conv = conv(down, wts, 'valid');

%{
n=10;
wts = [1/(2*n);repmat(1/n,n-1,1);1/(2*n)];
normal_conv = conv(normal_conv,wts,'valid');
cyclic_conv = conv(cyclic_conv,wts,'valid');
increasing_conv = conv(increasing_conv,wts,'valid');
decreasing_conv = conv(decreasing_conv,wts,'valid');
up_conv = conv(up_conv,wts,'valid');
down_conv = conv(down_conv, wts, 'valid');
%}

figure;
subplot(321);
plot(normal_conv);
title('normal conv');
subplot(322);
plot(cyclic_conv);
title('cyclic conv');
subplot(323);
plot(increasing_conv);
title('increasing conv');
subplot(324)
plot(decreasing_conv);
title('decreasing conv');
subplot(325)
plot(up_conv);
title('up shift conv');
subplot(326);
plot(down_conv);
title('down shift conv');
%}
%%%%%%%%%%%%%%%%%%%%%%%%%one example from each type.%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%total delta (sigma slope)%%%
sigma_slope = zeros(rnum, 1);
for i=1:rnum
    sigma_slope(i) = ts_smooth(i,cnum_smooth)-ts_smooth(i,1);
end
%histgram
figure('name','sigma slope')
ax1=subplot(231);
histogram(sigma_slope(1:100));
title('1.Normal')

ax2=subplot(232);
histogram(sigma_slope(101:200));
title('2.Cyclic')

ax3=subplot(233);
histogram(sigma_slope(201:300));
title('3.Increasing trend')

ax4=subplot(234);
histogram(sigma_slope(301:400));
title('4.Decreasing trend')

ax5=subplot(235);
histogram(sigma_slope(401:500));
title('5.Upward shift')

ax6=subplot(236);
histogram(sigma_slope(501:600));
title('6.Downward shift')
axis([ax1 ax2 ax3 ax4 ax5 ax6],[-6 6 0 40]);
%%%total delta (sigma slope)%%%

%%%( (sigma slope)/( (sigma|slope|) -|slope_max|) )%%%
feature2 = zeros(rnum, 1);
abs_slope = zeros(rnum,cnum_smooth-1);
for i=1:rnum
    for j=1:(cnum_smooth-1)
        abs_slope(i,j)=abs(ts_smooth(i,j+1)-ts_smooth(i,j));
    end
end

for i=1:rnum
    feature2(i) =  ( (ts_smooth(i,cnum_smooth)-ts_smooth(i,1)) / ( (sum(abs_slope(i,:)))-(max(abs_slope(i,:))) ) );
end

%histgram
figure('name','(sigma slope)/( (sigma|slope|) -|slope_max|)')
ax1=subplot(231);
histogram(feature2(1:100));
title('1.Normal')

ax2=subplot(232);
histogram(feature2(101:200));
title('2.Cyclic')

ax3=subplot(233);
histogram(feature2(201:300));
title('3.Increasing trend')

ax4=subplot(234);
histogram(feature2(301:400));
title('4.Decreasing trend')

ax5=subplot(235);
histogram(feature2(401:500));
title('5.Upward shift')

ax6=subplot(236);
histogram(feature2(501:600));
title('6.Downward shift')

axis([ax1 ax2 ax3 ax4 ax5 ax6],[-1.2 1 0 40]);

%%%(sigma slope)/max|slope|%%%
feature3 = zeros(60,1);
for i=1:rnum
    feature3(i) = sigma_slope(i)/max(abs(slope(i,:)));
end
%histgram
figure('name','(sigma slope)/max|slope|')
ax1=subplot(231);
histogram(feature3(1:100));
title('1.Normal')

ax2=subplot(232);
histogram(feature3(101:200));
title('2.Cyclic')

ax3=subplot(233);
histogram(feature3(201:300));
title('3.Increasing trend')

ax4=subplot(234);
histogram(feature3(301:400));
title('4.Decreasing trend')

ax5=subplot(235);
histogram(feature3(401:500));
title('5.Upward shift')

ax6=subplot(236);
histogram(feature3(501:600));
title('6.Downward shift')

axis([ax1 ax2 ax3 ax4 ax5 ax6],[-25 25 0 45]);

%%%(sigma slope)/max|slope_n|%%%
%Have the best results of distinguishing up/down shifts and in/decreasing
%from feature 1 to 4
step=8;
slope_n = zeros(rnum,cnum_smooth-step);
for i=1:rnum
    for j=1:(cnum_smooth-step)
        slope_n(i,j) = ts_smooth(i,j+step)-ts_smooth(i,j);
    end
end

feature4 = zeros(60,1);
for i=1:rnum
    feature4(i) = sigma_slope(i)/max(abs(slope_n(i,:)));
    %feature4(i) = sign(feature4(i)) * (abs(feature4(i)))^2;
end
%histgram
figure('name','(sigma slope)/max|slope_n|')
ax1=subplot(231);
histogram(feature4(1:100));
title('1.Normal')

ax2=subplot(232);
histogram(feature4(101:200));
title('2.Cyclic')

ax3=subplot(233);
histogram(feature4(201:300));
title('3.Increasing trend')

ax4=subplot(234);
histogram(feature4(301:400));
title('4.Decreasing trend')

ax5=subplot(235);
histogram(feature4(401:500));
title('5.Upward shift')

ax6=subplot(236);
histogram(feature4(501:600));
title('6.Downward shift')

axis([ax1 ax2 ax3 ax4 ax5 ax6],[-4 5 0 50]); %exp=1
%axis([ax1 ax2 ax3 ax4 ax5 ax6],[-15 20 0 60]); %exp=2