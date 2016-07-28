clear;
topNaccu=100;

%sc dataset
load('../../data/gt_sc.mat');
load('../../data/synthetic_control.mat');
ts = synthetic_control;
[rnum,~]=size(ts);

accutmp=zeros(600,5);

for queryno=1:600
    accutmp(queryno,:)=scpoortest( queryno,topNaccu,ts,rnum );
end

accu=zeros(6,5);
for i=1:6
    accu(i,:)=mean(accutmp(1+(i-1)*100:i*100,:));
end

