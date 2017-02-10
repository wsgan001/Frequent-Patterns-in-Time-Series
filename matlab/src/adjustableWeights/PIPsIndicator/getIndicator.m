function [ Indicator,PIPindex ] = getIndicator( ts, PIPinfo )
%ts: A time series you want to compare
%PIPinfo: the information of PIPs
%Indicator: x, y, slopt_left, length_left, slope_right, length_right, weight

[PIPnum,~] = size(PIPinfo);
%normalization
PIPindex = PIPinfo(:,1);%index in orginal time series
Indicator = zeros(PIPnum,7);

%% Locations
%X value
Indicator(:,1) = zscore(PIPinfo(:,1)); %normalized x-axis values - use zscore normalization to make x axis and y axis have the same scale (like what people see)
%xrange = Indicator(end,1) - Indicator(1,1);

%Y value
Indicator(:,2)=ts(PIPinfo(:,1)); % assume ts has been zscore normalized before this function.

%{
%nearby pattern
nearbyPatternIndex=[-1,1];
for x=1:2
    for i=1:PIPnum
        PIPorder=i+nearbyPatternIndex(x);
        if (PIPorder>=1 && PIPorder<=PIPnum)
            index=PIPinfo(PIPorder,1);
            PIPneighbour_rang=(index-PIPinfo(i,1))/xrange;
            Indicator(i,6+x)=(ts(index)-ts(PIPinfo(i,1)))/PIPneighbour_rang;
        else
            Indicator(i,6+x)=0;
        end
    end
end
%}

%% Local shapes
% slope left , length left, slope right, length right
for i = 1:PIPnum
    %left
    PIPorder = i - 1;
    if PIPorder>=1
        left_index=PIPinfo(PIPorder,1);
        
        dy = (ts(PIPinfo(i,1))-ts(left_index));
        dx_normalized = Indicator(i,1) - Indicator(i-1,1);
        Indicator(i,3) = dy/dx_normalized; % slope_left - need to use degree?
        Indicator(i,4) = norm(dx_normalized, dy); % normalized length_left
    else
        Indicator(i,3) = 0;
        Indicator(i,4) = 0;
    end
   
    %right
    PIPorder = i + 1;
    if  PIPorder<=PIPnum
        right_index=PIPinfo(PIPorder,1);
        
        dy = (ts(right_index)-ts(PIPinfo(i,1)));
        dx_normalized = Indicator(i+1,1) - Indicator(i,1);
        Indicator(i,5) = dy/dx_normalized; % slope_right - need to use degree?
        Indicator(i,6) = norm(dx_normalized, dy); % normalized length_right
    else
        Indicator(i,5) = 0;
        Indicator(i,6) = 0;
    end
    
    %initial weight - length_left + length_right
    if i == 1
        Indicator(i,7) = Indicator(i,6) * 2;
    elseif i == PIPnum
        Indicator(i,7) = Indicator(i,4) * 2;
    else
        Indicator(i,7) = Indicator(i,4) + Indicator(i,6);
    end
end


%% Weights - adjust(increase) the weights of begining and ending VIPs
Indicator(1, 7) = Indicator(1, 7) * 1.5;
Indicator(end,7) = Indicator(1, 7) * 1.5;

% normalize weights - percentage of the whole length
Indicator(:,7) = Indicator(:,7) / sum(Indicator(:,7));

%% Attention
%{
1. only the first six indicators are the feature vector, the last one is
the weight. So you should modify the distance function (only compare the distance of the first indicators and use the last one as weight -> how to use the weight is the correct way?)
%}

end
