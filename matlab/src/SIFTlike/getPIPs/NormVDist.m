function [ VD ] = NormVDist( ts,yrange )
%ts: original time series sequence
%yrange: value range of Y axis
%VD: vertical distance

tmp=linspace(ts(1),ts(end),length(ts)); %the line connecting the first and last points
VD=abs(ts-tmp);

VD=VD/yrange;

end
