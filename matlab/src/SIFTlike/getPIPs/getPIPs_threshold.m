function [ PIPinfo ] = getPIPs_threshold( ts,thr )
%locate perceptually important points (PIPs)
%ts: time series, 1*tslength vector
%thr: normalized threshold.
%MUST USE NormVDist/NormPDist AS DISTANCE METRIC

%The column of PIPinfo from left to right:
%PIPDist: Normalized Dist of each PIP
%PIPimportance: the order of being added to PIP set

%% initializaiton
if nargin==1
    thr = 0.15; 
end

[~,tslength]=size(ts);

%PIPindex=[1,tslength]; % the first two PIPs
PIPinfo=zeros(tslength,3);
%PIPinfo=zeros(60,3);
PIPinfo(1:2,:)=[1,0,1;tslength,0,2];
PIPnownum=2;
Dist=NormVDist(ts);
%Dist=NormPDist(ts,tslength);
Dist=Dist(2:end-1);
[Distpos,PIPpos]=max(Dist);
PIPpos=PIPpos+1;
wllength=round(tslength);
%wllength=50;
waitinglist=zeros(wllength,4)-1;
waitinglist(1,:)=[PIPpos,Distpos,1,tslength];%waitinglist=[PIPpos,Distpos,leftPIP,rightPIP];
FindFromHere=2;
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
%% find PIPs
%tic
[maxv,maxi]=max(waitinglist(:,2));
while (maxv>thr)
    PIPnewinfo=waitinglist(maxi,:);
    PIPnew=PIPnewinfo(1,1);
    PIPnownum=PIPnownum+1;
    PIPinfo(PIPnownum,:)=[PIPnew,maxv,PIPnownum];
    waitinglist(maxi,:)=[-1,-1,-1,-1];%delete used maxi
    
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
        Dist1=NormVDist(ts(first:middle));
        %Dist1=NormPDist(ts(first:middle),tslength);
        %Dist1=Dist1(2:end-1);
        Distpos1=max(Dist1(2:end-1));
        if (Distpos1>thr)
            indextmp1=2;
            while(Dist1(indextmp1)~=Distpos1)
                indextmp1=indextmp1+1;
            end
            PIPpos1=indextmp1+first-1; % PIP possible 1 - index in TS
            %positivePIPpos1=PIPpos1-1
            %indextmp1=find( Dist1(2:end-1)==Distpos1 );%in case of no fluctuation(i.e. linear)
            %PIPpos1=indextmp1(1)+first; % PIP possible 1 - index in TS
            while(waitinglist(FindFromHere,1)~=-1)% maybe dead loop, but just maybe
                FindFromHere=mod( (FindFromHere+1),wllength);
            end
            waitinglist(FindFromHere,:)=[PIPpos1,Distpos1,first,middle];
            FindFromHere=mod( (FindFromHere+1),wllength);
        end
    end
    
    if(last>(middle+1))
        Dist2=NormVDist(ts(middle:last));
        %Dist2=NormPDist(ts(middle:last),tslength);
        %Dist2=Dist2(2:end-1);
        Distpos2=max(Dist2(2:end-1));
        if (Distpos2>thr)
            indextmp2=2;
            while(Dist2(indextmp2)~=Distpos2)
                indextmp2=indextmp2+1;
            end
            PIPpos2=indextmp2+middle-1;
            %negativePIPpos2=-PIPpos2+1
            %indextmp2=find( Dist2(2:end-1)==Distpos2 );
            %PIPpos2=indextmp2(1)+middle;
            while(waitinglist(FindFromHere,1)~=-1)% maybe dead loop, but just maybe
                FindFromHere=mod( (FindFromHere+1),wllength);
            end
            waitinglist(FindFromHere,:)=[PIPpos2,Distpos2,middle,last];
            FindFromHere=mod( (FindFromHere+1),wllength);
        end
    end
    [maxv,maxi]=max(waitinglist(:,2));
end
%toc
%% return results
PIPinfo=PIPinfo(1:PIPnownum,:);
PIPinfo=sortrows(PIPinfo,1);
end
