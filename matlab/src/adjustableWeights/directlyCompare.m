function [ distance ] = directlyCompare( similarity1, similarity2 )
% normalized compare similarity levels viz by viz
% sum of similarity differences / maximum similarity differences
% output range is from 0 to 1
% 0 is perfectly matched, 1 is worst matched

differences = abs(similarity1 - similarity2);
maxDiff = 3 * size(similarity1,1);
distance = sum(differences) / maxDiff;

end