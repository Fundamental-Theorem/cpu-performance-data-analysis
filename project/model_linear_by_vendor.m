function [linCoeffs, linMSE] = model_linear_by_vendor(data, idx)

    % Filter and extract
    rowMask = (data(:, 1) == idx);
    samples = data(rowMask, :);
    X = samples(:, 2:7);
    y = samples(:, 8);
    
    % Shuffle
    rng(1);
    n = size(X, 1);
    randIndices = randperm(n);
    X = X(randIndices, :);
    y = y(randIndices);
    
    % Splitting 65/35
    split = round(0.65 * n);
    XTrain = X(1:split, :);
    XTest  = X(split+1:end, :);
    yTrain = y(1:split);
    yTest  = y(split+1:end);
    
    % Full linear model

    mdl = fitlm(XTrain, yTrain);
    linCoeffs = mdl.Coefficients.Estimate;
    
    % Prediction and error
    yPred = predict(mdl, XTest);
    linMSE = mean((yTest - yPred).^2);

end