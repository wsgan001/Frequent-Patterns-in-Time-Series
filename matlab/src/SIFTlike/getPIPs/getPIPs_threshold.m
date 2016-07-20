function [ PIPinfo ] = getPIPs_threshold( ts,thr )
%locate perceptually important points (PIPs)
%ts: time series, 1*tslength vector
%thr: normalized threshold.
%MUST USE NormVDist/NormPDist AS DISTANCE METRIC

%The column of PIPinfo from left to right:
%PIPDist: Normalized Dist of each PIP
%PIPimportance: the order of being added to PIP set

if nargin==1
    thr = 0.15; 
end

[~,tslength]=size(ts);
yrange=max(ts)-min(ts);

%PIPindex=[1,tslength]; % the first two PIPs
PIPinfo=[1,0,1;tslength,0,2];
PIPnownum=2;
Dist=NormVDist(ts,yrange);
%Dist=NormPDist(ts,tslength,yrange);
Dist=Dist(2:end-1);
[Distpos,PIPpos]=max(Dist);
PIPpos=PIPpos+1;
waitinglist=[PIPpos,Distpos,1,tslength];%waitinglist=[PIPpos,Distpos,leftPIP,rightPIP];

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
PIPindex=(sort(PIPinfo(:,1)))';
plot(PIPindex,ts(PIPindex));
hold off
%}

%first=1;
%middle=PIPnew;
%last=tslength;

[maxv,maxi]=max(waitinglist(:,2));
while (isempty(waitinglist)==0 && maxv>thr)
    PIPnewinfo=waitinglist(maxi,:);
    PIPnew=PIPnewinfo(1,1);
    PIPnownum=PIPnownum+1;
    PIPinfo=[PIPinfo;PIPnew,maxv,PIPnownum];
    waitinglist(maxi,:)=waitinglist(end,:);%cover maxi row by last row
    waitinglist=waitinglist(1:end-1,:);%delete last row. i.e. delete used maxi
    
    %{
    waitinglist=sortrows(waitinglist,2);%sort by Distpos
    [rtmp,~]=size(waitinglist);
    PIPnew=waitinglist(rtmp,1);
    PIPinfo=[PIPinfo;PIPnew,waitinglist(rtmp,2),length(PIPindex)+1];
    waitinglist=waitinglist(1:rtmp-1,:);
    %}
    
    %PIPindex=(sort(PIPinfo(:,1)))';
    %PIPnew_index_in_PIPindex=find(PIPindex==(PIPnew));
    first=PIPnewinfo(1,3);
    last=PIPnewinfo(1,4);
    middle=PIPnew;
    
    %plot for visual test
    %{
    pause(1)
    plot(1:tslength,ts);
    hold on
    PIPindex=(sort(PIPinfo(:,1)))';
    plot(PIPindex,ts(PIPindex));
    hold off
    %}
    
    if(middle>(first+1))
        Dist1=NormVDist(ts(first:middle),yrange);
        %Dist1=NormPDist(ts(first:middle),tslength,yrange);
        Dist1=Dist1(2:end-1);
        Distpos1=max(Dist1);
        if (Distpos1>0)
            indextmp1=find( Dist1==Distpos1 );%in case of no fluctuation(i.e. linear)
            PIPpos1=indextmp1(1)+first; % PIP possible 1 - index in TS
            waitinglist=[waitinglist;PIPpos1,Distpos1,first,middle];
        end
    end
    
    if(last>(middle+1))
        Dist2=NormVDist(ts(middle:last),yrange);
        %Dist2=NormPDist(ts(middle:last),tslength,yrange);
        Dist2=Dist2(2:end-1);
        Distpos2=max(Dist2);
        if (Distpos2>0)
            indextmp2=find( Dist2==Distpos2 );
            PIPpos2=indextmp2(1)+middle;
            waitinglist=[waitinglist;PIPpos2,Distpos2,middle,last];
        end
    end
    [maxv,maxi]=max(waitinglist(:,2));
end

PIPinfo=sortrows(PIPinfo,1);

end
