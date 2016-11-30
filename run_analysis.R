fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")

# unzip data to root directory
unzip(zipfile="./Dataset.zip",exdir="./")

#reading both datasets
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt") 
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
#merging sets
mergeddata <- rbind(traindata, testdata)

#reading column names for datasets from features.txt
columnnames <- read.table("./UCI HAR Dataset/features.txt")

#reading activity labels
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#reading activity ids
trainactivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
testactivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
#merging activity ids
mergedactivity <- rbind(trainactivity, testactivity)

#reading subject ids
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#merging subject ids 
mergedsubject <- rbind(trainsubject,testsubject)

#addding labels to data set
names(mergeddata) <- columnnames$V2

#selecting only the variables which contain mean and standart deviation
mergeddata <- mergeddata[ grepl("std|mean", names(mergeddata), ignore.case = TRUE)]

#replacing activity ids with activity labels
mergedactivity <- merge(mergedactivity, activitylabels, by.x = "V1", by.y = "V1")
mergedactivity <- mergedactivity[2]

# combining all sets into one
mergeddatasets <- cbind(mergedsubject,mergedactivity, mergeddata)

# adding variable names for subject and activity
names(mergeddatasets)[1:2] <- c("SubjectId", "Activity")

# creating tidy data set from mergeddatasets
tidydata <- group_by(mergeddatasets,SubjectId, Activity )
tidydata <- summarise_each(tidydata,funs(mean))

