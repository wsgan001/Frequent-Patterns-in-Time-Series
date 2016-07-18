function [ result, accuracy, gt, ts ] = DatasetTest( dataname )
%quick dataset test

TEST = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,dataname,'/',dataname,'_TEST']);
TRAIN = load([...
    '/Users/Steven/Academic/SR@Aditya/Zenvisage/datasets/UCR_TS_Archive_2015/'...
    ,dataname,'/',dataname,'_TRAIN']);

dataall = [TEST;TRAIN];
[rnum, cnum] = size(dataall);
gt = dataall(:,1);
ts = dataall(:,2:cnum);

kc = max(gt)-min(gt)+1;

[ result, accuracy ] = kmeans_fv( ts, gt, kc );

index = 1;
%flag = 0;
%test=1;
for i=min(gt):max(gt)
    figure;
    hold on
    for j=1:10
        while (gt(index)~=i)
            index=index+1;
            %if (index == rnum)
            %    flag=1;
            %end
            %index
            %gt(index)
            %max(gt)
            %(flag==0 && gt(index)~=i)
            %test=;
            %size(gt)
            %index
        end
        %if (gt(index)==i)
            %i
            %index
            plot(ts(index,:))
            index = index + 1;
        %end
    end
    %flag=0;
    title(['Type ',num2str(i)]);
    hold off
    index = 1;
end

end

