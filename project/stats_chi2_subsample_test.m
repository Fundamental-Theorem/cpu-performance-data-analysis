function p = stats_chi2_subsample_test(data, n, idx)

    % Randomly n observations from the choosen column 
    randIdx = randperm(length(data), n); 
    sample = data(randIdx, idx);
    
    % Extract the full population for the same variable 
    population = data(:, idx);

    bins = 6;
    edges = linspace(min(population), max(population), bins+1);
    sample = sample(~isnan(sample));
    
    % Check if edges are valid
    if any(isnan(edges)) || length(unique(edges)) < 2
        p = NaN;
        return;
    end

    % observed:count how many sample values fall into each bin
    obs = histcounts(sample, edges);
    
    % Count how many popoulation values fall into each bin
    exp = histcounts(population, edges);
    exp = exp * (length(sample) / length(population));
    
    % Avoid division by zero (happens if a bin has exp = 0) 
    exp(exp == 0) = 0.0001;
    
    % Compute the chi-square statistic 
    chi2 = sum((obs - exp).^2 ./ exp);
    df = bins - 1;
    p = 1 - chi2cdf(chi2, df);

end 
