function [ ranking ] = SimRank_rawdata_SBD( query,dataset )
%query: query time series
%dataset: time series dataset
%ranking: row (time series) indexes in the original dataset. From the most similar to the least similar. Namely the first number is the row index of the most similar time series in original dataset.

addpath('/Users/Steven/Documents/GitHub/k-Shape/Code');
[rnum, ~]=size(dataset);

Dist=zeros(rnum,2);
for i=1:rnum
    [Dist(i,1),~,~] = SBD(query, dataset(i,:));
    Dist(i,2)=i;
end

Dist=sortrows(Dist,1);
ranking=Dist(:,2);

end
