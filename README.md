tidydataset
===========

Getting and Cleaning Data Course Project: collect, work with, and clean a data set for later analysis

## Get Data

Download data manually from here:

`https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

into project work directory. Write permission for the working directory is required.

## Running the code

The code can be run under the RStudio IDE, or on the command line

    `$ R CMD BATCH run_analysis.R`

The zipfile with raw data is unzipped programmatically by the `run_analysis.R` script.  Intermediate result is a tree of subdirectories containing files with data to be transformed.

## Result

Final result is a file basically in `csv`-format named `tidydata.txt` in the current work directory. 

The result file `tidydata.txt` has 181 lines, 68 columns, 12308 (= 181 * 68) words (cells) and 224195 characters (on linux OS, found with command `wc`). The first line is a header line containing the column names. The data matches the principles of tidy data sets as recommended in the coursera.org course _Getting and Cleaning Data_.

Upload to coursera doesn't accept files with extension `.csv`, so the extension is set to `.txt`. The name of the tidy data set can be changed in the script.

More info can be found in CodeBook.md and features_info.txt.

