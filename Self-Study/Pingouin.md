# Statistics Library Pingouin
- Pingouin site url: https://pingouin-stats.org/build/html/api.html
- 통계 분석 라이브러리인 핑구인 펑션 개념 정리

# Table of Contents
- Functions
    - ANOVA and T-test
    - Bayesian
    - Circular
    - Contingency
    - Correlation and regression
    - Distribution
    - Effect sizes
    - Multiple comparisons and post-hoc tests
    - Multivariate tests
    - Non-parametric

- Others
    - Plotting
    - Power analysis
    - Reliability and consistency

# Functions

## ANOVA and T-test
```
ANOVA (Analysis of Variance):
그룹 간의 평균 차이를 비교하는 통계적 방법으로, 그룹 간 분산과 그룹 내 분산을 고려합니다.
그룹 간 차이의 통계적 유의성을 평가하는 데 사용됩니다.

T-test: 두 그룹 간 평균 차이를 평가하는 통계적 방법으로,
두 그룹의 평균이 통계적으로 유의미한 차이가 있는지를 확인하는 데 사용됩니다.
```

### ANOVA and T-test Statistical analysis
```
▣ anova([data, dv, between, ss_type, ...]) One-way and N-way ANOVA.

    # ANOVA 분석 개요
    한 개 또는 여러 개의 요인 간에 평균값의 차이를 분석하여 그룹 간의 통계적 유의성을 평가합니다.
    One-way ANOVA는 한 개의 요인을, N-way ANOVA는 여러 개의 요인을 다룰 수 있습니다.

▣ ancova([data, dv, between, covar, effsize]) ANCOVA with one or more covariate(s).

    # ANCOVA 분석 개요
    ANOVA와 유사하지만, 추가적으로 하나 이상의 연속형 공변량(보정 변수)을
    고려하여 결과를 조정하고 그룹 간 차이를 분석합니다.

▣ rm_anova([data, dv, within, subject, ...]) One-way and two-way repeated measures ANOVA.

    # RM_ANOVA 분석 개요
    반복 측정된 데이터에서 시간,
    조건 또는 처리에 따른 변화를 분석하는데 사용되며,
    개체 내의 변동과 그룹 간 변동을 고려합니다.

▣ epsilon(data[, dv, within, subject, correction]) Epsilon adjustement factor for repeated measures.

    # EPSILON 분석 개요
    반복 측정 설계에서의 이차원 요인의 epsilon 보정 요소를 계산하여,
    ANOVA의 가정을 충족시키고 신뢰도 있는 결과를 얻을 수 있도록 합니다.

▣ mixed_anova([data, dv, within, subject, ...]) Mixed-design (split-plot) ANOVA.

    # MIXED_ANOVA 분석 개요
    범주형과 반복 측정 요인을 모두 고려하는 혼합 설계 ANOVA로,
    그룹 간 및 개체 내 변동을 모두 분석합니다.

▣ welch_anova([data, dv, between]) One-way Welch ANOVA.

    # WELCH_ANOVA 분석 개요
    등분산성 가정이 깨진 경우에 사용되며,
    그룹 간 평균의 차이를 비교하는데 적합한 Welch의 수정된 ANOVA입니다.

▣ tost(x, y[, bound, paired, correction]) Two One-Sided Test (TOST) for equivalence.

    # TOST 분석 개요
    두 그룹 간 평균의 등가성을 평가하기 위한 통계적 검정 방법으로,
    두 개의 단측 t-검정을 사용합니다.

▣ ttest(x, y[, paired, alternative, ...]) T-test.

    # TTEST 분석 개요
    두 그룹 간 평균의 차이를 비교하기 위한 t-검정으로,
    두 그룹의 평균이 유의미한 차이가 있는지 평가합니다.

▣ ptests(self[, paired, decimals, padjust, ...]) Pairwise T-test between columns of a dataframe.

    # PTESTS 분석 개요
    데이터프레임의 열 간에 일대일로 비교하여 쌍체 T-검정을 수행하며,
    그룹 간 평균의 차이를 효과적으로 분석합니다.
```
- - -
## Bayesian
```
베이지안 통계(Bayesian Statistics):
사전 정보를 활용하여 사후 확률을 계산하는 통계적 방법으로, 불확실성을 모델링하는 데 유용합니다.
확률을 '확신의 정도'로 해석하며, 사전 정보와 데이터를 결합하여 추론합니다.
```

### Bayesian Statistical analysis
```
▣ bayesfactor_binom(k, n[, p, a, b]): Bayes factor of a binomial test with successes, trials and base probability

    # bayesfactor_binom 분석 개요
    이 함수는 이항 분포에 기반한 테스트의 Bayes Factor를 계산합니다.
    성공 횟수, 시행 횟수, 그리고 기본 확률 등을 고려하여 이항 분포에 대한 테스트 결과의 강도를 측정합니다.

▣ bayesfactor_ttest(t, nx[, ny, paired, ...]): Bayes Factor of a T-test.

    # bayesfactor_ttest 분석 개요
    이 함수는 T-검정에 대한 Bayes Factor를 계산합니다.
    두 그룹 간 평균의 차이를 검정하며, 샘플 크기, 짝지어진(paired) 여부 등을 고려하여 결과의 강도를 측정합니다.

▣ bayesfactor_pearson(r, n[, alternative, ...]): Bayes Factor of a Pearson correlation.

    # bayesfactor_pearson 분석 개요
    이 함수는 Pearson 상관관계에 대한 Bayes Factor를 계산합니다.
    상관관계의 강도와 방향성에 대한 정보를 표본 크기와 함께 고려하여 제시합니다.
```
- - -
## Circular
```
원형 통계(Circular Statistics):
주로 각도와 관련된 데이터를 다루는 통계 방법으로,
시계 방향으로 순환하는 데이터를 다룹니다.
예를 들어 시간, 방위각, 자이로스코프 등이 있습니다.
```

### Circular Statistical analysis
```
▣ convert_angles(angles[, low, high, positive]): Element-wise conversion of arbitrary-unit circular quantities to radians.

    임의의 단위로 표현된 각도를 라디안으로 변환하는 함수입니다.
    각도를 주어진 범위 내에서 양의 방향으로만 변환할 수 있습니다.

▣ circ_axial(angles, n): Transforms n-axial data to a common scale.

    n-axial 데이터를 공통된 척도로 변환합니다.
    각도 데이터를 주어진 척도에 맞추어 변환합니다.

▣ circ_corrcc(x, y[, correction_uniform]): Correlation coefficient between two circular variables.

    두 원형 변수 간의 상관 계수를 계산합니다.
    두 원형 변수의 상관 관계를 측정하며, uniformity correction을 적용할 수 있습니다.

▣ circ_corrcl(x, y): Correlation coefficient between one circular and one linear variable random variables.

    하나는 원형 변수이고 다른 하나는 선형 변수인 두 변수 간의 상관 계수를 계산합니다.

▣ circ_mean(angles[, w, axis]): Mean direction for (binned) circular data.

    (구간화된) 원형 데이터의 평균 방향을 계산합니다.
    가중치를 고려할 수 있습니다.

▣ circ_r(angles[, w, d, axis]): Mean resultant vector length for circular data.

    원형 데이터의 평균 결과 벡터의 길이를 계산합니다.
    가중치를 고려할 수 있습니다.

▣ circ_rayleigh(angles[, w, d]): Rayleigh test for non-uniformity of circular data.

    원형 데이터의 비균일성을 위한 Rayleigh 검정을 수행합니다.

▣ circ_vtest(angles[, dir, w, d]): V test for non-uniformity of circular data with a specified mean direction.

    주어진 평균 방향을 가진 원형 데이터의 비균일성을 검정하는 V 테스트를 수행합니다.
```
- - -
## Contingency
```
Contingency Table Analysis:
범주형 변수 간의 관련성을 파악하기 위해 특히
크로스탭(cross-tabulation)을 사용하여 데이터를 정리하고 분석하는 방법입니다.
```

### Contingency Statistical analysis
```
▣ chi2_independence(data, x, y[, correction]): Chi-squared independence tests between two categorical variables.
    두 개의 범주형 변수 간의 카이제곱 독립성 검정을 수행합니다.
    이를 통해 두 변수 간의 관련성이 있는지를 통계적으로 평가할 수 있습니다.

▣ chi2_mcnemar(data, x, y[, correction]): Performs the exact and approximated versions of McNemar's test.
    McNemar의 검정에 대한 정확한(exact) 및 근사(approximated) 버전을 수행합니다.
    두 관련 범주형 변수 간의 차이를 검정합니다.

▣ dichotomous_crosstab(data, x, y): Generates a 2x2 contingency table from a pandas.DataFrame that contains only dichotomous entries, which are converted to 0 or 1.
    이 함수는 Pandas DataFrame에서 이분형(dichotomous) 항목들만을 가진 2x2 교차표를 생성합니다.
    이분형 데이터를 0 또는 1로 변환하여 교차표를 만들어줍니다.

```
- - -
## Correlation and regression
```
상관 분석(Correlation Analysis):
두 변수 간의 관계 강도와 방향을 측정하는 통계 기법입니다.

회귀 분석(Regression Analysis):
한 변수가 다른 변수에 미치는 영향을 분석하고 예측하는 데 사용되는 통계 기법입니다.
```

### Correlation and regression Statistical analysis
```
▣ corr(x, y[, alternative, method]): (Robust) correlation between two variables.
    두 변수 간의 (로버스트한) 상관관계를 계산합니다.

▣ pairwise_corr(data[, columns, covar, ...]): Pairwise (partial) correlations between columns of a pandas dataframe.
    Pandas DataFrame 내 열(column)들 간의 (부분) 상관관계를 쌍으로 계산합니다.

▣ partial_corr([data, x, y, covar, x_covar, ...]): Partial and semi-partial correlation.
    부분 및 반부분 상관관계를 계산합니다.

▣ pcorr(self): Partial correlation matrix (pandas.DataFrame method).
    Pandas DataFrame의 부분 상관계수 행렬을 반환합니다.

▣ rcorr(self[, method, upper, decimals, ...]): Correlation matrix of a dataframe with p-values and/or sample size on the upper triangle (pandas.DataFrame method).
    상관관계 행렬을 생성하며, 상삼각 행렬 상단에는 p-값과/또는 표본 크기를 포함시킵니다.

▣ distance_corr(x, y[, alternative, n_boot, seed]): Distance correlation between two arrays.
    두 배열 간의 거리 상관관계를 계산합니다.

▣ rm_corr([data, x, y, subject]): Repeated measures correlation.
    반복 측정 상관관계를 계산합니다.

▣ linear_regression(X, y[, add_intercept, ...]): (Multiple) Linear regression.
    (다중) 선형 회귀분석을 수행합니다.

▣ logistic_regression(X, y[, coef_only, ...]): (Multiple) Binary logistic regression.
    (다중) 이항 로지스틱 회귀분석을 수행합니다.

▣ mediation_analysis([data, x, m, y, covar, ...]): Mediation analysis using a bias-correct non-parametric bootstrap method.
    편향 보정 비모수 부트스트랩 방법을 사용하여 중재 분석을 수행합니다.
```
- - -
## Distribution
```
분포(Distribution):
데이터의 값이 어떻게 분포되는지를 설명하는 통계학적 모형입니다.
```

### Distribution Statistical analysis
```
▣ anderson(*args[, dist]): Anderson-Darling test of distribution.
    Anderson-Darling 분포 검정을 수행합니다.
    특정 데이터가 주어진 분포와 얼마나 잘 일치하는지를 검정합니다.

▣ gzscore(x, *[, axis, ddof, nan_policy]): Geometric standard (Z) score.
    기하학적 표준(Z) 점수를 계산합니다.
    이상치에 민감하지 않은 정규화된 점수를 생성합니다.

▣ homoscedasticity(data[, dv, group, method, ...]): Test equality of variance.
    분산의 동질성을 검정합니다.
    그룹 간 또는 조건 간 분산이 동일한지를 평가합니다.

▣ normality(data[, dv, group, method, alpha]): Univariate normality test.
    단변량 정규성을 검정합니다.
    주어진 데이터가 정규 분포를 따르는지를 테스트합니다.

▣ sphericity(data[, dv, within, subject, ...]): Mauchly and JNS test for sphericity.
    구형성 검정을 위한 Mauchly와 JNS 검정을 수행합니다.
    반복 측정 자료에서의 조건 간 분산의 등분산성을 평가합니다.
```

- - -
## Effect sizes
```
효과 크기(Effect Sizes):
통계적 결과의 크기를 나타내는 척도로, 관찰된 차이의 중요성을 평가하는 데 사용됩니다.
```

### Effect Statistical analysis
```
▣ compute_effsize(x, y[, paired, eftype]): Calculate effect size between two set of observations.
    두 개의 관측치 집합 간의 효과 크기(effect size)를 계산합니다.
    효과 크기는 두 그룹 간의 차이를 나타내는 값으로, 페어링 여부 등을 고려하여 계산됩니다.

▣ compute_effsize_from_t(tval[, nx, ny, N, eftype]): Compute effect size from a T-value.
    T-값으로부터 효과 크기를 계산합니다.
    T-값과 샘플 크기 등을 고려하여 효과 크기를 계산합니다.

▣ convert_effsize(ef, input_type, output_type): Conversion between effect sizes.
    효과 크기 간의 변환을 수행합니다.
    입력된 효과 크기를 다른 유형의 효과 크기로 변환합니다.

▣ compute_esci([stat, nx, ny, paired, eftype, ...]): Parametric confidence intervals around a Cohen d or a correlation coefficient.
    Cohen의 d나 상관 계수 주변의 모수적 신뢰 구간을 계산합니다.
    주어진 효과 크기나 상관계수 주변의 신뢰 구간을 계산하는데 활용됩니다.

▣ compute_bootci(x[, y, func, method, paired, ...]): Bootstrapped confidence intervals of univariate and bivariate functions.
    단변량 및 이변량 함수의 부트스트랩 신뢰 구간을 계산합니다.
    주어진 데이터에서 함수의 신뢰 구간을 부트스트랩 방법을 통해 계산합니다.
```
- - -
## Multiple comparisons and post-hoc tests
```
다중 비교와 사후 검정(Multiple Comparisons and Post-hoc Tests):
그룹 간 비교에서 발생하는 유의성을 조정하고 추가적인 분석을 수행하는 통계적 방법입니다.
```

### Multiple comparisons Statistical analysis
```
▣ pairwise_corr(data[, columns, covar, ...]): Pairwise (partial) correlations between columns of a pandas dataframe.
    Pandas DataFrame의 열 간 (부분) 상관관계를 쌍으로 계산합니다.

▣ pairwise_tests([data, dv, between, within, ...]): Pairwise tests.
    쌍별로 테스트를 수행합니다.
    데이터 내의 다양한 그룹 간 또는 조건 간의 차이를 비교하고 테스트합니다.

▣ pairwise_tukey([data, dv, between, effsize]): Pairwise Tukey-HSD post-hoc test.
    쌍별로 Tukey-HSD 사후검정을 수행합니다.
    그룹 간 평균 차이에 대한 다중 비교 검정을 수행합니다.

▣ pairwise_gameshowell([data, dv, between, ...]): Pairwise Games-Howell post-hoc test.
    쌍별로 Games-Howell 사후검정을 수행합니다.
    다양한 그룹 간 평균 차이를 검정합니다.

▣ ptests(self[, paired, decimals, padjust, ...]): Pairwise T-test between columns of a dataframe.
    DataFrame의 열 간 쌍별 T-검정을 수행합니다.
    각 열 쌍 사이의 평균 차이를 비교합니다.

▣ multicomp(pvals[, alpha, method]): P-values correction for multiple comparisons.
    다중 비교에 대한 p-값 보정을 수행합니다.
    여러 가지 비교를 할 때 발생할 수 있는 p-값을 보정하여 유의미한 결과를 도출합니다.
```
- - -
## Multivariate tests
```
다변량 분석(Multivariate Analysis):
여러 개의 종속 변수를 고려하여 데이터를 분석하는 통계 기법입니다.
```
## Multivariate tests Statistical analysis
```
▣ box_m(data, dvs, group[, alpha]): Test equality of covariance matrices using the Box's M test.
    Box의 M 검정을 사용하여 공분산 행렬의 동질성을 검정합니다.
    다변량 데이터 내에서 그룹 간의 공분산 행렬이 동일한지를 평가합니다.

▣ multivariate_normality(X[, alpha]): Henze-Zirkler multivariate normality test.
    Henze-Zirkler 다변량 정규성 검정을 수행합니다.
    다변량 데이터가 다변량 정규분포를 따르는지를 테스트합니다.

▣ multivariate_ttest(X[, Y, paired]): Hotelling T-squared test (= multivariate T-test)
    Hotelling T-제곱 검정을 수행합니다.
    두 개 이상의 다변량 변수 그룹 간의 평균 차이를 검정합니다.
    이는 다변량 T-검정으로도 알려져 있습니다.
```
- - -
## Non-parametric
```
비모수적 방법(Non-parametric Methods):
모집단의 분포에 대한 가정을 하지 않고 데이터를 분석하는 방법입니다.
```
### Non-parametric Statistical analysis
```
▣ cochran([data, dv, within, subject]): Cochran Q test.
    Cochran Q 검정을 수행합니다.
    반복 측정 자료에서 범주형 변수에 따른 빈도의 동질성을 검정합니다.

▣ friedman([data, dv, within, subject, method]): Friedman test for repeated measurements.
    반복 측정을 위한 Friedman 검정을 수행합니다.
    같은 그룹 내에서의 서열 데이터에 대한 비모수적인 검정을 수행합니다.

▣ kruskal([data, dv, between, detailed]): Kruskal-Wallis H-test for independent samples.
    독립적인 샘플에 대한 Kruskal-Wallis H-검정을 수행합니다.
    세 개 이상의 그룹 간의 중위수 차이를 비교합니다.

▣ mad(a[, normalize, axis]): Median Absolute Deviation (MAD) along given axis of an array.
    배열의 주어진 축을 따라 Median Absolute Deviation (MAD)을 계산합니다.

▣ madmedianrule(a): Robust outlier detection based on the MAD-median rule.
    MAD-중위수 규칙을 기반으로 한 이상치 감지를 수행합니다.
    
▣ mwu(x, y[, alternative]): Mann-Whitney U Test (= Wilcoxon rank-sum test).
    Mann-Whitney U 검정을 수행합니다.
    두 개의 독립적인 표본 간의 중위수 차이를 비교합니다.

▣ wilcoxon(x[, y, alternative]): Wilcoxon signed-rank test.
    Wilcoxon 부호 순위 검정을 수행합니다.
    두 짝을 이룬 표본 간의 중위수 차이를 비교합니다.

▣ harrelldavis(x[, quantile, axis]): Harrell-Davis robust estimate of the quantile(s) of the data.
    데이터의 분위수에 대한 Harrell-Davis 강건한 추정치를 계산합니다.
```
- - -
# Others

## Plotting
```
시각화(Plotting):
데이터를 그래프나 차트로 시각적으로 표현하는 과정을 지원하는 함수들을 의미합니다.
```

## Power analysis
```
파워 분석(Power Analysis):
통계 실험에서 효과를 감지하기 위해 필요한 샘플 크기나 실험 설계에 필요한 통계적 파워를 분석하는 방법입니다.
```

## Relibility and consistency
```
신뢰도와 일관성(Reliability and Consistency):
측정 도구나 테스트의 안정성과 일관성을 평가하는 통계적 기법입니다.
```