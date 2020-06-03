library(dplyr)
setwd("UCI HAR Dataset")

#read data

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subjecttest <- read.table("test/subject_test.txt", col.names = "subject")
xtest <- read.table("test/X_test.txt", col.names = features$functions)
ytest <- read.table("test/y_test.txt", col.names = "code")
subjecttrain <- read.table("train/subject_train.txt", col.names = "subject")
xtrain <- read.table("train/X_train.txt", col.names = features$functions)
ytrain <- read.table("train/y_train.txt", col.names = "code")

#bind tables

xbound <- rbind(xtrain, xtest)
ybound <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain, subjecttest)
merged <- cbind(subject, xbound, ybound)

#select necessary columns

tidy <- merged %>% select(subject, code, contains("mean"), contains("std"))

#add activity names

tidy$code <- activities[tidy$code,2]
names(tidy)[2] = "activity"

#fix names

names(tidy)<-gsub("tBody", "TimeBody", names(tidy))
names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
names(tidy)<-gsub("BodyBody", "Body", names(tidy))
names(tidy)<-gsub("-mean()", "Mean", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-std()", "STD", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-freq()", "Frequency", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("angle", "Angle", names(tidy))
names(tidy)<-gsub("gravity", "Gravity", names(tidy))
names(tidy)<-gsub("^t", "Time", names(tidy))
names(tidy)<-gsub("^f", "Frequency", names(tidy))

#create final 

final <- tidy %>%
  group_by(subject, activity) %>%
  summarize_all(funs(mean))

#finish

write.table(final, "final.txt", row.name=FALSE)

