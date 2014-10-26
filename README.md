CourseraCleaningDataProject - Jay Chou
===========================

Johns Hopkins Data Science Track - Course: Getting and Cleaning Data - Course Project, October 2014

BELOW DETAILS THE STEPS I TOOK TO GENERATE THE FINAL .TXT FILE WHICH HAS 180 rows, 68 variables INCLUDING ACTIVITY AND SUBJECT

- Set working directory to the script location. setwd("~/Colo_St/Johns Hopkins/Clean Data/UCI HAR Dataset")

- Read in features.txt. Get rid of the 1st column, since the column names are in the 2nd column. Now transpose the data so you only have 1 row, 561 columns of column names

```
features <- read.table("features.txt", encoding="UTF-8")
features$V1 <- NULL
features_transposed <- t(features)
```

- Read Xtrain.txt in the train folder, specify there is no header in the file. Assign the header into train_Xtest by pulling from the transposed data of features.txt
```
trainXtext <- read.table("train/X_train.txt", sep= "", header=FALSE, encoding="UTF-8")
names(train_Xtext) <- features_transposed
```

- Repeat same steps done for the X_Train.txt file in train folder, but apply to test folder

- Read in "Ytrain.txt"" in the train folder and the test folder, these specify what activity each row did in "X_train""

```
trainYtext <- read.table("train/Y_train.txt", sep="", header=FALSE, encoding="UTF-8")
testYtext <- read.table("test/Y_test.txt", sep="", header=FALSE, encoding="UTF-8")
```
- Assign the column name of Activity to the Y_train data

```
names(train_Ytext) <- "Activity"
names(test_Ytext) <- "Activity"
```

- Read in subject_train.txt in the train folder and the test folder, these specify subject number of each row

```
train_subject_text <- read.table("train/subject_train.txt", sep="", header=FALSE, encoding="UTF-8")
test_subject_text <- read.table("test/subject_test.txt", sep="", header=FALSE, encoding="UTF-8")
names(train_subject_text) <- "Subject"
names(test_subject_text) <- "Subject"

train_X_Y_Subject_combined <- cbind(train_Xtext, train_Ytext, train_subject_text)
test_X_Y_Subject_combined  <- cbind(test_Xtext, test_Ytext, test_subject_text)
```

- both files - train_X_Y_Subject_combined have the same width and same column. We can simply use rbind to merge them together

```
mergedd <- rbind(train_X_Y_Subject_combined, test_X_Y_Subject_combined)
```

- Get names of the mergedd data frame and filter for columns with mean and std name only

```
mean_std_columns <- names(mergedd)
mean_std_columns <- (mean_std_columns[(grepl("mean()\\>",mean_std_columns) | grepl("std()",mean_std_columns) 
                                       | grepl("Subject",mean_std_columns) | grepl("Activity",mean_std_columns)) == TRUE])
```

-  Now select those 63 columns into a new dataframe called tidyset0

```
tidyset0 <- mergedd[, mean_std_columns]
```

- Aggreate the data based on Subject and Activity, then take the mean of each column other than Subject and Activity

```
tidyset <-aggregate(tidyset0, by=list(tidyset0$Subject, tidyset0$Activity), 
                            FUN=mean)
```

- Get rid of the extra unneeded columns
```
tidyset$Group.1 <- NULL
tidyset$Group.2 <- NULL
```

- Rename the activity number values into actual actitiity names. # e.g. Activity "1" is WALKING

- Finally write out the .txt file that now has 180 rows, 68 variables of the Mean and Std for each activity and subject. 

```
write.table(tidyset, "tidyset.txt", sep="\t")
```