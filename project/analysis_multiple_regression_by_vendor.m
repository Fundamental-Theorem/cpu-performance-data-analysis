clear; close all; clc;

% Read and filter the data (ventors with more than 10 samples)
T= readtable('CPUperformance.xlsx');
validCodes = groupcounts(T,'Code').Code( ...
              groupcounts(T,'Code').GroupCount > 10);
TFiltered = T(ismember(T.Code, validCodes), :);

% Read ventor names and codes
ventors = unique(TFiltered.VentorName);
codes = unique(TFiltered.Code);

% Convert the filtered table to an array
A = table2array(TFiltered(:, {'Code', 'MYCT', 'MMIN', 'MMAX', 'CACH', 'CHMIN', 'CHMAX', 'PRP'}));

% Create the columns of the stats table
n = length(ventors);
mseLin = zeros(n, 1);
msePCR = zeros(n, 1);
varsPCR = zeros(n, 1);
mseLASSO = zeros(n, 1);
varsLASSO = zeros(n, 1);

% Fill in the columns of the stats table
for i=1:length(codes)
    [linCoeffs, linMSE] = model_linear_by_vendor(A, codes(i));
    [pcrCoeffs, pcrMSE] = model_pcr_by_vendor(A, codes(i));
    [lassoCoeffs, lassoMSE] = model_lasso_by_vendor(A, codes(i));
    mseLin(i) = linMSE;
    msePCR(i) = pcrMSE;
    mseLASSO(i) = lassoMSE;
    varsPCR(i) = length(pcrCoeffs) - 1; % Subtracting the intercept
    varsLASSO(i) = length(pcrCoeffs) - 1; % Subtracting the intercept
end

% Assemble and display the final table
results = table(codes, ventors, mseLin, msePCR, varsPCR, mseLASSO, varsLASSO);
disp(results);

