function [ cost ] = PIP_based_dis_getPIPsthr_dtw( ts1,ts2,PIPthr )
%Calculate the distance between two time series ts1 and ts2
%using getPIPs_threshold and dtwMatch

addpath('./getPIPs')
addpath('./mathcingPIPs')
addpath('./PIPsIndicator')

%get PIPs to represent the time series
[ ~,PIPinfo1 ] = getPIPs_threshold(ts1, PIPthr);
[ ~,PIPinfo2 ] = getPIPs_threshold(ts2, PIPthr);

%get Indicators of PIPs
[ Indicator1,~ ] = getIndicator( ts1, PIPinfo1 );
[ Indicator2,~ ] = getIndicator( ts2, PIPinfo2 );

%calculate cost matrix
costmat=getCostmat(Indicator1,Indicator2);

[~,cost] = dtwMatch(costmat);

end

