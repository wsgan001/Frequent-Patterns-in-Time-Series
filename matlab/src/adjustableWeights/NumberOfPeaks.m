function [ peakNum ] = NumberOfPeaks( PIPinfo, ts )
% 3 VIPs, left one and right one are smaller than the middle one, and the height > 15% of y axis.
% [ PIPinfo ] = getPIPs_threshold( ts,thr )

yrange = max(ts) - min(ts);

peakNum = 0;
for i = 2:(size(PIPinfo,1)-1)
    if ts(PIPinfo(i,1)) > ts(PIPinfo(i-1,1)) && ts(PIPinfo(i,1)) > ts(PIPinfo(i+1,1))
        height_left = ts(PIPinfo(i,1)) - ts(PIPinfo(i-1,1));
        height_right = ts(PIPinfo(i,1)) - ts(PIPinfo(i+1,1));
        if height_left > yrange * 0.15 && height_right > yrange * 0.15
            peakNum = peakNum + 1;
        end
    end
end

end
