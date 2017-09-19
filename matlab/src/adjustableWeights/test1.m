data = [];

for queryIndex = 1:20
    queryIndex
    for userIndex = 1:8
        [a,b,c,d,e,f,g] = debugModel_TrainPlusTest( queryIndex, userIndex, fit_f, fit_cv_f, fit_cv_d, fit_cv_k, fit_cv_m, fit_cv_o );
        data = [data;[a,b,c,d,e,f,g]];
    end
end

csvwrite('data.csv',data);