function [ PD ] = NormPDist( ts, wholets)
%ts: original time series sequence
%wholets: whole time series to get the axis ranges
%PD: Normalized perpendicular distance (i.e. divided by the ranges of axises)

[rnum,cnum]=size(ts);
PD = zeros(rnum,cnum);
xrange=length(wholets);
yrange=max(wholets)-min(wholets);

for i=2:(cnum-1)
    PD(i) = (norm(cross([(i-1)/xrange,(ts(i)-ts(1))/yrange,0], [(cnum-1)/xrange,(ts(end)-ts(1))/yrange,0])))/...
        (norm([(cnum-1)/xrange,(ts(end)-ts(1))/yrange,0]));
end

end
