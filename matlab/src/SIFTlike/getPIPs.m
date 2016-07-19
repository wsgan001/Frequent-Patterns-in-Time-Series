function [ PIPindex ] = getPIPs( ts,n )
%locate perceptually important points (PIPs)
%ts: time series, 1*length vector
%n: the number of PIPs;

%PIPindex: PIPs' position in ts by order
%PIPDist: Dist of each PIP
%PIPimportance: the order of being added to PIP set

if nargin==1
    n = 10; % 10 PIPs as default
end

[~,length]=size(ts);

%tmp=linspace(ts(1),ts(end),length); %the line connecting the first and last points
%Dist=abs(ts-tmp); %Dist: vertical distance
Dist=PDist(ts);
Dist=Dist(2:end-1);
PIPnew=find( Dist==(max(Dist)) )+1;
PIPindex=[1,PIPnew,length]; % the first three PIPs

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

first=1;
middle=PIPnew;
last=length;
waitinglist=[];%column 1 for index in TS; column 2 for Distpos; each row for a possible PIP
while (size(PIPindex)<n)
    if(middle>first)
        %tmp1=linspace(ts(first),ts(middle),(middle-first+1));
        %Dist1=abs(ts(first:middle)-tmp1);%test
        %max(Dist1)%test
        Dist1=PDist(ts(first:middle));
        %max(Dist1)%test
        Dist1=Dist1(2:end-1);
        Distpos1=max(Dist1);
        PIPpos1=find( Dist1==Distpos1 )+first; % PIP possible 1 - index in TS      
    else
        PIPpos1=[];
    end
    
    if(last>middle)
        %tmp2=linspace(ts(middle),ts(last),(last-middle+1));
        %Dist2=abs(ts(middle:last)-tmp2);%test
        %max(Dist2)%test
        Dist2=PDist(ts(middle:last));
        %max(Dist2)%test
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
    %waitinglist(rtmp,2)%test
    %max(waitinglist(:,2))%test
    %waitinglist(rtmp-1,2)%test
    waitinglist=waitinglist(1:rtmp-1,:);
    
    PIPindex=[PIPindex,PIPnew];
    PIPindex=sort(PIPindex);
    PIPnew_index_in_PIPindex=find(PIPindex==(PIPnew));
    first=PIPindex(PIPnew_index_in_PIPindex-1);
    last=PIPindex(PIPnew_index_in_PIPindex+1);
    middle=PIPnew;
    
    %plot for visual test
    pause(1)
    plot(1:length,ts);
    hold on
    plot(PIPindex,ts(PIPindex));
    hold off
    
end

end
