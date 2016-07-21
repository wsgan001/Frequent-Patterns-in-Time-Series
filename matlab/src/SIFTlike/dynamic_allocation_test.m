% test

clc;

num=10000;

tic
a=zeros(10000,1);
for i=1:num
    a(i,1)=1;
end
toc

tic
b=[];
for i=1:num
    b=[b;1];
end
toc