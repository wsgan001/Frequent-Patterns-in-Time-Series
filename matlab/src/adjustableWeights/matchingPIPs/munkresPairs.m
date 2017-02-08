function [assignmentPairs,costPerPair] = munkresPairs(costMat)
%return assignmentPairs instead of assignment

[assignment,cost] = munkres(costMat);
assignmentPairs=[];
for i=1:length(assignment)
    assignmentPairs=[assignmentPairs;i,assignment(i)];
end

costPerPair=cost/sum(assignment~=0)

end

