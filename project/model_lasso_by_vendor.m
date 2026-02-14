function [lassoCoeffs, lassoMSE, lassoIndices] = model_lasso_by_vendor(data, idx)
    
    rowMask = data(:, 1) == idx;
    samples = data(rowMask, :);
    y = samples(:, 8);
    x = samples(:, 2:7);

    % Shuffle using size(x,1) to be safe
    rng(1);
    n = size(x, 1);
    randIndices = randperm(n);
    x = x(randIndices, :);
    y = y(randIndices);

    % Splitting
    split = round(0.65 * n);
    xTrain = x(1:split, :);
    xTest  = x(split+1:end, :);
    yTrain = y(1:split);
    yTest  = y(split+1:end);

    % Standardization (Calculated manually for the Test Set)
    mu = mean(xTrain);
    sigma = std(xTrain);
    xTrainZ = (xTrain - mu) ./ sigma;
    xTestZ  = (xTest - mu) ./ sigma; 

    % LASSO Call (data has already been standardized manually)
    [B, FitInfo] = lasso(xTrainZ, yTrain, 'CV', 4, 'Standardize', false); 

    % Select lambda
    idxLambdaMin = FitInfo.IndexMinMSE;
    betaLASSO = B(:, idxLambdaMin);
    intercept = FitInfo.Intercept(idxLambdaMin);

    % Identify selected predictors
    lassoIndices = find(betaLASSO ~= 0);

    % Predict on test set
    yPred = xTestZ * betaLASSO + intercept;
    
    % Output values
    lassoMSE = mean((yTest - yPred).^2);
    lassoCoeffs = [intercept; betaLASSO];

end