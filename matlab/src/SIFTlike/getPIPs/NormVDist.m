function [ VD ] = NormVDist( ts,wholets )
%ts: original time series sequence
%wholets: whole time series to get the axis ranges
%VD: vertical distance

tmp=linspace(ts(1),ts(end),length(ts)); %the line connecting the first and last points
VD=abs(ts-tmp);

yrange=max(wholets)-min(wholets);
VD=VD/yrange;

end
