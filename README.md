
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SRTTAnalysis

<!-- badges: start -->

<!-- badges: end -->

This package includes a set of functions to analyse raw reaction time
data (e.g., SRTT), calculate performance and plot the results of this
analysis

## Installation

You can install the development version of SRTTAnalysis from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("albertooof/SRTTAnalysis")
```

You can also install the development version of SRTTAnalysis from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("yourusername/mypackage")
```

## Example

Basic examples which show you how to run the code and what output to
expect:

``` r
library(SRTTAnalysis)

data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_wide, format = "Wide")[, 1:10])
#>       ID       V2       V3       V4       V5      V6       V7       V8       V9
#> SRTT 999 1006.925 865.6895 794.4408 1068.544 1015.67 986.3141 1020.384 881.7637
#>           V10
#> SRTT 1011.258
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6      V7       V8      V9
#> SRTT 999 1066.272 1050.622 1048.372 1273.707 1034.825 924.664 1105.891 1019.28
#>           V10
#> SRTT 955.0643
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 1010.37183247608 1006.23000897069 977.626453905324 975.732668523859
#> SRTT1  B 1116.83419215563 995.796045713177 915.351403399957 1083.14255800826
#> SRTT2  C 1030.68024642277 1096.39327270639 977.646753570648  1024.9295447563
#> SRTT3  D 993.985302141683 947.121047640882 1005.93970979949 1169.05520811701
#> SRTT4  E 1117.63964882047  930.70538927048 1056.85442334468 942.888025197635
#> SRTT5  F 1050.11368532403 1142.72230811268 909.802674891437 1053.75153256327
#>                     V6               V7               V8               V9
#> SRTT  994.641032150653 844.733943851035 1069.94913669121 1136.09476406584
#> SRTT1 986.430360140052 1053.43243944463 830.659974801489 985.409372571991
#> SRTT2 1068.51929014814 935.086853988661 954.746336370099 969.734185232775
#> SRTT3 1145.72594480561 1145.65173119461 1028.69776588194 826.745677748114
#> SRTT4 1198.40417550495 1041.59005194885 757.899821578177 1052.42875381633
#> SRTT5 1138.05877109246 1070.21155655253 1002.15449320359 1205.13801762564
#>                    V10
#> SRTT  1075.79625089383
#> SRTT1   1092.239298795
#> SRTT2 1083.41378742049
#> SRTT3 977.645298445566
#> SRTT4 1175.73332654326
#> SRTT5 872.208985257432
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A 1010.3718   1006.23  977.6265  975.7327   994.641  844.7339 1069.9491
#> SRTT1  B 1116.8342   995.796  915.3514 1083.1426  986.4304 1053.4324    830.66
#> SRTT2  C 1030.6802 1096.3933  977.6468 1024.9295 1068.5193  935.0869  954.7463
#> SRTT3  D  993.9853   947.121 1005.9397 1169.0552 1145.7259 1145.6517 1028.6978
#> SRTT4  E 1117.6396  930.7054 1056.8544   942.888 1198.4042 1041.5901  757.8998
#> SRTT5  F 1050.1137 1142.7223  909.8027 1053.7515 1138.0588 1070.2116 1002.1545
#>              V9       V10
#> SRTT  1136.0948 1075.7963
#> SRTT1  985.4094 1092.2393
#> SRTT2  969.7342 1083.4138
#> SRTT3  826.7457  977.6453
#> SRTT4 1052.4288 1175.7333
#> SRTT5  1205.138   872.209
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1  Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999        8 15.55556        16 14.28571        8 9.666667        10     9.5
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1       14 15.55556         8 13.92857
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999      7.5 14.33333  8.333333   12.75       10 10.33333  16.66667   11.25
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1       15 13.33333  6.666667    12.5
```

``` r
random_matrix <- matrix(stats::rnorm(10 * 1200, mean = 1, sd = 0.1), nrow = 10, ncol = 1200)

for (i in 1:10) { 
  num_nas <- sample(50:300, 1)
  random_matrix[i, sample(1200, num_nas)] <- NA 
  }

random_df_w <- data.frame(ID = LETTERS[1:10], random_matrix)

percentage_of_filtered_values_for_Dataframe(random_df_w, format = "Wide",number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A       20 18.3333333333333        16 18.2142857142857       14
#> 2   B       12 20.5555555555556        14 17.8571428571429       16
#> 3   C       28 18.8888888888889        20 20.7142857142857       20
#> 4   D        6 5.55555555555556         0 4.64285714285714        4
#> 5   E        4 7.77777777777778         0 5.71428571428571       10
#> 6   F       20               25        22 23.5714285714286       22
#> 7   G        6 11.1111111111111        18 11.4285714285714        4
#> 8   H       16 15.5555555555556        22 16.7857142857143       18
#> 9   I       10 14.4444444444444         6 12.1428571428571       12
#> 10  J       18 21.6666666666667        26 21.7857142857143       24
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  13.3333333333333        12   13.25        6 11.6666666666667        20
#> 2  21.6666666666667        10    19.5       24 18.8888888888889        26
#> 3                19        28   20.25       24 24.4444444444444        22
#> 4  3.66666666666667         6       4        2 6.11111111111111         2
#> 5                 6        14     7.5       10 7.77777777777778         8
#> 6  22.3333333333333        22   22.25       22               25        18
#> 7  10.6666666666667        18   10.75       10 15.5555555555556        24
#> 8  15.3333333333333        12   15.25       16 11.6666666666667        10
#> 9  10.6666666666667        12      11       10 8.33333333333333        12
#> 10 22.6666666666667        22   22.75       28               20        20
#>             Skill_3
#> 1  12.1428571428571
#> 2  21.0714285714286
#> 3  23.9285714285714
#> 4  4.64285714285714
#> 5  8.21428571428571
#> 6  23.2142857142857
#> 7  16.0714285714286
#> 8  12.1428571428571
#> 9  9.28571428571429
#> 10 21.4285714285714
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A       20 18.3333333333333        16 18.2142857142857       14
#> 2   B       12 20.5555555555556        14 17.8571428571429       16
#> 3   C       28 18.8888888888889        20 20.7142857142857       20
#> 4   D        6 5.55555555555556         0 4.64285714285714        4
#> 5   E        4 7.77777777777778         0 5.71428571428571       10
#> 6   F       20               25        22 23.5714285714286       22
#> 7   G        6 11.1111111111111        18 11.4285714285714        4
#> 8   H       16 15.5555555555556        22 16.7857142857143       18
#> 9   I       10 14.4444444444444         6 12.1428571428571       12
#> 10  J       18 21.6666666666667        26 21.7857142857143       24
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  13.3333333333333        12   13.25        6 11.6666666666667        20
#> 2  21.6666666666667        10    19.5       24 18.8888888888889        26
#> 3                19        28   20.25       24 24.4444444444444        22
#> 4  3.66666666666667         6       4        2 6.11111111111111         2
#> 5                 6        14     7.5       10 7.77777777777778         8
#> 6  22.3333333333333        22   22.25       22               25        18
#> 7  10.6666666666667        18   10.75       10 15.5555555555556        24
#> 8  15.3333333333333        12   15.25       16 11.6666666666667        10
#> 9  10.6666666666667        12      11       10 8.33333333333333        12
#> 10 22.6666666666667        22   22.75       28               20        20
#>             Skill_3
#> 1  12.1428571428571
#> 2  21.0714285714286
#> 3  23.9285714285714
#> 4  4.64285714285714
#> 5  8.21428571428571
#> 6  23.2142857142857
#> 7  16.0714285714286
#> 8  12.1428571428571
#> 9  9.28571428571429
#> 10 21.4285714285714
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID  preRND_1   Train_1 postRND_1      Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 0.9745009 0.9991153 0.9931921 -0.005923206 0.998532 1.013386  1.006711
#>        Skill_2  preRND_3   Train_3 postRND_3    Skill_3
#> 1 -0.006675537 0.9748304 0.9864794  1.010554 0.02407499
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID  preRND_1  Train_1 postRND_1     Skill_1 preRND_2   Train_2 postRND_2
#> 1 999 0.9916353 1.003941 0.9660888 -0.03785195 1.002099 0.9974989 0.9942967
#>        Skill_2 preRND_3   Train_3 postRND_3     Skill_3
#> 1 -0.003202222  1.01356 0.9900421   0.96439 -0.02565215
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A 0.988954504739368  0.99150447911669 0.998948105793866  0.00744362667717546
#> 2  B 0.973176960651621   1.0130032182245  1.01641117725843  0.00340795903393576
#> 3  C   1.0179349807467 0.985811672559567 0.976752900259677 -0.00905877229988983
#> 4  D 0.991687053986389  1.01034572773704  1.03553420228591   0.0251884745488669
#> 5  E  1.00688144887781  0.97898553734279  1.02778374486019   0.0487982075174012
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1 0.995996702764588  0.99279294124478  1.02929686594711   0.0365039247023343
#> 2   1.0230781216115   1.0014505183086  1.01048959360181  0.00903907529321013
#> 3   1.0034497013274 0.999370575787765 0.999922315071627 0.000551739283862096
#> 4  1.01006712224422 0.994863860177466  1.00477377531982  0.00990991514235451
#> 5 0.992438693337497  1.00196357240194 0.980490563261032  -0.0214730091409109
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1  1.01391704326363  1.01922849914661 0.980345197945351  -0.0388833012012583
#> 2  1.00035533656726 0.992090295724002 0.999254321474246  0.00716402575024355
#> 3  1.00612427464064 0.985919568194056 0.979123040768888 -0.00679652742516812
#> 4 0.986854786047723  1.00849678929041  1.00091713457217 -0.00757965471824296
#> 5 0.988845092256389  1.00862875819625  1.01609333336644  0.00746457517018762
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1
#> 1  A 0.987651084572732  1.00027658661126  1.01231751705567
#> 2  B 0.973892514049751  1.00482654936273  1.00438503704989
#> 3  C  1.02203787921375 0.992991223804095  1.01830397353207
#> 4  D 0.983108494224669  1.00432455823644 0.994029934011353
#> 5  E  1.00101069323713 0.995329122918115 0.977184634231079
#>                 Skill_1          preRND_2           Train_2         postRND_2
#> 1    0.0120409304444067  1.01910284666822  1.00934121275224  1.01055484261805
#> 2 -0.000441512312841397  1.00535125285749  1.00495561893704 0.997383071990339
#> 3    0.0253127497279793 0.980213624222984  1.00546447777316   1.0185158922169
#> 4   -0.0102946242250862 0.946590102145391 0.999698294056706 0.999649163731694
#> 5   -0.0181444886870353  1.01233339848778 0.996304568818293 0.992392553778323
#>                 Skill_2          preRND_3           Train_3         postRND_3
#> 1   0.00121362986580897 0.982344768791754  1.01213368273905 0.968698908324228
#> 2  -0.00757254694670284 0.989127856538728 0.991873218781828  1.01372964986245
#> 3    0.0130514144437375 0.986192437392675 0.996101395315903 0.985181778326759
#> 4 -4.91303250117481e-05  1.03905649013133  1.00378054181057 0.980541005431891
#> 5  -0.00391201503996985  1.00633812676443  1.00781536941073  1.01346697797502
#>               Skill_3
#> 1 -0.0434347744148204
#> 2  0.0218564310806203
#> 3 -0.0109196169891438
#> 4 -0.0232395363786817
#> 5 0.00565160856429592
```

``` r
random_list_w <- cbind(999, (as.data.frame(t(stats::rnorm(500, mean = 1, sd = 0.1)))))


png("plot1.png", width = 800, height = 600)

plot_data(random_list_w,format = "Wide" , limit_y_axis_min_max = TRUE,  limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.1,   standard_error = FALSE, color_dots = "black",   color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'

dev.off()
#> png 
#>   2
```

``` r

random_list_l <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))

png("plot2.png", width = 800, height = 600)

plot_data(random_list_l, format = "Long" , limit_y_axis_min_max = TRUE,limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "lm",   span_loess_fitting = 0.1, standard_error = T,  color_dots = "black",  color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'

dev.off()
#> png 
#>   2
```

``` r

random_df_w <- data.frame( ID = LETTERS[1:10], matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500))

png("plot3.png", width = 800, height = 600)

plot_data_for_Dataframes(random_df_w, format = "Wide" , limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8, limit_y_axis_upper = 1, design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.25, standard_error = FALSE, color_dots = "black", color_line = "grey", color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'

dev.off()
#> png 
#>   2
```

``` r

random_df_l <- as.data.frame(t(random_df_w))

png("plot4.png", width = 800, height = 600)

plot_data_for_Dataframes(random_df_l,format = "Long" ,  limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8,   limit_y_axis_upper = 1,  design = c(50, 100, 50, 50, 100, 50,  25, 50, 25), function_to_fit = "lm",  span_loess_fitting = 0.25,   standard_error = FALSE,  color_dots = "black", color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
```

``` r

png("plot5.png", width = 800, height = 600)

plot_skills(skill, format = "Wide", col_line = "blue",col_dots = "grey")

dev.off()
#> png 
#>   2
```

``` r

png("plot6.png", width = 800, height = 600)

plot_skills_for_Dataframes(skill_df,  format = "Wide",  col_line = "blue",   col_dots = "grey")

dev.off()
#> png 
#>   2
```
