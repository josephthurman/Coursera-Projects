## Runs analysis to combine and tidy the test and training data in the UCI HAR
## dataset.
##
## Assumes that the data set provided in the assignment has been unzipped to a 
## folder titled "UCI HAR Dataset", and that this folder is in the working 
## directory.
##
## Requires the following packages:
## dplyr, tidyr
##

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))

## STEP 1 (Read and combine data)

# Read all data and merge into one frame
training.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
training.activity <- read.table("UCI HAR Dataset/train/y_train.txt")
training.data <- read.table("UCI HAR Dataset/train/X_train.txt")

test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt")
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")

training <- cbind(training.subject, training.activity, training.data)
test <- cbind(test.subject, test.activity, test.data)

combined <- rbind(training,test)

rm(training.subject, training.data, training.activity, training, test.subject, test.data, test.activity, test)

# STEP 4 (Give descriptive variable names, easier done early)

measurements <- read.table("UCI HAR Dataset/features.txt", colClasses = c("NULL","character"), col.names = c("None", "measurements"))$measurements
variablenames <- c("Subject", "Activity", measurements)
variablenames <- gsub("[[:punct:]]","",variablenames)
names(combined) <- variablenames
rm(variablenames, measurements)

# STEP 2 (Select measurements relating to mean and standard deviation)

# Select only columns relating to the mean or standard deviation for a
# particular measurement
combined.meanstd.only <- combined[grepl("Subject|(mean(?!Freq))|std|Activity",names(combined), perl = TRUE)]

#Edit column names for easier readability
newnames <- gsub("(mean|std)([XYZ])","\\2\\1", names(combined.meanstd.only))
newnames <- gsub("mean","Mean", newnames)
newnames <- gsub("std","Std", newnames)
names(combined.meanstd.only) <- newnames
rm(combined, newnames)

# STEP 3 (Give descriptive activity names)
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses = c("numeric", "character"), col.names = c("index", "activity"))

combined.meanstd.only$Activity <- factor(combined.meanstd.only$Activity, labels = activity.labels$activity)

rm(activity.labels)

# STEP 5 (Tidy and summarize the data)
tidy <- combined.meanstd.only %>%
    group_by(Subject, Activity) %>%
    summarise_all(.funs = mean) 
tidy <- data.frame(tidy)

#Save and clean up
write.table(tidy, "UCI_HAR_tidy.txt", row.names = FALSE)
rm(combined.meanstd.only)
