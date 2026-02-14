function [paramCI, bootCI] = stats_mean_ci(data, n, idx)

    % Random samppling of the data
    randIdx = randperm(length(data), n);
    samples = data(randIdx, idx);

    % Parametric CI for the mean of the samples
    a = 0.05;
    mu = mean(samples); 
    sigma = std(samples);
    tVal = tinv(1-a/2, n-1);
    paramCI = mu + [-1 1]*(tVal*sigma/sqrt(n));
    
    % Bootstrap CI for the mean of the samples
    bootCI = bootci(1000, @mean, samples);

end