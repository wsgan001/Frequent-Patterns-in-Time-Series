function [ globalIncrease ] = GlobalIncrease( ts )

%normalization
ts = zscore(ts);

globalIncrease = max(ts) - min(ts);

end

