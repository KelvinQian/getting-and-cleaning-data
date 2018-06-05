setwd("C:\\Users\\Qian Qian\\Desktop\\data analysis\\gettingandcleaningdatarelated")
library(data.table)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(url,'./UCI HAR Dataset.zip', mod='wb')
  unzip("UCI HAR Dataset.zip",exdir=getwd())
}

features <- read.csv('./UCI HAR Dataset/features.txt', header=FALSE, sep='')
features <- as.character(features[,2])

data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header=FALSE,sep='')
data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt', header = FALSE, sep='')

data.train <- data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train)<- c(c('subject','activity'),features)

data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)

data.one<- rbind(data.train, data.test)

mean.sd_extract <- grep('mean|std', features)
data.extract <- data.one[,c(1,2,mean.sd_extract +2)]

activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.extract$activity <- activity.labels[data.extract$activity]

name.4 <- names(data.extract)
name.4 <- gsub("[(][)]", "", name.4)
name.4 <- gsub("^t", "TimeDomain_", name.4)
name.4 <- gsub("^f", "FrequencyDomain_", name.4)
name.4 <- gsub("Acc", "Accelerometer", name.4)
name.4 <- gsub("Gyro", "Gyroscope", name.4)
name.4 <- gsub("Mag", "Magnitude", name.4)
name.4 <- gsub("-mean-", "_Mean_", name.4)
name.4 <- gsub("-std-", "_StandardDeviation_", name.4)
name.4 <- gsub("-", "_", name.4)
names(data.extract) <- name.4

data.5.tidy <- aggregate(data.extract[,3:81], by = list(activity = data.extract$activity, subject = data.extract$subject),FUN = mean)
write.table(x = data.5.tidy, file = "data_tidy.txt", row.names = FALSE)