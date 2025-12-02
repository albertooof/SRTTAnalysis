
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
devtools::install_github("albertooof/SRTTAnalysis")
```

## Example

Basic examples which show you how to run the code and what output to
expect:

``` r
library(SRTTAnalysis)

data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_wide, format = "Wide")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1106.881 767.1544 1076.947 1322.643 931.2359 1091.562 923.1487
#>            V9      V10
#> SRTT 947.8955 819.0893
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1020.177 856.6154 1029.274 1144.184 1109.928 986.4059 1121.091
#>            V9      V10
#> SRTT 920.4398 1081.174
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 934.240278157524 1040.58857327226 1030.67394731021 1036.93095821272
#> SRTT1  B 1171.19576113923  1115.3888691892 1043.52591909877 1023.60692184977
#> SRTT2  C 1003.24016798611 949.652189264318 957.095546970069 1002.47682643879
#> SRTT3  D 946.502095794578  1114.4270723653 1104.17194463083 1043.38713668796
#> SRTT4  E 861.586555342874 1079.66940043769 839.122778225521 1014.20711090634
#> SRTT5  F 933.521102439867 892.094324734357  1002.4577571431 1174.55430982411
#>                     V6               V7               V8               V9
#> SRTT  836.775593693454 949.821482273255 1030.60597444657 1139.79192134973
#> SRTT1 1106.46756932183 1044.38736888475 941.663694764379 1016.28003750539
#> SRTT2 960.568473883902 1055.92957059658  932.95799997482  944.39698248213
#> SRTT3 873.613821669473 1095.95976307743 1076.58946836216 1090.55827079564
#> SRTT4 1087.56958888728 1016.73267307033 879.185189033302 925.421989920672
#> SRTT5 958.041861610274 995.097160884623 1001.99803053699 1078.11849299108
#>                    V10
#> SRTT  1112.80049552948
#> SRTT1 1038.15492315102
#> SRTT2  978.37349588072
#> SRTT3 1024.45370881822
#> SRTT4 964.242230758117
#> SRTT5 997.651987452361
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A  934.2403 1040.5886 1030.6739  1036.931  836.7756  949.8215  1030.606
#> SRTT1  B 1171.1958 1115.3889 1043.5259 1023.6069 1106.4676 1044.3874  941.6637
#> SRTT2  C 1003.2402  949.6522  957.0955 1002.4768  960.5685 1055.9296   932.958
#> SRTT3  D  946.5021 1114.4271 1104.1719 1043.3871  873.6138 1095.9598 1076.5895
#> SRTT4  E  861.5866 1079.6694  839.1228 1014.2071 1087.5696 1016.7327  879.1852
#> SRTT5  F  933.5211  892.0943 1002.4578 1174.5543  958.0419  995.0972  1001.998
#>             V9       V10
#> SRTT  1139.792 1112.8005
#> SRTT1  1016.28 1038.1549
#> SRTT2  944.397  978.3735
#> SRTT3 1090.558 1024.4537
#> SRTT4  925.422  964.2422
#> SRTT5 1078.118   997.652
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2 Train_2 postRND_2 Skill_2
#> 1 999        6 8.888889         4     7.5       12       5         6       6
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1       10 12.22222        10 11.42857
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1 Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999      7.5       8         0    6.75     12.5 6.333333  8.333333    7.25
#>   preRND_3 Train_3 postRND_3 Skill_3
#> 1     12.5      10  3.333333    9.25
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
#> 1   A       10 13.8888888888889        12 12.8571428571429       12
#> 2   B       14 20.5555555555556        30 21.0714285714286       20
#> 3   C       20 12.2222222222222        24 15.7142857142857       18
#> 4   D       12 8.88888888888889         2 8.21428571428571       14
#> 5   E        4 6.66666666666667         4 5.71428571428571        6
#> 6   F        8 6.11111111111111         6 6.42857142857143        4
#> 7   G       28 23.8888888888889        32 26.0714285714286       20
#> 8   H       28               20        30 23.2142857142857       16
#> 9   I       16 16.1111111111111        16 16.0714285714286       14
#> 10  J       12               15         6 12.8571428571429       12
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  22.3333333333333        14      20       18 16.1111111111111        10
#> 2                23        28   23.25       22 21.6666666666667        18
#> 3                17        16      17       16 13.8888888888889        18
#> 4  9.66666666666667         8      10       12 8.88888888888889         8
#> 5                 6         8    6.25       10 3.88888888888889         4
#> 6  1.66666666666667         8    2.75        4                5         2
#> 7  25.6666666666667        28   25.25       22 23.3333333333333        24
#> 8  22.6666666666667        16      21       28 33.3333333333333        32
#> 9  16.6666666666667         4   14.75       12 13.3333333333333        16
#> 10               15        16   14.75       14 15.5555555555556        22
#>             Skill_3
#> 1  15.3571428571429
#> 2  21.0714285714286
#> 3                15
#> 4  9.28571428571429
#> 5                 5
#> 6  4.28571428571429
#> 7  23.2142857142857
#> 8  32.1428571428571
#> 9  13.5714285714286
#> 10 16.4285714285714
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A       10 13.8888888888889        12 12.8571428571429       12
#> 2   B       14 20.5555555555556        30 21.0714285714286       20
#> 3   C       20 12.2222222222222        24 15.7142857142857       18
#> 4   D       12 8.88888888888889         2 8.21428571428571       14
#> 5   E        4 6.66666666666667         4 5.71428571428571        6
#> 6   F        8 6.11111111111111         6 6.42857142857143        4
#> 7   G       28 23.8888888888889        32 26.0714285714286       20
#> 8   H       28               20        30 23.2142857142857       16
#> 9   I       16 16.1111111111111        16 16.0714285714286       14
#> 10  J       12               15         6 12.8571428571429       12
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  22.3333333333333        14      20       18 16.1111111111111        10
#> 2                23        28   23.25       22 21.6666666666667        18
#> 3                17        16      17       16 13.8888888888889        18
#> 4  9.66666666666667         8      10       12 8.88888888888889         8
#> 5                 6         8    6.25       10 3.88888888888889         4
#> 6  1.66666666666667         8    2.75        4                5         2
#> 7  25.6666666666667        28   25.25       22 23.3333333333333        24
#> 8  22.6666666666667        16      21       28 33.3333333333333        32
#> 9  16.6666666666667         4   14.75       12 13.3333333333333        16
#> 10               15        16   14.75       14 15.5555555555556        22
#>             Skill_3
#> 1  15.3571428571429
#> 2  21.0714285714286
#> 3                15
#> 4  9.28571428571429
#> 5                 5
#> 6  4.28571428571429
#> 7  23.2142857142857
#> 8  32.1428571428571
#> 9  13.5714285714286
#> 10 16.4285714285714
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID  preRND_1 Train_1 postRND_1    Skill_1  preRND_2  Train_2 postRND_2
#> 1 999 0.9848547 1.00777  1.038082 0.03031224 0.9896013 1.020759  1.023645
#>       Skill_2  preRND_3  Train_3 postRND_3     Skill_3
#> 1 0.002885951 0.9789957 1.015713 0.9760522 -0.03966114
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1   Train_1 postRND_1    Skill_1  preRND_2  Train_2 postRND_2
#> 1 999  1.01117 0.9931764  1.006608 0.01343179 0.9835793 1.011305 0.9685753
#>       Skill_2  preRND_3   Train_3 postRND_3     Skill_3
#> 1 -0.04272978 0.9835488 0.9899191 0.9930002 0.003081033
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A 0.991830907164298 0.990524527928973 0.994809106323992 0.00428457839501917
#> 2  B 0.999204036699904 0.979227666606391 0.980253504845494 0.00102583823910296
#> 3  C 0.986170139326773 0.987341835434592 0.989552353672706 0.00221051823811436
#> 4  D  1.01544360795896  1.01761724932966 0.972058820304524 -0.0455584290251403
#> 5  E 0.995989410720585 0.990509812946361 0.974414208306248 -0.0160956046401131
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1 0.998246691044736 0.979792042534733  1.00388329606639   0.0240912535316573
#> 2 0.999478175678207  1.00216087365779  1.00505768908914  0.00289681543135201
#> 3  1.00097679047342 0.976666381613799  1.00639183078723   0.0297254491734263
#> 4 0.983558602968023  1.00715070339009  1.00009761870987 -0.00705308468021948
#> 5 0.997184832399868  1.00584487814675 0.978481780790528  -0.0273630973562212
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1 0.998238419989153  1.00160210802877  1.00185222088068 0.000250112851918116
#> 2  1.01523009969377 0.987423789119735  1.00107925531639   0.0136554661966545
#> 3 0.999098672701238 0.995771732295333  1.01312435607568   0.0173526237803435
#> 4 0.984523225477755  0.99454302654297 0.996456766554729  0.00191374001175848
#> 5 0.995825709629444  1.00486133246232 0.991746402311453  -0.0131149301508701
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A  0.99729259237669 0.991181156855414 0.963640096766642   -0.027541060088772
#> 2  B 0.993184418405471 0.994373379033112  1.00555002855706   0.0111766495239446
#> 3  C 0.979461820510874 0.994817787207243 0.988769060588285 -0.00604872661895794
#> 4  D  1.01587164815959 0.996708674967225 0.994558126057548 -0.00215054890967736
#> 5  E 0.984128591515247 0.997687031861138 0.988913324251209 -0.00877370760992924
#>            preRND_2           Train_2         postRND_2             Skill_2
#> 1  1.01626071214704 0.998880013632606 0.986942840515256 -0.0119371731173497
#> 2 0.960920260677448  1.00989216772368  1.01509666525872 0.00520449753503849
#> 3  1.03870378755423 0.989490770769244  1.00342763326329  0.0139368624940441
#> 4 0.983713395382551  0.99933048647086 0.980207754218612 -0.0191227322522484
#> 5 0.986419865089617  1.00195413275612  1.01018062214534 0.00822648938922099
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1 0.998617901443259  1.00315319469129  1.00349827126775 0.000345076576455439
#> 2 0.971341513522473 0.991873411314807 0.998965363047693  0.00709195173288524
#> 3 0.978247519268949 0.999932171592081 0.987297105222371  -0.0126350663697103
#> 4  1.03923057926564  1.00094581766495  0.97823057029713  -0.0227152473678179
#> 5 0.993771869799585  1.00366112098349  1.01656293686847   0.0129018158849799
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
