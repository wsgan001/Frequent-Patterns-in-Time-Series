clear;
clc;

%load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control(1,:);
n=20;

[~,length]=size(ts);

tmp=linspace(ts(1),ts(end),length); %the line connecting the first and last points
VD=abs(ts-tmp); %VD: vertical distance
VD=VD(2:end-1);
PIPnew=find( VD==(max(VD)) )+1;
PIPindex=[1,PIPnew,length]; % the first three PIPs

plot(1:60,ts);
hold on
plot(PIPindex,ts(PIPindex));
hold off

%{
pseudo code:
the new PIP and its two adjacent PIPs as middle, first and last of the
segment.
locate two possible PIPs from the two subsegment divided by middle
add these two possible PIPs into waiting list
select the points from the waiting list with maximum VD and add it to PIPs
as new PIP.
REPEAT UNTIL GETTING N PIPS
%}
first=1;
middle=PIPnew;
last=length;
waitinglist=[];%column 1 for index in TS; column 2 for VDpos; each row for a possible PIP
while (size(PIPindex)<n)
    if(middle>first)
        tmp1=linspace(ts(first),ts(middle),(middle-first+1));
        VD1=abs(ts(first:middle)-tmp1);
        VD1=VD1(2:end-1);
        VDpos1=max(VD1);
        PIPpos1=find( VD1==VDpos1 )+first; % PIP possible 1 - index in TS      
    else
        PIPpos1=[];
    end
    
    if(last>middle)
        tmp2=linspace(ts(middle),ts(last),(last-middle+1));
        VD2=abs(ts(middle:last)-tmp2);
        VD2=VD2(2:end-1);
        VDpos2=max(VD2);
        PIPpos2=find( VD2==VDpos2 )+middle;
    else
        PIPpos2=[];
    end
    
    waitinglist=[waitinglist;PIPpos1,VDpos1;PIPpos2,VDpos2];
    waitinglist=sortrows(waitinglist,2);%sort by VDpos
    [rtmp,~]=size(waitinglist);
    PIPnew=waitinglist(rtmp,1);
    waitinglist=waitinglist(1:rtmp-1,:);
    
    PIPindex=[PIPindex,PIPnew];
    PIPindex=sort(PIPindex);
    PIPnew_index_in_PIPindex=find(PIPindex==(PIPnew));
    first=PIPindex(PIPnew_index_in_PIPindex-1);
    last=PIPindex(PIPnew_index_in_PIPindex+1);
    middle=PIPnew;
    
    pause(1)
    plot(1:60,ts);
    hold on
    plot(PIPindex,ts(PIPindex));
    hold off
end
