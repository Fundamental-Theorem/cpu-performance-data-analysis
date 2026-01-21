# CPU Performance Analysis: Statistical Inference and Predictive Modeling

## Project Overview

This project presents an applied data analysis study focused on understanding, modeling, and interpreting CPU performance using statistical inference and regression techniques. The analysis is based on a classic real-world dataset describing computer processor characteristics and their observed performance.

Rather than treating the dataset as a purely predictive benchmark, the project emphasizes **statistical reasoning**, **sampling variability**, **model diagnostics**, and **methodological decision-making**. Through a sequence of focused analytical investigations, the project explores how conclusions about performance, relationships between variables, and model reliability depend on assumptions, sample size, and analytical choices.

The work is structured around **six core analytical questions**, each motivated by a realistic data science scenario and designed to demonstrate meaningful understanding of data analysis beyond mechanical computation.

---

## Dataset Description

### Data Source

The dataset originates from an influential study in machine learning and performance prediction:

> **Kibler, D. & Aha, D. (1988).**  
> *Instance-Based Prediction of Real-Valued Attributes.*  
> Proceedings of the Canadian Conference on Artificial Intelligence (CSCSI).

It has since been widely used in both statistical analysis and machine learning contexts to study the relationship between hardware characteristics and CPU performance.

---

### Dataset Structure

The dataset consists of **209 observations**, each corresponding to a computer processor. Each observation includes a manufacturer identifier, a set of hardware-related indicators, and a published performance measure.

| Column | Variable Name | Description |
|------:|---------------|-------------|
| 1 | `VendorCode` | Manufacturer code (integer values from 1 to 12) |
| 2 | `VendorName` | Name of the manufacturer |
| 3 | `MYCT` | Machine cycle time (in nanoseconds) |
| 4 | `MMIN` | Minimum main memory (in kilobytes) |
| 5 | `MMAX` | Maximum main memory (in kilobytes) |
| 6 | `CACH` | Cache memory (in kilobytes) |
| 7 | `CHMIN` | Minimum number of channels |
| 8 | `CHMAX` | Maximum number of channels |
| 9 | `PRP` | Published Relative Performance (CPU performance metric) |

The primary response variable throughout the project is **PRP**, while the remaining indicators are treated as explanatory variables depending on the analysis context.

---

## Analytical Questions

### 1. Distributional Stability and Transformations

Small samples are often used to draw conclusions about large systems, but their empirical distributions may not reflect the population accurately.

This analysis investigates whether the distribution of selected CPU indicators observed in small random samples is consistent with the distribution observed in the full dataset. Repeated subsampling is used to assess distributional stability, and the suitability of the normal distribution is examined.

The analysis is repeated after applying a logarithmic transformation to evaluate whether transformations improve agreement with theoretical assumptions and reduce sampling-induced distortions.

---

### 2. Reliability of Confidence Intervals in Practice

Confidence intervals are a fundamental tool in performance estimation, yet their practical reliability depends on data characteristics and methodological assumptions.

Using repeated small-sample experiments, this analysis compares **parametric confidence intervals** and **bootstrap-based confidence intervals** for the mean of selected CPU indicators. The empirical coverage probability of each method is evaluated by examining how often the true dataset mean falls within the estimated intervals.

The procedure is repeated after logarithmic transformation of the data, and results are interpreted in light of theoretical expectations and real-world data limitations.

---

### 3. Comparing Manufacturer Performance Under Uncertainty

Performance comparisons between manufacturers are common in both industry benchmarking and research, but such comparisons are sensitive to sample size and distributional assumptions.

This analysis compares average CPU performance between randomly selected pairs of manufacturers. For each comparison, distributional diagnostics guide the choice between parametric and resampling-based inference methods.

By repeating this process across multiple manufacturer pairs, the analysis assesses whether observed performance differences are systematic or largely driven by sampling variability.

---

### 4. Correlation Estimation and Testing Philosophy

Understanding relationships between hardware characteristics is essential, but correlation estimates derived from small samples can be unstable and misleading.

This analysis examines the relationship between selected CPU indicators by constructing confidence intervals for correlation coefficients using parametric transformations. The stability and reliability of these estimates are evaluated across repeated samples.

In parallel, parametric hypothesis testing is compared with randomization-based testing to highlight philosophical and practical differences between inferential approaches. The impact of logarithmic transformations on both estimation and testing conclusions is also assessed.

---

### 5. Choosing an Appropriate Regression Model

Predicting CPU performance from hardware characteristics requires balancing model simplicity, interpretability, and predictive adequacy.

Using a subset of the data, multiple regression models are explored to describe the relationship between processor cycle time and performance. Model selection is guided by residual diagnostics, goodness-of-fit measures, and model assumptions.

The selected model is then compared with one fitted on the full dataset to evaluate generalizability and to discuss the risks of overfitting and underfitting in data-driven modeling.

---

### 6. Model Selection and Generalization Across Manufacturers

High-dimensional predictors and limited data can challenge traditional modeling approaches, particularly when performance varies across manufacturers.

For manufacturers with sufficient observations, this analysis compares multiple linear regression strategies, including full models and dimension-reduction techniques such as Principal Component Regression (PCR) and LASSO. Model performance is evaluated using out-of-sample prediction error rather than in-sample fit.

The analysis investigates whether different modeling approaches favor different predictors and discusses implications for robustness, interpretability, and generalization in real-world performance modeling.

---

## Project Focus

This project is intentionally centered on **statistical reasoning**, **inferential reliability**, and **model evaluation**, rather than purely predictive accuracy. The goal is to demonstrate how thoughtful analytical choices influence conclusions drawn from real-world data.

---

