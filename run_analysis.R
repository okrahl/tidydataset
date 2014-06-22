# Getting and Cleaning Data Course Project

# change this to local work directory
#projwd <- "/path/to/local/coursera/project/"
projwd <- "/home/adam/Dokumente/proj/coursera/getting_and_cleaning_data"
zipfile <- "getdata_projectfiles_UCI HAR Dataset.zip"

# define functions
merge.datasets <- function (datasets) {
  
}

convert.name <- function (name) {
  # converts a name of a function or variable according to google styleguide
  # https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
  #
  # Args:
  #   'name': character vector of length 1 representing the name of a
  #           variable in an unstardardized manner, 
  #           i.e. containing special characters
  #
  # Returns: 
  #   name according to google styleguide, that is: no special characters, 
  #   no underscores, all lower case
  # Examples:
  #   in                                out
  #   fBodyGyro-bandsEnergy()-49,64     f.body.gyro.bands.energy.49.64
  #   tBodyAcc-mean()-X                 t.body.acc.mean.x
  #   angle(tBodyGyroMean,gravityMean)  angle.t.body.gyro.mean.gravity.mean
  # rules:
  # strip all parenthesis pairs "()"
  # replace all special characters with a dot: ()-,
  # replace all upper case characters "U" with preceding dot: ".U"
  # translate to lower case
  # replace all multiple dots with single dot
  # strip trailing dot
  result <- NULL
  #result <- gsub()
  return(result)
}
source("convert_name.R")
convert.name("fBodyGyro-bandsEnergy()-49,64..")
convert.name("tBodyAcc-mean()-X")
convert.name("angle(tBodyGyroMean,gravityMean)")
convert.name("AenÖIHavet..")
setwd(projwd)
unzip(zipfile)

# read data
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
file <- "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt"
body_acc_x_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt"
body_acc_y_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt"
body_acc_z_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
body_gyro_x_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
body_gyro_y_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
body_gyro_z_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
total_acc_x_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
total_acc_y_train <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
total_acc_z_train <- read.table(file, header = FALSE, sep = "")
# test data
file <- "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/X_test.txt"
x_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/y_test.txt"
y_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"
body_acc_x_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"
body_acc_y_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"
body_acc_z_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"
body_gyro_x_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"
body_gyro_y_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"
body_gyro_z_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"
total_acc_x_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"
total_acc_y_test <- read.table(file, header = FALSE, sep = "")
file <- "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"
total_acc_z_test <- read.table(file, header = FALSE, sep = "")

# 
x_col_complete_train <- data.frame(subject_train, y_train, x_train)
x_col_complete_test <- data.frame(subject_test, y_test, x_test)
x_all <- rbind(x_col_complete_train, x_col_complete_test)
feature.names <- unlist(lapply(as.character(features[,2]), convert.name))
names(x_all) <- c("subject", "activity", feature.names)


