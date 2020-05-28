# This is a script that creates a tidy data set from "Human Activity Recognition Using Smartphones Data Set".
# Written in R version 3.6.3 (2020-02-29) on Linux Xubuntu 18.04
# More info is available in a README file, located at: https://github.com/mantvius/Getting-and-Cleaning-Data-Course-Project

# First, zip file with original data is downloaded and unpacked.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"Smartphones_Dataset.zip")
date_downloaded <- date()
unzip("Smartphones_Dataset.zip")

# reading the original data into R
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# merging the training and test sets  to create one data set
merged_X <- rbind(X_test, X_train)

# reading the file with feature names and labeling data with these names 
feature_names <- read.table("./UCI HAR Dataset/features.txt")
colnames(merged_X) <- feature_names$V2

# Extracting only the measurements on the mean and standard deviation for each measurement
extracted <- merged_X[, grep("(mean|std)\\(", colnames(merged_X))]

# merging subjects of train with subjects of test and activities of train with activities of test; labeling them
merged_y <- rbind(y_test, y_train)
merged_subject <- rbind(subject_test, subject_train)
colnames(merged_y) <- "Activity"
colnames(merged_subject) <- "Subject"

# merging data set with subjects and activities
merged_all <- cbind(merged_subject, merged_y, extracted)

# reading the file with activity names and using these names to name the activities in the data set 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
merged_all$Activity <- activity_labels$V2[merged_y$Activity]

# creating another tidy data set with the average of each variable for each activity and each subject
library(reshape2)
melted_set <- melt(merged_all, id = c("Subject", "Activity"), measure.vars = names(merged_all)[3:68])
tidy_dataset <- dcast(melted_set, Subject + Activity ~ variable, mean)

# writing the created tidy data set into a text file
write.table(tidy_dataset, "./tidy_dataset.txt", row.name=FALSE)

