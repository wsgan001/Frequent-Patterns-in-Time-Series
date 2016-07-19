function [ PD ] = PDist( ts )
%ts: original time series sequence
%PD: Perpendicular distance

[rnum,cnum]=size(ts);
PD = zeros(rnum,cnum);

for i=2:(cnum-1)
    PD(i) = (norm(cross([i-1,ts(i)-ts(1),0], [cnum-1,ts(end)-ts(1),0])))/...
        (norm([cnum-1,ts(end)-ts(1),0]));
end

end
