function [pcrCoeffs, pcrMSE] = model_pcr_by_vendor(data, idx)

    rowMask = data(:, 1) == idx;
    samples = data(rowMask, :);
    y = samples(:, 8);
    x = samples(:, (2:7));

    % Shuffle x and y
    rng(1);
    randIndices = randperm(length(x));
    x = x(randIndices, :);
    y = y(randIndices);

    % Splitting the training and testing data on 65%-35%
    n = size(x, 1);
    split = round(0.65*n);
    xTrain = x((1:split), :);
    xTest = x(split+1:n, :);
    yTrain = y((1:split));
    yTest = y(split+1:n);

    % Standardize the X data using the training statistics
    mu = mean(xTrain);
    sigma = std(xTrain);
    xTrainZ = (xTrain - mu)./sigma;
    xTestZ = (xTest - mu)./sigma; 

    % PCA on training data, choose k principal components
    [coeff, score, latent, ~, explained] = pca(xTrainZ); 
    cumExp = cumsum(explained);
    k = find(cumExp >= 95, 1); % Keeping 95% variance

    % Regression on principal components
    tTrain = score(:,1:k);
    betaPCR = [ones(size(tTrain, 1), 1) tTrain] \ yTrain;

    % Project test data into PC space
    tTest = xTestZ * coeff(:,1:k);
    tTest = [ones(size(tTest,1),1), tTest];
    yPred = tTest * betaPCR;

    pcrCoeffs = betaPCR;
    pcrMSE = mean((yTest - yPred).^2);

end