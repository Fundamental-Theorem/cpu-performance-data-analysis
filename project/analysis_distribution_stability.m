clear; close all; clc;

M = 100;
n = 40;
alpha = 0.05;

data = readmatrix('CPUperformance.xlsx');
indices = [3, 5, 7];
names = ["MYCT", "MMAX", "CHMIN"];

% Original Data 
fprintf('Original scale:\n');
for i = 1:length(indices)
    acceptCount = 0;
    for k = 1:M
        p = stats_chi2_subsample_test(data, n, indices(i));
        if p > alpha
            acceptCount = acceptCount + 1;
        end
    end
    acceptanceRate = 100 * (acceptCount / M);
    fprintf('%s: %.2f%%\n', names(i), acceptanceRate);
end


% Log-transformed Data
fprintf('\nLog-transformed scale:\n');
logData = log(data);
for i = 1:length(indices)
    acceptCount = 0;
    for k = 1:M
        p = stats_chi2_subsample_test(logData, n, indices(i));
        if p > alpha
            acceptCount = acceptCount + 1;
        end
    end
    acceptanceRate = 100 * (acceptCount / M);
    fprintf('%s (log): %.2f%%\n', names(i), acceptanceRate);
end
