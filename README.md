
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
#>       ID      V2       V3       V4       V5       V6       V7      V8      V9
#> SRTT 999 1055.61 995.4306 992.9921 972.4429 948.9312 920.7012 881.047 964.958
#>      V10
#> SRTT  NA
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 758.7108 981.0126 1044.664 1096.287 968.7183 934.9099 930.9135
#>            V9     V10
#> SRTT 1091.774 1088.07
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 938.160592074479  1048.1424670755 1178.96577434155 1028.09335833491
#> SRTT1  B 1097.88311961416 891.585874812956 1008.72520817987 1005.50096366872
#> SRTT2  C 1142.53111690519 993.540101408093 994.933479152476 989.539447002484
#> SRTT3  D 1225.59856477976 953.854353332164 1037.15543042178 1000.79858593616
#> SRTT4  E 889.788919263464  1131.0026458852 931.760097686175 942.123463975961
#> SRTT5  F 1002.92851529223 985.307539595968  944.22402346462 1015.71479651301
#>                     V6               V7               V8               V9
#> SRTT  860.630971236683 1120.53346609158 1090.64796659292 952.210350928468
#> SRTT1 819.682521219086 1007.80632520578 1191.13975589685  837.35813170449
#> SRTT2 1001.69434257516 1109.04102512394 981.488793102407 902.952239530973
#> SRTT3 883.703273828199 1091.46818955885 772.320171662685 826.363350609757
#> SRTT4  950.24308974799 1076.96092671796 981.983596732926 1125.33709008116
#> SRTT5 1118.17741180124  971.58414040956 1056.95921282937 1122.65424732354
#>                    V10
#> SRTT  973.502560316159
#> SRTT1 997.212760270983
#> SRTT2 1102.46003211198
#> SRTT3 1022.24508610874
#> SRTT4 1165.89730520917
#> SRTT5 1072.52816178529
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A  938.1606 1048.1425 1178.9658 1028.0934   860.631 1120.5335  1090.648
#> SRTT1  B 1097.8831  891.5859 1008.7252  1005.501  819.6825 1007.8063 1191.1398
#> SRTT2  C 1142.5311  993.5401  994.9335  989.5394 1001.6943  1109.041  981.4888
#> SRTT3  D 1225.5986  953.8544 1037.1554 1000.7986  883.7033 1091.4682  772.3202
#> SRTT4  E  889.7889 1131.0026  931.7601  942.1235  950.2431 1076.9609  981.9836
#> SRTT5  F 1002.9285  985.3075   944.224 1015.7148 1118.1774  971.5841 1056.9592
#>              V9       V10
#> SRTT   952.2104  973.5026
#> SRTT1  837.3581  997.2128
#> SRTT2  902.9522   1102.46
#> SRTT3  826.3634 1022.2451
#> SRTT4 1125.3371 1165.8973
#> SRTT5 1122.6542 1072.5282
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1  Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       12 11.66667         8 11.07143       10 7.666667        14    8.75
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1        4 10.55556         6 8.571429
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10 10.66667        10    10.5       10 7.666667        10    8.25
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1     17.5 8.666667  3.333333    8.75
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
#> 1   A        8                5         6 5.71428571428571        8
#> 2   B        2 8.33333333333333         4 6.42857142857143        0
#> 3   C       18 17.7777777777778        22 18.5714285714286       12
#> 4   D       24 21.1111111111111        22 21.7857142857143       20
#> 5   E       10 21.6666666666667        24               20       22
#> 6   F       18 11.1111111111111        12             12.5       10
#> 7   G       26               30        22 27.8571428571429       16
#> 8   H       18 15.5555555555556        22 17.1428571428571       10
#> 9   I       18 11.1111111111111        14 12.8571428571429       16
#> 10  J       26               20        26 22.1428571428571       14
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  6.33333333333333         2       6        4 6.11111111111111         8
#> 2  6.33333333333333         6     5.5        6 6.66666666666667         0
#> 3  20.3333333333333        26      20       14 23.8888888888889        22
#> 4  19.3333333333333        24      20       22 18.3333333333333        14
#> 5                15        20    16.5       18               20        22
#> 6                10        18      11        8 12.7777777777778        14
#> 7  21.3333333333333        34   22.25       24 22.2222222222222        18
#> 8  15.6666666666667        26   16.25       20 16.1111111111111        10
#> 9  11.3333333333333         8    11.5       12 16.6666666666667        18
#> 10 20.6666666666667        40   22.25       16 20.5555555555556        22
#>             Skill_3
#> 1  6.07142857142857
#> 2  5.35714285714286
#> 3  21.7857142857143
#> 4  18.2142857142857
#> 5                20
#> 6  12.1428571428571
#> 7  21.7857142857143
#> 8  15.7142857142857
#> 9  16.0714285714286
#> 10               20
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A        8                5         6 5.71428571428571        8
#> 2   B        2 8.33333333333333         4 6.42857142857143        0
#> 3   C       18 17.7777777777778        22 18.5714285714286       12
#> 4   D       24 21.1111111111111        22 21.7857142857143       20
#> 5   E       10 21.6666666666667        24               20       22
#> 6   F       18 11.1111111111111        12             12.5       10
#> 7   G       26               30        22 27.8571428571429       16
#> 8   H       18 15.5555555555556        22 17.1428571428571       10
#> 9   I       18 11.1111111111111        14 12.8571428571429       16
#> 10  J       26               20        26 22.1428571428571       14
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  6.33333333333333         2       6        4 6.11111111111111         8
#> 2  6.33333333333333         6     5.5        6 6.66666666666667         0
#> 3  20.3333333333333        26      20       14 23.8888888888889        22
#> 4  19.3333333333333        24      20       22 18.3333333333333        14
#> 5                15        20    16.5       18               20        22
#> 6                10        18      11        8 12.7777777777778        14
#> 7  21.3333333333333        34   22.25       24 22.2222222222222        18
#> 8  15.6666666666667        26   16.25       20 16.1111111111111        10
#> 9  11.3333333333333         8    11.5       12 16.6666666666667        18
#> 10 20.6666666666667        40   22.25       16 20.5555555555556        22
#>             Skill_3
#> 1  6.07142857142857
#> 2  5.35714285714286
#> 3  21.7857142857143
#> 4  18.2142857142857
#> 5                20
#> 6  12.1428571428571
#> 7  21.7857142857143
#> 8  15.7142857142857
#> 9  16.0714285714286
#> 10               20
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID  preRND_1  Train_1 postRND_1     Skill_1 preRND_2   Train_2 postRND_2
#> 1 999 0.9962972 1.010615   1.01843 0.007815062 1.012978 0.9968214 0.9897896
#>        Skill_2 preRND_3 Train_3 postRND_3     Skill_3
#> 1 -0.007031803 1.008801 1.00547 0.9820289 -0.02344083
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1  Train_1 postRND_1      Skill_1 preRND_2  Train_2 postRND_2
#> 1 999 1.019331 1.019079  1.014334 -0.004744982 1.011662 0.981596  1.014432
#>      Skill_2 preRND_3  Train_3 postRND_3    Skill_3
#> 1 0.03283608 1.019171 0.976517 0.9885263 0.01200932
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1            Skill_1
#> 1  A 0.992259603055613  1.00066357850128  1.02251837617628 0.0218547976749928
#> 2  B 0.993659153724015 0.995507626822242 0.977533651720439 -0.017973975101803
#> 3  C 0.994924607459593 0.982717222656474  1.02140975805457 0.0386925353980966
#> 4  D 0.988676390110167 0.986462128512146  1.01270054305719 0.0262384145450397
#> 5  E 0.972598966231646  1.00931223608784   1.0258622204687  0.016549984380865
#>           preRND_2           Train_2         postRND_2             Skill_2
#> 1 1.00064295510499 0.999166918941358 0.983353161742127 -0.0158137571992311
#> 2   1.028365868016  1.02540930732572  1.00653102199959  -0.018878285326126
#> 3 1.01993207700226  1.03560342538009 0.996282287087751 -0.0393211382923433
#> 4 1.00394839095316  1.00936042971163  0.99748017939317 -0.0118802503184591
#> 5 0.99977982267469  1.00844743364693 0.983766141780266 -0.0246812918666592
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1    1.013305739909 0.995105311246148  1.00057357795713  0.00546826671098488
#> 2  1.03829480701053  1.00128776937311  1.01639696489994   0.0151091955268339
#> 3  1.00306582044394  1.00221422091147  1.01273915663637   0.0105249357249042
#> 4 0.996238580557185 0.993240844133674 0.990717549551615 -0.00252329458205958
#> 5  1.00496598774611 0.996823746263178  1.02394761712705   0.0271238708638694
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A  0.98666129736882  1.00362036098938  1.00801395157692 0.00439359058754296
#> 2  B 0.982543413574924 0.996253362453942  1.00742698287961  0.0111736204256664
#> 3  C 0.992406161122089  1.00249557007653 0.987826596170562 -0.0146689739059649
#> 4  D 0.992356942805598  1.00069954274312  1.01018823992578 0.00948869718265244
#> 5  E 0.964924414366936  1.00166562170991 0.987184050882948 -0.0144815708269636
#>            preRND_2          Train_2         postRND_2              Skill_2
#> 1 0.995425728682317 1.00444961810835 0.971623925594351  -0.0328256925140006
#> 2  1.01006789043934 1.02056430407546  1.00224959449451  -0.0183147095809493
#> 3  1.01781323313102 1.01485477444783 0.995285985324108  -0.0195687891237242
#> 4 0.997520851752097 1.00221856020907  1.06962512875269   0.0674065685436243
#> 5 0.989088967310873 1.00142565062622 0.992629096806216 -0.00879655382000111
#>            preRND_3           Train_3         postRND_3             Skill_3
#> 1 0.995810254329022 0.993675154384465  1.01123029436191  0.0175551399774416
#> 2 0.994309977602598 0.999655211493554  1.02158075437067  0.0219255428771192
#> 3  1.02733914588769 0.992781577988562   1.0105656569456  0.0177840789570362
#> 4 0.979881491238717 0.980404909523703 0.985493534674859 0.00508862515115527
#> 5 0.992679059236748  1.00565237537751  1.04001882915681  0.0343664537792934
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
