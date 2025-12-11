#' SRTT_analysis
#'
#' This function helps streamlining analysis of reaction time data, like the Serial Reaction Time Task (SRTT)
#'
#' The functions goes over the 'data' file.
#' We expect 'data' to have one column for each subject, with ID on top.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Units are preferred in milliseconds but we also handle when presented in seconds
#' The fixed boundary are to remove predictive reaction times (<200ms) or when subject was distracted (>2000ms)
#' The default value is 2 standard deviation and a window size of ~2.5% of the total number of trials
#'
#' @param data Single participant data, including their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param unit Unit of the response times, can take either "Seconds" or "Milliseconds"
#' @param type_of_filtering What type of filtering do you want to apply?  "Fixed_Window" only applies a fixed window type, instead, "Rolling_Standard_Deviation", only applies a rolling window "Fixed_and_Rolling", first applies a fixed window and then a rolling window
#' @param lower_boundary_fixed_filtering_milliseconds During the 'Fixed_Window' filtering what is the lower boundary (in milliseconds)? Enter an integer
#' @param upper_boundary_fixed_filtering_milliseconds During the 'Fixed_Window' filtering what is the upper boundary (in milliseconds)? Enter an integer
#' @param standard_deviations During the 'Rolling_Standard_Deviation' filtering, how many standard deviations from the mean do you want to filter? Enter a numeric value > 1
#' @param running_window_width_percentage During the 'Rolling_Standard_Deviation' filtering, how large is the rolling window? Enter a numeric value from 0 to 1
#' @return A file in wide format with all the reaction time data filtered
#' @export
#' @examples
#' # Basic usage
#' data_wide <- data.frame(id = 999, t(rnorm(500, mean = 1, sd = 0.1)))
#' head(SRTT_analysis(data_wide, format = "Wide")[, 1:10])
#'
#' data_long <- data.frame(value = c(999, rnorm(500, mean = 1, sd = 0.1)))
#' head(SRTT_analysis(data_long, format = "Long")[, 1:10])
SRTT_analysis <- function(data,
                          format = "Long",
                          unit = "Seconds",
                          type_of_filtering = "Rolling_Standard_Deviation",
                          lower_boundary_fixed_filtering_milliseconds = 200,
                          upper_boundary_fixed_filtering_milliseconds = 2000,
                          standard_deviations = 2,
                          running_window_width_percentage = 0.025
                          ){

  # Initialize empty data frames
  df_1 <- NULL

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    data <- tidyr::pivot_longer(data,
                         cols=1:ncol((data)),
                         names_to='var',
                         values_to='ResponseTime')

    data <- subset(data, select=-var)


  }


  # Change coloumn name to dataframe
  colnames(data)[1] <- "ResponseTime"

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if format == "Long" , we need to save ID
  if (format == "Long"){

    # find current ID number
    current_id <- data[1,]


    # remove current ID number
    data <- data[-1,]

  }

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  data_frame <- as.data.frame(data)
  colnames(data_frame)[1] <- "ResponseTime"

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # Make sure data are numeric values


  if (format == "Long"){

    data_frame <- as.numeric((data_frame$ResponseTime))
  }


  if (format == "Wide"){

    data_frame <- as.numeric(unlist(data_frame$ResponseTime))

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if the unit == "Seconds"
  # transform the unit from Second to Milliseconds

  if (unit == "Seconds"){

    data_frame <- data_frame*1000

  }

  # ----
  #   <><><><><><><><><><><><>  FILTERING WITH FIXED WINDOW <><><><><><><><><><><><> ----


  #  Filter trials where they might have taken a break and where they are too quick


  if (type_of_filtering == "Fixed_Window"){


    filter_aa <- dplyr::between(data_frame, lower_boundary_fixed_filtering_milliseconds, upper_boundary_fixed_filtering_milliseconds)

    l <- which(filter_aa == FALSE)                     # FIND THE INDEX OF THOSE VALUES OUTSIDE THE RANGE
    data_frame_1 <- data_frame
    data_frame_1[l] <- NA                               # GIVE AN na TO THESE INDEXES WE FOUND






  }



  # ----
  #   <><><><><><><><><><><><>  FILTERING WITH ROLLING STANDARD DEVIATION <><><><><><><><><><><><> ----

  if (type_of_filtering == "Rolling_Standard_Deviation"){


    # we need to go from percentage sign to an actual number of trials
    running_window_width <- ceiling(running_window_width_percentage * length(data_frame))

    # calculate the running standard deviation and running mean
    rolling_standard_deviation <- runner::runner( data_frame ,
                                                  k = running_window_width ,
                                                  f = stats::sd ,
                                                  na_pad = FALSE) # CALCULATED ROLLING STD
    rolling_mean <- runner::runner( data_frame ,
                                    k = running_window_width ,
                                    f = mean ,
                                    na_pad = FALSE) # CALCULATE ROLLING MEAN

    # calculate the running mean plus and minus the running standard deviation
    mini <- rolling_mean - (standard_deviations * rolling_standard_deviation)              # MEAN MINUS X STD
    maxi <- rolling_mean + (standard_deviations * rolling_standard_deviation)                # MEAN PLUS X STD


    filter_aa <- dplyr::between(data_frame, mini, maxi)   # RETURNS A LOGICAL VECTOR SAYING WHETHER THAT INDEX IS BETWEEN THESE TWO LIMITS
    indices <- base::which(filter_aa == FALSE)                                    # FIND INDEXES
    data_frame_1 <- data_frame
    data_frame_1[indices] <- NA               # REPLACE WITH na

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  }


  # ----
  #   <><><><><><><><><><><><>  FILTERING WITH FIXED WINDOW AND ROLLING STANDARD DEVIATION <><><><><><><><><><><><> ----

  if (type_of_filtering == "Fixed_and_Rolling"){

    #  Filter trials where they might have taken a break and where they are too quick
    filter_aa <- dplyr::between(data_frame, lower_boundary_fixed_filtering_milliseconds, upper_boundary_fixed_filtering_milliseconds)
    l <- which(filter_aa == FALSE)                     # FIND THE INDEX OF THOSE VALUES OUTSIDE THE RANGE
    data_frame_1 <- data_frame
    data_frame_1[l] <- NA                               # GIVE AN na TO THESE INDEXES WE FOUND


    # we need to go from percentage sign to an actual number of trials
    running_window_width <- ceiling(running_window_width_percentage * length(data_frame))

    # calculate the running standard deviation and running mean
    rolling_standard_deviation <- runner::runner( data_frame_1 ,
                                                  k = running_window_width ,
                                                  f = stats::sd ,
                                                  na_pad = FALSE) # CALCULATED ROLLING STD
    rolling_mean <- runner::runner( data_frame_1 ,
                                    k = running_window_width ,
                                    f = mean ,
                                    na_pad = FALSE) # CALCULATE ROLLING MEAN

    # calculate the running mean plus and minus the running standard deviation
    mini <- rolling_mean - (standard_deviations * rolling_standard_deviation)              # MEAN MINUS X STD
    maxi <- rolling_mean + (standard_deviations * rolling_standard_deviation)                # MEAN PLUS X STD


    filter_aa <- dplyr::between(data_frame_1, mini, maxi)   # RETURNS A LOGICAL VECTOR SAYING WHETHER THAT INDE IS BETWEEN THESE TWO LIMITS
    indices <- base::which(filter_aa == FALSE)                                    # FIND INDEXES
    data_frame_1[indices] <- NA               # REPLACE WITH na

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  }

  # ----
  #   <><><><><><><><><><><><>    POST-FILTERING   <><><><><><><><><><><><> ----

  # make sure it is a data frame
  # data_frame_1: HAS SRTT VALUE (with NaN) AND TRIAL_NUMBER
  data_frame_1 <- as.data.frame((data_frame_1))
  colnames(data_frame_1)[1] <- "SRTT"

  # ADD ID
  data_data_frame_1  <- as.data.frame( t ( rbind(current_id , data_frame_1)))
  # data_data_frame_1  <- as.data.frame( t ( data_frame_1))

  # Rename it 'ID'
  colnames(data_data_frame_1)[1] <- "ID"



  # add these observations to a data frame and save it to the workspace
  df_1 <-  rbind(df_1, data_data_frame_1)

  return(df_1)

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # ----
  #   <><><><><><><><><><><><>      END   <><><><><><><><><><><><> ----
  # ----

}



#' SRTT_analysis_for_Dataframes
#'
#' This function is a wrapper for 'SRTT_analysis' to handle dataframes as input data
#' The functions goes over the 'data' file.
#' We expect 'data' to have one column for each subject, with ID on top.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Units are preferred in milliseconds but we also handle when presented in seconds
#' The fixed boundary are to remove predictive reaction times (<200ms) or when subject was distracted (>2000ms)
#' The default value is 2 standard deviation and a window size of ~2.5% of the total number of trials
#'
#' @param data Dataframe including participant data, and their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param unit Unit of the response times, can take either "Seconds" or "Milliseconds"
#' @param type_of_filtering What type of filtering do you want to apply?  "Fixed_Window" only applies a fixed window type, instead, "Rolling_Standard_Deviation", first applies a fixed windown and then a rolling window
#' @param lower_boundary_fixed_filtering_milliseconds During the 'Fixed_Window' filtering what is the lower boundary (in milliseconds)? Enter an integer
#' @param upper_boundary_fixed_filtering_milliseconds During the 'Fixed_Window' filtering what is the upper boundary (in milliseconds)? Enter an integer
#' @param standard_deviations During the 'Rolling_Standard_Deviation' filtering, how many standard deviations from the mean do you want to filter? Enter a numeric value > 1
#' @param running_window_width_percentage During the 'Rolling_Standard_Deviation' filtering, how large is the rolling window? Enter a numeric value from 0 to 1
#' @return A file in wide format with all the reaction time data filtered, and one row for each participant
#' @export
#' @examples
#' # Basic usage
#' ID <- LETTERS[1:5]
#' dataframe_wide <- data.frame(ID = ID, matrix(stats::rnorm(5 * 500, mean = 1, sd = 0.1), nrow = 5, ncol = 500) )
#' head(SRTT_analysis_for_Dataframes(dataframe_wide, format = "Wide")[, 1:10])
#'
#' dataframe_long <- as.data.frame(t(dataframe_wide))
#' head(SRTT_analysis_for_Dataframes(dataframe_long, format = "Long" ,running_window_width_percentage = 0.3)[, 1:10])
SRTT_analysis_for_Dataframes <- function(data,
                                         format = "Long",
                                         unit = "Seconds",
                                         type_of_filtering = "Rolling_Standard_Deviation",
                                         lower_boundary_fixed_filtering_milliseconds = 200,
                                         upper_boundary_fixed_filtering_milliseconds = 2000,
                                         standard_deviations = 2,
                                         running_window_width_percentage = 0.025
                                         ){

  # initialise empty dataframe

  new <- NULL



  # format == wide, iterate over rows
  if (format == "Wide"){

    for (i in 1:nrow(data)){
      new <- rbind(new, SRTT_analysis(data[i, ],
                                      format = format,
                                      unit = unit,
                                      type_of_filtering = type_of_filtering,
                                      lower_boundary_fixed_filtering_milliseconds = lower_boundary_fixed_filtering_milliseconds,
                                      upper_boundary_fixed_filtering_milliseconds = upper_boundary_fixed_filtering_milliseconds,
                                      standard_deviations = standard_deviations,
                                      running_window_width_percentage = running_window_width_percentage)
      )
    }
  }




  # format == wide, iterate over coloumns
  if (format == "Long"){

    for (i in 1:ncol(data)){
      new <- rbind(new, SRTT_analysis(data[, i],
                                      format = format,
                                      unit = unit,
                                      type_of_filtering = type_of_filtering,
                                      lower_boundary_fixed_filtering_milliseconds = lower_boundary_fixed_filtering_milliseconds,
                                      upper_boundary_fixed_filtering_milliseconds = upper_boundary_fixed_filtering_milliseconds,
                                      standard_deviations = standard_deviations,
                                      running_window_width_percentage = running_window_width_percentage)
      )
    }
  }

  new <- as.data.frame(new)


  return(new)

}



#' percentage_of_filtered_values
#'
#' This function can be used to calculate the percentage of NA values in a dataframe. It could be useful to calculate the percentage of values filtered using the 'SRTT_analysis' function or to calculate the number of wrong responses (in case this are coded with an NA value)
#'
#' Going over the 'data' file.
#' We expect 'data' to have one column for each subject, with ID on top.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Need to indicate the number of rounds
#' Each round is split into three sections: Random_Pre, Training and Random_Post
#' If all rounds have the same number of trials for each section (rounds_of_equal_length = TRUE) (e.g., Random_Pre always 50 trials, Training always 300 trials and Random_Post always 50 trials), only enter once the 'design' values
#' If rounds have different number of trials for each section (rounds_of_equal_length = FALSE) (e.g., Training at round-1 is 200 trials, then at round-2 300 trials and then 400 trials), you need to specify the entirety of the design (e.g., c(50, 200, 50, 50, 300, 50, 50, 400, 50)).
#'
#' @param data Single participant data, including their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param number_of_rounds How many rounds did the participants perform? Enter an integer
#' @param rounds_of_equal_length Did the participant perform the same amount of trials in every block? TRUE/FALSE
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @return A file in wide format that gives the percentage of NA values for each section of the design
#' @export
#' @examples
#' # Basic usage
#' random_values <- stats::rnorm(1200, mean = 1, sd = 0.1)
#' num_nas <- sample(50:150, 1)
#' random_values[sample(1200, num_nas)] <- NA
#' random_list_w <- data.frame(ID = 999, t(random_values))
#' percentage_of_filtered_values(random_list_w, format = "Wide", number_of_rounds = 3,  rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#' random_list_l <- as.data.frame(t(random_list_w))
#' percentage_of_filtered_values(random_list_l, format = "Long", number_of_rounds = 3,  rounds_of_equal_length = TRUE, design = c(40, 300, 60))
percentage_of_filtered_values <- function(data,
                                          format = "Long",
                                          number_of_rounds = 3,
                                          rounds_of_equal_length = FALSE,
                                          design = c(50 , 180, 50,
                                                     50, 300, 50,
                                                     50 , 180, 50,
                                                     50 , 180, 50)
                                          ){

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    data <- tidyr::pivot_longer(data,
                         cols=1:ncol((data)),
                         names_to='var',
                         values_to='ResponseTime')

    data <- subset(data, select=-var)

  }


  # Change column name to data frame
  colnames(data)[1] <- "ResponseTime"


  # if format == "Long" , we need to save ID
  if (format == "Long"){

    # find current ID number
    current_id <- data[1,]


    # remove current ID number
    data <- data[-1,]

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # Make sure data are numeric values

  if (format == "Long"){

    data <- as.numeric((data))
  }


  if (format == "Wide"){

    data <- as.numeric(unlist(data$ResponseTime))

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # Initialize an empty data frame and give a name to its columns based on the type of column and the round number

  number_of_cols <- 1+(number_of_rounds*4) # We need one ID coloumn + three coloumns per round (Pre_RND, Train, Post_RND, Skill)

  NAs_total <- data.frame(matrix(nrow=1,ncol=number_of_cols))

  colnames(NAs_total)[1] <- "ID"


  round = 0

  for (i  in (1:number_of_rounds)){


    colnames(NAs_total)[2+round] <- paste0("preRND_" , i)
    colnames(NAs_total)[3+round] <- paste0("Train_" , i)
    colnames(NAs_total)[4+round] <- paste0("postRND_" , i)
    colnames(NAs_total)[5+round] <- paste0("Skill_" , i)

    round = round + 4

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # Make sure (again) data is a data frame .. you can never be too sure
  data_frame <- as.data.frame(data)

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # rounds_of_equal_length == TRUE ----

  if (rounds_of_equal_length == TRUE | rounds_of_equal_length == T){

    # initialize temporary data frame, this looks at one ID at a time and one round at a time
    NAs_local <- NULL


    # this helps me take a count of how many total trials have been already completed.
    # it is a counter starting at zero and at the end of each round I add the total number of trials completed.
    # I then add this total number of trials to the dplyr::slice function
    block_length = 0


    # iterate over the blocks
    for (block in  1:number_of_rounds){


      # SLICING THE DATAFRAME
      data_block_Pre <- dplyr::slice(data_frame,
                                     (1+block_length):(design[1]+block_length)
      )

      data_block_Training <- dplyr::slice(data_frame,
                                          (design[1]+block_length+1):(design[1]+design[2]+block_length)
      )

      data_block_Post <- dplyr::slice(data_frame,
                                      (design[1]+design[2]+block_length+1):(design[1]+design[2]+design[3]+block_length)
      )


      # CHANGING THE NAME OF THE REACTION TIME COLOUMN
      colnames(data_block_Pre)[1] <- "SRTT"
      colnames(data_block_Training)[1] <- "SRTT"
      colnames(data_block_Post)[1] <- "SRTT"

      # ADD A COLOUMN WITH THE NUMBER OF TRIALS
      data_block_Pre$Trial_Number <- 1:nrow(data_block_Pre)
      data_block_Training$Trial_Number <- 1:nrow(data_block_Training)
      data_block_Post$Trial_Number <- 1:nrow(data_block_Post)


      # calculate error rate for each section
      NAs_PreRND     <- sum(is.na(data_block_Pre$SRTT)) / nrow(data_block_Pre) * 100
      NAs_SEQ  <- sum(is.na(data_block_Training$SRTT)) / nrow(data_block_Training) *   100
      NAs_PostRND  <- sum(is.na(data_block_Post$SRTT)) / nrow(data_block_Post) * 100
      avg_NAs <-  (sum(is.na(data_block_Pre$SRTT)) + sum(is.na(data_block_Training$SRTT)) + sum(is.na(data_block_Post$SRTT))) /  (nrow(data_block_Pre) +  nrow(data_block_Training) + nrow(data_block_Post)) * 100

      # JOIN THE SKILLS
      NAs_local <- cbind(current_id,
                         NAs_PreRND,
                         NAs_SEQ,
                         NAs_PostRND,
                         avg_NAs)

      # Change name so to match 'NAs_local'
      colnames(NAs_local)[1] <- "ID"
      colnames(NAs_local)[2] <- paste0("preRND_" , block)
      colnames(NAs_local)[3] <- paste0("Train_" , block)
      colnames(NAs_local)[4] <- paste0("postRND_" , block)
      colnames(NAs_local)[5] <- paste0("Skill_" , block)



      # make it into data frame
      NAs_local <- as.data.frame(NAs_local)

      # bind it to the data frame which will be outputted and saved
      NAs_total <- dplyr::bind_rows(NAs_total, NAs_local)

      # update block_length
      block_length = (design[1]+design[2]+design[3]) * block


    }


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # the first row will be empty, remove it
    NAs_total <- utils::tail(NAs_total, -1)

    # consolidate multiple rows with the same ID by filling in the NA values and save it to the workspace
    NAs_total <- NAs_total |>
      dplyr::group_by(ID) |>
      dplyr::summarise(dplyr::across(dplyr::everything(), ~dplyr::first(stats::na.omit(.))))

    NAs_total <- as.data.frame(NAs_total)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  }





  # ----
  # rounds_of_equal_length == FALSE ----

  if (rounds_of_equal_length == FALSE | rounds_of_equal_length == F){


    # initialize temporary data frame, this looks at one ID at a time and one round at a time
    NAs_local <- NULL



    # this helps me take a count of how many total trials have been already completed.
    # it is a counter starting at zero and at the end of each round I add the total number of trials completed.
    # I then add this total number of trials to the dplyr::slice function
    block_length = 0


    # this helps me take a count of what index i am in the 'design' vector
    # it is a counter starting at zero and at the end of each round I add a '3', which is the number of indexes already used (rnd-pre, training, rnd-post)
    # i add this value to the index of design[]
    # i need this also in block_length when adding up the number of trials performed. I use block_number to update the index of design[]
    block_number = 0


    for (block in  1:number_of_rounds){


      # SLICING THE DATAFRAME
      data_block_Pre <- dplyr::slice(data_frame,
                                     (1+block_length):(design[1+block_number]+block_length)
      )

      data_block_Training <- dplyr::slice(data_frame,
                                          (design[1+block_number]+block_length+1):(design[1+block_number]+design[2+block_number]+block_length)
      )

      data_block_Post <- dplyr::slice(data_frame,
                                      (design[1+block_number]+design[2+block_number]+block_length+1):(design[1+block_number]+design[2+block_number]+design[3+block_number]+block_length)
      )


      # CHANGING THE NAME OF THE REACTION TIME COLOUMN
      colnames(data_block_Pre)[1] <- "SRTT"
      colnames(data_block_Training)[1] <- "SRTT"
      colnames(data_block_Post)[1] <- "SRTT"

      # ADD A COLOUMN WITH THE NUMBER OF TRIALS
      data_block_Pre$Trial_Number <- 1:nrow(data_block_Pre)
      data_block_Training$Trial_Number <- 1:nrow(data_block_Training)
      data_block_Post$Trial_Number <- 1:nrow(data_block_Post)


      # calculate error rate for each section
      NAs_PreRND     <- sum(is.na(data_block_Pre$SRTT)) / nrow(data_block_Pre) * 100
      NAs_SEQ  <- sum(is.na(data_block_Training$SRTT)) / nrow(data_block_Training) *   100
      NAs_PostRND  <- sum(is.na(data_block_Post$SRTT)) / nrow(data_block_Post) * 100
      avg_NAs <-  (sum(is.na(data_block_Pre$SRTT)) + sum(is.na(data_block_Training$SRTT)) + sum(is.na(data_block_Post$SRTT))) /  (nrow(data_block_Pre) +  nrow(data_block_Training) + nrow(data_block_Post)) * 100

      # JOIN THE SKILLS
      NAs_local <- cbind(current_id,
                         NAs_PreRND,
                         NAs_SEQ,
                         NAs_PostRND,
                         avg_NAs)

      # Change name so to match 'NAs_local'
      colnames(NAs_local)[1] <- "ID"
      colnames(NAs_local)[2] <- paste0("preRND_" , block)
      colnames(NAs_local)[3] <- paste0("Train_" , block)
      colnames(NAs_local)[4] <- paste0("postRND_" , block)
      colnames(NAs_local)[5] <- paste0("Skill_" , block)


      # make it into data frame
      NAs_local <- as.data.frame(NAs_local)



      # bind it to the data frame which will be outputted and saved
      NAs_total <- dplyr::bind_rows(NAs_total, NAs_local)


      # update block_length
      block_length = block_length + (design[1+block_number]+design[2+block_number]+design[3+block_number])

      # update block_number
      block_number = block_number + 3


    }


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # the first row will be empty, remove it
    NAs_total <- utils::tail(NAs_total, -1)

    # consolidate multiple rows with the same ID by filling in the NA values and save it to the workspace
    NAs_total <- NAs_total |>
      dplyr::group_by(ID) |>
      dplyr::summarise(dplyr::across(dplyr::everything(), ~data.table::first(stats::na.omit(.))))


    NAs_total <- as.data.frame(NAs_total)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  }

  # ----
  # Return ----


  return(NAs_total)


}


#' percentage_of_filtered_values_for_Dataframe
#'
#' This function is a wrapper for 'SRTT_analysis_for_Dataframes' to handle dataframes as input data
#' Going over the 'data' file.
#' We expect 'data' to have one column for each subject, with ID on top.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Need to indicate the number of rounds
#' Each round is split into three sections: Random_Pre, Training and Random_Post
#' If all rounds have the same number of trials for each section (rounds_of_equal_length = TRUE) (e.g., Random_Pre always 50 trials, Training always 300 trials and Random_Post always 50 trials), only enter once the 'design' values
#' If rounds have different number of trials for each section (rounds_of_equal_length = FALSE) (e.g., Training at round-1 is 200 trials, then at round-2 300 trials and then 400 trials), you need to specify the entirety of the design (e.g., c(50, 200, 50, 50, 300, 50, 50, 400, 50)).
#'
#' @param data Dataframe including participant data, and their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param number_of_rounds How many rounds did the participants perform? Enter an integer
#' @param rounds_of_equal_length Did the participant perform the same amount of trials in every block? TRUE/FALSE
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @return A file in wide format that gives the percentage of NA values for each section of the design
#' @export
#' @examples
#' # Basic usage
#'random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)
#'for (i in 1:5) { num_nas <- sample(50:300, 1)
#'random_matrix[i, sample(1200, num_nas)] <- NA }
#'random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)
#'percentage_of_filtered_values_for_Dataframe(random_df_w, format = "Wide", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
#'random_df_l <- as.data.frame(t(random_df_w))
#'percentage_of_filtered_values_for_Dataframe(data = random_df_l,format = "Long", number_of_rounds = 3, rounds_of_equal_length = FALSE, design = c(50 , 180, 50, 50, 300, 50, 50 , 180, 50, 50 , 180, 50))
percentage_of_filtered_values_for_Dataframe <-function(data,
                                                       format = "Long",
                                                       number_of_rounds = 3,
                                                       rounds_of_equal_length = FALSE,
                                                       design = c(50 , 180, 50,
                                                                  50, 300, 50,
                                                                  50 , 180, 50,
                                                                  50 , 180, 50)
                                                       ){
  # initialise empty dataframe
  new <- NULL


  # format == wide, iterate over rows
  if (format == "Wide"){
    for (i in 1:nrow(data)){

      new <- rbind(new, percentage_of_filtered_values(data = data[i,],
                                                      format = format,
                                                      number_of_rounds = number_of_rounds,
                                                      rounds_of_equal_length = rounds_of_equal_length,
                                                      design = design))
    }
  }



  # format == wide, iterate over coloumns
  if (format == "Long"){
    for (i in 1:ncol(data)){
      new <- rbind(new, percentage_of_filtered_values(data = data[, i],
                                                      format = format,
                                                      number_of_rounds = number_of_rounds,
                                                      rounds_of_equal_length = rounds_of_equal_length,
                                                      design = design))

    }
  }

  return (new)

}


#' Calculate_Skill_Sequence
#'
#' This function calculates the Skill for each round. Skill is calculate as the difference between final random and sequential button presses. We calculate the 'advantage' of one over the other
#'
#' Going over the 'data' file.
#' We expect 'data' to have one column for each subject.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Need to indicate the number of rounds
#' Each round is split into three sections: Random_Pre, Training and Random_Post
#' If all rounds have the same number of trials for each section (rounds_of_equal_length = TRUE') (e.g., Random_Pre always 50 trials, Training always 300 trials and Random_Post always 50 trials), only enter once 'design' what the value is for each section.
#' If rounds have different number of trials for each section (rounds_of_equal_length = FALSE) (e.g., Training at round-1 is 200 trials, then at round-2 300 trials and then 400 trials), you need to specify the entirety of the design (e.g., c(50, 200, 50, 50, 300, 50, 50, 400, 50)).
#' Random_Pre, Training and Random_Post are free to change.
#' "automatically_select_span" runs the loess.as	function from the fANCOVA package, which fits a local polynomial regression with automatic smoothing parameter selection via generalized cross-validation
#' The default value for 'span_random' is 20% of the total number of trials
#' The default value for 'span_training' is 14% of the total number of trials
#' "size_of_trial_window_for_skill_same" do you want the size of the window to calculate the skill to be the same for the SEQ and the RND?
#' If TRUE, it will use: "size_of_trial_window_for_skill_percentage", which is the number of trials to be used for calculating the skill. We generally use the last 50 trials of a 180 sequential section (~28%).
#' If "size_of_trial_window_for_skill_same" is FALSE, you will need to specify "size_of_trial_window_for_skill_percentage_SEQ" and size_of_trial_window_for_skill_percentage_RND"
#'
#' @param data Single participant data, including their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param number_of_rounds How many rounds did the participants perform? Enter an integer
#' @param rounds_of_equal_length Did the participant perform the same amount of trials in every block? TRUE/FALSE
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @param automatically_select_span Do you want to manually select the span for the loess function or do you want to automatically select it via generalized cross-validation? TRUE/FALSE
#' @param span_random How wide do you want the window of the (pre & post)random phase to be? Numeric between 0 and 1
#' @param span_training How wide do you want the window of the sequential phase to be? Numeric between 0 and 1
#' @param size_of_trial_window_for_skill_same Do you want to use the same window for calculating Skill for both random and sequential phase? TRUE/FALSE
#' @param size_of_trial_window_for_skill_percentage If you want to use the same window, select a numeric value between 0 and 1
#' @param size_of_trial_window_for_skill_percentage_SEQ If you DO NOT want to use the same window, select a numeric value between 0 and 1 for the sequential part
#' @param size_of_trial_window_for_skill_percentage_RND If you DO NOT want to use the same window, select a numeric value between 0 and 1 for the random part
#' @return A file in wide format that calculate the acquired skill for each round
#' @export
#' @examples
#' # Basic usage
#' data_wide <- data.frame(id = 999, t(rnorm(1200, mean = 1, sd = 0.1)))
#' Calculate_Skill_Sequence(data_wide, format= "Wide" , rounds_of_equal_length = FALSE, design = c(50, 200, 50, 50, 300, 50, 50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#'
#' data_long <- data.frame(value = c(999, rnorm(1200, mean = 1, sd = 0.1)))
#' Calculate_Skill_Sequence(data_long, format= "Long" , design = c(40, 300, 60), size_of_trial_window_for_skill_percentage = 0.10)
Calculate_Skill_Sequence <- function(data,
                                     format = "Long",
                                     number_of_rounds = 3,
                                     rounds_of_equal_length = TRUE,
                                     design = c(50, 300, 50),
                                     automatically_select_span = FALSE,
                                     span_random = 0.20,
                                     span_training = 0.14,
                                     size_of_trial_window_for_skill_same = TRUE,
                                     size_of_trial_window_for_skill_percentage = 0.28 ,
                                     size_of_trial_window_for_skill_percentage_SEQ = 0.1,
                                     size_of_trial_window_for_skill_percentage_RND = 0.1
                                     ){

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    data <- tidyr::pivot_longer(data,
                         cols=1:ncol((data)),
                         names_to='var',
                         values_to='ResponseTime')

    data <- subset(data, select=-var)

  }


  # Change column name to data frame
  colnames(data)[1] <- "ResponseTime"


  # if format == "Long" , we need to save ID
  if (format == "Long"){

    # find current ID number
    current_id <- data[1,]


    # remove current ID number
    data <- data[-1,]

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # Make sure data are numeric values

  if (format == "Long"){

    data <- as.numeric((data))
  }


  if (format == "Wide"){

    data <- as.numeric(unlist(data$ResponseTime))

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # Initialize an empty data frame and give a name to its columns based on the type of column and the round number

  number_of_cols <- 1+(number_of_rounds*4) # We need one ID coloumn + three coloumns per round (Pre_RND, Train, Post_RND, Skill)

  skill_total <- data.frame(matrix(nrow=1,ncol=number_of_cols))

  colnames(skill_total)[1] <- "ID"


  round = 0

  for (i  in (1:number_of_rounds)){


    colnames(skill_total)[2+round] <- paste0("preRND_" , i)
    colnames(skill_total)[3+round] <- paste0("Train_" , i)
    colnames(skill_total)[4+round] <- paste0("postRND_" , i)
    colnames(skill_total)[5+round] <- paste0("Skill_" , i)

    round = round + 4

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # Make sure (again) data is a data frame .. you can never be too sure
  data_frame <- as.data.frame(data)

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # rounds_of_equal_length == TRUE ----

  if (rounds_of_equal_length == TRUE | rounds_of_equal_length == T){

    # initialize temporary data frame, this looks at one ID at a time and one round at a time
    skill_local <- NULL


    # this helps me take a count of how many total trials have been already completed.
    # it is a counter starting at zero and at the end of each round I add the total number of trials completed.
    # I then add this total number of trials to the dplyr::slice function
    block_length = 0


    # iterate over the blocks
    for (block in  1:number_of_rounds){


      # SLICING THE DATAFRAME
      data_block_Pre <- dplyr::slice(data_frame,
                                     (1+block_length):(design[1]+block_length)
      )

      data_block_Training <- dplyr::slice(data_frame,
                                          (design[1]+block_length+1):(design[1]+design[2]+block_length)
      )

      data_block_Post <- dplyr::slice(data_frame,
                                      (design[1]+design[2]+block_length+1):(design[1]+design[2]+design[3]+block_length)
      )


      # CHANGING THE NAME OF THE REACTION TIME COLOUMN
      colnames(data_block_Pre)[1] <- "SRTT"
      colnames(data_block_Training)[1] <- "SRTT"
      colnames(data_block_Post)[1] <- "SRTT"

      # ADD A COLOUMN WITH THE NUMBER OF TRIALS
      data_block_Pre$Trial_Number <- 1:nrow(data_block_Pre)
      data_block_Training$Trial_Number <- 1:nrow(data_block_Training)
      data_block_Post$Trial_Number <- 1:nrow(data_block_Post)


      if (automatically_select_span == TRUE | automatically_select_span == T){

        #Smoothing parameters >> LOESS MODEL

        d_T <- data_block_Training |> tidyr::drop_na()
        span_training <- fANCOVA::loess.as(y = d_T$SRTT , x = d_T$Trial_Number ,
                                  degree = 1, family = 'gaussian', criterion = c("aicc", "gcv")[2])$pars$span

        d_R <- data_block_Post |> tidyr::drop_na()
        span_random <- fANCOVA::loess.as(y = d_R$SRTT , x = d_R$Trial_Number ,
                                degree = 1, family = 'gaussian', criterion = c("aicc", "gcv")[2])$pars$span



      }


      #Smoothing parameters >> LOESS MODEL

      loess_RND_Pre <- stats::loess(SRTT ~ Trial_Number, data=data_block_Pre,
                             span=span_random, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)

      loess_Training <- stats::loess(SRTT ~ Trial_Number, data=data_block_Training,
                              span=span_training, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)

      loess_RND_Post <- stats::loess(SRTT ~ Trial_Number, data=data_block_Post,
                              span=span_random, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)



      if (size_of_trial_window_for_skill_same == FALSE | size_of_trial_window_for_skill_same == F){

        window_size_training_SEQ <- round( ( nrow(data_block_Training) * size_of_trial_window_for_skill_percentage_SEQ), digits = 0)
        window_size_training_RND <- round( ( nrow(data_block_Post) * size_of_trial_window_for_skill_percentage_RND), digits = 0)
      }


      if (size_of_trial_window_for_skill_same == TRUE | size_of_trial_window_for_skill_same == T){

        # it is the same value but with two names
        window_size_training_SEQ <- round( ( nrow(data_block_Training) * size_of_trial_window_for_skill_percentage), digits = 0)
        window_size_training_RND <- window_size_training_SEQ


        if (window_size_training_SEQ >= nrow(data_block_Post)){
          stop("Error: The skill window size is larger than or equal to the number of random trials. Please reduce the size of the window")
        }


      }


      # Predict and select the mean of the last 50 values
      skills_training <- utils::tail(stats::predict(loess_Training),
                              n = window_size_training_SEQ)
      skills_training_mean_50 <- mean(skills_training[1:window_size_training_SEQ], na.rm = T)

      # we want to use the same size window for the random too
      skills_rnd_pre <- stats::predict(loess_RND_Pre)
      #skills_rnd_pre_mean_25 <- mean(skills_rnd_pre[1:25], na.rm = T)
      skills_rnd_pre_mean_50 <- mean(skills_rnd_pre[1:window_size_training_RND], na.rm = T)


      skills_rnd_post <- stats::predict(loess_RND_Post)
      #skills_rnd_post_mean_25 <- mean(skills_rnd_post[1:25], na.rm = T)
      skills_rnd_post_mean_50 <- mean(skills_rnd_post[1:window_size_training_RND], na.rm = T)


      # Calculate Skill as the difference between RND_post and Training
      skill <- skills_rnd_post_mean_50 - skills_training_mean_50



      # JOIN THE SKILLS
      skill_local <- cbind(current_id,
                           skills_rnd_pre_mean_50,
                           skills_training_mean_50,
                           skills_rnd_post_mean_50,
                           skill)

      # Change name so to match 'skill_local'
      colnames(skill_local)[1] <- "ID"
      colnames(skill_local)[2] <- paste0("preRND_" , block)
      colnames(skill_local)[3] <- paste0("Train_" , block)
      colnames(skill_local)[4] <- paste0("postRND_" , block)
      colnames(skill_local)[5] <- paste0("Skill_" , block)

      # make it into data frame
      skill_local <- as.data.frame(skill_local)

      # bind it to the data frame which will be outputted and saved
      skill_total <- dplyr::bind_rows(skill_total, skill_local)

      # update block_length
      block_length = (design[1]+design[2]+design[3]) * block


    }


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # the first row will be empty, remove it
    skill_total <- utils::tail(skill_total, -1)

    # consolidate multiple rows with the same ID by filling in the NA values and save it to the workspace
    skill_total <- skill_total |>
      dplyr::group_by(ID) |>
      dplyr::summarise(dplyr::across(dplyr::everything(), ~dplyr::first(stats::na.omit(.))))

    skill_total <- as.data.frame(skill_total)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  }





  # ----
  # rounds_of_equal_length == FALSE ----

  if (rounds_of_equal_length == FALSE | rounds_of_equal_length == F){


    # initialize temporary data frame, this looks at one ID at a time and one round at a time
    skill_local <- NULL



    # this helps me take a count of how many total trials have been already completed.
    # it is a counter starting at zero and at the end of each round I add the total number of trials completed.
    # I then add this total number of trials to the dplyr::slice function
    block_length = 0


    # this helps me take a count of what index i am in the 'design' vector
    # it is a counter starting at zero and at the end of each round I add a '3', which is the number of indexes already used (rnd-pre, training, rnd-post)
    # i add this value to the index of design[]
    # i need this also in block_length when adding up the number of trials performed. I use block_number to update the index of design[]
    block_number = 0


    for (block in  1:number_of_rounds){


      # SLICING THE DATAFRAME
      data_block_Pre <- dplyr::slice(data_frame,
                                     (1+block_length):(design[1+block_number]+block_length)
      )

      data_block_Training <- dplyr::slice(data_frame,
                                          (design[1+block_number]+block_length+1):(design[1+block_number]+design[2+block_number]+block_length)
      )

      data_block_Post <- dplyr::slice(data_frame,
                                      (design[1+block_number]+design[2+block_number]+block_length+1):(design[1+block_number]+design[2+block_number]+design[3+block_number]+block_length)
      )


      # CHANGING THE NAME OF THE REACTION TIME COLOUMN
      colnames(data_block_Pre)[1] <- "SRTT"
      colnames(data_block_Training)[1] <- "SRTT"
      colnames(data_block_Post)[1] <- "SRTT"

      # ADD A COLOUMN WITH THE NUMBER OF TRIALS
      data_block_Pre$Trial_Number <- 1:nrow(data_block_Pre)
      data_block_Training$Trial_Number <- 1:nrow(data_block_Training)
      data_block_Post$Trial_Number <- 1:nrow(data_block_Post)


      if (automatically_select_span == TRUE | automatically_select_span == T){

        #Smoothing parameters >> LOESS MODEL

        d_T <- data_block_Training |> tidyr::drop_na()
        span_training <- fANCOVA::loess.as(y = d_T$SRTT , x = d_T$Trial_Number ,
                                  degree = 1, family = 'gaussian', criterion = c("aicc", "gcv")[2])$pars$span

        d_R <- data_block_Post |> tidyr::drop_na()
        span_random <- fANCOVA::loess.as(y = d_R$SRTT , x = d_R$Trial_Number ,
                                degree = 1, family = 'gaussian', criterion = c("aicc", "gcv")[2])$pars$span

      }



      #Smoothing parameters >> LOESS MODEL
      loess_RND_Pre <- stats::loess(SRTT ~ Trial_Number, data=data_block_Pre,
                             span=span_random, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)

      loess_Training <- stats::loess(SRTT ~ Trial_Number, data=data_block_Training,
                              span=span_training, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)

      loess_RND_Post <- stats::loess(SRTT ~ Trial_Number, data=data_block_Post,
                              span=span_random, degree = 1, family = 'gaussian', se=T , na.action = na.exclude)

      # Predict and select the mean of the last 50 values
      window_size_training <- round( ( nrow(data_block_Training) * size_of_trial_window_for_skill_percentage), digits = 0)
      skills_training <- utils::tail(stats::predict(loess_Training),
                              n = window_size_training)
      skills_training_mean_50 <- mean(skills_training[1:window_size_training], na.rm = T)

      skills_rnd_pre <- stats::predict(loess_RND_Pre)
      #skills_rnd_pre_mean_25 <- mean(skills_rnd_pre[1:25], na.rm = T)
      skills_rnd_pre_mean_50 <- mean(skills_rnd_pre[1:window_size_training], na.rm = T)


      skills_rnd_post <- stats::predict(loess_RND_Post)
      #skills_rnd_post_mean_25 <- mean(skills_rnd_post[1:25], na.rm = T)
      skills_rnd_post_mean_50 <- mean(skills_rnd_post[1:window_size_training], na.rm = T)



      # Calculate Skill as the difference between RND_post and Training
      skill <- skills_rnd_post_mean_50 - skills_training_mean_50



      # JOIN THE SKILLS
      skill_local <- cbind(current_id,
                           skills_rnd_pre_mean_50,
                           skills_training_mean_50,
                           skills_rnd_post_mean_50,
                           skill)

      # Change name so to match 'skill_local'
      colnames(skill_local)[1] <- "ID"
      colnames(skill_local)[2] <- paste0("preRND_" , block)
      colnames(skill_local)[3] <- paste0("Train_" , block)
      colnames(skill_local)[4] <- paste0("postRND_" , block)
      colnames(skill_local)[5] <- paste0("Skill_" , block)


      # make it into data frame
      skill_local <- as.data.frame(skill_local)



      # bind it to the data frame which will be outputted and saved
      skill_total <- dplyr::bind_rows(skill_total, skill_local)


      # update block_length
      block_length = block_length + (design[1+block_number]+design[2+block_number]+design[3+block_number])

      # update block_number
      block_number = block_number + 3


    }


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # the first row will be empty, remove it
    skill_total <- utils::tail(skill_total, -1)

    # consolidate multiple rows with the same ID by filling in the NA values and save it to the workspace
    skill_total <- skill_total |>
      dplyr::group_by(ID) |>
      dplyr::summarise(dplyr::across(dplyr::everything(), ~dplyr::first(stats::na.omit(.))))


    skill_total <- as.data.frame(skill_total)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  }

  return(skill_total)


}


#' Calculate_Skill_Sequence_for_Dataframes
#'
#' This function is a wrapper for 'Calculate_Skill_Sequence' to handle dataframes as input data
#' Going over the 'data' file.
#' We expect 'data' to have one column for each subject.
#' We handle also the option where the format is wide
#' The first row has subject's ID ("ID")
#' All the other rows are reaction_times
#' Need to indicate the number of rounds
#' Each round is split into three sections: Random_Pre, Training and Random_Post
#' If all rounds have the same number of trials for each section (rounds_of_equal_length = TRUE') (e.g., Random_Pre always 50 trials, Training always 300 trials and Random_Post always 50 trials), only enter once 'design' what the value is for each section.
#' If rounds have different number of trials for each section (rounds_of_equal_length = FALSE) (e.g., Training at round-1 is 200 trials, then at round-2 300 trials and then 400 trials), you need to specify the entirety of the design (e.g., c(50, 200, 50, 50, 300, 50, 50, 400, 50)).
#' Random_Pre, Training and Random_Post are free to change.
#' "automatically_select_span" runs the loess.as	function from the fANCOVA package, which fits a local polynomial regression with automatic smoothing parameter selection via generalized cross-validation
#' The default value for 'span_random' is 20% of the total number of trials
#' The default value for 'span_training' is 14% of the total number of trials
#' "size_of_trial_window_for_skill_same" do you want the size of the window to calculate the skill to be the same for the SEQ and the RND?
#' If TRUE, it will use: "size_of_trial_window_for_skill_percentage", which is the number of trials to be used for calculating the skill. We generally use the last 50 trials of a 180 sequential section (~28%).
#' If "size_of_trial_window_for_skill_same" is FALSE, you will need to specify "size_of_trial_window_for_skill_percentage_SEQ" and size_of_trial_window_for_skill_percentage_RND"
#'
#' @param data Dataframe including participant data, and their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param number_of_rounds How many rounds did the participants perform? Enter an integer
#' @param rounds_of_equal_length Did the participant perform the same amount of trials in every block? TRUE/FALSE
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @param automatically_select_span Do you want to manually select the span for the loess function or do you want to automatically select it via generalized cross-validation? TRUE/FALSE
#' @param span_random How wide do you want the window of the (pre & post)random phase to be? Numeric between 0 and 1
#' @param span_training How wide do you want the window of the sequential phase to be? Numeric between 0 and 1
#' @param size_of_trial_window_for_skill_same Do you want to use the same window for calculating Skill for both random and sequential phase? TRUE/FALSE
#' @param size_of_trial_window_for_skill_percentage If you want to use the same window, select a numeric value between 0 and 1
#' @param size_of_trial_window_for_skill_percentage_SEQ If you DO NOT want to use the same window, select a numeric value between 0 and 1 for the sequential part
#' @param size_of_trial_window_for_skill_percentage_RND If you DO NOT want to use the same window, select a numeric value between 0 and 1 for the random part
#' @return A file in wide format that calculate the acquired skill for each round
#' @export
#' @examples
#' # Basic usage
#' random_matrix <- matrix(stats::rnorm(5 * 1200, mean = 1, sd = 0.1), nrow = 5, ncol = 1200)
#' random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)
#' Calculate_Skill_Sequence_for_Dataframes(data = random_df_w, format= "Wide" ,  rounds_of_equal_length = FALSE, design = c(50, 200, 50,  50, 300, 50,  50, 400, 50), span_random = 0.20,  span_training = 0.14, automatically_select_span = TRUE, size_of_trial_window_for_skill_same = TRUE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.28, size_of_trial_window_for_skill_percentage_RND = 0.50)
#' random_df_l <- as.data.frame(t(random_df_w))
#' Calculate_Skill_Sequence_for_Dataframes(data = random_df_l, format= "Long" ,  number_of_rounds = 3, rounds_of_equal_length = TRUE, design = c(50, 300, 50), span_random = 0.10,  span_training = 0.4, automatically_select_span = FALSE, size_of_trial_window_for_skill_same = FALSE, size_of_trial_window_for_skill_percentage = 0.15 , size_of_trial_window_for_skill_percentage_SEQ = 0.8, size_of_trial_window_for_skill_percentage_RND = 0.50)
Calculate_Skill_Sequence_for_Dataframes <- function(data,
                                                    format = "Long",
                                                    number_of_rounds = 3,
                                                    rounds_of_equal_length = TRUE,
                                                    design = c(50, 300, 50),
                                                    automatically_select_span = FALSE,
                                                    span_random = 0.20,
                                                    span_training = 0.14,
                                                    size_of_trial_window_for_skill_same = TRUE,
                                                    size_of_trial_window_for_skill_percentage = 0.28 ,
                                                    size_of_trial_window_for_skill_percentage_SEQ = 0.1,
                                                    size_of_trial_window_for_skill_percentage_RND = 0.1
                                                    ){

  # initialise empty dataframe
  new <- NULL


  # format == wide, iterate over rows
  if (format == "Wide"){
    for (i in 1:nrow(data)){

      new <- rbind(new, Calculate_Skill_Sequence(data = data[i, ] ,
                                                 format = format,
                                                 number_of_rounds = number_of_rounds,
                                                 rounds_of_equal_length = rounds_of_equal_length,
                                                 design =design ,
                                                 automatically_select_span = automatically_select_span,
                                                 span_random = span_random,
                                                 span_training = span_training,
                                                 size_of_trial_window_for_skill_same = size_of_trial_window_for_skill_same,
                                                 size_of_trial_window_for_skill_percentage = size_of_trial_window_for_skill_percentage ,
                                                 size_of_trial_window_for_skill_percentage_SEQ = size_of_trial_window_for_skill_percentage_SEQ,
                                                 size_of_trial_window_for_skill_percentage_RND = size_of_trial_window_for_skill_percentage_RND)
      )
    }
  }


  # format == Long, iterate over coloumns
  if (format == "Long"){
    for (i in 1:ncol(data)){

      new <- rbind(new, Calculate_Skill_Sequence(data = data[, i] ,
                                                 format = format,
                                                 number_of_rounds = number_of_rounds,
                                                 rounds_of_equal_length = rounds_of_equal_length,
                                                 design =design ,
                                                 automatically_select_span = automatically_select_span,
                                                 span_random = span_random,
                                                 span_training = span_training,
                                                 size_of_trial_window_for_skill_same = size_of_trial_window_for_skill_same,
                                                 size_of_trial_window_for_skill_percentage = size_of_trial_window_for_skill_percentage ,
                                                 size_of_trial_window_for_skill_percentage_SEQ = size_of_trial_window_for_skill_percentage_SEQ,
                                                 size_of_trial_window_for_skill_percentage_RND = size_of_trial_window_for_skill_percentage_RND)
      )
    }
  }


  return(new)

}




#' plot_data
#'
#' this is a function to visualize response times
#' each dot is a response
#' X-axis = time
#' Y-axis = response time
#' can fit either a linear or a loess function the data
#'
#' @param data Single participant data, including their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param limit_y_axis_min_max Do you want to limit the range of the y-axis? TRUE/FALSE
#' @param limit_y_axis_lower If you want to set a limit, enter a numeric value for the upper boundary
#' @param limit_y_axis_upper If you want to set a limit, enter a numeric value for the lower boundary
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @param function_to_fit What function do you want to fit on the data? "loess" or "lm
#' @param span_loess_fitting What span do you want to use when fitting a loess function? Enter a value between 0 and 1
#' @param standard_error Do you want to show the standard error as a shaded area? TRUE/FALSE
#' @param color_dots What color do you want to use for the dots? (e.g., "grey")
#' @param color_line What color do you want to use for the fitted line? (e.g., "black")
#' @param color_intercept What color do you want to use for the vertical intercept lines? (e.g., "black")
#' @return A figure of all response times
#' @export
#' @examples
#' # Basic usage
#' random_list_w <- cbind(999, (as.data.frame(t(stats::rnorm(500, mean = 1, sd = 0.1)))))
#' random_list_l <- rbind(999 , (as.data.frame(stats::rnorm(500, mean = 1, sd = 0.1))))
#' plot <- plot_data(random_list_w,format = "Wide" , limit_y_axis_min_max = TRUE,  limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.1,   standard_error = FALSE, color_dots = "black",   color_line = "grey",  color_intercept = "grey")
#' plot+ggplot2::geom_hline(yintercept =1, col="red")
#' plot <- plot_data(random_list_l, format = "Long" , limit_y_axis_min_max = TRUE,limit_y_axis_lower = 0.5,  limit_y_axis_upper = 1.5,  design = c(50, 200, 50, 50, 100, 50), function_to_fit = "lm",   span_loess_fitting = 0.1, standard_error = TRUE,  color_dots = "black",  color_line = "grey",  color_intercept = "grey")
#' plot+ggplot2::geom_hline(yintercept =1, col="red")
plot_data <- function(data,
                      format = "Wide" ,
                      limit_y_axis_min_max = FALSE,
                      limit_y_axis_lower = 0,
                      limit_y_axis_upper = 1,
                      design = c(50, 200, 50,
                                 50, 100, 50),
                      function_to_fit = "loess",
                      span_loess_fitting = 0.25,
                      standard_error = FALSE,
                      color_dots = "black",
                      color_line = "grey",
                      color_intercept = "grey"
                      ){

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    data <- tidyr::pivot_longer(data,
                         cols=1:ncol((data)),
                         names_to='var',
                         values_to='ResponseTime')

    data <- subset(data, select=-var)


  }


  # Change coloumn name to dataframe
  colnames(data)[1] <- "ResponseTime"

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if format == "Long" , we need to save ID
  if (format == "Long"){

    # find current ID number
    current_id <- data[1,]


    # remove current ID number
    data <- data[-1,]

  }

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  data_frame <- as.data.frame(data)
  colnames(data_frame)[1] <- "ResponseTime"

  data_frame$time <- 1:sum(design)

  intercepts <- cumsum(design)


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  if (limit_y_axis_min_max == TRUE){

    limit_y_axis_lower = min(data_frame$ResponseTime)

    limit_y_axis_upper= max(data_frame$ResponseTime)

  }

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  p <- ggplot2::ggplot(data_frame, ggplot2::aes(time, ResponseTime))+
    ggplot2::geom_vline(xintercept = intercepts, col = color_intercept, linetype="dashed", linewidth = 1 )+
    ggplot2::geom_point(col = color_dots, size = 2)+
    ggplot2::ylim(limit_y_axis_lower , limit_y_axis_upper )+
    ggplot2::theme_bw()+
    ggplot2::stat_smooth(data = data_frame, ggplot2::aes(x = time, y = ResponseTime), col = color_line,
                method = function_to_fit, se = standard_error, span = span_loess_fitting ,
                linewidth = 2)+
    ggplot2::theme(legend.position = "none")

  return(p)


}


#' plot_data_for_Dataframes
#'
#' This function is a wrapper for 'plot_data' to handle dataframes as input data
#' this is a function to visualize response times
#' each dot is a response
#' X-axis = time
#' Y-axis = response time
#' can fit either a linear or a loess function the data
#'
#' @param data Dataframe including participant data, and their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param limit_y_axis_min_max Do you want to limit the range of the y-axis? TRUE/FALSE
#' @param limit_y_axis_lower If you want to set a limit, enter a numeric value for the upper boundary
#' @param limit_y_axis_upper If you want to set a limit, enter a numeric value for the lower boundary
#' @param design What was the design of your task? Enter the number of trials of pre-Random, Sequential and post-Random, in this order. Enter a vector (using 'c()') of integer values
#' @param function_to_fit What function do you want to fit on the data? "loess" or "lm
#' @param span_loess_fitting What span do you want to use when fitting a loess function? Enter a value between 0 and 1
#' @param standard_error Do you want to show the standard error as a shaded area? TRUE/FALSE
#' @param color_dots What color do you want to use for the dots? (e.g., "grey")
#' @param color_line What color do you want to use for the fitted line? (e.g., "black")
#' @param color_intercept What color do you want to use for the vertical intercept lines? (e.g., "black")
#' @return A figure of all response times
#' @export
#' @examples
#' # Basic usage
#' random_df_w <- data.frame( ID = LETTERS[1:5], matrix(stats::rnorm(5 * 500, mean = 1, sd = 0.1), nrow = 5, ncol = 500))
#' plot_data_for_Dataframes(random_df_w, format = "Wide" , limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8, limit_y_axis_upper = 1, design = c(50, 200, 50, 50, 100, 50), function_to_fit = "loess", span_loess_fitting = 0.25, standard_error = FALSE, color_dots = "black", color_line = "grey", color_intercept = "grey")
#' random_df_l <- as.data.frame(t(random_df_w))
#' plot_data_for_Dataframes(random_df_l, format = "Long" ,  limit_y_axis_min_max = FALSE, limit_y_axis_lower = 0.8,   limit_y_axis_upper = 0.9,  design = c(50, 100, 50, 50, 100, 50,  25, 50, 25), function_to_fit = "lm",  span_loess_fitting = 0.25,   standard_error = FALSE,  color_dots = "black", color_line = "grey",  color_intercept = "grey")
plot_data_for_Dataframes <- function(data,
                                     format = "Wide" , # Long
                                     limit_y_axis_min_max = FALSE,
                                     limit_y_axis_lower = 0,
                                     limit_y_axis_upper = 1,
                                     design = c(50, 200, 50,
                                                50, 100, 50),
                                     function_to_fit = "loess",
                                     span_loess_fitting = 0.25,
                                     standard_error = FALSE,
                                     color_dots = "black",
                                     color_line = "grey",
                                     color_intercept = "grey"
                                     ){

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    n_trials <- ncol(data) - 1

    data <- tidyr::pivot_longer(data,
                         cols=2:ncol((data)),
                         names_to='var',
                         values_to='ResponseTime')

    n_ids <- length(unique(data$ID))

    time_vector <- rep(1:n_trials, times = n_ids)

    data$time <- time_vector

  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if format == "Long" , we need to save ID
  if (format == "Long"){

    # find current ID number
    current_id <- data[1,]

    # find how many IDs there are
    n_ids <- length(unique(current_id))

    # find how many trials there are
    n_trials <- nrow(data) - 1

    # create an ID variable for later
    ID_variable <- unlist(rep(current_id[1,], each = n_trials))

    # create a time variable for later
    time_vector <- rep(1:n_trials, times = n_ids)


    # pivot longer
    data <- tidyr::pivot_longer(data,
                         cols=1:ncol((data)),
                         names_to=NULL,
                         values_to='ResponseTime')

    # remove all IDs at the top
    data <- dplyr::slice(data, -(1:n_ids))


    # attach time and ID variables
    data$time <- time_vector

    data$ID <- ID_variable


    data$ResponseTime <- as.numeric(data$ResponseTime)

  }

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  data_frame <- as.data.frame(data)

  intercepts <- cumsum(design)


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  if (limit_y_axis_min_max == TRUE){

    limit_y_axis_lower = min(data_frame$ResponseTime)

    limit_y_axis_upper= max(data_frame$ResponseTime)

  }

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  p <- ggplot2::ggplot(data_frame, ggplot2::aes(time, ResponseTime))+
    ggplot2::geom_vline(xintercept = intercepts, col = color_intercept, linetype="dashed", linewidth = 1 )+
    ggplot2::geom_point(ggplot2::aes(col = ID),alpha = 0.4, size = 0.5)+
    ggplot2::ylim(limit_y_axis_lower , limit_y_axis_upper )+
    ggplot2::theme_bw()+
    ggplot2::stat_smooth(data = data_frame, ggplot2::aes(x = time, y = ResponseTime, group = ID, col = ID),
                method = function_to_fit, se = standard_error, span = span_loess_fitting ,
                linewidth = 1, alpha = 0.5)+
    ggplot2::stat_smooth(data = data_frame, ggplot2::aes(x = time, y = ResponseTime),
                method = function_to_fit, se = standard_error, span = span_loess_fitting ,
                linewidth = 2, alpha = 1)+
    ggplot2::theme(legend.position = "none")

  return(p)


}




#' plot_skills
#'
#' this is a function to visualize Skill
#' each dot is a response
#' X-axis = type of skill
#' Y-axis = response time
#'
#' @param data Single participant data, including their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param col_line What color do you want to use for the line? (e.g., "black")
#' @param col_dots What color do you want to use for the dots? (e.g., "grey")
#' @return A figure of all Skill
#' @export
#' @examples
#' # Basic usage
#' data_wide <- data.frame(id = 999, t(rnorm(12, mean = 1, sd = 0.1)))
#' names(data_wide) <- c("ID", "preRND1", "Train1", "postRND1", "Skill1", "preRND2", "Train2", "postRND2", "Skill2", "preRND3", "Train3", "postRND3", "Skill3")
#' plots <- plot_skills(data_wide, format = "Wide", col_line = "grey",col_dots = "grey")
#' plots$plot1
#' plots$plot2
plot_skills <- function(data,
                        format = "Wide",
                        col_line = "grey",
                        col_dots = "grey"
                        ){

  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    # filter whether it is Skill or average RT data

    df_skill <- dplyr::select(data, starts_with("Skill"))

    df_RT <- dplyr::select(data, !starts_with("Skill"))

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_RT
    name_sequence <- c("preRND", "SEQ", "postRND")

    num_cols <- ncol(df_RT)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_RT) <- new_names

    df_RT <- as.data.frame(df_RT)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_skill
    name_sequence <- c("Skill")

    num_cols <- ncol(df_skill)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_skill) <- new_names


    df_skill <- as.data.frame(df_skill)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



    # pivot_longer
    df_skill <- tidyr::pivot_longer(df_skill,
                             cols=1:ncol(df_skill),
                             names_to='var',
                             values_to='ResponseTime')


    df_RT <- tidyr::pivot_longer(df_RT,
                          cols=1:ncol(df_RT),
                          names_to='var',
                          values_to='ResponseTime')

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # order the x-axis variables as factors
    df_RT$var <- factor(df_RT$var, levels = c("preRND_1", "SEQ_1", "postRND_1",
                                              "preRND_2", "SEQ_2", "postRND_2",
                                              "preRND_3", "SEQ_3", "postRND_3",
                                              "preRND_4", "SEQ_4", "postRND_4",
                                              "preRND_5", "SEQ_5", "postRND_5",
                                              "preRND_6", "SEQ_6", "postRND_6"))

    df_skill$var <- factor(df_skill$var, levels = c("Skill_1", "Skill_2",
                                                    "Skill_3", "Skill_4",
                                                    "Skill_5", "Skill_6"))


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    df_RT$group <- "A"
    df_skill$group <- "A"

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if format == "Long" , we need to save ID
  #  if (format == "Long"){

  # find current ID number
  #  current_id <- data[1,]


  # remove current ID number
  # data <- data[-1,]

  #}


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  p1 <- ggplot2::ggplot(df_skill, ggplot2::aes(var, ResponseTime))+
    ggplot2::geom_point(col = col_dots, size = 2)+
    ggplot2::theme_bw()+
    ggplot2::geom_line(ggplot2::aes(group = group), col = col_line, linewidth  = 1)+
    ggplot2::theme(legend.position = "none")+
    ggplot2::theme(axis.title.x=ggplot2::element_blank())


  p2 <- ggplot2::ggplot(df_RT, ggplot2::aes(var, ResponseTime))+
    ggplot2::geom_point(col = col_dots, size = 2)+
    ggplot2::theme_bw()+
    ggplot2::geom_line(ggplot2::aes(group = group),col = col_line, linewidth  = 1)+
    ggplot2::theme(legend.position = "none")+
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))+
    ggplot2::theme(axis.title.x=ggplot2::element_blank())+
    ggplot2::theme(axis.title.y=ggplot2::element_blank())



    return(list(plot1 = p1, plot2 = p2))



}


#' plot_skills_for_Dataframes
#'
#' This function is a wrapper for 'plot_skills' to handle dataframes as input data
#' this is a function to visualize Skill
#' each dot is a response
#' X-axis = type of skill
#' Y-axis = response time
#'
#' @param data Dataframe including participant data, and their ID
#' @param format How are the data shaped? "Long" or "Wide"
#' @param col_line What color do you want to use for the line? (e.g., "black")
#' @param col_dots What color do you want to use for the dots? (e.g., "grey")
#' @param error_measure How do you want to calculate the group-wise error measure? "sd" for standard deviation or "se" for standard error of the mean
#' @return A figure of all Skill
#' @export
#' @examples
#' # Basic usage
#' random_matrix <- matrix(stats::rnorm(5 * 12, mean = 1, sd = 0.1), nrow = 5, ncol = 12)
#' random_df_w <- data.frame(ID = LETTERS[1:5], random_matrix)
#' names(random_df_w) <- c("ID", "preRND1", "Train1", "postRND1", "Skill1", "preRND2", "Train2", "postRND2", "Skill2", "preRND3", "Train3", "postRND3", "Skill3")
#' plots <- plot_skills_for_Dataframes(random_df_w,  format = "Wide",   col_line = "blue", col_dots = "grey")
#' plots$plot1
#' random_df_l <- as.data.frame(t(random_df_w))
#' plots <- plot_skills_for_Dataframes(random_df_l,  format = "Long",  col_line = "blue",   col_dots = "grey")
#' plots$plot2
plot_skills_for_Dataframes <- function(data,
                                       format = "Wide",
                                       col_line = "grey",
                                       col_dots = "grey",
                                       error_measure = "se"
                                       ){

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # this is a function to visualize Skill
  # each dot is a response
  # X-axis = type of skill
  # Y-axis = response time


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # requirements.txt

  # ggplot2::ggplot
  # Rmisc

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # Make sure data is a data.frame
  data <- as.data.frame(data)


  # if format == "Wide" , we need to save ID and change the data frame to 'Long' format
  if (format == "Wide"){

    colnames(data)[1] <- "ID"
    current_id <- data$ID

    data <- subset(data, select=-ID)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    # filter whether it is Skill or average RT data

    df_skill <- dplyr::select(data, starts_with("Skill"))

    df_RT <- dplyr::select(data, !starts_with("Skill"))

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_RT
    name_sequence <- c("preRND", "SEQ", "postRND")

    num_cols <- ncol(df_RT)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_RT) <- new_names

    df_RT <- as.data.frame(df_RT)

    df_RT$ID <- current_id

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_skill
    name_sequence <- c("Skill")

    num_cols <- ncol(df_skill)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_skill) <- new_names


    df_skill <- as.data.frame(df_skill)


    df_skill$ID <- current_id

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



    # pivot_longer
    df_skill <- tidyr::pivot_longer(df_skill,
                             cols=1:(ncol(df_skill)-1),
                             names_to='var',
                             values_to='ResponseTime')


    df_RT <- tidyr::pivot_longer(df_RT,
                          cols=1:(ncol(df_RT)-1),
                          names_to='var',
                          values_to='ResponseTime')

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # order the x-axis variables as factors
    df_RT$var <- factor(df_RT$var, levels = c("preRND_1", "SEQ_1", "postRND_1",
                                              "preRND_2", "SEQ_2", "postRND_2",
                                              "preRND_3", "SEQ_3", "postRND_3",
                                              "preRND_4", "SEQ_4", "postRND_4",
                                              "preRND_5", "SEQ_5", "postRND_5",
                                              "preRND_6", "SEQ_6", "postRND_6"))

    df_skill$var <- factor(df_skill$var, levels = c("Skill_1", "Skill_2",
                                                    "Skill_3", "Skill_4",
                                                    "Skill_5", "Skill_6"))


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    df_RT$ResponseTime <- as.numeric(df_RT$ResponseTime)

    df_skill$ResponseTime <- as.numeric(df_skill$ResponseTime)


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    df_RT$group <- "A"
    df_skill$group <- "A"

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  # if format == "Long" , we need to save ID
  if (format == "Long"){

  # find current ID number
    current_id <- data[1,]


  # remove current ID number
    data <- data[-1,]

    data$var <- rownames(data)


    # save 'var' coloumn
    col_names <- data$var

    # Transpose everything except var column
    data <- as.data.frame(t(data[, -which(names(data) == "var")]))

    # Assign var values as column names
    colnames(data) <- col_names


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    # filter whether it is Skill or average RT data

    df_skill <- dplyr::select(data, starts_with("Skill"))

    df_RT <- dplyr::select(data, !starts_with("Skill"))

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_RT
    name_sequence <- c("preRND", "SEQ", "postRND")

    num_cols <- ncol(df_RT)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_RT) <- new_names

    df_RT <- as.data.frame(df_RT)

    df_RT$ID <- t(current_id)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # standardize names for df_skill
    name_sequence <- c("Skill")

    num_cols <- ncol(df_skill)

    sequence_length <- length(name_sequence)

    base_names <- rep(name_sequence, length.out = num_cols)

    iteration_index <- rep(1:ceiling(num_cols / sequence_length), each = sequence_length, length.out = num_cols)

    new_names <- paste0(base_names, "_", iteration_index)

    names(df_skill) <- new_names


    df_skill <- as.data.frame(df_skill)


    df_skill$ID <- t(current_id)

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



    # pivot_longer
    df_skill <- tidyr::pivot_longer(df_skill,
                                    cols=1:(ncol(df_skill)-1),
                                    names_to='var',
                                    values_to='ResponseTime')


    df_RT <- tidyr::pivot_longer(df_RT,
                                 cols=1:(ncol(df_RT)-1),
                                 names_to='var',
                                 values_to='ResponseTime')

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


    # order the x-axis variables as factors
    df_RT$var <- factor(df_RT$var, levels = c("preRND_1", "SEQ_1", "postRND_1",
                                              "preRND_2", "SEQ_2", "postRND_2",
                                              "preRND_3", "SEQ_3", "postRND_3",
                                              "preRND_4", "SEQ_4", "postRND_4",
                                              "preRND_5", "SEQ_5", "postRND_5",
                                              "preRND_6", "SEQ_6", "postRND_6"))

    df_skill$var <- factor(df_skill$var, levels = c("Skill_1", "Skill_2",
                                                    "Skill_3", "Skill_4",
                                                    "Skill_5", "Skill_6"))


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    df_RT$ResponseTime <- as.numeric(df_RT$ResponseTime)

    df_skill$ResponseTime <- as.numeric(df_skill$ResponseTime)


    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    df_RT$group <- "A"
    df_skill$group <- "A"

    #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


  }


  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  df_skill_mean <- Rmisc::summarySE(df_skill, measurevar = "ResponseTime", groupvars = "var", na.rm=T)


  df_RT_mean <-  Rmisc::summarySE(df_RT, measurevar = "ResponseTime", groupvars = "var", na.rm=T)

  #<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



  p1 <- ggplot2::ggplot(df_skill, ggplot2::aes(var, ResponseTime))+
    ggplot2::geom_point(ggplot2::aes(col = ID), size = 0.5)+
    ggplot2::geom_line(ggplot2::aes(group = ID , col = ID), linewidth  = 0.2, alpha = 0.4)+
    ggplot2::geom_errorbar(data = df_skill_mean,
                  ggplot2::aes(x = var, ymin = ResponseTime - get(error_measure), ymax = ResponseTime + get(error_measure)), linewidth = 2 , width = .1, colour = col_line) +
    ggplot2::geom_point(data = df_skill_mean, col = col_dots, size = 4)+
    ggplot2::theme_bw()+
    ggplot2::theme(legend.position = "none")+
    ggplot2::theme(axis.title.x=ggplot2::element_blank())


  p2 <- ggplot2::ggplot(df_RT, ggplot2::aes(var, ResponseTime))+
    ggplot2::geom_point(ggplot2::aes(col = ID), size = 0.5)+
    ggplot2::theme_bw()+
    ggplot2::geom_line(ggplot2::aes(group = ID, col = ID), linewidth  = 0.1, alpha =0.4)+
    ggplot2::geom_errorbar(data = df_RT_mean,
                  ggplot2::aes(x = var, ymin = ResponseTime - get(error_measure) , ymax = ResponseTime + get(error_measure)), linewidth = 2 , width = .1, colour = col_line) +
    ggplot2::geom_point(data = df_RT_mean, col = col_dots, size = 4)+
    ggplot2::theme(legend.position = "none")+
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))+
    ggplot2::theme(axis.title.x=ggplot2::element_blank())+
    ggplot2::theme(axis.title.y=ggplot2::element_blank())


  return(list(plot1 = p1, plot2 = p2))



}

