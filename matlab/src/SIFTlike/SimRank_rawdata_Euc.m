function [ ranking ] = SimRank_rawdata_Euc( query,dataset )
%query: query time series
%dataset: time series dataset
%ranking: each row for each row of dataset, value = 1 means most similar

[rnum, ~]=size(dataset);

Dist=zeros(rnum,2);
for i=1:rnum
    Dist(i,1)=norm( query - dataset(i,:) );
    Dist(i,2)=i;
end

Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end

