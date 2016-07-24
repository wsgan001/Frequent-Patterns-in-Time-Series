%clustering test

clear;
%clc;

%% parameter
WinLen=10;%sliding whindow length
PIPthr=0.15;
UCRdataset='50words';%not so good 50 classes, 905 TS, 270 D
%UCRdataset='yoga';%good 2 classes, 3300 TS, 426 D
%UCRdataset='wafer';%good 2 classes, 7174 TS, 152 D
%UCRdataset='HandOutlines';% 2 classes, 1370 TS, 2709 D
%UCRdataset='uWaveGestureLibrary_X'; % not so good 8 classes, 4478 TS, 315 D
%UCRdataset='synthetic_control'; %6 classes, 600 TS, 60 D

%% similarity ranking parameters
queryno=401;
TopN2show=[3,5,20,50,100];

%% load dataset
%sc dataset
%{
load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control;
gt = gt_sc;
[rnum,cnum]=size(ts);
%}

%UCR dataset

TEST = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TEST']);
TRAIN = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,UCRdataset,'/',UCRdataset,'_TRAIN']);

dataall = [TEST;TRAIN];
[~, cnum] = size(dataall);
gt = dataall(:,1);
ts = dataall(:,2:cnum);
[rnum,~]=size(ts);

%{
%plot to show a global picture
figure
hold on
for i=1:rnum
    plot(ts(i,:))
end
title('all raw data')
hold off
%}

%% preprocessing
%normalization/scaling
ts_norm = ts;
for i=1:rnum
    ts_norm(i,:)=(ts(i,:)-mean(ts(i,:)))/ std(ts(i,:));
    %ts_norm(i,:)=ts(i,:)/mean(ts(i,:));
end

%smoothing
%WinLen=6;%sliding whindow length
wts = [1/(2*WinLen);repmat(1/WinLen,WinLen-1,1);1/(2*WinLen)];
for i=1:rnum
    ts_smooth(i,:) = conv(ts_norm(i,:),wts,'valid');   
end
%[~,cnum_smooth]=size(ts_smooth);

%% clustering
%{
[ result,Dist,c ] = hc_PIPthr_dtw( ts_smooth,gt,PIPthr );
result
%}

%% similarity ranking
query=ts_smooth(queryno,:);

% For time complexity: n TS, m D for each TS, x for PIP number; n*logn for finally ranking
%%%%%PIPthr_dtw%%%%% - O(n*m + n*x^2 + n*logn)
disp(' ')
disp('Run time of PIPthr_dtw:')
tic
[ ranking_PIPthr_dtw ] = SimRank_PIPthr_dtw( query,ts_smooth,PIPthr );
toc

%%%%%PIPthr_munkres%%%%% - O(n*m + n*x^3 + n*logn)
disp(' ')
disp('Run time of PIPthr_munkres:')
tic
[ ranking_PIPthr_munkres ] = SimRank_PIPthr_munkres( query,ts_smooth,PIPthr );
toc

%%%%%comparison - smoothing data based euclidean%%%%% - O(n*m + n*logn)
disp(' ')
disp('Run time of euclidean:')
tic
[ ranking_euc ] = SimRank_rawdata_Euc( query,ts );
toc

%%%%%comparison - all points based dtw%%%%% - O(n*m^2 + n*logn)

disp(' ')
disp('Run time of all points based dtw:')
%dtwwl=round(cnum*0.1);
dtwwl=Inf;
tic
[ ranking_rawdata_dtw ] = SimRank_rawdata_dtw( query,ts, dtwwl);
toc

%visual results(after smoothing)
figure
hold on
for i=1:rnum
    plot(ts(i,:))
end
title('all smoothed data')
hold off
for topn=TopN2show
    if (topn>rnum)
        topn=rnum;
    end
    
    figure
    %plot to show a global picture
    subplot(221)
    hold on
    for i=2:topn
        plot(ts(ranking_PIPthr_dtw(i),:));
    end
    plot(ts(ranking_PIPthr_dtw(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - PIPthr\_dtw'])
    
    subplot(222)
    hold on
    for i=2:topn
        plot(ts(ranking_PIPthr_munkres(i),:));
    end
    plot(st(ranking_PIPthr_munkres(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - PIPthr\_munkres'])
    
    subplot(223)
    hold on
    for i=2:topn
        plot(ts(ranking_euc(i),:));
    end
    plot(ts(ranking_euc(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - all points based Euclidean'])
    
    subplot(224)
    hold on
    for i=2:topn
        plot(ts(ranking_rawdata_dtw(i),:));
    end
    plot(ts(ranking_rawdata_dtw(1),:),':or','MarkerFaceColor','r')
    hold off
    title(['smoothing top ',num2str(topn),' - all points based dtw'])
    
end
