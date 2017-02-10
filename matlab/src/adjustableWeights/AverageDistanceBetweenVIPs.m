function [ averageDistanceBetweenVIPs ] = AverageDistanceBetweenVIPs( PIPinfo, tslength )
% AverageDistanceBetweenVIPs
% [ PIPinfo ] = getPIPs_threshold( ts,thr )

xindex = 1:tslength;
x_normalized = zscore(xindex);

totalDistance = 0;
for i = 1:(size(PIPinfo,1)-1)
    totalDistance = totalDistance + x_normalized(PIPinfo(i+1,1)) - x_normalized(PIPinfo(i,1));
end

averageDistanceBetweenVIPs = totalDistance / (size(PIPinfo,1)-1);

end
