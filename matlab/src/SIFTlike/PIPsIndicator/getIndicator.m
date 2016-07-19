function [ Indicator,PIPindex ] = getIndicator( ts, PIPinfo )
%ts: One time series sequence you want to compare, maybe after smoothing or not
%PIPinfo: the information of PIPs
%Indicator: x(PIPindex) , PIPDist, PIPimportance, delta y-2, delta y-1, y, delta y+1, delta y+2
Xneighbourhood=-2:2;

[PIPnum,~]=size(PIPinfo);
%normalization
xrange=length(ts);
yrange=max(ts)-min(ts);

PIPindex=PIPinfo(:,1);
%%
%form indicator
%x(PIPindex)
Indicator=PIPinfo(:,1);
Indicator(:,1)=Indicator(:,1)/xrange; %normalized

%PIPDist - already normalized
Indicator=[Indicator,PIPinfo(:,2)]; %already normalized

%PIPimportance
Indicator=[Indicator,PIPinfo(:,3)];
Indicator(:,3)=Indicator(:,3)/max(PIPinfo(:,3));%normalized

%the Y value in Xneighbourhood
for x=Xneighbourhood
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
    tmp=tmp/yrange; % normalized
    Indicator=[Indicator,tmp];
end

%%
%adjustment


end

