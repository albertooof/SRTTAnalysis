
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
#> SRTT 999 1123.833 1042.245 1054.023 1058.975 968.2542 947.8224 920.8375
#>            V9      V10
#> SRTT 868.6683 1043.216
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 938.4167 965.0994 954.2637 1060.973 1038.863 1143.145 1353.337
#>            V9      V10
#> SRTT 1115.457 966.7055
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 914.557894858387 988.794123968225  957.84782007047 1015.65872388342
#> SRTT1  B 747.417280996626 866.217410309589 1020.87486181179 963.137069274626
#> SRTT2  C 969.871602107795 1073.56913309605 951.800760182788 1067.77302648691
#> SRTT3  D 1096.02200896066 1043.41915131079  1080.4547959594 911.554667931183
#> SRTT4  E 900.697651105048 871.984044645861 1190.95949183171 1030.61201169966
#> SRTT5  F 1197.18844595636 1064.93216883129 1137.38417059557 1123.74057830524
#>                     V6               V7               V8               V9
#> SRTT  1021.37264204339 957.459561624307 973.985384577526 1070.62773787813
#> SRTT1 883.763393875376 1009.62859663898 906.018746569357 992.776597502424
#> SRTT2 850.927956828707 978.392217013019 1033.45302138879 1063.49808330019
#> SRTT3 1063.37424476092 910.722699097696 1052.53158568169  1026.0445605111
#> SRTT4 1030.99817820245 1015.00885391291  981.20123440041 939.897244721484
#> SRTT5 1160.81318582098 1001.34575368408 1040.38104362635 1067.42372672714
#>                    V10
#> SRTT  1128.89032673436
#> SRTT1 1168.41929000091
#> SRTT2  1127.0497115894
#> SRTT3 1081.86255068376
#> SRTT4 973.865070280893
#> SRTT5 915.123270053299
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A  914.5579  988.7941  957.8478 1015.6587 1021.3726  957.4596  973.9854
#> SRTT1  B  747.4173  866.2174 1020.8749  963.1371  883.7634 1009.6286  906.0187
#> SRTT2  C  969.8716 1073.5691  951.8008  1067.773   850.928  978.3922  1033.453
#> SRTT3  D  1096.022 1043.4192 1080.4548  911.5547 1063.3742  910.7227 1052.5316
#> SRTT4  E  900.6977   871.984 1190.9595  1030.612 1030.9982 1015.0089  981.2012
#> SRTT5  F 1197.1884 1064.9322 1137.3842 1123.7406 1160.8132 1001.3458  1040.381
#>              V9       V10
#> SRTT  1070.6277 1128.8903
#> SRTT1  992.7766 1168.4193
#> SRTT2 1063.4981 1127.0497
#> SRTT3 1026.0446 1081.8626
#> SRTT4  939.8972  973.8651
#> SRTT5 1067.4237  915.1233
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1 Train_1 postRND_1  Skill_1 preRND_2 Train_2 postRND_2 Skill_2
#> 1 999        2       5         4 4.285714        6       6        12    6.75
#>   preRND_3 Train_3 postRND_3  Skill_3
#> 1        0       5         2 3.571429
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1 Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999      2.5       5         5    4.75       10 5.333333  6.666667       6
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1     12.5 3.666667  6.666667       5
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
#> 1   A        8 7.77777777777778        14 8.92857142857143        4
#> 2   B       16 21.1111111111111        18 19.6428571428571       14
#> 3   C       14 12.2222222222222        16 13.2142857142857       12
#> 4   D       20 18.3333333333333        18 18.5714285714286       16
#> 5   E       14 15.5555555555556        14               15       22
#> 6   F       10 12.2222222222222         8 11.0714285714286       10
#> 7   G       10 9.44444444444444        10 9.64285714285714       10
#> 8   H       24 31.6666666666667        18 27.8571428571429       20
#> 9   I       10 13.3333333333333         8 11.7857142857143        8
#> 10  J       18 15.5555555555556        24             17.5       18
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  9.33333333333333        22   10.25       10 10.5555555555556        12
#> 2  17.3333333333333        20   17.25       26 16.6666666666667        22
#> 3  15.6666666666667         8   14.25       14 12.7777777777778        10
#> 4  20.3333333333333        28   20.75       18 23.3333333333333        18
#> 5  14.6666666666667        22    16.5       12 12.2222222222222        20
#> 6                12        20   12.75       10               10        14
#> 7  8.33333333333333         6    8.25        4 7.22222222222222         4
#> 8                23        24   22.75       20 21.6666666666667        18
#> 9  10.3333333333333         2       9        6 15.5555555555556        10
#> 10 16.6666666666667        20   17.25       22 16.6666666666667        24
#>             Skill_3
#> 1  10.7142857142857
#> 2  19.2857142857143
#> 3              12.5
#> 4  21.4285714285714
#> 5  13.5714285714286
#> 6  10.7142857142857
#> 7  6.07142857142857
#> 8  20.7142857142857
#> 9  12.8571428571429
#> 10 18.9285714285714
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A        8 7.77777777777778        14 8.92857142857143        4
#> 2   B       16 21.1111111111111        18 19.6428571428571       14
#> 3   C       14 12.2222222222222        16 13.2142857142857       12
#> 4   D       20 18.3333333333333        18 18.5714285714286       16
#> 5   E       14 15.5555555555556        14               15       22
#> 6   F       10 12.2222222222222         8 11.0714285714286       10
#> 7   G       10 9.44444444444444        10 9.64285714285714       10
#> 8   H       24 31.6666666666667        18 27.8571428571429       20
#> 9   I       10 13.3333333333333         8 11.7857142857143        8
#> 10  J       18 15.5555555555556        24             17.5       18
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  9.33333333333333        22   10.25       10 10.5555555555556        12
#> 2  17.3333333333333        20   17.25       26 16.6666666666667        22
#> 3  15.6666666666667         8   14.25       14 12.7777777777778        10
#> 4  20.3333333333333        28   20.75       18 23.3333333333333        18
#> 5  14.6666666666667        22    16.5       12 12.2222222222222        20
#> 6                12        20   12.75       10               10        14
#> 7  8.33333333333333         6    8.25        4 7.22222222222222         4
#> 8                23        24   22.75       20 21.6666666666667        18
#> 9  10.3333333333333         2       9        6 15.5555555555556        10
#> 10 16.6666666666667        20   17.25       22 16.6666666666667        24
#>             Skill_3
#> 1  10.7142857142857
#> 2  19.2857142857143
#> 3              12.5
#> 4  21.4285714285714
#> 5  13.5714285714286
#> 6  10.7142857142857
#> 7  6.07142857142857
#> 8  20.7142857142857
#> 9  12.8571428571429
#> 10 18.9285714285714
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1 Train_1 postRND_1    Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 1.008683  1.0192  1.036285 0.01708523 1.002907 1.006424 0.9851999
#>       Skill_2 preRND_3   Train_3 postRND_3      Skill_3
#> 1 -0.02122381 1.003115 0.9957357 0.9961839 0.0004482754
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1   Train_1 postRND_1    Skill_1  preRND_2   Train_2 postRND_2
#> 1 999 1.015466 0.9774836 0.9950354 0.01755174 0.9928339 0.9955735  1.009167
#>      Skill_2  preRND_3   Train_3 postRND_3    Skill_3
#> 1 0.01359323 0.9837565 0.9983475  1.014013 0.01566512
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A 0.996502864167764  1.01140599734535  1.01764567475527 0.00623967740992226
#> 2  B   1.0119803292844 0.994766275187499  1.03587407105228  0.0411077958647806
#> 3  C  0.99667412574813  0.97465354902109  1.00620423591056  0.0315506868894722
#> 4  D   0.9959291637391 0.989081936435147 0.978431333402232 -0.0106506030329147
#> 5  E  1.01684809998233  1.00928583858352 0.993404036097915 -0.0158818024856029
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1  1.00973292137471 0.972357705988276  1.01632704711571   0.0439693411274376
#> 2 0.999947579526102  1.00630661677234 0.997918280040293  -0.0083883367320472
#> 3 0.993545104816421 0.998719018246788 0.992704956440883 -0.00601406180590436
#> 4  1.00799610119709 0.992733254991132 0.984934699259669 -0.00779855573146282
#> 5 0.997653934802433  1.00299610911012 0.988462598865615  -0.0145335102445034
#>            preRND_3           Train_3         postRND_3               Skill_3
#> 1 0.964455808477205  1.00489084183453  1.00404204135337 -0.000848800481158651
#> 2 0.987702349015378 0.987733574760862  1.00213671026356    0.0144031355026991
#> 3  1.00440190907314  1.00198637934376  1.01124199844352   0.00925561909976036
#> 4 0.988990255816803  1.00094062823547  1.01080493952004   0.00986431128457332
#> 5 0.987364945619122 0.988853395174869 0.990838326997476   0.00198493182260706
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A  1.00220433750622   1.0057743307994  1.00361344242856 -0.00216088837084083
#> 2  B  1.01594592200989 0.998643193242842 0.980626606196153  -0.0180165870466892
#> 3  C  1.00065219237705 0.993434314447404 0.975887135188751  -0.0175471792586528
#> 4  D 0.995693639488542 0.989738064328608 0.998454974908349  0.00871691057974044
#> 5  E  1.01870652929392  1.00418604834196  1.02078661669988   0.0166005683579229
#>            preRND_2           Train_2         postRND_2               Skill_2
#> 1 0.992198677115151 0.983553293972811 0.980380155872581   -0.0031731381002299
#> 2 0.987417512616969 0.999048326054537  1.01736622897935    0.0183179029248172
#> 3  1.00563256775266  0.99904257479244 0.998483829323627 -0.000558745468812849
#> 4   0.9942064069128 0.993517860463968   1.0190402996864    0.0255224392224328
#> 5 0.997709742564624 0.994372304772023  1.03497241266081    0.0406001078887857
#>            preRND_3          Train_3         postRND_3               Skill_3
#> 1    1.003703082497 1.00437286252057  1.00600585234651   0.00163298982594462
#> 2   1.0304969214922 1.00366587289493  1.01569075541282    0.0120248825178857
#> 3 0.990286361670949 1.00294379285925  1.00243648923485 -0.000507303624398325
#> 4  0.96903828669513 1.00116465598136  1.00153619510882  0.000371539127460796
#> 5 0.963410847529383 1.00152643651305 0.981401173850623   -0.0201252626624298
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

![](man/figures/README-example12-1.png)

``` r

random_list_l <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))

png("plot2.png", width = 800, height = 600)

plot_data(random_list_l, format = "Long" , limit_y_axis_min_max = TRUE,limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "lm",   span_loess_fitting = 0.1, standard_error = T,  color_dots = "black",  color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'

dev.off()
#> png 
#>   2
```

![](man/figures/README-example13-1.png)

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

![](man/figures/README-example14-1.png)

``` r

random_df_l <- as.data.frame(t(random_df_w))

png("plot4.png", width = 800, height = 600)

plot_data_for_Dataframes(random_df_l,format = "Long" ,  limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8,   limit_y_axis_upper = 1,  design = c(50, 100, 50, 50, 100, 50,  25, 50, 25), function_to_fit = "lm",  span_loess_fitting = 0.25,   standard_error = FALSE,  color_dots = "black", color_line = "grey",  color_intercept = "grey")
#> `geom_smooth()` using formula = 'y ~ x'
#> `geom_smooth()` using formula = 'y ~ x'
```

![](man/figures/README-example15-1.png)

``` r

png("plot5.png", width = 800, height = 600)

plot_skills(skill, format = "Wide", col_line = "blue",col_dots = "grey")

dev.off()
#> png 
#>   2
```

![](man/figures/README-example16-1.png)

``` r

png("plot6.png", width = 800, height = 600)

plot_skills_for_Dataframes(skill_df,  format = "Wide",  col_line = "blue",   col_dots = "grey")

dev.off()
#> png 
#>   2
```

![](man/figures/README-example17-1.png)
