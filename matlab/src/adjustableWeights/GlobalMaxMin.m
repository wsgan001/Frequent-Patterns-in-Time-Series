function [ globalMaxMin ] = GlobalMaxMin ( ts )
%[max_y, max_x, min_y, min_x]

%normalization
ts_y_zscore = zscore(ts);
ts_x_zscore = zsocre(1:(size(ts,2)));

globalMaxMin = zeros(1,4);

[globalMaxMin(1,1), index] = max(ts_y_zscore) ;
globalMaxMin(1,2) = ts_x_zscore(index);

[globalMaxMin(1,3), index] = min(ts_y_zscore) ;
globalMaxMin(1,4) = ts_x_zscore(index);

end
