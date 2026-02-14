function corr_ci = stats_fisher_corr_ci(n, data1, data2)

    % Random sampling pairs of the data
    rand_idx = randperm(length(data1), n);
    samples1 = data1(rand_idx);
    samples2 = data2(rand_idx);

    % Calculate the correlation coefficient and its confidence interval
    [~, ~, rl, ru] = corrcoef(samples1, samples2); % corrcoef uses Fisher's transformation

    % Extract the output
    corr_ci = [rl(1, 2) ru(1, 2)];

end