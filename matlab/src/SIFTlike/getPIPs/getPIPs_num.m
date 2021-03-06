function [ PIPindex,PIPinfo ] = getPIPs_num( ts,n )
%locate perceptually important points (PIPs)
%ts: time series, 1*tslength vector
%n: the number of PIPs;

%The column of PIPinfo from left to right:
%PIPindex: PIPs' position in ts by order
%PIPDist: Normalized Dist of each PIP
%PIPimportance: the order of being added to PIP set

if nargin==1
    n = 10; % 10 PIPs as default
end

[~,tslength]=size(ts);
yrange=max(ts)-min(ts);

%Dist=NormVDist(ts,yrange);
Dist=NormPDist(ts,tslength,yrange);
Dist=Dist(2:end-1);
PIPnew=find( Dist==(max(Dist)) )+1;
PIPindex=[1,PIPnew,tslength]; % the first three PIPs
PIPinfo=[1,0,1;tslength,0,2;PIPnew,max(Dist),3];

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
%{
figure;
plot(1:tslength,ts);
hold on
plot(PIPindex,ts(PIPindex));
hold off
%}

first=1;
middle=PIPnew;
last=tslength;
waitinglist=[];%column 1 for index in TS; column 2 for Distpos; each row for a possible PIP
while (size(PIPindex)<n)
    if(middle>first)
        %Dist1=NormVDist(ts(first:middle),yrange);
        Dist1=NormPDist(ts(first:middle),tslength,yrange);
        Dist1=Dist1(2:end-1);
        Distpos1=max(Dist1);
        PIPpos1=find( Dist1==Distpos1 )+first; % PIP possible 1 - index in TS      
    else
        PIPpos1=[];
    end
    
    if(last>middle)
        %Dist2=NormVDist(ts(middle:last),yrange);
        Dist2=NormPDist(ts(middle:last),tslength,yrange);
        Dist2=Dist2(2:end-1);
        Distpos2=max(Dist2);
        PIPpos2=find( Dist2==Distpos2 )+middle;
    else
        PIPpos2=[];
    end
    
    waitinglist=[waitinglist;PIPpos1,Distpos1;PIPpos2,Distpos2];
    waitinglist=sortrows(waitinglist,2);%sort by Distpos
    [rtmp,~]=size(waitinglist);
    PIPnew=waitinglist(rtmp,1);
    PIPinfo=[PIPinfo;PIPnew,waitinglist(rtmp,2),length(PIPindex)+1];
    waitinglist=waitinglist(1:rtmp-1,:);
    
    PIPindex=[PIPindex,PIPnew];
    PIPindex=sort(PIPindex);
    PIPnew_index_in_PIPindex=find(PIPindex==(PIPnew));
    first=PIPindex(PIPnew_index_in_PIPindex-1);
    last=PIPindex(PIPnew_index_in_PIPindex+1);
    middle=PIPnew;
    
    %plot for visual test
    %{
    pause(0.5)
    plot(1:tslength,ts);
    hold on
    plot(PIPindex,ts(PIPindex));
    hold off
    %}
    
end

PIPinfo=sortrows(PIPinfo,1);

end
