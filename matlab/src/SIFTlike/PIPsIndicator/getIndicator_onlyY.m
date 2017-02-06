function [ Indicator,PIPindex ] = getIndicator_onlyY( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: y
%delta PIP-1 yvalue, delta PIP+1 yvalue

[PIPnum,~]=size(PIPinfo);
%normalization
%xrange=length(ts)-1;
PIPindex=PIPinfo(:,1);
Indicator=zeros(PIPnum,1);

%X value
%Indicator(:,1)=PIPinfo(:,1)/xrange;

%Y value
Indicator(:,1)=ts(PIPinfo(:,1));

end

