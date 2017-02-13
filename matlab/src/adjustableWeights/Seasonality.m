function [ seasonality ] = Seasonality( ts )
% calculate one ts's seasonality score
% seasonality = [frequency_max, frequency_max_amplitude, frequency_average, standard deviation]

seasonality = zeros(1,4);
ts_fdomain = abs(fft(ts));
[seasonality(2),seasonality(1)] = max(ts_fdomain);
seasonality(3) = (ts_fdomain .* (1:size(ts_fdomain,2))) / sum(ts_fdomain);
seasonality(4) = std(ts_fdomain);

end
