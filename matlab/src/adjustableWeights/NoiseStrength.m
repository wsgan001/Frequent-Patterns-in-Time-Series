function [ noiseStrength ] = NoiseStrength( ts )
% noiseStrength = [e_left, e_middle e_right]

% detrend (smooth suing Gaussion kernel)
wsize = max(2, size(ts,2) * 0.1);
stdev = 100;
ts_smoothed = smoothts(ts, 'g', wsize, stdev);

% zscore normalization
ts_smoothed = zscore(ts_smoothed')';
ts_detrend = ts - ts_smoothed;

% measure noise strength
noiseStrength = zeros(1,3);
pieceLength = round(size(ts,2) / 3);
noiseStrength(1,1) = std(ts(1:pieceLength),0,2);
noiseStrength(1,2) = std(ts(pieceLength+1:2*pieceLength),0,2);
noiseStrength(1,3) = std(ts(2*pieceLength+1:end),0,2);

end

