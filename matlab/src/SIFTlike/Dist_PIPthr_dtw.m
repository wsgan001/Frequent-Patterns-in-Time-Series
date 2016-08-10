function [ dist ] = Dist_PIPthr_dtw( ts1,ts2,PIPthr )
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/getPIPs')
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/matchingPIPs')
addpath('/Users/Steven/Documents/GitHub/Frequent-Patterns-in-Time-Series/matlab/src/SIFTlike/PIPsIndicator')

if nargin<3
    PIPthr=0.15;
end

%% PIPinfo
PIPinfo1 = getPIPs_threshold(ts1, PIPthr);
PIPinfo2 = getPIPs_threshold(ts2, PIPthr);

%% get indicators of PIPs
[Indicator1,~] = getIndicator( ts1, PIPinfo1 );
[Indicator2,~] = getIndicator( ts2, PIPinfo2 );

%% dynamic computing
costmat=getCostmat(Indicator1,Indicator2);
[~,dist]=dtwMatch(costmat);

end
