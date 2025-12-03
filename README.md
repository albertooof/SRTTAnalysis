
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

![](man/figures/TypesOfDataframe.png)

## Example

Basic examples which show you how to run the code and what output to
expect:

``` r
library(SRTTAnalysis)

data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_wide, format = "Wide")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1065.633 1182.289 1104.021 982.2833 978.0589 1014.262 922.8496
#>            V9      V10
#> SRTT 963.3692 921.8697
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1139.566 852.4791 914.4319 984.2402 955.0144 1000.229 909.2936
#>            V9     V10
#> SRTT 847.8748 1035.33
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 1011.80847759111 1077.29594437334 1064.13682121781 1028.36283628541
#> SRTT1  B  1128.2645656305 1072.25912264444 1134.85947722677 1044.44739682352
#> SRTT2  C 1036.00788065901 1030.97119774468 943.883204566213 1000.48815616923
#> SRTT3  D 1036.11010488235 1052.61006919711 1039.71207762285 940.780430712375
#> SRTT4  E 927.602550871109 1061.50283468456 1010.98899181892 990.878386479189
#> SRTT5  F 884.557244006911 1015.82867600036 928.779164564308 1111.59422691851
#>                     V6               V7               V8               V9
#> SRTT  990.170797468756 1158.39947851658 996.659202627368 1006.18773782813
#> SRTT1 1112.10391055919 986.973949335861 910.619544914128 1096.21583765756
#> SRTT2 910.078122496884 961.980630924582 894.540144142503 1030.01979277084
#> SRTT3 1036.69170058609 997.412474384947 942.725059232799             <NA>
#> SRTT4 1030.97903252424 1275.25790079872 1074.48876167305 1028.64831969545
#> SRTT5 1016.50522174357 1070.69295910012 1059.67028828177  1146.0520405152
#>                    V10
#> SRTT  1069.96791271605
#> SRTT1 1074.02794119217
#> SRTT2 978.328206284657
#> SRTT3 1087.70241924587
#> SRTT4 1038.22348447483
#> SRTT5 1002.76273400748
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A 1011.8085 1077.2959 1064.1368 1028.3628  990.1708 1158.3995  996.6592
#> SRTT1  B 1128.2646 1072.2591 1134.8595 1044.4474 1112.1039  986.9739  910.6195
#> SRTT2  C 1036.0079 1030.9712  943.8832 1000.4882  910.0781  961.9806  894.5401
#> SRTT3  D 1036.1101 1052.6101 1039.7121  940.7804 1036.6917  997.4125  942.7251
#> SRTT4  E  927.6026 1061.5028  1010.989  990.8784  1030.979 1275.2579 1074.4888
#> SRTT5  F  884.5572 1015.8287  928.7792 1111.5942 1016.5052  1070.693 1059.6703
#>              V9       V10
#> SRTT  1006.1877 1069.9679
#> SRTT1 1096.2158 1074.0279
#> SRTT2 1030.0198  978.3282
#> SRTT3      <NA> 1087.7024
#> SRTT4 1028.6483 1038.2235
#> SRTT5  1146.052 1002.7627
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1  Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10 7.222222         8 7.857143        8 8.333333         6       8
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1        6 6.666667         6 6.428571
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2 Train_2 postRND_2 Skill_2
#> 1 999       10 7.666667  8.333333       8      7.5       8         5     7.5
#>   preRND_3 Train_3 postRND_3 Skill_3
#> 1      2.5       9        15    9.25
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
#> 1   A        4 9.44444444444444         6 7.85714285714286        2
#> 2   B       14 17.7777777777778        16 16.7857142857143       24
#> 3   C       34 16.1111111111111        22 20.3571428571429       22
#> 4   D       10 19.4444444444444        18             17.5       32
#> 5   E       12 7.77777777777778         6 8.21428571428571        2
#> 6   F       20 17.2222222222222        14 17.1428571428571       10
#> 7   G       10 6.11111111111111         4 6.42857142857143       12
#> 8   H        4 5.55555555555556         6 5.35714285714286        4
#> 9   I       10 6.66666666666667         8              7.5       12
#> 10  J       16 17.7777777777778         8 15.7142857142857       20
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  5.66666666666667         8     5.5        4                5         8
#> 2  16.3333333333333        22      18       12 17.7777777777778        20
#> 3                19        14   18.75       22 19.4444444444444         8
#> 4                17        26      20       16 22.2222222222222        20
#> 5                 9         8       8       10 6.11111111111111        10
#> 6  19.6666666666667        22   18.75       18 19.4444444444444        30
#> 7  5.33333333333333         2    5.75        6 7.22222222222222         0
#> 8                 5         4    4.75        8 4.44444444444444         4
#> 9                 8         6    8.25        8 10.5555555555556         2
#> 10               19        18      19       24 18.8888888888889        16
#>             Skill_3
#> 1  5.35714285714286
#> 2  17.1428571428571
#> 3  17.8571428571429
#> 4  20.7142857142857
#> 5               7.5
#> 6  21.0714285714286
#> 7  5.71428571428571
#> 8                 5
#> 9  8.57142857142857
#> 10 19.2857142857143
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A        4 9.44444444444444         6 7.85714285714286        2
#> 2   B       14 17.7777777777778        16 16.7857142857143       24
#> 3   C       34 16.1111111111111        22 20.3571428571429       22
#> 4   D       10 19.4444444444444        18             17.5       32
#> 5   E       12 7.77777777777778         6 8.21428571428571        2
#> 6   F       20 17.2222222222222        14 17.1428571428571       10
#> 7   G       10 6.11111111111111         4 6.42857142857143       12
#> 8   H        4 5.55555555555556         6 5.35714285714286        4
#> 9   I       10 6.66666666666667         8              7.5       12
#> 10  J       16 17.7777777777778         8 15.7142857142857       20
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  5.66666666666667         8     5.5        4                5         8
#> 2  16.3333333333333        22      18       12 17.7777777777778        20
#> 3                19        14   18.75       22 19.4444444444444         8
#> 4                17        26      20       16 22.2222222222222        20
#> 5                 9         8       8       10 6.11111111111111        10
#> 6  19.6666666666667        22   18.75       18 19.4444444444444        30
#> 7  5.33333333333333         2    5.75        6 7.22222222222222         0
#> 8                 5         4    4.75        8 4.44444444444444         4
#> 9                 8         6    8.25        8 10.5555555555556         2
#> 10               19        18      19       24 18.8888888888889        16
#>             Skill_3
#> 1  5.35714285714286
#> 2  17.1428571428571
#> 3  17.8571428571429
#> 4  20.7142857142857
#> 5               7.5
#> 6  21.0714285714286
#> 7  5.71428571428571
#> 8                 5
#> 9  8.57142857142857
#> 10 19.2857142857143
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1  Train_1 postRND_1      Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 1.014504 1.010668  1.002976 -0.007692724 0.998535 1.004854 0.9890573
#>       Skill_2  preRND_3   Train_3 postRND_3    Skill_3
#> 1 -0.01579695 0.9987773 0.9877216  1.005101 0.01737953
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1  Train_1 postRND_1     Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 1.031675 1.019282  1.008499 -0.01078269 1.018217 1.000256 0.9854792
#>       Skill_2 preRND_3  Train_3 postRND_3     Skill_3
#> 1 -0.01477659 0.982399 1.001297 0.9710359 -0.03026105
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1
#> 1  A  1.01452088875814  1.02330057023223 0.995715654256144
#> 2  B 0.983743668849024  1.01411340250092 0.988403794236348
#> 3  C  1.00892321035453  1.02306364015988  1.02272842726122
#> 4  D  1.01273207320812 0.977226274828451  1.02479483368333
#> 5  E  1.00497869546726  1.02465144060752 0.993622781462777
#>                 Skill_1          preRND_2           Train_2         postRND_2
#> 1   -0.0275849159760837  1.00306727500991  1.01725452573906 0.994368269474938
#> 2    -0.025709608264576  1.00237042739951 0.995195319053889 0.998304695279345
#> 3 -0.000335212898655568 0.999017454915877  1.01310781094886  1.02627712047876
#> 4    0.0475685588548767 0.971922241796456  1.01675272917404 0.980282049171431
#> 5    -0.031028659144739  1.00601823369647  1.01100102064561 0.993519722380552
#>               Skill_2          preRND_3           Train_3         postRND_3
#> 1 -0.0228862562641214 0.975607694572439 0.988504264605708 0.994118836376265
#> 2 0.00310937622545548 0.991252649977809 0.995352733115367 0.996608176398593
#> 3  0.0131693095298995 0.997316700694582  1.00085302417423  1.00497847630393
#> 4 -0.0364706800026068  1.00688240210851  1.02008738530687  1.03936132976934
#> 5 -0.0174812982650572  1.00073205544967  1.00009222102818 0.973010465830987
#>               Skill_3
#> 1 0.00561457177055724
#> 2  0.0012554432832258
#> 3 0.00412545212969428
#> 4  0.0192739444624652
#> 5 -0.0270817551971981
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A  1.01711925832883  1.01278437856084 0.981741839926212  -0.0310425386346317
#> 2  B 0.983426428907558  1.00672615223423 0.992875450168898  -0.0138507020653343
#> 3  C  1.00209449176114  1.01090412411881 0.995090298689353   -0.015813825429459
#> 4  D  1.01609827312373 0.991424410016027 0.976555078094217  -0.0148693319218101
#> 5  E  1.01285707128385  1.00341243114407 0.994697923254803 -0.00871450788926342
#>            preRND_2           Train_2         postRND_2             Skill_2
#> 1  1.00161567743666 0.998633604237302 0.983625166561293 -0.0150084376760087
#> 2  1.00962292640205  0.99836358091026 0.975939484558486 -0.0224240963517741
#> 3  0.98347677286261  1.01274259633209 0.976790786561087 -0.0359518097709992
#> 4  1.00527918579919  1.00458637585989  1.03333406566988  0.0287476898099852
#> 5 0.983238908417732  1.00124396742576 0.977940082417042 -0.0233038850087192
#>            preRND_3           Train_3         postRND_3               Skill_3
#> 1  1.00183167597994 0.995371005292011 0.994689118551754 -0.000681886740256932
#> 2  1.00836190367684 0.989224809738774  1.00682930936655    0.0176044996277783
#> 3 0.967293948350158  1.00220327666529    1.011947943259   0.00974466659371576
#> 4  1.01938029848257  1.00889609737293  1.03751943506972    0.0286233376967944
#> 5 0.995263783407747  1.00478619619322 0.980532295035561   -0.0242539011576555
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
