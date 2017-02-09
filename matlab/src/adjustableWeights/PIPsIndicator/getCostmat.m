function [ Costmat ] = getCostmat( rIndicator,cIndicator )
%rIndicator(i,:) stands for row i of Costmat
%cIndicator(j,:) stands for column j of Costmat

[rnum,dimension]=size(rIndicator);
[cnum,~]=size(cIndicator);
Costmat=zeros(rnum,cnum);

for i=1:rnum
    for j=1:cnum
        %Costmat(i,j)=norm(rIndicator(i,:)-cIndicator(j,:));%Euclidean distance
        Costmat(i,j) = (norm(rIndicator(i,1:(dimension-1))-cIndicator(j,1:(dimension-1)))) * (rIndicator(i,end) + cIndicator(j,end)) / 2;% * average weights
    end
end

end
