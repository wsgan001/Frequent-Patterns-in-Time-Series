function [ Indicator,PIPindex ] = getIndicator( ts, PIPinfo )
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
            (PIPinfo(PIPrightorder,1)-PIPinfo(PIPleftorder,1))/2/xrange;
    elseif (PIPleftorder>=1 && PIPleftorder<=PIPnum) %only left side in TS
        PIPneighbour_rang=...
            (PIPinfo(i,1)-PIPinfo(PIPleftorder,1))/xrange;
    else %only right side inTS
        PIPneighbour_rang=...
            (PIPinfo(PIPrightorder,1)-PIPinfo(i,1))/xrange;
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
            tmp(i,j)=ts(index)-ts(PIPinfo(i,1));
            tmp(i,j)=tmp(i,j)/PIPneighbour_rang;
        else
            tmp(i,j)=0;
        end
    end
    if(yrange~=0)
        tmp=tmp/yrange; % normalized
    end
end
Indicator=[Indicator,tmp];

%%
%adjustment
%x
Indicator(:,1)=Indicator(:,1)*5;

%y
Indicator(:,4)=Indicator(:,4)*1;

end

