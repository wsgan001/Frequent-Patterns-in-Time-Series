accuracy = zeros(1,6);

for queryIndex = 1:20
    queryIndex
    for userIndex = 1:8
        [a,b,c,d,e,f] = debugModel_TrainPlusTest( queryIndex, userIndex, fit_f, fit_cv_f, fit_cv_d, fit_cv_k, fit_cv_m, fit_cv_o );
        tmp = [a,b,c,d,e,f];
        figure
        bar(tmp)
        set(gca,'XTickLabel',{'f','cv_f','cv_d','cv_k','cv_m','cv_o'})
        title(['query-',num2str(queryIndex),'; user-', num2str(userIndex)]);
        accuracy = accuracy + tmp;
    end
end

accuracy = accuracy / 160;

fprintf('f: %1.4f\n', accuracy(1))
fprintf('cv_f: %1.4f\n', accuracy(2))
fprintf('cv_d: %1.4f\n', accuracy(3))
fprintf('cv_k: %1.4f\n', accuracy(4))
fprintf('cv_m: %1.4f\n', accuracy(5))
fprintf('cv_o: %1.4f\n', accuracy(6))