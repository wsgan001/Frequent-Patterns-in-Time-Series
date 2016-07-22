function [ Costmat ] = getCostmat( rIndicator,cIndicator )
%rIndicator(i,:) stands for row i of Costmat
%cIndicator(j,:) stands for column j of Costmat

[rnum,~]=size(rIndicator);
[cnum,~]=size(cIndicator);
Costmat=zeros(rnum,cnum);

for i=1:rnum
    for j=1:cnum
        %Costmat(i,j)=sum(abs(rIndicator(i,:)-cIndicator(j,:)));%Manhattan distance, i.e. L-1 norm
        Costmat(i,j)=norm(rIndicator(i,:)-cIndicator(j,:));%Euclidean distance
    end
end

end

