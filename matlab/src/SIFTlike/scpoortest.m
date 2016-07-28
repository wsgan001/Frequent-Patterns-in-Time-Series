function [ accutmp ] = scpoortest( queryno,topNaccu,ts,rnum )
%% parameter
WinLen=2;%sliding whindow length smooth 20
PIPthr=0.15;

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

%% similarity ranking
%topNaccu=50;%top N match accuracy
query=ts(queryno,:);
query_smooth=ts_smooth(queryno,:);

% For time complexity: n TS, m D for each TS, x for PIP number; n*logn for finally ranking
%%%%%PIPthr_dtw%%%%% - O(n*m + n*x^2 + n*logn)
[ ranking_PIPthr_dtw ] = SimRank_PIPthr_dtw( query_smooth,ts_smooth,PIPthr );

%%%%%PIPthr_dtw2 only x,y%%%%% - O(n*m + n*x^2 + n*logn)
[ ranking_PIPthr_dtw_onlyxy ] = SimRank_PIPthr_dtw_onlyxy( query_smooth,ts_smooth,PIPthr );

%%%%%PIPthr_munkres%%%%% - O(n*m + n*x^3 + n*logn)
[ ranking_PIPthr_munkres ] = SimRank_PIPthr_munkres( query_smooth,ts_smooth,PIPthr );

%%%%%comparison - all-point euclidean%%%%% - O(n*m + n*logn)
[ ranking_euc ] = SimRank_rawdata_Euc( query,ts );

%%%%%comparison - all-point dtw%%%%% - O(n*m^2 + n*logn)
%dtwwl=round(cnum*0.1);
dtwwl=Inf;
[ ranking_rawdata_dtw ] = SimRank_rawdata_dtw( query,ts, dtwwl);

%sc accuracy
accutmp_MVIP=sum((fix((ranking_PIPthr_dtw(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
%disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp_MVIP),'% - PIPthr_dtw']);
accutmp_MVIP_onlyxy=sum((fix((ranking_PIPthr_dtw_onlyxy(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
%disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp_MVIP_onlyxy),'% - PIPthr_dtw_onlyxy']);
accutmp_munkres=sum((fix((ranking_PIPthr_munkres(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1) )/topNaccu*100;%accuracy
%disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp_munkres),'% - PIPthr_munkres']);
accutmp_euc=sum((fix((ranking_euc(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
%disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp_euc),'% - all-point Euclidean']);
accutmp_dtw=sum((fix((ranking_rawdata_dtw(1:topNaccu)-1)/100)+1)==(fix((queryno-1)/100)+1))/topNaccu*100;%accuracy
%disp(['Top',num2str(topNaccu),' accuracy: ',num2str(accutmp_dtw),'% - all-point DTW']);

accutmp=[accutmp_MVIP,accutmp_MVIP_onlyxy,accutmp_munkres,accutmp_euc,accutmp_dtw];

end

