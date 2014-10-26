# Set working directory to the script location
setwd("~/Colo_St/Johns Hopkins/Clean Data/UCI HAR Dataset")

# Read in features.txt 
features <- read.table("features.txt", encoding="UTF-8")
# Get rid of the 1st column, since the column names are in the 2nd column
features$V1 <- NULL
# Now transpose the data so you only have 1 row, 561 columns of column names
features_transposed <- t(features)

# Read X_train.txt in the train folder, specify there is no header in the file
train_Xtext <- read.table("train/X_train.txt", sep= "", header=FALSE, encoding="UTF-8")
# Now assign the header into train_Xtest by pulling from the transposed data of features.txt
names(train_Xtext) <- features_transposed

# Repeat same steps done for the X_Train.txt file in train folder, but apply to test folder
test_Xtext <- read.table("test/X_test.txt", sep="", header=FALSE, encoding="UTF-8")
names(test_Xtext) <- features_transposed

# Read in Y_train.txt in the train folder and the test folder, these specify what activity each row did in X_train
train_Ytext <- read.table("train/Y_train.txt", sep="", header=FALSE, encoding="UTF-8")
test_Ytext <- read.table("test/Y_test.txt", sep="", header=FALSE, encoding="UTF-8")
# Assign the column name of Activity to the Y_train data
names(train_Ytext) <- "Activity"
names(test_Ytext) <- "Activity"

# Read in subject_train.txt in the train folder and the test folder, these specify subject number of each row
train_subject_text <- read.table("train/subject_train.txt", sep="", header=FALSE, encoding="UTF-8")
test_subject_text <- read.table("test/subject_test.txt", sep="", header=FALSE, encoding="UTF-8")
names(train_subject_text) <- "Subject"
names(test_subject_text) <- "Subject"

train_X_Y_Subject_combined <- cbind(train_Xtext, train_Ytext, train_subject_text)
test_X_Y_Subject_combined  <- cbind(test_Xtext, test_Ytext, test_subject_text)

# You could write the combined trained file or combined test file out to take a look
# write.csv(train_X_Y_Subject_combined, file = "Trained.csv")
# write.csv(test_X_Y_Subject_combined, file = "Tested.csv")

# One way to combine the train and test files through merge()
# mergedd <- merge(train_X_Y_Subject_combined, test_X_Y_Subject_combined, all=TRUE)

# However, since both files - train_X_Y_Subject_combined have the same width and same column 
# Names we can simply use rbind to merge them together
mergedd <- rbind(train_X_Y_Subject_combined, test_X_Y_Subject_combined)
# You could write the combined train+test file to local directory to take a look
# write.csv(mergedd, file = "mergedd.csv")

# List all the columns (563) in the final merged file of train and test
mean_std_columns <- names(mergedd)
# Now filter the column list only down to columns that have Mean and Std data, for mean, use \\> since 
# You need to filter out the "meanFreq()" columns and \\> matches mean() at the end exactly
# You end up with 68 columns that has only the mean and std plus Activity and Subject
mean_std_columns <- (mean_std_columns[(grepl("mean()\\>",mean_std_columns) | grepl("std()",mean_std_columns) 
                                       | grepl("Subject",mean_std_columns) | grepl("Activity",mean_std_columns)) == TRUE])

# Now select those 63 columns into a new dataframe called tidyset0
tidyset0 <- mergedd[, mean_std_columns]

# We now aggreate the data based on Subject and Activity, then take the mean of each column
# Other than Subject and Activity
tidyset <-aggregate(tidyset0, by=list(tidyset0$Subject, tidyset0$Activity), 
                            FUN=mean)

# Get rid of the extra unneeded columns
#tidyset$Group.1 <- NULL
#tidyset$Group.2 <- NULL
# Another way to delete the columns
#drops <- c("Group.1", "Group.2")
#tidyset <- tidyset[,!(names(tidyset) %in% drops)]

# Rename the activity number values into actual actitiity names
# e.g. Activity "1" is WALKING
tidyset$Activity[tidyset$Activity==1] <- "WALKING"
tidyset$Activity[tidyset$Activity==2] <- "WALKING_UPSTAIRS"
tidyset$Activity[tidyset$Activity==3] <- "WALKING_DOWNSTAIRS"
tidyset$Activity[tidyset$Activity==4] <- "SITTING"
tidyset$Activity[tidyset$Activity==5] <- "STANDING"
tidyset$Activity[tidyset$Activity==6] <- "LAYING"

write.table(tidyset, "tidyset.txt", sep="\t")
