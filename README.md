
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
#>       ID       V2       V3      V4       V5       V6      V7       V8       V9
#> SRTT 999 884.5578 1072.724 960.116 1185.726 832.8884 969.707 1003.665 1184.637
#>           V10
#> SRTT 1057.455
```

``` r

data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_long, format = "Long")[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1018.152 977.0014 1093.651 986.4247 995.6037 938.5044 773.1436
#>            V9      V10
#> SRTT 844.1881 1125.583
```

``` r
ID <- LETTERS[1:10]

dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(10 * 500, mean = 1, sd = 0.1), nrow = 10, ncol = 500) )

head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10]) 
#>       ID               V2               V3               V4               V5
#> SRTT   A 1041.97595872556 889.421729572889 1088.33425953517 987.936613861029
#> SRTT1  B 1044.42809928137 921.377835505357 1216.15389799767 1097.82462185093
#> SRTT2  C 949.960320319959 1093.52256714917 1092.89282518735 1111.32394634425
#> SRTT3  D 851.859031398716  1057.6053414391 890.601440308166 846.365325152997
#> SRTT4  E 998.096178895149 1170.85249199883 1064.43920898286 1002.24037220981
#> SRTT5  F 1042.97439265457 1139.69001001511 849.946448170402 1211.69234423562
#>                     V6               V7               V8               V9
#> SRTT  963.925839192502 974.494781108883 1046.21950371265 870.588990957739
#> SRTT1 926.841513911732 1034.48277462566 1032.22020684657 957.259119304523
#> SRTT2 1064.40442920568 1042.95956443914 1026.08810151465 949.721453881137
#> SRTT3 827.678630024729 1129.84849862655 1122.08213483891 1052.19282756045
#> SRTT4 916.378191586671 982.535001307431 947.667123817254 1222.71398889379
#> SRTT5 1089.30728215652 945.456114672577 1060.11416673662 1171.04716333818
#>                    V10
#> SRTT              <NA>
#> SRTT1 1100.94267518783
#> SRTT2 929.884828675894
#> SRTT3 931.757757717692
#> SRTT4 777.297377897696
#> SRTT5 1004.46875062524
```

``` r

dataframe_long <- as.data.frame(t(dataframe_wide))

head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10]) 
#>       ID        V2        V3        V4        V5        V6        V7        V8
#> SRTT   A  1041.976  889.4217 1088.3343  987.9366  963.9258  974.4948 1046.2195
#> SRTT1  B 1044.4281  921.3778 1216.1539 1097.8246  926.8415 1034.4828 1032.2202
#> SRTT2  C  949.9603 1093.5226 1092.8928 1111.3239 1064.4044 1042.9596 1026.0881
#> SRTT3  D   851.859 1057.6053  890.6014  846.3653  827.6786 1129.8485 1122.0821
#> SRTT4  E  998.0962 1170.8525 1064.4392 1002.2404  916.3782   982.535  947.6671
#> SRTT5  F 1042.9744   1139.69  849.9464 1211.6923 1089.3073  945.4561 1060.1142
#>              V9       V10
#> SRTT    870.589      <NA>
#> SRTT1  957.2591 1100.9427
#> SRTT2  949.7215  929.8848
#> SRTT3 1052.1928  931.7578
#> SRTT4  1222.714  777.2974
#> SRTT5 1171.0472 1004.4688
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1  Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10 10.55556        12 10.71429       14 12.33333         6   11.75
#>   preRND_3  Train_3 postRND_3  Skill_3
#> 1       10 11.66667        12 11.42857
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999     12.5 10.66667        15    11.5     12.5 10.66667  13.33333   11.25
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1      7.5 8.333333  8.333333    8.25
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
#> 1   A       14               20        10 17.1428571428571       18
#> 2   B       18 18.8888888888889        24 19.6428571428571       12
#> 3   C        6                5         4                5       10
#> 4   D        8 15.5555555555556        16 14.2857142857143       18
#> 5   E        8 17.7777777777778        22 16.7857142857143       20
#> 6   F       14 11.1111111111111         8 11.0714285714286        2
#> 7   G        4 3.88888888888889         4 3.92857142857143        8
#> 8   H       18 18.3333333333333        22 18.9285714285714       28
#> 9   I       14 17.7777777777778        20             17.5        8
#> 10  J       10 17.2222222222222        10 14.6428571428571       12
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  13.3333333333333        18    14.5       10 13.3333333333333        14
#> 2  18.3333333333333        28   18.75       16 15.5555555555556        16
#> 3                 5         6    5.75        8 7.22222222222222         4
#> 4                17        16      17       16 16.1111111111111        16
#> 5                17        26    18.5       10               25        20
#> 6                13        12    11.5       10 15.5555555555556        14
#> 7                 6         4       6        0 3.88888888888889         0
#> 8  12.6666666666667        20    15.5       16               15        24
#> 9                24        24      22       22 17.2222222222222        16
#> 10 15.3333333333333         8      14       12 13.8888888888889        14
#>             Skill_3
#> 1  12.8571428571429
#> 2  15.7142857142857
#> 3  6.78571428571429
#> 4  16.0714285714286
#> 5  21.4285714285714
#> 6  14.2857142857143
#> 7               2.5
#> 8  16.7857142857143
#> 9  17.8571428571429
#> 10 13.5714285714286
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A       14               20        10 17.1428571428571       18
#> 2   B       18 18.8888888888889        24 19.6428571428571       12
#> 3   C        6                5         4                5       10
#> 4   D        8 15.5555555555556        16 14.2857142857143       18
#> 5   E        8 17.7777777777778        22 16.7857142857143       20
#> 6   F       14 11.1111111111111         8 11.0714285714286        2
#> 7   G        4 3.88888888888889         4 3.92857142857143        8
#> 8   H       18 18.3333333333333        22 18.9285714285714       28
#> 9   I       14 17.7777777777778        20             17.5        8
#> 10  J       10 17.2222222222222        10 14.6428571428571       12
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1  13.3333333333333        18    14.5       10 13.3333333333333        14
#> 2  18.3333333333333        28   18.75       16 15.5555555555556        16
#> 3                 5         6    5.75        8 7.22222222222222         4
#> 4                17        16      17       16 16.1111111111111        16
#> 5                17        26    18.5       10               25        20
#> 6                13        12    11.5       10 15.5555555555556        14
#> 7                 6         4       6        0 3.88888888888889         0
#> 8  12.6666666666667        20    15.5       16               15        24
#> 9                24        24      22       22 17.2222222222222        16
#> 10 15.3333333333333         8      14       12 13.8888888888889        14
#>             Skill_3
#> 1  12.8571428571429
#> 2  15.7142857142857
#> 3  6.78571428571429
#> 4  16.0714285714286
#> 5  21.4285714285714
#> 6  14.2857142857143
#> 7               2.5
#> 8  16.7857142857143
#> 9  17.8571428571429
#> 10 13.5714285714286
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1  Train_1 postRND_1    Skill_1  preRND_2   Train_2 postRND_2
#> 1 999 1.000229 1.013868  1.031925 0.01805767 0.9892627 0.9911951  0.993996
#>       Skill_2  preRND_3  Train_3 postRND_3    Skill_3
#> 1 0.002800932 0.9864433 1.013232  1.008116 -0.0051159
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID  preRND_1  Train_1 postRND_1       Skill_1  preRND_2   Train_2 postRND_2
#> 1 999 0.9948882 0.995902 0.9956887 -0.0002132389 0.9903942 0.9664473  1.023667
#>      Skill_2 preRND_3  Train_3 postRND_3    Skill_3
#> 1 0.05721948 1.015067 0.977724  1.018004 0.04028049
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A 0.999071352985157  1.01143787355136 0.995612534318132  -0.0158253392332298
#> 2  B  1.01060253626538 0.998616472053505  0.98213019573767   -0.016486276315835
#> 3  C  1.02359887216017  1.01420269785286  0.98348708818622  -0.0307156096666381
#> 4  D 0.993434194284565  1.02955665401325  1.02817900331823 -0.00137765069502338
#> 5  E 0.993509939480881 0.986748935536473  1.00254236309226   0.0157934275557914
#>            preRND_2           Train_2         postRND_2               Skill_2
#> 1 0.979593385923611 0.985801175247483 0.992541434588229   0.00674025934074629
#> 2 0.994930145709942  1.00221594183136  1.00350550983533   0.00128956800396329
#> 3  1.00506814105331 0.999257915350125 0.993464511285748  -0.00579340406437712
#> 4 0.984263063256346 0.975938799600924  1.01141717734701     0.035478377746088
#> 5  1.00084446224518 0.993326593525151  0.99312183816361 -0.000204755361541742
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1 0.981100460821568  1.00078736334014 0.998816317692144 -0.00197104564799611
#> 2  1.00836617781514 0.993045239459624 0.988299330370326 -0.00474590908929717
#> 3  1.00243344043591 0.979897229391248 0.999116333181182   0.0192191037899339
#> 4 0.983285878995602 0.999118409829127  0.98704238997158  -0.0120760198575466
#> 5  1.00804032444618  1.01196162061096 0.975480910070151  -0.0364807105408063
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1              Skill_1
#> 1  A   1.0068209134855 0.989486316577102  1.01185067316881    0.022364356591709
#> 2  B  1.00886397860213 0.987726387433355  1.02576607683691   0.0380396894035597
#> 3  C  1.02806445898385  1.00454334050437 0.996985008657173 -0.00755833184719379
#> 4  D 0.986069313213444  1.00831169124519  1.01760749980276   0.0092958085575674
#> 5  E 0.984535827055082  1.00159819149948  1.00485152765844  0.00325333615895529
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1 0.991161922520748 0.989109549514335  1.01264958640681   0.0235400368924785
#> 2  0.97813728241006 0.999399498071827  1.00148215664858  0.00208265857675327
#> 3 0.985784422887313 0.996990818208938  1.00437913488605  0.00738831667711415
#> 4  1.00641903056535 0.986387434739809   1.0176217590343   0.0312343242944874
#> 5  1.02162371756194 0.998136844330861 0.991432535878792 -0.00670430845206826
#>            preRND_3           Train_3         postRND_3              Skill_3
#> 1  1.01057231074888  0.99525216980378 0.995499552006233 0.000247382202453239
#> 2  1.01095048603035 0.993940205110954 0.991868302994138 -0.00207190211681596
#> 3 0.978633334774804 0.988501984328867  1.00668010508374   0.0181781207548766
#> 4 0.965192683488549 0.999843270704288 0.972840411529235  -0.0270028591750524
#> 5 0.977120356677815 0.998121560730228 0.969102802647771   -0.029018758082457
```

``` r
random_list_w <- cbind(999, (as.data.frame(t(stats::rnorm(500, mean = 1, sd = 0.1)))))


png("plot1.png", width = 800, height = 600)

plot <- plot_data(random_list_w,format = "Wide" , limit_y_axis_min_max = TRUE,  limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.1,   standard_error = FALSE, color_dots = "black",   color_line = "grey",  color_intercept = "grey")

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
