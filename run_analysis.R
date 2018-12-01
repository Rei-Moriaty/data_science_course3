library(dplyr)
if(!file.exists('dataset3')){
  url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, 'dataset.zip', method="auto")
}
if (!file.exists("dataset.zip")) { 
  unzip("dataset.zip") 
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code, 2]
names(TidyData)[2] = "activity"
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "Acc", "Accelerometer")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "Gyro", "Gyroscope")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "BoduBody", "Body")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "Mag", "Magnitude")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "^t", "Time")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "^f", "Frequecncy")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "tBody", "TimeBody")
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "-mean()", "Mean", ignore.case = TRUE)
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "-std()", "STD", ignore.case = TRUE)
names(TidyData)<-stringi::stri_replace_all_regex(names(TidyData), "-freq()", "Frequency", ignore.case = TRUE)
names(TidyData)<-stri_replace_all_regex(names(TidyData), "angle", "Angle")
names(TidyData)<-stri_replace_all_regex(names(TidyData), "gravity", "Gravity")
Data <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data, "Data.txt", row.name=FALSE)
