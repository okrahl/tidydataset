## Data to work on

The original data set is split into 28 files in 4 subdirectories. The file `README.txt` is self explanatory, the file `features_info.txt` explains the semantic of data fields.

Skipping the `/Inertial Signals` subdirectories, the `dim()` Funktion gives the following results:

    file                    rows columns #levels
    activity_labels.txt        6       2      6
    features.txt             561       2
    subject_train.txt       7352       1     21
    X_train.txt             7352     561
    y_train.txt             7352       1      6
    subject_test.txt        2947       1      9
    X_test.txt              2947     561
    y_test.txt              2947       1      6

    561(1), 477(2)
The heading `#levels` indicates the number of levels (different values), found with the code snippet `length(levels(as.factor(subject_train[,1])))`. The 9 levels of `subject_test.txt` are `2, 4, 9, 10, 12, 13, 18, 20, 24`, together with the complementary 21 levels in`subject_train.txt` this results in a serie from 1 to 30. So these levels are the subject IDs.

The 9 files in the subdirectory `/UCI HAR Dataset/train/Inertial Signals` all have 7352 rows by 128 columns, the 9 files in the subdirectory `UCI HAR Dataset/test/Inertial Signals` all have 2947 rows by 128 columns. The subdirectories `Inertial Signals` seem to hold raw data not matching the course projects requirements.

Now it is obvious how these data fit together. The number of rows in `features.txt` matches the number of columns in `X_train.txt` and `X_test.txt`, so `features.txt` holds the column names. The number of levels in `y_train.txt` and `y_test.txt` matches the number of levels in `activity_labels.txt`, so the `y`-files hold the activity as integers, and `activity_labels.txt` maps these integers to descriptive labels. Combining these data into an intermediate table will result in a table with 10299 rows and 563 columns. 

## Merging the training and the test sets to create one data set

The 6 data files are merged in three steps:

   1. `subject_train.txt`, `y_train.txt`, `X_train.txt` are combined to make a data.frame with 7352 rows and 563 columns for the training dataset using the `data.frame()`-Funktion.
   2. `subject_test.txt`, `y_test.txt`, `X_test.txt` are combined to make a data.frame with 2947 rows and 563 columns for the test dataset using the `data.frame()`-Funktion.
   3. the data.frames from step 1 and 2 are combined to make a data.frame with 10299 rows and 563 columns using the `rbind()`-Funktion

## Extract only the measurements on the mean and standard deviation for each measurement

Only the features with both mean and standard deviation are regarded, so features are extracted pairwise. Picking `tBodyAccJerk-std()-Y` for example results in complementary feature `tBodyAccJerk-mean()-Y` to extract, and vice versa. On the other hand `angle(Z,gravityMean)` is not extracted, because there is no feature `angle(Z,gravityStd)` or something alike.

For filtering the features a roundtrip calculation takes place. Starting with the standard deviation all features will be regarded containing "std" in some way. From this a partner set of features is created by replacing the "std" substring with "mean". A lookup of this partner features in the original feature list will strip artificial "mean"-partners created by string replacement, but not included in the original measurements. The partner feature set after lookup has at most the same number of elements as the features of standard deviation we started with, maybe less. Now a backward substitution of "mean" back to "std" takes place to keep only those standard deviations, whose "mean" partner has passed the existence check.

If the features contained two hypothetical values `angle-X-std()` and `angle-mean()-X`, but no `angle-X-mean()`, which would be the requested partner for `angle-X-std()`. Lookup of substitute will drop `angle-X-mean()` and the backward substitution will drop `angle-X-std()`. Maybe `angle-X-std()` and `angle-mean()-X` belong together, but we don't know, because they are violating a consistent naming scheme. Not being sure they appear pairwise, they are dropped both.

## Descriptive activity names to name the activities in the data set

This subtask is the most simple one. Build a data dictionary (hash table) from the content of file `activity_labels.txt`, so the descriptive activity name can be accessed by the integer activity as index. In this special case the integer activity in the file is identical to the row index, so the algorithm can be further simplified. Just access the data.frame from `activity_labels.txt` by the integer in the activity row of the extracted data. 

## Appropriately label the data set with descriptive variable names

In the file `features.txt` the variables contain special characters like `-()` etc. which have an own meaning in R, breaking standard functions on column names. The R function `make.names()` gives a clue about valid column names, but there are some quirks in the result. A sequence of special characters results in a sequence of dots in the variable name. These multiple dots elongate the name without much use.

A decision has to be made about the flag indicating time or frequency domain of the measurement. As soon as velocity or acceleration are encountered, it is well known to encounter time as well, and frequency too as inverse of time. So the time and frequency flags are left as-is.

As a personel bias I use lower case as often as possible, and I avoid camel case as often as possible. Encountering camel cases and translating to lower case will lose word boundaries and therefore readability. I decided to insert a single dot at word boundary and to translate to lower case. As a tradeoff the variable name is expanded.

A full description of variable names is still given in the file `features_info.txt`

## Average by subject and activity

The intermediate result of the last step above is a data.frame with 10299 rows and 68 columns. Using `melt` and `cast` of package `reshape2` transforms this to a data.frame with 180 rows and 68 columns. The 180 rows are given by grouping the 30 subject identifiers (`id`) and the 6 activities. The certain number of rows with the same identifier and the same activity in the intermediate result will be aggregated into a single row in the final result. The aggregate function is the `mean()`-Funktion.

## Result

The `id` is the identifier of the subject who performed the activity, values are 1 to 30.
The `activity` is self explanatory, values are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
The other 66 columns are the mean of measurements explained in `features_info.txt`, averaged by id and activity.