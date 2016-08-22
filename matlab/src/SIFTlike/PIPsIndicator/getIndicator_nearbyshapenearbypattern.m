function [ Indicator,PIPindex ] = getIndicator_nearbyshapenearbypattern( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: x(PIPindex), delta y-2, delta y-1, y, delta y+1, delta y+2,
%delta PIP-1 yvalue, delta PIP+1 yvalue

[PIPnum,~]=size(PIPinfo);
%normalization
xrange=length(ts)-1;
PIPindex=PIPinfo(:,1);
Indicator=zeros(PIPnum,6);

%{
%X value
Indicator(:,1)=PIPinfo(:,1)/xrange;

%Y value
Indicator(:,2)=ts(PIPinfo(:,1));
%}
%nearby shape
nearbyShapeIndex=[-2,-1,1,2];
for x=1:4
    for i=1:PIPnum
        % delta y
        index = PIPinfo(i,1)+nearbyShapeIndex(x);
        if(index>=1 && index<=length(ts))
            Indicator(i,x)=(ts(index)-ts(PIPinfo(i,1)))*xrange;
        else
            Indicator(i,x)=0;
        end
    end
end

%nearby pattern
nearbyPatternIndex=[-1,1];
for x=1:2
    for i=1:PIPnum
        PIPorder=i+nearbyPatternIndex(x);
        if (PIPorder>=1 && PIPorder<=PIPnum)
            index=PIPinfo(PIPorder,1);
            PIPneighbour_rang=(index-PIPinfo(i,1))/xrange;
            Indicator(i,4+x)=(ts(index)-ts(PIPinfo(i,1)))/PIPneighbour_rang;
        else
            Indicator(i,4+x)=0;
        end
    end
end


end