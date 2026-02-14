clear; close all; clc;

% Parameters
M = 100;           % Number of repeated subsampling experiments
n = 20;            % Subsample size
rng(1);            % Reproducibility

% Load data
dataRaw = readmatrix('CPUperformance.xlsx');
indices = [3, 5, 7];              % MYCT, MMAX, CHMIN
names   = ["MYCT", "MMAX", "CHMIN"];

% Run experiment for both scales
scales = {"Original", "Log-Transformed"};
for s = 1:length(scales)
    if s == 1
        data = dataRaw;
    else
        % log1p used because CHMIN contains zeros
        data = log1p(dataRaw);
    end
    fprintf('\n=== %s Scale ===\n\n', scales{s});
    for i = 1:length(indices)
        paramCI = zeros(M, 2);
        bootCI  = zeros(M, 2);
        paramCoverage = 0;
        bootCoverage  = 0;
        trueMean = mean(data(:, indices(i)));

        % Repeated subsampling experiment
        for j = 1:M
            [paramCI(j,:), bootCI(j,:)] = ...
                stats_mean_ci(data, n, indices(i));
            if paramCI(j,1) < trueMean && trueMean < paramCI(j,2)
                paramCoverage = paramCoverage + 1;
            end
            if bootCI(j,1) < trueMean && trueMean < bootCI(j,2)
                bootCoverage = bootCoverage + 1;
            end
        end

        % Display results
        fprintf('%s:\n', names(i));
        fprintf('  Parametric CI coverage: %.2f%%\n', 100*paramCoverage/M);
        fprintf('  Bootstrap CI coverage : %.2f%%\n\n', 100*bootCoverage/M);

        % Visualization
        figure;
        subplot(1,2,1)
        histogram(paramCI(:,1), 20);
        hold on;
        histogram(paramCI(:,2), 20);
        title(sprintf('%s - Parametric CI Bounds (%s)', names(i), scales{s}));
        legend('Lower Bound','Upper Bound');
        hold off;

        subplot(1,2,2)
        histogram(bootCI(:,1), 20);
        hold on;
        histogram(bootCI(:,2), 20);
        title(sprintf('%s - Bootstrap CI Bounds (%s)', names(i), scales{s}));
        legend('Lower Bound','Upper Bound');
        hold off;
    end
end