# Read subject column into test_subject and set column name to "Subject.Id"
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject) <- c("Subject.Id")
# Read in activity category data and set column name to "Activity.Code"
test_y = read.table("UCI HAR Dataset/test/y_test.txt")
colnames(test_y) <- c("Activity.Code")
# Read in Activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# add activity labels as factor to test_y
test_y$Activity = factor(test_y$Activity.Code, labels = activity_labels[,2], ordered = FALSE)
# Read test data
test_data = read.table("UCI HAR Dataset/test/X_test.txt")
# Read column names for data and set columns names in test_data
features <- read.table("UCI HAR Dataset/features.txt")
colnames(test_data) <- features[,2]
# Extract only mean and std columns for each observation
test_data_summary = test_data[,grepl("(.*mean.*)", colnames(test_data))]

# concatenate subject, activity code and data columns to test data frame test_df
test_df = cbind(test_subject, test_y, test_data_summary)

# clean up to free memory
rm(test_data)

# Same as above applied to the training data files

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject) <- c("Subject.Id")
train_y = read.table("UCI HAR Dataset/train/y_train.txt")
colnames(train_y) <- c("Activity.Code")
train_y$Activity = factor(train_y$Activity.Code, labels = activity_labels[,2], ordered = FALSE)
train_data = read.table("UCI HAR Dataset/train/X_train.txt")
colnames(train_data) <- features[,2]
train_data_summary = train_data[,grepl("(.*mean.*)", colnames(train_data))]
train_df = cbind(train_subject, train_y, train_data_summary)
rm(train_data)
# Combine observations (rows) in training and test datasets
all_har_df = rbind(train_df, test_df)
# Remove the Activity.Code column
all_har_df$Activity.Code <- NULL

# create a melt by Activity (factor) and Subject.Id
har_melt = melt(all_har_df, id=c("Subject.Id", "Activity"))
subject_summary = dcast(har_melt, Subject.Id + Activity ~ variable, mean)


