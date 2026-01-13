
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SRTTAnalysis <img src="man/figures/logo2.png" align="right" height="139"/>

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

## Visual summary for SRTT_analysis function

![](man/figures/visual_summary.png)

## Example

Basic examples which show you how to run the code and what output to
expect:

``` r
library(SRTTAnalysis)

data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
head(SRTT_analysis(data_wide, format = "Wide", normalize_when = 0)[, 1:10])
#>       ID       V2       V3       V4       V5       V6       V7       V8
#> SRTT 999 1044.261 961.8445 973.2335 1014.588 896.7612 959.7739 1021.548
#>            V9      V10
#> SRTT 905.6385 1077.269
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
#>       ID        V2        V3        V4       V5        V6        V7        V8
#> SRTT   A 1097.9556 1073.9156 1008.9309 979.9437  973.5562 1090.8436 1052.4546
#> SRTT1  B 1116.4367  924.1834 1085.7588 946.2668  980.1357  917.1996 1029.7749
#> SRTT2  C  931.1892 1080.2228 1064.5274 909.1817  997.9547  942.0799  876.2762
#> SRTT3  D  869.3393  960.3619  794.9855  990.405  856.7179 1001.1788  822.0325
#> SRTT4  E  972.6381 1051.9295 1170.4813 808.2983 1061.5915  1155.446  979.3847
#> SRTT5  F  891.5141  1058.982 1072.6228 1037.112  992.6091  975.2012 1073.5003
#>              V9       V10
#> SRTT  1059.6437      <NA>
#> SRTT1 1081.2926  915.8623
#> SRTT2  872.8209 1146.3056
#> SRTT3  987.6223 1025.7047
#> SRTT4  901.9046 1196.2533
#> SRTT5 1076.9781  970.8584
```

``` r
random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)

num_nas <- sample(50:150, 1)

random_values[sample(1200, num_nas)] <- NA

random_list_w <- data.frame(ID = 999, t(random_values))

percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1  Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999        8 11.66667         6      10       16 10.66667        10   11.25
#>   preRND_3 Train_3 postRND_3  Skill_3
#> 1       14      10        22 12.85714
```

``` r
random_list_l <- as.data.frame(t(random_list_w))

percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
#>    ID preRND_1 Train_1 postRND_1 Skill_1 preRND_2  Train_2 postRND_2 Skill_2
#> 1 999       10      11  11.66667      11     12.5 10.33333        10    10.5
#>   preRND_3  Train_3 postRND_3 Skill_3
#> 1     12.5 12.33333  11.66667   12.25
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
#> 1   A        8 18.8888888888889         8               15       16
#> 2   B       14 16.1111111111111        10 14.6428571428571       26
#> 3   C       10 8.33333333333333         4 7.85714285714286       10
#> 4   D       10 8.88888888888889        14               10        8
#> 5   E       18 12.7777777777778        14 13.9285714285714       10
#> 6   F       20 22.7777777777778        18 21.4285714285714       14
#> 7   G        6 8.33333333333333         2 6.78571428571429        8
#> 8   H       12 4.44444444444444         0                5        4
#> 9   I       12 13.8888888888889        14 13.5714285714286       22
#> 10  J       16 22.7777777777778        28             22.5       22
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1                15        22      16       14 19.4444444444444        10
#> 2                17        16      18       18 16.6666666666667        18
#> 3                12        10    11.5       12 11.6666666666667        12
#> 4  5.33333333333333         8       6        8 6.11111111111111         2
#> 5  12.6666666666667         8   11.75       12               15        14
#> 6                16        20   16.25       18 23.3333333333333         8
#> 7                 8         6    7.75        4 7.22222222222222         6
#> 8                 8        16     8.5        8 7.77777777777778         6
#> 9  20.6666666666667        18    20.5       18               15        22
#> 10 20.6666666666667        18    20.5       14 18.8888888888889        10
#>             Skill_3
#> 1  16.7857142857143
#> 2  17.1428571428571
#> 3  11.7857142857143
#> 4  5.71428571428571
#> 5  14.2857142857143
#> 6  19.6428571428571
#> 7  6.42857142857143
#> 8               7.5
#> 9  16.7857142857143
#> 10 16.4285714285714
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#>    ID preRND_1          Train_1 postRND_1          Skill_1 preRND_2
#> 1   A        8 18.8888888888889         8               15       16
#> 2   B       14 16.1111111111111        10 14.6428571428571       26
#> 3   C       10 8.33333333333333         4 7.85714285714286       10
#> 4   D       10 8.88888888888889        14               10        8
#> 5   E       18 12.7777777777778        14 13.9285714285714       10
#> 6   F       20 22.7777777777778        18 21.4285714285714       14
#> 7   G        6 8.33333333333333         2 6.78571428571429        8
#> 8   H       12 4.44444444444444         0                5        4
#> 9   I       12 13.8888888888889        14 13.5714285714286       22
#> 10  J       16 22.7777777777778        28             22.5       22
#>             Train_2 postRND_2 Skill_2 preRND_3          Train_3 postRND_3
#> 1                15        22      16       14 19.4444444444444        10
#> 2                17        16      18       18 16.6666666666667        18
#> 3                12        10    11.5       12 11.6666666666667        12
#> 4  5.33333333333333         8       6        8 6.11111111111111         2
#> 5  12.6666666666667         8   11.75       12               15        14
#> 6                16        20   16.25       18 23.3333333333333         8
#> 7                 8         6    7.75        4 7.22222222222222         6
#> 8                 8        16     8.5        8 7.77777777777778         6
#> 9  20.6666666666667        18    20.5       18               15        22
#> 10 20.6666666666667        18    20.5       14 18.8888888888889        10
#>             Skill_3
#> 1  16.7857142857143
#> 2  17.1428571428571
#> 3  11.7857142857143
#> 4  5.71428571428571
#> 5  14.2857142857143
#> 6  19.6428571428571
#> 7  6.42857142857143
#> 8               7.5
#> 9  16.7857142857143
#> 10 16.4285714285714
```

``` r
data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))

Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>    ID preRND_1   Train_1 postRND_1      Skill_1 preRND_2   Train_2 postRND_2
#> 1 999 1.003699 0.9786158 0.9735664 -0.005049365  1.01485 0.9997396 0.9804708
#>       Skill_2  preRND_3  Train_3 postRND_3      Skill_3
#> 1 -0.01926883 0.9961846 1.014341  1.006672 -0.007669217
```

``` r
data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))

skill <- Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)

skill
#>    ID preRND_1   Train_1 postRND_1    Skill_1  preRND_2  Train_2 postRND_2
#> 1 999 1.013476 0.9816946  1.014415 0.03272041 0.9946301 1.011789 0.9964855
#>       Skill_2 preRND_3   Train_3 postRND_3    Skill_3
#> 1 -0.01530321 1.008105 0.9963799  1.038697 0.04231757
```

``` r

random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)

random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)

skill_df <- Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)

skill_df 
#>   ID          preRND_1           Train_1         postRND_1             Skill_1
#> 1  A  1.04425198183905  1.00769030189604 0.985910124503173 -0.0217801773928692
#> 2  B   1.0208151317908 0.999112852939954 0.985538928757077 -0.0135739241828773
#> 3  C 0.988863152213793  0.98949519621822 0.993153666143068 0.00365846992484753
#> 4  D 0.982262247979667 0.991896614934844  1.02488763008592  0.0329910151510777
#> 5  E 0.984062461412145 0.991933317023291 0.970450556000349 -0.0214827610229426
#>            preRND_2           Train_2         postRND_2              Skill_2
#> 1  1.02582509480855 0.997882489001473  1.01208117187413   0.0141986828726544
#> 2   1.0195267630017  1.00142151360886 0.990275377487969  -0.0111461361208897
#> 3  0.99404261282165  1.01287593724316 0.999893581421086  -0.0129823558220693
#> 4 0.987402994233304  1.00032696928553  1.01193209286992    0.011605123584391
#> 5  0.99665831879383  1.01611852006204  1.01420451302871 -0.00191400703333722
#>            preRND_3          Train_3         postRND_3              Skill_3
#> 1 0.984144065304991 0.99895550609196  1.01834561843395   0.0193901123419876
#> 2 0.992431460166781 1.01694774510692 0.986271621917688   -0.030676123189231
#> 3  1.00421521553118  1.0140601658285 0.998785449652263   -0.015274716176239
#> 4 0.988823470268265 1.00072062945492 0.991960629866419 -0.00875999958850293
#> 5 0.997529001859437 0.99888401599746 0.989136203265462 -0.00974781273199843
```

``` r
random_df_l <- as.data.frame(t(random_df_w))

Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
#>   ID          preRND_1           Train_1         postRND_1
#> 1  A  1.04777296156401  1.00893270071137 0.981022169146356
#> 2  B  1.02742152415532  1.00614446769006  1.00560285440196
#> 3  C  1.00072104474869 0.991077741903588  1.00539759834528
#> 4  D 0.982110492007978   1.0011667404446 0.981813440693738
#> 5  E 0.980434531755349  0.99388332580926  1.00261064722107
#>                 Skill_1          preRND_2           Train_2         postRND_2
#> 1   -0.0279105315650151  1.00726545045713 0.996595863238036  1.00736845751344
#> 2 -0.000541613288102871 0.976683929575534 0.995070238751369 0.987860827073403
#> 3    0.0143198564416959  1.00138298535015  1.00733085752694  1.01420844526409
#> 4    -0.019353299750858 0.987073069383484 0.996322893022049 0.986761779556408
#> 5   0.00872732141181376  1.00824968966506 0.997899854380634 0.997281804335202
#>                Skill_2          preRND_3           Train_3         postRND_3
#> 1   0.0107725942754027 0.980380513360883  1.00456886016055  1.00883422867122
#> 2 -0.00720941167796618 0.991312615648555  1.00643051849231 0.979219430143696
#> 3  0.00687758773715186 0.983765671496438 0.995570454122783 0.994046722552493
#> 4 -0.00956111346564059  1.00613042981588  1.00151971796071 0.994959158447615
#> 5 -0.00061805004543225 0.988169011674211  1.00297505244379 0.981210875497943
#>                Skill_3
#> 1  0.00426536851066395
#> 2  -0.0272110883486095
#> 3 -0.00152373157029029
#> 4 -0.00656055951309764
#> 5  -0.0217641769458439
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
