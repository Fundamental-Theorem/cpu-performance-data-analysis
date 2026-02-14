clear; close all; clc;

% Parameters
n = 50;          % Subsample size
rng(1);          % Reproducibility

% Load data
data = readmatrix('CPUperformance.xlsx');
myct = data(:,3);
prp  = data(:,9);

% Create subsample
randIdx = randperm(length(myct), n);
myctSub = myct(randIdx);
prpSub  = prp(randIdx);

% Define modeling function
fitModels = @(x,y) struct( ...
    'Linear',     fitlm(x,y), ...
    'LogLinear',  fitlm(x, log(y)), ...
    'PowerLaw',   fitlm(log(x), log(y)), ...
    'LogX',       fitlm(log(x), y), ...
    'InverseX',   fitlm(1./x, y) );

% Fit models
modelsSub  = fitModels(myctSub, prpSub);
modelsFull = fitModels(myct, prp);


% FIGURE 1: Residual Diagnostics
figure;
modelNames = fieldnames(modelsSub);
colors = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30"];
for i = 1:length(modelNames)

    subplot(2,5,i)
    mdl = modelsSub.(modelNames{i});
    scatter(mdl.Fitted, mdl.Residuals.Standardized, 'filled', 'MarkerFaceColor', colors(i));
    title(sprintf('Subsample - %s\nR^2=%.3f', ...
        modelNames{i}, mdl.Rsquared.Adjusted));

    subplot(2,5,i+5)
    mdlFull = modelsFull.(modelNames{i});
    scatter(mdlFull.Fitted, mdlFull.Residuals.Standardized, 'filled', 'MarkerFaceColor', colors(i));
    title(sprintf('Full Data - %s\nR^2=%.3f', ...
        modelNames{i}, mdlFull.Rsquared.Adjusted));
end

sgtitle('Standardized Residual Diagnostics Across Models');

% ===============================
% FIGURE 2: Fitted Curve Comparison
% ===============================

figure;

kSub  = linspace(min(myctSub), max(myctSub), 400);
kFull = linspace(min(myct), max(myct), 400);

% Auxiliary function for fitted curves
computeCurves = @(mdlStruct, k) struct( ...
    'Linear',     mdlStruct.Linear.Coefficients.Estimate(1) + ...
                  mdlStruct.Linear.Coefficients.Estimate(2) * k, ...
    'LogLinear',  exp(mdlStruct.LogLinear.Coefficients.Estimate(1) + ...
                      mdlStruct.LogLinear.Coefficients.Estimate(2) * k), ...
    'PowerLaw',   exp(mdlStruct.PowerLaw.Coefficients.Estimate(1)) .* ...
                  k.^mdlStruct.PowerLaw.Coefficients.Estimate(2), ...
    'LogX',       mdlStruct.LogX.Coefficients.Estimate(1) + ...
                  mdlStruct.LogX.Coefficients.Estimate(2) * log(k), ...
    'InverseX',   mdlStruct.InverseX.Coefficients.Estimate(1) + ...
                  mdlStruct.InverseX.Coefficients.Estimate(2) ./ k );

curvesSub  = computeCurves(modelsSub,  kSub);
curvesFull = computeCurves(modelsFull, kFull);

% --- Subsample ---
subplot(2,1,1)
scatter(myctSub, prpSub, 40, 'filled'); hold on;
fields = fieldnames(curvesSub);
colors = lines(length(fields));

for i = 1:length(fields)
    plot(kSub, curvesSub.(fields{i}), 'Color', colors(i,:));
end

title('Subsample Model Fits');
xlabel('MYCT');
ylabel('PRP');
legend(['Data'; fields], 'Location','best');
grid on;
hold off;

% --- Full Data ---
subplot(2,1,2)
scatter(myct, prp, 20, 'filled'); hold on;

for i = 1:length(fields)
    plot(kFull, curvesFull.(fields{i}), 'Color', colors(i,:));
end

title('Full Dataset Model Fits');
xlabel('MYCT');
ylabel('PRP');
legend(['Data'; fields], 'Location','best');
grid on;
hold off;