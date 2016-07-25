y=[100,100,45,81;34,100,92,97;49,61,88,83;77,88,85,86;59,58,52,70;60,84,72,84;];
   b=bar(y);
   grid on;
   legend('all-point Euclidean','all-point DTW','MVIP','MVIP(only X, Y features)');
   xlabel('Class');
   ylabel('Accuracy/%');