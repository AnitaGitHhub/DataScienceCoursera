run_analysis <- function(){

library(plyr)
# Step 1 :Download and unzip the data files

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"Dataset.zip")
unzip ("Dataset.zip")

# Step 2 :Merge the training and test sets to create one data set

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


# combine(row bind)  the test and train datasets to create 'x','y' & subjects data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 3 :Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names from the 2nd column in features table
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the required columns from x_data
x_data <- x_data[, mean_and_std]

# Assign correct column names to x_data
names(x_data) <- features[mean_and_std, 2]

# Step 4 :Use descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 5 :Appropriately label the data set with descriptive variable names


# correct column name
names(subject_data) <- "subject"

# column bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 6 :Create a second, independent tidy data set with the average of each variable for each activity and each subject
# i.e. column means of column 1: 66, the last two columns 67 and 68 being subject and activity itself


mean_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(mean_data, "averages_data.txt", row.name=FALSE)

}


