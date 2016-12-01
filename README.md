# Getting and Cleaning Data
This repository contains files required for peer grading for Coursera program.

The purpose of this project was to demonstrate ability to collect, work with, and clean a data set. The goal was to prepare tidy data that can be used for later analysis. 

Original dataset can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Repository contains 4 files.

Readme.md <- file that you are reading right know explaining whole thinking process.
CodeBook.md <- containing information about the output dataset from run_analysis.R script
tidydata.txt <- tidy dataset from run_analysis.R grouped by subject and activity, avarage for each variable was calculated. 

## Code review

Script assumes that dataset was unziped to R working directory.
For purpose of grouping and summarizing we are loading dplyr package

```

library(dplyr)
```

Both dataset are being read by read.table into memory and merged by rbind function.


traindata <- read.table("./UCI HAR Dataset/train/X_train.txt") 
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")

mergeddata <- rbind(traindata, testdata)
```

Column names and activity labels are also being read.

```

columnnames <- read.table("./UCI HAR Dataset/features.txt")


activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
```

Similar procedure is being applied to dataset containing subjects ID. We merge both datasets with rbind function

```

trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

mergedsubject <- rbind(trainsubject,testsubject)
```

adding labels to dataset and extracting only means and standard deviation of each measurements

```
names(mergeddata) <- columnnames$V2

#selecting only the variables which contain mean and standart deviation
```
mergeddata <- mergeddata[ grepl("std|mean", names(mergeddata), ignore.case = TRUE)]
```

replacing activity ID with coresponding Lables and merging all dataset together

```
for (i in activitylabels$V1){ mergedactivity[mergedactivity$V1 == i,] <- as.character(activitylabels[i,2]) }
```

# combining all sets into one
```
mergeddatasets <- cbind(mergedsubject,mergedactivity, mergeddata)
```

adding first two rows own labels

```
# adding variable names for subject and activity
names(mergeddatasets)[1:2] <- c("SubjectId", "Activity")
```

cleaning dataset, creating tidydata set

```
# creating tidy data set from mergeddatasets
tidydata <- group_by(mergeddatasets,SubjectId, Activity )
tidydata <- summarise_each(tidydata,funs(mean))
```
