##########################################################################################################

## Data Cleaning Course Project

## A full description is available at the site where the data was obtained:
        
##        http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Here are the data for the project:
        
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##########################################################################################################


# 1. Merge the training and the test sets to create one data set.

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd("D:/JHU Data Science/UCI HAR Dataset")

# Read in the data from files
features     <- read.table('features.txt',header=FALSE); #imports features.txt
activityType <- read.table('activity_labels.txt',header=FALSE); #imports activity_labels.txt

#loads activity data sets from test and train within working directory

testactivity  <- read.table("test/Y_test.txt" , header = FALSE)
trainactivity <- read.table("train/Y_train.txt", header = FALSE)

#loads subject data sets from test and train

testsubject  <- read.table("test/subject_test.txt", header = FALSE)
trainsubject <- read.table("train/subject_train.txt", header = FALSE)

#loads features data sets from test and train

testfeatures  <- read.table("test/X_test.txt", header = FALSE)
trainfeatures <- read.table("train/X_train.txt", header = FALSE)


#combines activity, subject, and features sets from test and train repectively
#Merges the training and the test sets to create one data set.

activity <- rbind(trainactivity, testactivity)
subject <- rbind(trainsubject, testsubject)
features <- rbind(trainfeatures, testfeatures)

#changes factor levels(1-6) to match activity labels
labels <- read.table("activity_labels.txt", header = FALSE)
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

#names activity and subject columns

names(activity)<- c("activity")
names(subject)<-c("subject")

#names feature columns from features text file

featurestxt <- read.table("features.txt", head=FALSE)
names(features)<- featurestxt$V2

#selects columns with mean and standard deviation data and subsetting

meanstdev<-c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))
subdata<-subset(features,select=meanstdev)

#Combines data sets with activity names and labels

subjectactivity <- cbind(subject, activity)
finaldata <- cbind(subdata, subjectactivity)

#Clarifying time and frequency variables
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))

#Creates new data set with subject and activity means

suppressWarnings(tidydata <- aggregate(finaldata, by = list(finaldata$subject, finaldata$activity), FUN = mean))

colnames(tidydata)[1] <- "Subject"

names(tidydata)[2] <- "Activity"

#removes avg and stdev for non-aggregated sub and act columns

tidydata <- tidydata[1:68]

#Writes tidy data to text file
write.table(tidydata, file = "tidydata.txt", row.name = TRUE, sep='\t')

