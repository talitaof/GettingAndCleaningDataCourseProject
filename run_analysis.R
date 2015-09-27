# Getting and Cleaning Data Course Project

# 1. Merges the training and the test sets to create one data set.

## read data into data frames
sTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

sTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# 3. Uses descriptive activity names to name the activities in the data set

# add column name for files
## subject
names(sTrain) <- "subjectID"
names(sTest) <- "subjectID"

## measurement
features <- read.table("./UCI HAR Dataset/features.txt")
names(X_train) <- features$V2
names(X_test) <- features$V2

## label
names(y_train) <- "activity"
names(y_test) <- "activity"

# 1. (continue)

# merge
t <- cbind(sTrain, y_train, X_train)
s <- cbind(sTest, y_test, X_test)
combined <- rbind(t, s)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

means <- grepl("mean\\(\\)", names(combined)) |grepl("std\\(\\)", names(combined))
means[1:2] <- TRUE
combined <- combined[, means]

# 4.Appropriately labels the data set with descriptive variable names. 
combined$activity <- factor(combined$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)
write.csv(tidy, "./UCI HAR Dataset/tidyData.txt", row.names=FALSE)

