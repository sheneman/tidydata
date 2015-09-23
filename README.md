
Tidy Data Version of the Human Activity Recognition Using Smartphones Data Set
=================================
Here we present a "tidy" summary version of an original dataset as described here:

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

In particular, to produce the summary dataset, we combine the original *training* and *test* datasets and then subset the original data to include only features (column names) that involve the *mean* or *standard deviation* of a measurement and we summarize this subset by computing the mean values for all remaining features for every combination of subjects (n=30) and activities (n=6).   This results in tidy data table with 180 rows and 80 columns.




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

