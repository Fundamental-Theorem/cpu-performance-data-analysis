clear; close all; clc;

% Parameters
M = 100;      % Number of repeated subsampling experiments
n = 20;       % Subsample size
rng(1);       % Reproducibility

% Load data
data = readmatrix('CPUperformance.xlsx');
mmax  = data(:,5);
chmin = data(:,7);

% Run experiment for both scales
scales = {"Original", "Log-Transformed"};
figure;
for s = 1:length(scales)
    if s == 1
        x = mmax;
        y = chmin;
    else
        x = log1p(mmax);
        y = log1p(chmin);
    end

    % Full-sample correlation
    R = corrcoef(x, y);
    rTrue = R(1,2);

    % Visualization
    subplot(1, 2, s);
    scatter(x, y, 'filled');
    title(sprintf('%s Scale: r = %.3f', scales{s}, rTrue));
    xlabel('MMAX');
    ylabel('CHMIN');

    % Repeated CI estimation
    coverageCount = 0;

    for i = 1:M
        corrCI = stats_fisher_corr_ci(n, x, y);

        if corrCI(1) < rTrue && rTrue < corrCI(2)
            coverageCount = coverageCount + 1;
        end
    end

    % Display results
    coverageRate = 100 * coverageCount / M;

    fprintf('\n=== %s Scale ===\n', scales{s});
    fprintf('True correlation: %.4f\n', rTrue);
    fprintf('CI coverage rate: %.2f%%\n', coverageRate);
    fprintf('---------------------------------------------\n');
end