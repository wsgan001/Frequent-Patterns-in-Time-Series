% consistent with getIndicatorsOnlyXY in MVIP.java
function [ Indicator,PIPindex ] = getIndicator_onlyxy( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: x(PIPindex), y

[PIPnum,~]=size(PIPinfo);
%normalization
xrange=length(ts)-1;
PIPindex=PIPinfo(:,1);
Indicator=zeros(PIPnum,2);

%X value
Indicator(:,1)=PIPinfo(:,1)/xrange;

%Y value
Indicator(:,2)=ts(PIPinfo(:,1));

end

