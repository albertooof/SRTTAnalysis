
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SRTTAnalysis <img src="man/figures/logo2.png" align="right" height="139" alt="" />

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
devtools::install_github("albertooof/SRTTAnalysis")
```

## Types of Dataframe expected as input

![](man/figures/TypesOfDataframe.png) \## Visual summary for
SRTT_analysis function ![](man/figures/visual_summary.png)

## Example

Basic examples which show you how to run the code and what output to
expect:

``` r
library(SRTTAnalysis)

data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_wide, format = "Wide", normalize_when = 0)[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1109.498 1281.424 885.4243 1259.387 1116.022 970.9406 816.8759
#>            V9      V10
#> SRTT 1048.844 1023.177
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long", normalize_when = 1, normalize_type = "z_score")[, 1:10])
#>       ID V2 V3 V4 V5 V6 V7 V8 V9 V10
#> SRTT 999 NA NA NA NA NA NA NA NA  NA
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide", normalize_when = 3, normalize_type = "min_max")[, 1:10]) 
#>       ID   V2   V3   V4   V5   V6   V7   V8   V9  V10
#> SRTT   A <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
#> SRTT1  B <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
#> SRTT2  C <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
#> SRTT3  D <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
#> SRTT4  E <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
#> SRTT5  F <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A 1145.3282  973.3162  1028.454 1005.6737  953.5842 1050.0519 1029.5042
#> SRTT1  B  881.1623 1085.4786  974.2009  994.2318  1253.594  918.2818 1119.2207
#> SRTT2  C 1190.5321  955.7954   1024.87  968.1992 1141.6709 1053.6641 1186.6466
#> SRTT3  D 1186.6541  969.2078  715.8539 1026.4434 1032.0363 1000.1693  959.4289
#> SRTT4  E  927.8118 1027.4064 1017.6555 1112.5081  960.9366  845.3368  915.0225
#> SRTT5  F 1065.8268  859.1575 1031.7708  926.7857  964.5051 1030.3036 1233.6537
#>              V9       V10
#> SRTT   940.4388  902.9329
#> SRTT1  945.9108 1187.1528
#> SRTT2  856.2279 1238.9359
#> SRTT3  929.1228 1145.1933
#> SRTT4  806.3037  853.4967
#> SRTT5 1036.8829 1013.6241
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10 6.666667         8     7.5        0 3.333333         8     3.5
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1        4 7.222222         2 5.714286
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10 5.666667         5       6        5 3.666667  8.333333     4.5
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1       10 3.666667         5     4.5
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
#> 1   A       12 10.5555555555556        14 11.4285714285714        4
#> 2   B       22 21.1111111111111        12 19.6428571428571       16
#> 3   C        6 10.5555555555556        14 10.3571428571429       14
#> 4   D        8 15.5555555555556        16 14.2857142857143       16
#> 5   E       16 7.22222222222222        10 9.28571428571429       14
#> 6   F       14 11.6666666666667        10 11.7857142857143       14
#> 7   G        6 7.77777777777778        12 8.21428571428571       12
#> 8   H       24 21.1111111111111        24 22.1428571428571       24
#> 9   I       30               20        20 21.7857142857143       24
#> 10  J       28 24.4444444444444        34 26.7857142857143       24
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  14.3333333333333        10    12.5        6 11.6666666666667        16
#> 2  17.6666666666667        16   17.25       20 13.8888888888889        12
#> 3  13.3333333333333        10      13       14 12.7777777777778        10
#> 4  15.3333333333333        16    15.5       16 13.8888888888889        12
#> 5  10.3333333333333         6   10.25       16 10.5555555555556        10
#> 6  8.33333333333333         4     8.5       10 9.44444444444444        14
#> 7                11        14    11.5        6 9.44444444444444        10
#> 8                22        14   21.25       24 16.1111111111111        16
#> 9                25        22    24.5       26 15.5555555555556        16
#> 10               25        20   24.25       20 23.8888888888889        26
#>             Skill_3
#> 1  11.4285714285714
#> 2  14.6428571428571
#> 3              12.5
#> 4  13.9285714285714
#> 5  11.4285714285714
#> 6  10.3571428571429
#> 7  8.92857142857143
#> 8              17.5
#> 9              17.5
#> 10 23.5714285714286
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A       12 10.5555555555556        14 11.4285714285714        4
#> 2   B       22 21.1111111111111        12 19.6428571428571       16
#> 3   C        6 10.5555555555556        14 10.3571428571429       14
#> 4   D        8 15.5555555555556        16 14.2857142857143       16
#> 5   E       16 7.22222222222222        10 9.28571428571429       14
#> 6   F       14 11.6666666666667        10 11.7857142857143       14
#> 7   G        6 7.77777777777778        12 8.21428571428571       12
#> 8   H       24 21.1111111111111        24 22.1428571428571       24
#> 9   I       30               20        20 21.7857142857143       24
#> 10  J       28 24.4444444444444        34 26.7857142857143       24
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  14.3333333333333        10    12.5        6 11.6666666666667        16
#> 2  17.6666666666667        16   17.25       20 13.8888888888889        12
#> 3  13.3333333333333        10      13       14 12.7777777777778        10
#> 4  15.3333333333333        16    15.5       16 13.8888888888889        12
#> 5  10.3333333333333         6   10.25       16 10.5555555555556        10
#> 6  8.33333333333333         4     8.5       10 9.44444444444444        14
#> 7                11        14    11.5        6 9.44444444444444        10
#> 8                22        14   21.25       24 16.1111111111111        16
#> 9                25        22    24.5       26 15.5555555555556        16
#> 10               25        20   24.25       20 23.8888888888889        26
#>             Skill_3
#> 1  11.4285714285714
#> 2  14.6428571428571
#> 3              12.5
#> 4  13.9285714285714
#> 5  11.4285714285714
#> 6  10.3571428571429
#> 7  8.92857142857143
#> 8              17.5
#> 9              17.5
#> 10 23.5714285714286
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1  Train_1 postRND_1    Skill_1 preRND_2  Train_2 postRND_2
#> 1 999  1.01431 1.016392  1.001138 -0.0152541 0.973036 1.039264 0.9916871
#>       Skill_2 preRND_3   Train_3 postRND_3      Skill_3
#> 1 -0.04757668 1.000608 0.9884962 0.9891443 0.0006480952
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1  Train_1 postRND_1     Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 1.011813 1.008316 0.9831478 -0.02516834 1.006494 1.006363  1.017706
#>      Skill_2 preRND_3  Train_3 postRND_3     Skill_3
#> 1 0.01134231 1.001567 1.011555 0.9868117 -0.02474347
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A   1.0016472388076 0.984574622626273  1.00097206652147   0.0163974438951949
#> 2  B    1.021051263901  1.00759721194793 0.980066644834031  -0.0275305671139037
#> 3  C  1.02062155714409 0.984013981785663 0.995228301730387   0.0112143199447242
#> 4  D 0.997039939922274  1.02610899261101  1.01106394970929  -0.0150450429017237
#> 5  E 0.991682436737224  0.99055071758062 0.986188748304122 -0.00436196927649868
#>            preRND_2           Train_2        postRND_2              Skill_2
#> 1  1.00270780454522  1.00651458185649 1.03289221707038   0.0263776352138887
#> 2 0.995126417683251 0.994532439763882 1.00153726883632  0.00700482907244204
#> 3  1.00154332740769 0.991615062036047 1.03142046167826   0.0398053996422152
#> 4  1.01037164582053  1.00283763320607 1.00078151699955 -0.00205611620651225
#> 5  1.01218120838257   1.0099281467799 1.00266896932271 -0.00725917745718752
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1  0.99903328941232 0.985864286317932 0.987601248399917  0.00173696208198504
#> 2 0.997483224451375  0.99620794676217   1.0205360362531   0.0243280894909287
#> 3   1.0079432134235  1.02021031982598 0.985968540246785  -0.0342417795791935
#> 4 0.996427158315866  1.00517113479236  1.01108960708557  0.00591847229321063
#> 5  1.00637656304407 0.983012765984238 0.977904702372932 -0.00510806361130556
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A  1.01215826312661   1.0021523136273  1.01754030310603  0.0153879894787314
#> 2  B  1.01769544677431  1.00636868308433 0.977346957010793 -0.0290217260735316
#> 3  C  1.01835649512043 0.994146944702599  1.01049167277219  0.0163447280695893
#> 4  D 0.995485116767315   1.0039734369325 0.985151365107198 -0.0188220718252993
#> 5  E 0.995429862436792  0.99363160563364 0.952161971186357 -0.0414696344472832
#>            preRND_2           Train_2         postRND_2             Skill_2
#> 1 0.999059191216288  1.00377254561162  1.00848271635508 0.00471017074345959
#> 2 0.995212848526036 0.997340062538283  1.00165930577791 0.00431924323962896
#> 3  1.01388371826848  1.00523048755798 0.988909598676455 -0.0163208888815257
#> 4  1.00142636432314  1.00593865656851  1.00730127493881 0.00136261837030283
#> 5  1.04984218684333   1.0047934270796  1.01822524505828  0.0134318179786788
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1  0.99304937853615 0.993291118485857 0.976509065424155   -0.016782053061702
#> 2  1.01093701081762 0.996358223671057  1.01095186646092    0.014593642789862
#> 3  0.97697862138492  1.00035506737323 0.995830326412073 -0.00452474096115707
#> 4  1.01888471704316  1.00399835150604  1.01957845125074   0.0155800997446969
#> 5 0.981313432744909 0.988042705476823 0.964303035285278  -0.0237396701915445
```

``` r

random_list_w <- cbind(999, (as.data.frame(t(stats::rnorm(500, mean = 1, sd = 0.1)))))

plot_data(random_list_w,format = "Wide" , limit_y_axis_min_max = TRUE,  limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.1,   standard_error = FALSE, color_dots = "black",   color_line = "grey",  color_intercept = "grey")
```

![](man/figures/README-example12-1.png)

``` r

random_list_l <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))

plot_data(random_list_l, format = "Long" , limit_y_axis_min_max = TRUE,limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "lm",   span_loess_fitting = 0.1, standard_error = T,  color_dots = "black",  color_line = "grey",  color_intercept = "grey")
```

![](man/figures/README-example13-1.png)

``` r

random_df_w <- data.frame( ID = LETTERS[1:10], matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500))

plot_data_for_Dataframes(random_df_w, format = "Wide" , limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8, limit_y_axis_upper = 1, design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.25, standard_error = FALSE, color_dots = "black", color_line = "grey", color_intercept = "grey")
```

![](man/figures/README-example14-1.png)

``` r

random_df_l <- as.data.frame(t(random_df_w))

plot_data_for_Dataframes(random_df_l,format = "Long" ,  limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8,   limit_y_axis_upper = 1,  design = c(50, 100, 50, 50, 100, 50,  25, 50, 25), function_to_fit = "lm",  span_loess_fitting = 0.25,   standard_error = FALSE,  color_dots = "black", color_line = "grey",  color_intercept = "grey")
```

![](man/figures/README-example15-1.png)

``` r

data_wide <- data.frame(id = 999, t(rnorm(12, mean = 1, sd = 0.1)))

names(data_wide) <- c("ID", "preRND1", "Train1", "postRND1", "Skill1", "preRND2", "Train2", "postRND2", "Skill2", "preRND3", "Train3", "postRND3", "Skill3")

plots <- plot_skills(data_wide, format = "Wide", col_line = "grey",col_dots = "grey")

plots$plot1
```

![](man/figures/README-example16-1.png)

``` r

plots$plot2
```

![](man/figures/README-example17-1.png)

``` r

random_matrix <- matrix(stats::rnorm(5 * 12, mean = 1, sd = 0.1), nrow = 5, ncol = 12)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

names(random_df_w) <- c("ID", "preRND1", "Train1", "postRND1", "Skill1", "preRND2", "Train2", "postRND2", "Skill2", "preRND3", "Train3", "postRND3", "Skill3")

plots <- plot_skills_for_Dataframes(random_df_w,  format = "Wide",   col_line = "blue", col_dots = "grey")

plots$plot1
```

![](man/figures/README-example18-1.png)

``` r
random_df_l <- as.data.frame(t(random_df_w))

plots <- plot_skills_for_Dataframes(random_df_l,  format = "Long",  col_line = "blue",   col_dots = "grey")

plots$plot2
```

![](man/figures/README-example19-1.png)
