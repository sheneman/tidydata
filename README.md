Tidy Data Version of the Human Activity Recognition Using Smartphones Data Set
=================================
Here we present a "tidy" summary version of an original dataset as described here:

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

In particular, to produce the summary dataset, we combine the original *training* and *test* datasets and then subset the original data to include only features (column names) that involve the *mean* or *standard deviation* of a measurement and we summarize this subset by computing the mean values for all remaining features for every combination of subjects (n=30) and activities (n=6).   This results in tidy data table with 180 rows and 80 columns.

## The run_analysis.R Script

This section describes the R script that reads, processes, subsets, and produces the tidy dataset.

### Load Supporting Datasets (Activity Labels and Features)

```{r,echo=TRUE}
# Load the activity labels
activity_labels <- read.csv("dataset/activity_labels.txt", sep ="", stringsAsFactors=FALSE, header=FALSE)
activity_labels <- activity_labels[,2]

# Load the feature labels (column names)
features <- read.csv("dataset/features.txt", sep="", stringsAsFactors=FALSE, header=FALSE)
features <- features$V2    # convert into a simple vector
```

###  Load the TESTING data and related supporting files into separate dataframes

```{r,echo=TRUE}
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

```

###  Load the TRAINING data and related supporting files into separate dataframes

```{r}
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
```

### Combine the TEST and TRAINING data sets 

```{r}
# combine both datasets into a single object
alldata <- rbind(test_data, train_data)
```

### SUBSET data from the combined dataset

```{r}

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
alldata$datatype <- NULL     

```

### TIDY DATA SET CREATION

We create a dataframe with the columns using the original column names, but with the rows for all possible combinations of subject X activity.   This should be a data frame with 180 rows and 79 columns.   We will add a column later to specify the specific combination of subject and activity per row.   This will match the row.names() of the data frame, but since we strip row names out when we write out the tidy data set

```{r}

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

```

##Code Book for Summary Tidy Data

*This revised "Code Book" is based on the original documentation provided with the original data set, but modified to better describe only the summary (tidy) Dataset.*

###The Code Book
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

As described in the original dataset documentation, these signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation

The columns in the derived tidy dataset are constructed using the combination of signals and variables as described above but with one key difference:   Since the summary ("tidy") dataset summarizes the original data by computing the *mean* of the observations for every combination of subject and activity, the column names have been revised to reflect this calculation of the mean values.  The term "meanOf" is prepended to every column name to reflect this.   

####The exhaustive list of data columns in the new tidy dataset:   

**Note:  All values for these observations  are signed floating point values.**

* meanOf_tBodyAcc-mean()-X               
* meanOf_tBodyAcc-mean()-Y               
* meanOf_tBodyAcc-mean()-Z              
* meanOf_tBodyAcc-std()-X                
* meanOf_tBodyAcc-std()-Y                
* meanOf_tBodyAcc-std()-Z               
* meanOf_tGravityAcc-mean()-X            
* meanOf_tGravityAcc-mean()-Y            
* meanOf_tGravityAcc-mean()-Z           
* meanOf_tGravityAcc-std()-X             
* meanOf_tGravityAcc-std()-Y             
* meanOf_tGravityAcc-std()-Z            
* meanOf_tBodyAccJerk-mean()-X           
* meanOf_tBodyAccJerk-mean()-Y           
* meanOf_tBodyAccJerk-mean()-Z          
* meanOf_tBodyAccJerk-std()-X            
* meanOf_tBodyAccJerk-std()-Y            
* meanOf_tBodyAccJerk-std()-Z           
* meanOf_tBodyGyro-mean()-X              
* meanOf_tBodyGyro-mean()-Y              
* meanOf_tBodyGyro-mean()-Z             
* meanOf_tBodyGyro-std()-X               
* meanOf_tBodyGyro-std()-Y               
* meanOf_tBodyGyro-std()-Z              
* meanOf_tBodyGyroJerk-mean()-X          
* meanOf_tBodyGyroJerk-mean()-Y          
* meanOf_tBodyGyroJerk-mean()-Z         
* meanOf_tBodyGyroJerk-std()-X           
* meanOf_tBodyGyroJerk-std()-Y           
* meanOf_tBodyGyroJerk-std()-Z          
* meanOf_tBodyAccMag-mean()              
* meanOf_tBodyAccMag-std()               
* meanOf_tGravityAccMag-mean()          
* meanOf_tGravityAccMag-std()            
* meanOf_tBodyAccJerkMag-mean()          
* meanOf_tBodyAccJerkMag-std()          
* meanOf_tBodyGyroMag-mean()             
* meanOf_tBodyGyroMag-std()              
* meanOf_tBodyGyroJerkMag-mean()        
* meanOf_tBodyGyroJerkMag-std()          
* meanOf_fBodyAcc-mean()-X               
* meanOf_fBodyAcc-mean()-Y              
* meanOf_fBodyAcc-mean()-Z               
* meanOf_fBodyAcc-std()-X                
* meanOf_fBodyAcc-std()-Y               
* meanOf_fBodyAcc-std()-Z                
* meanOf_fBodyAcc-meanFreq()-X           
* meanOf_fBodyAcc-meanFreq()-Y          
* meanOf_fBodyAcc-meanFreq()-Z           
* meanOf_fBodyAccJerk-mean()-X           
* meanOf_fBodyAccJerk-mean()-Y          
* meanOf_fBodyAccJerk-mean()-Z           
* meanOf_fBodyAccJerk-std()-X            
* meanOf_fBodyAccJerk-std()-Y           
* meanOf_fBodyAccJerk-std()-Z            
* meanOf_fBodyAccJerk-meanFreq()-X       
* meanOf_fBodyAccJerk-meanFreq()-Y      
* meanOf_fBodyAccJerk-meanFreq()-Z       
* meanOf_fBodyGyro-mean()-X              
* meanOf_fBodyGyro-mean()-Y             
* meanOf_fBodyGyro-mean()-Z              
* meanOf_fBodyGyro-std()-X               
* meanOf_fBodyGyro-std()-Y              
* meanOf_fBodyGyro-std()-Z               
* meanOf_fBodyGyro-meanFreq()-X          
* meanOf_fBodyGyro-meanFreq()-Y         
* meanOf_fBodyGyro-meanFreq()-Z          
* meanOf_fBodyAccMag-mean()              
* meanOf_fBodyAccMag-std()              
* meanOf_fBodyAccMag-meanFreq()
* meanOf_fBodyBodyAccJerkMag-mean()      
* meanOf_fBodyBodyAccJerkMag-std()      
* meanOf_fBodyBodyAccJerkMag-meanFreq()  
* meanOf_fBodyBodyGyroMag-mean()         
* meanOf_fBodyBodyGyroMag-std()         
* meanOf_fBodyBodyGyroMag-meanFreq()     
* meanOf_fBodyBodyGyroJerkMag-mean()     
* meanOf_fBodyBodyGyroJerkMag-std()     
* meanOf_fBodyBodyGyroJerkMag-meanFreq() 

Finally, we add a new column of *character string* identifiers to reflect the specific combination of subject and activity for each row of the dataset:

* observation - a character string (e.g. "Subject_2_WALKING")                      

