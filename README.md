
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
#>       ID       V2      V3       V4       V5       V6       V7       V8       V9
#> SRTT 999 1019.536 1120.81 868.3533 944.6477 1010.695 967.6449 984.2794 1189.178
#>           V10
#> SRTT 1016.326
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1055.603 1057.013 968.6268 1161.007 1132.638 1002.352 1064.365
#>            V9      V10
#> SRTT 1012.115 1054.059
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 1038.58383132661 881.023501999012 1060.71676044607 1029.06991209366
#> SRTT1  B 976.400570064746 850.775164912896 1334.89435627722 1036.42323083867
#> SRTT2  C 912.679910814466 1283.99639411918 942.015525951171 894.734498395742
#> SRTT3  D 1135.45885777913 853.758888041847 1157.96281372074 1026.71819101707
#> SRTT4  E 1070.29197450021 968.150053411014 1093.24769916571 1113.37070092423
#> SRTT5  F 1175.86364877155 986.147800400768  1007.1137797157 808.002252558875
#>                     V6               V7               V8               V9
#> SRTT  1034.44637411197 1013.97988286021 970.004238033768 1107.07261073653
#> SRTT1 1009.80473664544 1069.73718888493 1146.68612560929 989.338883382163
#> SRTT2 902.382882173762 976.474607373566 1226.55348692391 1026.71539788901
#> SRTT3 1028.46769012811 973.077954708213 990.246630877566 953.128081090294
#> SRTT4  977.51729496009 1071.47133391911  1156.2192990243 906.921397044103
#> SRTT5 987.102941473395 1136.86242538538 947.087268110355 1107.26040238792
#>                    V10
#> SRTT  898.619594034997
#> SRTT1 1031.95835358628
#> SRTT2 1229.55787135525
#> SRTT3 881.886514744773
#> SRTT4 997.577322493832
#> SRTT5 1022.97281139502
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A 1038.5838  881.0235 1060.7168 1029.0699 1034.4464 1013.9799  970.0042
#> SRTT1  B  976.4006  850.7752 1334.8944 1036.4232 1009.8047 1069.7372 1146.6861
#> SRTT2  C  912.6799 1283.9964  942.0155  894.7345  902.3829  976.4746 1226.5535
#> SRTT3  D 1135.4589  853.7589 1157.9628 1026.7182 1028.4677   973.078  990.2466
#> SRTT4  E  1070.292  968.1501 1093.2477 1113.3707  977.5173 1071.4713 1156.2193
#> SRTT5  F 1175.8636  986.1478 1007.1138  808.0023  987.1029 1136.8624  947.0873
#>              V9       V10
#> SRTT  1107.0726  898.6196
#> SRTT1  989.3389 1031.9584
#> SRTT2 1026.7154 1229.5579
#> SRTT3  953.1281  881.8865
#> SRTT4  906.9214  997.5773
#> SRTT5 1107.2604 1022.9728
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1  Skill_1 preRND_2 Train_2 postRND_2 Skill_2
#> 1 999        8 8.888889         8 8.571429        6      17        10   14.75
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1       12 11.66667        12 11.78571
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1 Train_1 postRND_1 Skill_1 preRND_2 Train_2 postRND_2 Skill_2
#> 1 999       10       8  26.66667      11     27.5      12  11.66667    13.5
#>   preRND_3 Train_3 postRND_3 Skill_3
#> 1       10      12  18.33333   12.75
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
#> 1   A        2               10         8 8.21428571428571        8
#> 2   B       14 23.3333333333333        32 23.2142857142857       22
#> 3   C       22 27.7777777777778        28 26.7857142857143       22
#> 4   D       20 16.6666666666667        18             17.5        6
#> 5   E        8 8.88888888888889        24 11.4285714285714        8
#> 6   F       18               25        26 23.9285714285714       20
#> 7   G       28 21.6666666666667        14 21.4285714285714       22
#> 8   H       14 14.4444444444444        12 13.9285714285714       22
#> 9   I        6 5.55555555555556         8 6.07142857142857        0
#> 10  J       16 8.33333333333333         8 9.64285714285714       10
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  4.66666666666667        10    5.75        8 5.55555555555556        14
#> 2                19        16      19       26 16.6666666666667        30
#> 3  21.6666666666667        20    21.5       16 18.3333333333333        24
#> 4                16        26      16       20 16.1111111111111        12
#> 5  8.66666666666667        10    8.75        6 8.88888888888889        14
#> 6  29.3333333333333        24    27.5       24 21.6666666666667        22
#> 7  21.3333333333333        26      22       28 25.5555555555556        20
#> 8  12.6666666666667         6      13       10 12.7777777777778        16
#> 9  5.33333333333333         6    4.75       10 7.22222222222222         8
#> 10 9.66666666666667        12      10       10 8.88888888888889         8
#>             Skill_3
#> 1               7.5
#> 2  20.7142857142857
#> 3  18.9285714285714
#> 4  16.0714285714286
#> 5  9.28571428571429
#> 6  22.1428571428571
#> 7                25
#> 8  12.8571428571429
#> 9  7.85714285714286
#> 10 8.92857142857143
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A        2               10         8 8.21428571428571        8
#> 2   B       14 23.3333333333333        32 23.2142857142857       22
#> 3   C       22 27.7777777777778        28 26.7857142857143       22
#> 4   D       20 16.6666666666667        18             17.5        6
#> 5   E        8 8.88888888888889        24 11.4285714285714        8
#> 6   F       18               25        26 23.9285714285714       20
#> 7   G       28 21.6666666666667        14 21.4285714285714       22
#> 8   H       14 14.4444444444444        12 13.9285714285714       22
#> 9   I        6 5.55555555555556         8 6.07142857142857        0
#> 10  J       16 8.33333333333333         8 9.64285714285714       10
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  4.66666666666667        10    5.75        8 5.55555555555556        14
#> 2                19        16      19       26 16.6666666666667        30
#> 3  21.6666666666667        20    21.5       16 18.3333333333333        24
#> 4                16        26      16       20 16.1111111111111        12
#> 5  8.66666666666667        10    8.75        6 8.88888888888889        14
#> 6  29.3333333333333        24    27.5       24 21.6666666666667        22
#> 7  21.3333333333333        26      22       28 25.5555555555556        20
#> 8  12.6666666666667         6      13       10 12.7777777777778        16
#> 9  5.33333333333333         6    4.75       10 7.22222222222222         8
#> 10 9.66666666666667        12      10       10 8.88888888888889         8
#>             Skill_3
#> 1               7.5
#> 2  20.7142857142857
#> 3  18.9285714285714
#> 4  16.0714285714286
#> 5  9.28571428571429
#> 6  22.1428571428571
#> 7                25
#> 8  12.8571428571429
#> 9  7.85714285714286
#> 10 8.92857142857143
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1 Train_1 postRND_1     Skill_1 preRND_2   Train_2 postRND_2
#> 1 999 1.014211 1.03994  1.029643 -0.01029698  1.00019 0.9954279 0.9915118
#>        Skill_2  preRND_3  Train_3 postRND_3    Skill_3
#> 1 -0.003916094 0.9971092 1.008614  1.009615 0.00100144
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1  Train_1 postRND_1     Skill_1  preRND_2  Train_2 postRND_2
#> 1 999 1.005023 1.030968 0.9964824 -0.03448537 0.9693115 1.006202  1.003997
#>        Skill_2 preRND_3 Train_3 postRND_3    Skill_3
#> 1 -0.002205174 1.004045 0.99242  1.039183 0.04676292
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A 0.995156177355438 0.977324731025264 0.987137673532831  0.0098129425075667
#> 2  B 0.992978823497727  1.01470621267155 0.987083426385672 -0.0276227862858752
#> 3  C 0.978907239745287 0.996576971067983  1.02799314317902  0.0314161721110401
#> 4  D  1.01346963202014 0.993677578020179  1.02279656894221  0.0291189909220269
#> 5  E 0.967975422633715  1.00460264188136  1.02148284449014  0.0168802026087802
#>            preRND_2           Train_2        postRND_2             Skill_2
#> 1 0.998076720361819 0.991059949526894 1.00222164947103    0.01116169994414
#> 2 0.970638964414575 0.983096055624029 1.01904114449778  0.0359450888737511
#> 3 0.996605073603927 0.995848435263785 1.02286273103388  0.0270142957700907
#> 4  1.00394664148313  1.01330758661705 1.03147204063504  0.0181644540179846
#> 5  1.01425021189973  1.00685948969553 1.00817589338506 0.00131640368953079
#>            preRND_3           Train_3         postRND_3               Skill_3
#> 1 0.999709388927701  1.01983277012977  1.00225910757853   -0.0175736625512439
#> 2 0.988706401960764  0.99921883593525  1.00283302902032   0.00361419308507371
#> 3  0.98842525880412 0.995207705696463 0.994745091864824 -0.000462613831639591
#> 4  1.00359380924098 0.998508389806216  1.02501644876311    0.0265080589568908
#> 5  1.01776750967654 0.998423628660519  0.98742051930035    -0.011003109360169
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1        postRND_1             Skill_1
#> 1  A 0.996340863317318  1.00331212028146 1.02823633584561  0.0249242155641567
#> 2  B 0.991045258515309 0.994775932336261 1.00214282010502 0.00736688776876238
#> 3  C 0.976270950816723 0.998593183171323 1.00837329078369  0.0097801076123667
#> 4  D  1.01594773580475  1.00683697469182 1.01551353255896 0.00867655786713373
#> 5  E 0.959802275252875 0.995917941251562 1.00671148998393  0.0107935487323648
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1 0.981717779148003 0.998395955790003 0.981766511400254  -0.0166294443897487
#> 2  1.00171153809659 0.997734363339509  0.99521701549754 -0.00251734784196844
#> 3 0.982998134918259  1.00235241569332 0.985737543748067  -0.0166148719452538
#> 4  1.02829458185908   1.0119637430359  1.00427809202057 -0.00768565101532936
#> 5  1.00297413006216  1.00833196891485  1.01023705772386  0.00190508880901197
#>            preRND_3           Train_3         postRND_3               Skill_3
#> 1  1.00451247337146  1.00967244440664 0.982507567056873   -0.0271648773497709
#> 2  1.01713755738978  1.00270854428976  1.01446846021818    0.0117599159284136
#> 3 0.972719542751737 0.990362691641351   1.0179825970691    0.0276199054277524
#> 4  1.02178629692719 0.998159059091485  1.03808414456982    0.0399250854783347
#> 5  1.01182434679445 0.994500675257605 0.993916207026286 -0.000584468231319524
```

``` r
random_list_w <- cbind(999, (as.data.frame(t(stats::rnorm(500, mean = 1, sd = 0.1)))))

plot <- plot_data(random_list_w,format = "Wide" , limit_y_axis_min_max = TRUE,  limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.1,   standard_error = FALSE, color_dots = "black",   color_line = "grey",  color_intercept = "grey")

plot+ggplot2::geom_hline(yintercept =1, col="red")
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="man/figures/README-example12-1.png" width="100%" />

``` r

random_list_l <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))


plot <- plot_data(random_list_l, format = "Long" , limit_y_axis_min_max = TRUE,limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "lm",   span_loess_fitting = 0.1, standard_error = T,  color_dots = "black",  color_line = "grey",  color_intercept = "grey")

plot+ggplot2::geom_hline(yintercept =1, col="red")
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="man/figures/README-example13-1.png" width="100%" />

``` r

random_df_w <- data.frame( ID = LETTERS[1:10], matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500))

plot_data_for_Dataframes(random_df_w, format = "Wide" , limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8, limit_y_axis_upper = 1, design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.25, standard_error = FALSE, color_dots = "black", color_line = "grey", color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="man/figures/README-example14-1.png" width="100%" />

``` r

random_df_l <- as.data.frame(t(random_df_w))

plot_data_for_Dataframes(random_df_l,format = "Long" ,  limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8,   limit_y_axis_upper = 1,  design = c(50, 100, 50, 50, 100, 50,  25, 50, 25), function_to_fit = "lm",  span_loess_fitting = 0.25,   standard_error = FALSE,  color_dots = "black", color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="man/figures/README-example15-1.png" width="100%" />

``` r

plot_skills(skill, format = "Wide", col_line = "blue",col_dots = "grey")
```

<img src="man/figures/README-example16-1.png" width="100%" />

``` r

plot_skills_for_Dataframes(skill_df,  format = "Wide",  col_line = "blue",   col_dots = "grey")
```

<img src="man/figures/README-example17-1.png" width="100%" />
