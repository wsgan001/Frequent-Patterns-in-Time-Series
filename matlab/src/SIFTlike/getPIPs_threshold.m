function [ PIPindex ] = getPIPs_threshold( ts,thr )
%locate perceptually important points (PIPs)
%ts: time series, 1*length vector
%thr: normalized threshold.
%MUST USE NormVDist/NormPDist AS DISTANCE METRIC

%PIPindex: PIPs' position in ts by order
%PIPDist: Dist of each PIP
%PIPimportance: the order of being added to PIP set

if nargin==1
    thr = 0.05; 
end

[~,length]=size(ts);

PIPindex=[1,length]; % the first three PIPs
waitinglist=[];%column 1 for index in TS; column 2 for Distpos; each row for a possible PIP
Dist=NormVDist(ts,ts);
%Dist=NormPDist(ts,ts);
Dist=Dist(2:end-1);
Distpos=max(Dist);
PIPpos=find( Dist==(Distpos) )+1;
waitinglist=[waitinglist;PIPpos,Distpos];

%{
pseudo code:
the new PIP and its two adjacent PIPs as middle, first and last of the
segment.
locate two possible PIPs from the two subsegment divided by middle
add these two possible PIPs into waiting list
select the points from the waiting list with maximum Dist and add it to PIPs
as new PIP.
REPEAT UNTIL GETTING N PIPS
%}
%plot for visual test
figure;
plot(1:length,ts);
hold on
plot(PIPindex,ts(PIPindex));
hold off

%first=1;
%middle=PIPnew;
%last=length;

while (max(waitinglist(:,2))>thr)
    waitinglist=sortrows(waitinglist,2);%sort by Distpos
    [rtmp,~]=size(waitinglist);
    PIPnew=waitinglist(rtmp,1);
    waitinglist=waitinglist(1:rtmp-1,:);
    
    PIPindex=[PIPindex,PIPnew];
    PIPindex=sort(PIPindex);
    PIPnew_index_in_PIPindex=find(PIPindex==(PIPnew));
    first=PIPindex(PIPnew_index_in_PIPindex-1);
    last=PIPindex(PIPnew_index_in_PIPindex+1);
    middle=PIPnew;
    
    %plot for visual test
    pause(0.5)
    plot(1:length,ts);
    hold on
    plot(PIPindex,ts(PIPindex));
    hold off
    
    if(middle>first)
        Dist1=NormVDist(ts(first:middle),ts);
        %Dist1=NormPDist(ts(first:middle),ts);
        Dist1=Dist1(2:end-1);
        Distpos1=max(Dist1);
        PIPpos1=find( Dist1==Distpos1 )+first; % PIP possible 1 - index in TS      
    else
        PIPpos1=[];
    end
    
    if(last>middle)
        Dist2=NormVDist(ts(middle:last),ts);
        %Dist2=NormPDist(ts(middle:last),ts);
        Dist2=Dist2(2:end-1);
        Distpos2=max(Dist2);
        PIPpos2=find( Dist2==Distpos2 )+middle;
    else
        PIPpos2=[];
    end
    
    waitinglist=[waitinglist;PIPpos1,Distpos1;PIPpos2,Distpos2];
    
end

end
