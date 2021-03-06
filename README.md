# Samsung phone Data Analysis

## Preliminaries

Download the data and save as zip file

```r
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
    "dataset.zip")
```

Unarchive the saved zip file

```r
unzip("dataset.zip")
```

## Cleaning data

Read variable names in feature.txt file

```r
features <- read.table("UCI HAR Dataset/features.txt")
```

Look at the data

```r
head(features)
```

```
##   V1                V2
## 1  1 tBodyAcc-mean()-X
## 2  2 tBodyAcc-mean()-Y
## 3  3 tBodyAcc-mean()-Z
## 4  4  tBodyAcc-std()-X
## 5  5  tBodyAcc-std()-Y
## 6  6  tBodyAcc-std()-Z
```

Convert variable names to appropriate labels by usibg gsab function

```r
feature_names <- gsub("[\\(\\)\\,\\-]", "", features$V2)
```

Create index of columns with "mean" and "std" substrings using grep function

```r
mean.and.std <- grep("mean|std", feature_names, ignore.case = TRUE)
```

Read activity_labels.txt file

```r
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
```

## Merging data

Read and merge activities of train and test set, which are in y_train.txt and y_test.txt files respectively using rbind function

```r
activity.code <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"), read.table("UCI HAR Dataset/train/y_train.txt"))
```

Join activities and activty.code data sets by code using merge function

```r
activity <- merge(activity.code, activities, by = "V1")
```

Read and merge subjects of train and test set from subject_train.txt and subject_test.txt into one data set called subject

```r
subject <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"), read.table("UCI HAR Dataset/train/subject_train.txt"))
```

Read and merge measurements of train and test data sets into one data set called measurments using rbind function

```r
measurements <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"), read.table("UCI HAR Dataset/train/X_train.txt"))
```

Assign variable names to variables of measurements data set

```r
colnames(measurements) <- feature_names
```

Extract mean and std measurements from data set using subsetting 

```r
mean.and.std.measurements <- measurements[mean.and.std]
```

Add the subject column to the measurments data set

```r
mean.and.std.measurements$subject <- subject$V1
```

Add activity column to the measurments data set

```r
mean.and.std.measurements$activity <- activity$V2
```

## Creating final data set

Create second data set  with the average of each variable for each activity and each subject using aggregate function

```r
aggr.by.activity.and.subject <- aggregate(mean.and.std.measurements[, !(names(mean.and.std.measurements) %in% 
    c("activity", "subject"))], by = list(activity = mean.and.std.measurements$activity, 
    subject = mean.and.std.measurements$subject), FUN = mean)
```


## Creating txt file with the final data set
write.matrix(aggr.by.activity.and.subject, file = "tidy data.txt", sep = "\t        ")
