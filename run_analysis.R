# Download the file
if (!file.exists("getdata-projectfiles-UCI HAR Dataset.zip"))  
{
  download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
# Unzip the file
  unzip("getdata-projectfiles-UCI HAR Dataset.zip")
  }

# 1. Merges the training and the test sets to create one data set.

trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")

trainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")

trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

testData <- read.table("./UCI HAR Dataset/test/X_test.txt")

testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt")

testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

joinedData <- rbind(trainData, testData)

joinedLabel <- rbind(trainLabel, testLabel)

joinedSubject <- rbind(trainSubject, testSubject)

mergedData <- cbind(joinedSubject, joinedLabel, joinedData)
dim(mergedData) # 10299*563
head(mergedData)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./UCI HAR Dataset/features.txt")
dim(features) # 561*2
meansd = grep("mean\\(\\)|std\\(\\)", features$V2)
length(meansd) # 66
extractedData <- joinedData[,meansd]
dim(extractedData) # 10299*66
head(extractedData)

# 3. Uses descriptive activity names to name the activities in the data set

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", " ", activity[, 2]))
activityLabel <- activity[joinedLabel[, 1], 2]
joinedLabel[, 1] <- activityLabel
names(joinedLabel) <- "Activity"
head(joinedLabel)


# 4. Appropriately labels the data set with descriptive activity names.

names(joinedSubject) <- "Subject"
colnames(extractedData) <- features$V2[meansd]
firstData <- cbind(joinedSubject, joinedLabel, extractedData)
dim(firstData) # 10299*68
head(firstData)

write.table(firstData, "first_dataset.txt") # write out the 1st dataset


# 5. Creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.

library("plyr")

secondData <- ddply(firstData, c("Subject","Activity"), colwise(mean))
head(secondData)

write.table(secondData, "tidy_dataset.txt") # write out the 2nd dataset



