function [ Dist ] = DTWone2set( query, dataset )

[rnum, ~]=size(dataset);

Dist=zeros(rnum,1);
for i=1:rnum
    Dist(i,1)=dtw(query,dataset(i,:));
end

end

