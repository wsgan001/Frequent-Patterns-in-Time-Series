%Revised DTW

% Original author's information:
%{
% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

% dynamic time warping of two signals
%}

function [ assignmentPairs,costPerPair ] = dtwMatch( costMat,w )
% dtw Matching
% w - slide window length
% assignmentPairs is assigned to each row in order and the value means this row
% match No. value column. If value = 0, that means no matched points.

[ns,nt]=size(costMat);
path=zeros(ns,nt,2);%record the last adjacent position in the matric along the dtw path

if nargin<2
    w=Inf;
end

w=max(w, abs(ns-nt)); % adapt window size

%% initialization
D=zeros(ns+1,nt+1)+Inf; % cache matrix
D(1,1)=0;
path(1,1,:)=[0,0];

%% begin dynamic programming
for i=1:ns
    for j=max(i-w,1):min(i+w,nt)
        oost=costMat(i,j);
        lastoost=min( [D(i,j+1), D(i+1,j), D(i,j)] );
        D(i+1,j+1)=oost+lastoost;
        
        if(lastoost==D(i,j+1))
            path(i,j,:)=[i-1,j];
        elseif(lastoost==D(i+1,j))
            path(i,j,:)=[i,j-1];
        else
            path(i,j,:)=[i-1,j-1];
        end
    end
end

%% Return results
pathtmp=zeros(1,2);
pathtmp(1)=path(ns,nt,1);
pathtmp(2)=path(ns,nt,2);
assignmentPairs=[ns,nt];
while(sum(pathtmp)~=0)
    assignmentPairs=[assignmentPairs;pathtmp(1),pathtmp(2)];
    tmp1=pathtmp(1);
    tmp2=pathtmp(2);
    pathtmp(1)=path(tmp1,tmp2,1);
    pathtmp(2)=path(tmp1,tmp2,2);
end

costPerPair=D(ns+1,nt+1)/size(assignmentPairs,1);

end

