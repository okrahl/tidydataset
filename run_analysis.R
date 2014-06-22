# Getting and Cleaning Data Course Project
library(reshape2)

# global constants
k.zipfile <- "getdata_projectfiles_UCI HAR Dataset.zip"
k.tidydata.file <- "tidydata.txt"
k.dot <- "."

# define functions
read.data <- function (){
  ## returns a list of data.frames each representing the contents of a file
  file <- "UCI HAR Dataset/activity_labels.txt"
  activity_labels <- read.table(file, header = FALSE, sep = "")
  file <- "UCI HAR Dataset/features.txt"
  features <- read.table(file, header = FALSE, sep = "")
  # training data
  file <- "UCI HAR Dataset/train/subject_train.txt"
  subject_train <- read.table(file, header = FALSE, sep = "")
  file <- "UCI HAR Dataset/train/X_train.txt"
  x_train <- read.table(file, header = FALSE, sep = "")
  file <- "UCI HAR Dataset/train/y_train.txt"
  y_train <- read.table(file, header = FALSE, sep = "")
  # test data
  file <- "UCI HAR Dataset/test/subject_test.txt"
  subject_test <- read.table(file, header = FALSE, sep = "")
  file <- "UCI HAR Dataset/test/X_test.txt"
  x_test <- read.table(file, header = FALSE, sep = "")
  file <- "UCI HAR Dataset/test/y_test.txt"
  y_test <- read.table(file, header = FALSE, sep = "")

  return(list(activity_labels=activity_labels, features=features, 
       subject_train=subject_train, x_train=x_train, y_train=y_train,
       subject_test=subject_test, x_test=x_test, y_test=y_test))
}

merge.datasets <- function (datasets) {
  ## Build a single data.frame from 6 file contents
  ## Input is a list of data.frames representing file contents
  ## Return is a dataframe with 10299 rows by 563 columns, the two leading 
  ## columns are subject id and activity followed by 561 feature columns
  ## the first 7352 rows are from training data set, the following 2947 rows
  ## are from test data set
  train_col_complete <- data.frame(datasets$subject_train, 
                                     datasets$y_train, datasets$x_train)
  test_col_complete <- data.frame(datasets$subject_test, 
                                    datasets$y_test, datasets$x_test)
  x_all <- rbind(train_col_complete, test_col_complete)
  return(x_all)
}

filter.features <- function(features) {
  ## Input is a factor of length 561 with the measurement features as character
  ## Return is a logical vector matching the pairwise features containing 
  ## "std" and "mean"

  # starting with features with standard deviation std
  stdl <-  grepl("std", features)
  stdfeat <- features[stdl]
  std.to.mean <- gsub("std", "mean", stdfeat)
  std.to.mean.logical <- features %in% std.to.mean
  # roundtrip
  stdpartner <- features[std.to.mean.logical]
  stdroundtrip <- gsub("mean", "std", stdpartner)
  stdroundtripl <- features %in% stdroundtrip
  return(stdroundtripl | std.to.mean.logical)
}

set.descriptive.activities <- function(df, filecontent){
  ## replaces integer values in second column of input data
  ## with descriptive names from file `activity_labels.txt
  ## Input
  ##   df: dataframe with integer values from 1 to 6 in second column
  ##   filecontent: list of data.frames each element is content of a file
  ## Returns a dataframe with descriptive activity names in column 2
  act.labels <- filecontent$activity_labels[,2]
  names(act.labels) <- filecontent$activity_labels[,1]
  df[,2] <- act.labels[df[,2]]
  return(df)
}

replace.camelcase <- function (camelcase.str, del = k.dot) {
  # inserts the delimiter ahead of the uppercase letter in a camelcase string
  #   http://stackoverflow.com/questions/8406974/splitting-camelcase-in-r
  #
  # Args:
  #   camelcase.str: string with camelcase: CalculateAvgClicks, kConstantName
  #   del: delimiter, to be inserted before uppercase letter
  #
  # Returns:
  #   String with delimiter before each uppercase letter except first letter:
  #     Calculate.Avg.Clicks, k.Constant.Name
  tmp.str <- unlist(list(camelcase.str))
  tmp.str <- gsub("^[^[:alnum:]]+|[^[:alnum:]]+$", "", tmp.str)
  result <- gsub("(?!^)(?=[[:upper:]])", del, tmp.str, perl = TRUE)
  return(result)
}

replace.repeating.delimiters <- function (rep.str, del = ".") {
  # replaces a sequence of repeating delimiters in a string with a single 
  # delimiter
  #
  # Args:
  #   rep.str: string with sequence of repeating delimiters
  #      abc...de.f, abc___de_f
  #   del: delimiter
  #
  # Returns:
  #   string with condensed sequence of delimiters
  #     abc.de.f, abc_de_f
  k.one.or.more <- "+"
  esc.del <- c(k.dot)
  if (del %in% esc.del) {
    regex <- paste0("\\", del, k.one.or.more)
  } else {
    regex <- paste0(del, k.one.or.more)
  }
  result <- gsub(regex, del, rep.str)
}

convert.name <- function (name, del = ".") {
  # converts a name of a function or variable according to google styleguide
  # except camelcase
  # https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
  #
  # Args:
  #   'name': character vector of length 1 representing the name of a
  #           variable in an unstardardized manner, 
  #           i.e. containing special characters
  #   'del': delimiter depending on style guide
  #
  # Returns: 
  #   name according to google styleguide, that is: no special characters, 
  #   no underscores, all lower case
  # Examples:
  #   in                                out
  #   fBodyGyro-bandsEnergy()-49,64     f.body.gyro.bands.energy.49.64
  #   tBodyAcc-mean()-X                 t.body.acc.mean.x
  #   angle(tBodyGyroMean,gravityMean)  angle.t.body.gyro.mean.gravity.mean
  
  # replace all special characters with delimiter. Special characters: ()-,
  #result <- gsub("[\\(\\),-]", del, name)
  result <- make.names(name)
  # replace camelcase with leading delimiter
  #   http://stackoverflow.com/questions/8406974/splitting-camelcase-in-r
  result <- replace.camelcase(result, del = k.dot)
  # condense multiple delimiters to single delimiter
  result <- replace.repeating.delimiters(result, del = k.dot)
  # translate to lower case
  result <- tolower(result)
  return(result)
}

## main program
unzip(k.zipfile)

filecontent <- read.data()

# 1. Merge the training and the test sets to create one data set
merged.data <- merge.datasets(filecontent)

# 2. Extract only the measurements on the mean and standard deviation 
#   for each measurement.
features <- filecontent$features[,2]
feat.filter <- filter.features(features)
extracted.data <- merged.data[c(TRUE,TRUE, feat.filter)]

# 3. Use descriptive activity names to name the activities in the data set
prime.tidy.data <- set.descriptive.activities(extracted.data, filecontent)

# 4. Appropriately label the data set with descriptive variable names
feature.names <- unlist(lapply(as.character(features[feat.filter]), convert.name))
names(prime.tidy.data) <- c("id", "activity", feature.names)

# 5. Create a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.
molten <- melt(prime.tidy.data, id.vars=c("id", "activity"))
second.tidyset <- dcast(molten, id + activity ~ variable, mean)

# write tidy data set to disc
write.table(second.tidyset, k.tidydata.file, row.names=FALSE)
