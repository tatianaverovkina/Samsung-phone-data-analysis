Samsung phone Data Analysis:

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")

unzip("dataset.zip")

features<-read.table("UCI HAR Dataset/features.txt")

head(features)

feature_names<-gsub("[\\(\\)\\,\\-]", "", features$V2)

mean.and.std<-grep("mean|std", feature_names, ignore.case=TRUE)

activities<-read.table("UCI HAR Dataset/activity_labels.txt")

activity.code<-rbind(read.table("UCI HAR Dataset/test/y_test.txt"), read.table("UCI HAR Dataset/train/y_train.txt"))

activity<-merge(activity.code, activities, by="V1")

subject<-rbind(read.table("UCI HAR Dataset/test/subject_test.txt"), read.table("UCI HAR Dataset/train/subject_train.txt"))

measurements<-rbind(read.table("UCI HAR Dataset/test/X_test.txt"), read.table("UCI HAR Dataset/train/X_train.txt"))

colnames(measurements)<-feature_names
 
mean.and.std.measurements<-measurements[mean.and.std]

mean.and.std.measurements$subject <- subject$V1

mean.and.std.measurements$activity <- activity$V2

aggr.by.activity.and.subject<-aggregate(mean.and.std.measurements[,!(names(mean.and.std.measurements) %in%c("activity", "subject"))], by=list(activity=mean.and.std.measurements$activity, subject=mean.and.std.measurements$subject), FUN=mean)

write.matrix(aggr.by.activity.and.subject, file = "final data.txt", sep = "\t        ")
