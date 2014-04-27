# Samsung phone Data Analysis

The following analyses is based on data of experiments have been carried out with a group of 30 volunteers. Each person performed six activities wearing smartphone (Samsung Galaxy S II) with integrated Android platform provides several sensors that monitor the motion of a device. Motion sensors are useful for monitoring device movement, such as tilt, shake, rotation, or swing. The movement is usually a reflection of direct user input (for example, a user steering a car in a game or a user controlling a ball in a game), but it can also be a reflection of the physical environment in which the device is sitting( for example, moving with you while you drive your car).[1] The data set contains information taken from two of hardware-based sensors: the accelerometer and gyroscope. A gyroscope is a device for measuring or maintaining orientation, based on the principles of angular momentum. An accelerometer is a device that measures proper acceleration. Accelerometer measures how much activity is going on in, on three different axes. Though similar in purpose, they measure different things. When combined into a single device, they can create a very powerful array of information. This is becoming really widely-used now in a lot of medical studies, but is also being used in other places as well. 


## Preliminaries
 
 For the analysis was used the sample of experimental data containing indicators of accelerometer and gyroscope devices integrated at Android platform of Sumsung GalaxyS2. The data were downloaded from URL "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" on April 25, 2014 using the R programming language. 

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
The data set contains 561 observations and 2 variables. They are all names of measures of acceleration and velocity in 3 axis: x,y,z.

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
The names of variables contain a lot of  signs (such as "()","-",","), which are recognized as function in R, thus gsub function was applied to eliminate all those signs.
Convert variable names to appropriate labels

```r
feature_names <- gsub("[\\(\\)\\,\\-]", "", features$V2)
```

Create index of columns with "mean" and "std" substrings

```r
mean.and.std <- grep("mean|std", feature_names, ignore.case = TRUE)
```

Read activity_labels.txt file

```r
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
```
The data set contains 6 observations and 2 variables. In this dataset there is a variable labeled V2 and that variable tells what the subject(volunteer) was doing while he/she was participating in the study. 1 is for walking, 2 is for walking upstairs, 3 is for walking downstairs, 4 is for sitting, 5 is for standing, and 6 is for laying. V1 variable indicates the code of activity.

## Merging data

Read and merge activities of train and test set, which are in y_train.txt and y_test.txt files respectively 

```r
activity.code <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"), read.table("UCI HAR Dataset/train/y_train.txt"))
```

Join activities and activty.code data sets by code

```r
activity <- merge(activity.code, activities, by = "V1")
```

Read and merge subjects of train and test set from subject_train.txt and subject_test.txt into one data set called subject

```r
subject <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"), read.table("UCI HAR Dataset/train/subject_train.txt"))
```
This data set contains 1 variable and 10299 variables, indicating the number of subject(volonteer).

Read and merge measurements of train and test data sets into one data set called measurments

```r
measurements <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"), read.table("UCI HAR Dataset/train/X_train.txt"))
```
Measurments data set contains 561 variable and 10299 observations. And all of those numbers performing measures of devises in 3 axis: x,y,z. 

Assign variable names to variables of measurements data set

```r
colnames(measurements) <- feature_names
```

Extract mean and std measurements from the data set

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

Create second data set  with the average of each variable for each activity and each subject

```r
aggr.by.activity.and.subject <- aggregate(mean.and.std.measurements[, !(names(mean.and.std.measurements) %in% 
    c("activity", "subject"))], by = list(activity = mean.and.std.measurements$activity, 
    subject = mean.and.std.measurements$subject), FUN = mean)
```
The final data set with the average of each variable for each activity and each subject contains 88 variables and 35 observation. 

## Creating txt file with the final data set
write.matrix(aggr.by.activity.and.subject, file = "tidy data.txt", sep = "\t        ")

