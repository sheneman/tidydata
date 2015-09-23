#
# Assignment #1 - Getting and Cleaning Data
#
# Peer review assignment
#
# Luke Sheneman
#

########################################
#
# Load some general supporting datasets
#

# Load the activity labels
activity_labels <- read.csv("dataset/activity_labels.txt", sep ="", stringsAsFactors=FALSE, header=FALSE)
activity_labels <- activity_labels[,2]

# Load the feature labels (column names)
features <- read.csv("dataset/features.txt", sep="", stringsAsFactors=FALSE, header=FALSE)
features <- features$V2    # convert into a simple vector


######################################
#
# TESTING DATA
# 
# Load the testing data and supporting files into separate dataframes
#
test_data <- read.csv("dataset/test/X_test.txt", sep="", stringsAsFactors=FALSE, header=FALSE)
colnames(test_data) <- features

# create a column in the dataframe indicating the datatype as "test"
datatype <- rep("test",nrow(test_data))
test_data <- cbind(test_data, datatype)

test_activities <- read.csv("dataset/test/y_test.txt", sep="", stringsAsFactors=FALSE, header=FALSE)
test_activities <- test_activities[,1]

# create a column in the dataframe indicating the activity code
test_data$activitycode <- test_activities

# Load the test subjects into a vector
test_subjects <- read.csv("dataset/test/subject_test.txt", sep="", stringsAsFactors=FALSE, header=FALSE)
test_subjects <- test_subjects[,1]
test_data$subject <- test_subjects





###################################
#
# TRAINING DATA
#
# Load the training data and supporting files into separate dataframes
#
train_data <- read.csv("dataset/train/X_train.txt", sep="")
colnames(train_data) <- features

# create a column in the dataframe indicating the datatype as "train"
datatype <- rep("train",nrow(train_data))
train_data <- cbind(train_data, datatype)

# read the activity codes from the train dataset and append a column for activitycode and activity
train_activities <- read.csv("dataset/train/y_train.txt", sep="")
train_activities <- train_activities[,1]

# append a column in the train_data dataframe for the activity code
train_data$activitycode <- train_activities

train_subjects <- read.csv("dataset/train/subject_train.txt", sep="")
train_subjects <- train_subjects[,1]
train_data$subject <- train_subjects




###########################################
#
# COMBINE DATA SETS
#
# combine both datasets into a single object
alldata <- rbind(test_data, train_data)



############################################
#
#  SUBSET DATA
#
#  Subset the data by only keeping the features that include "mean" and "std"
#    in their feature name as per the assignment instructions


# preserve the special columns "datatype", "activity_code", and "subject"
meankeeps <- grep("mean", features)
stdkeeps <- grep("std", features)
allkeeps <- sort(c(meankeeps,stdkeeps))

# preserve the actual original feature names for the subset of columns
# that we are preserving
tmpall <- alldata[,allkeeps]
original_colnames <- colnames(tmpall)
tmpall <- NULL

# compile a vector of indices that we will keep that include "mean",
#    "std", and couple others that will be useful for further 
#    subsetting and the creation of the final tidy dataset
allkeeps <- c(allkeeps, 
              grep("datatype",colnames(alldata)), 
              grep("activitycode",colnames(alldata)),
              grep("subject",colnames(alldata)))

# subset the data by preserving only the columns of interest
alldata <- alldata[,allkeeps]

# add a column for human-readable activity labels to the merged data
activity <- as.vector(NULL)
for(i in 1:nrow(alldata)) {
  index <- alldata[i,"activitycode"]
  activity <- c(activity,activity_labels[index])
}

#  add the human readable activity column to the data frame
alldata$activity <- activity

# remove some columns since we do not need them going forward
alldata$activitycode <- NULL
alldata$datatype <- NULL     # for now





################################
#
# TIDY DATA SET CREATION
#

# create a dataframe with the columns using the original column names, but with
# the rows for all possible combinations of subject X activity.   This should be a
# data frame with 180 rows and 79 columns.   We will add a column later to specify
# the specific combination of subject and activity per row.   This will match the 
# row.names() of the data frame, but since we strip row names out when we write out
# the tidy data se

# generate a vector of all combinations of subjects (30) and activities (6)
#  these will be the row names in the new tidy dataset.   Also build the
#  tidy dataset by computing the mean for every observation column for every
#  combination of subject and activity

# initialize some variables
row_vector <- as.vector(NULL)
tidy_data <- as.data.frame(NULL)
rowindex <- as.numeric(1)

# the main nested loop for creating the tidy set
#   for every kind of activity and every kind of subject, 
#   subset the observations from the dataframe and compute the mean value 
#   and store in the tidy_data data frame
for(label in activity_labels) {
  for(j in levels(as.factor(alldata$subject))) {
  
    tmpstr <- paste("Subject",j,label,sep="_")
    row_vector <- c(row_vector, tmpstr)
    
    for(k in original_colnames) {
      mean_obs_subset <- mean(alldata[(alldata$subject==j & alldata$activity==label),k])
      tidy_data[rowindex,k] <- mean_obs_subset
    }
    
    rowindex <- rowindex + 1
  }
}

# The meaning of the columns in the tidy data set has now 
#   changed from the original, as the columns now represent the 
#   mean of the observations (for all Subjects X Activities).  I
#   prepend the prefix "meanOf_" to all column names.
row.names(tidy_data) <- row_vector
new_cnames = as.vector(NULL)
for (cname in original_colnames) {
    tmpstr <- paste("meanOf",cname,sep="_")
    new_cnames = c(new_cnames, tmpstr)
}
colnames(tidy_data) <- new_cnames

# we'll use the row names to create a separate column for 
#   tracking the Subject/Activity combination since we have to 
#   strip row names out of the final tidy data text file
tidy_data$observation <- row.names(tidy_data)

# the last step is to write the file to disk
write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)
