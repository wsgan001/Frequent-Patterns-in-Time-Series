%{
function [ Indicator,PIPindex ] = getIndicator_onlyxy( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: x(PIPindex), delta y-2, delta y-1, y, delta y+1, delta y+2,
%delta PIP-1 yvalue, delta PIP+1 yvalue
Xneighbour=-2:2;
PIPneighbour=[-1,1];

[PIPnum,~]=size(PIPinfo);
%normalization
xrange=length(ts);
yrange=max(ts)-min(ts);
%yrange=6; %resus are not good

PIPindex=PIPinfo(:,1);
%%
%form indicator
%x(PIPindex)
Indicator=PIPinfo(:,1);
Indicator(:,1)=Indicator(:,1)/xrange; %normalized
%Indicator(:,1)=Indicator(:,1)*1;%weight parameter

%PIPDist - already normalized
%Indicator=[Indicator,PIPinfo(:,2)]; %already normalized

%PIPimportance
%Indicator=[Indicator,PIPinfo(:,3)];
%Indicator(:,3)=Indicator(:,3)/max(PIPinfo(:,3));%normalized

%nearby shape
%the Y value in Xneighbour
for x=Xneighbour
    tmp=zeros(PIPnum,1);
    for i=1:PIPnum
        if (x==0) % y
            tmp(i,1)=ts(PIPinfo(i,1));
        else % delta y+x
            index = (PIPinfo(i,1)+x);
            if(index>=1 && index<=length(ts))
                tmp(i,1)=ts(index)-ts(PIPinfo(i,1));
            else
                tmp(i,1)=0;
            end
        end
    end
    if (yrange~=0)
        tmp=tmp/yrange; % normalized
    end
    Indicator=[Indicator,tmp];
end

%adjacent PIPs' shape
%the Y value in PIPneighbour
tmp=zeros(PIPnum,length(PIPneighbour));
for i=1:PIPnum
    PIPleftorder=i+PIPneighbour(1);
    PIPrightorder=i+PIPneighbour(end);
    if ((PIPleftorder>=1 && PIPleftorder<=PIPnum) &&...
            (PIPrightorder>=1 && PIPrightorder<=PIPnum)) %all in TS
        PIPneighbour_rang=...
            (PIPinfo(PIPrightorder,1)-PIPinfo(PIPleftorder,1))/2;
    elseif (PIPleftorder>=1 && PIPleftorder<=PIPnum) %only left side in TS
        PIPneighbour_rang=...
            (PIPinfo(i,1)-PIPinfo(PIPleftorder,1));
    else %only right side inTS
        PIPneighbour_rang=...
            (PIPinfo(PIPrightorder,1)-PIPinfo(i,1));
    end
    for j=1:length(PIPneighbour)
        PIPx=PIPneighbour(j);
        PIPorder=i+PIPx;
        if(PIPorder>=1 && PIPorder<=PIPnum)
            index=(PIPinfo(PIPorder,1));
        else
            index=-1;
        end
        if(index>=1 && index<=length(ts))
            tmp(i,j)=(ts(index)-ts(PIPinfo(i,1)))/PIPneighbour_rang;
        else
            tmp(i,j)=0;
        end
    end
end
if(yrange~=0)
    tmp=tmp/yrange; % normalized
end
Indicator=[Indicator,tmp];

%%
%adjustment
%x
Indicator(:,1)=Indicator(:,1)*1;

%y
Indicator(:,4)=Indicator(:,4)*1;
Indicator=[Indicator(:,1),Indicator(:,4)];
%Indicator=Indicator(:,1);
end
%}

%% consistent with getIndicatorsOnlyXY in MVIP.java
function [ Indicator,PIPindex ] = getIndicator_onlyxy( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: x(PIPindex), delta y-2, delta y-1, y, delta y+1, delta y+2,
%delta PIP-1 yvalue, delta PIP+1 yvalue

[PIPnum,~]=size(PIPinfo);
%normalization
xrange=length(ts);
PIPindex=PIPinfo(:,1);
Indicator=zeros(PIPnum,2);

%X value
Indicator(:,1)=PIPinfo(:,1)/xrange;

%Y value
Indicator(:,2)=ts(PIPinfo(:,1));
%{
%nearby shape
nearbyShapeIndex=[-2,-1,1,2];
for x=1:4
    for i=1:PIPnum
        % delta y
        index = PIPinfo(i,1)+nearbyShapeIndex(x);
        if(index>=1 && index<=length(ts))
            Indicator(i,2+x)=ts(index)-ts(PIPinfo(i,1));
        else
            Indicator(i,2+x)=0;
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
            Indicator(i,6+x)=(ts(index)-ts(PIPinfo(i,1)))/PIPneighbour_rang;
        else
            Indicator(i,6+x)=0;
        end
    end
end
%}

end

