function [ slope ] = RegressionSlope( ts )
% Regression global slope

x = 1:size(ts,2);
p = polyfit(x,ts,1);
slope = p(1);


end

