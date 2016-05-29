# Codebook.md
<h1>Codebook for Programming assignment Week 4</h1>

<h2>Getting and Cleaning Data Course Project</h2>
Instructions for project:  
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

R script called run_analysis.R does the following.

Merges the training and the test sets to create one data set.  
Extracts only the measurements on the mean and standard deviation for each measurement.  
Uses descriptive activity names to name the activities in the data set.  
Appropriately labels the data set with descriptive variable names.  
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

<h2>Description of the DATA</h2>
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix ‘t’ to denote time) were captured at a constant rate of 50 Hz. and the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) – both using a low pass Butterworth filter.

The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the ‘f’ to indicate frequency domain signals).

<h2>Description of abbreviations of measurements</h2>

leading t or f is based on time or frequency measurements  
Body = related to body movement  
Gravity = acceleration of gravity  
Acc = accelerometer measurement  
Gyro = gyroscopic measurements  
Jerk = sudden movement acceleration  
Mag = magnitude of movement  
mean and SD are calculated for each subject for each activity for each mean and SD measurements.  
The units given are g’s for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

These signals were used to estimate variables of the feature vector for each pattern:  
‘-XYZ’ is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

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
 * The set of variables that were estimated from these signals are:

mean(): Mean value  
std(): Standard deviation  

<h3>Data Set Information</h3>
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

<h2>Description of run_analysis()</h2>

## 1. Merges the training and the test sets to create one data set
    ## Download zip file and unzip to folder: UCI HAR Dataset:
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./data/z.zip", method = "curl")
    unzip(zipfile = "./data/z.zip", exdir = "./data")
    
    ## Read training and test data sets listed in README file in USI HAR Dataset folder:
    ## test/subject_test.txt
    ## test/X_test.txt
    ## test/y_test.txt
    ## train/subject_train.txt
    ## train/X_train.txt
    ## train/y_train.txt

    Use files to create the following data frames:
    dataActivityTest  <- read.table(file.path(mypath, "test" , "y_test.txt" ), header = FALSE)
    dataActivityTrain <- read.table(file.path(mypath, "train", "y_train.txt"), header = FALSE)
    
    dataSubjectTest  <- read.table(file.path(mypath, "test" , "subject_test.txt"), header = FALSE)
    dataSubjectTrain <- read.table(file.path(mypath, "train", "subject_train.txt"), header = FALSE)
    
    dataFeaturesTest  <- read.table(file.path(mypath, "test" , "X_test.txt" ), header = FALSE)
    dataFeaturesTrain <- read.table(file.path(mypath, "train", "X_train.txt"), header = FALSE)
    
        ## Bind data sets by rows to combine test and train data
    dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
    dataActivity<- rbind(dataActivityTrain, dataActivityTest)
    dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
    
    ## Name variables in single-column data sets
    names(dataSubject) <- "subjectID"
    names(dataActivity) <- "activityNum"
    
    ## Name variables in dataFeatures using V2 from "features.txt"
    dataFeaturesNames <- read.table(file.path(mypath, "features.txt"), head=FALSE)
    names(dataFeatures) <- dataFeaturesNames$V2
    
    ## Merge all columns
    dataMerged <- cbind(dataSubject, dataActivity, dataFeatures)
    
    
## 2. Extracts only the measurements on the mean and standard deviation for each measurement
    ## In dataFeaturesNames created above, look for column names with text that contains mean() or std()
    selIndex <- grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)
    
    ## From dtMerged extract only the columns with index selIndex
    dataMergedSel <- dataMerged[, selIndex]
    
    ## Add subject and activity columns
    ## dataMergedSel <- cbind(dataSubject, dataActivity, dataMergedSel)
    
    
## 3. Uses descriptive activity names to name the activities in the data set
    ## Lookup values are found in activity_labels.txt
    activityLabels <- read.table(file.path(mypath, "activity_labels.txt"), header = FALSE)
    setnames(activityLabels, names(activityLabels), c("activityNum", "activityName"))
    
## 4. Appropriately labels the data set with descriptive variable names.
    leading t or f is based on time or frequency measurements.
    Body = related to body movement.
    Gravity = acceleration of gravity
    Acc = accelerometer measurement
    Gyro = gyroscopic measurements
    Jerk = sudden movement acceleration
    Mag = magnitude of movement
    
    ## Merge dataMergedSel with activityLabels
    dataMergedFinal <- merge(x = dataMergedSel, y = activityLabels, by = "activityNum")
    
    ## Sort data by two key columns
    dataMergedFinal <- arrange(dataMergedFinal, subjectID, activityNum)
    
    
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    ## mean and SD are calculated for each subject for each activity for each mean and SD measurements. 
    ## The units given are g’s for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec 
    ## for the corresponding jerks.
    
    TidyDataMerged <- data.table(dataMergedFinal)
    
    ## Use lapply function to calculate mean() by subjectID and activityNum
    TidyData <- TidyDataMerged[, lapply(.SD, mean), by = c("subjectID", "activityNum")]
    
    ## Output TidyData to file Tidy.txt
    write.table(TidyData, file = "Tidy.txt")
    
    ## View Tidy.txt
    ## Verify that the TideData meets tidiness criteria:
        ## 1. Each variable forms a column.
        ## 2. Each observation forms a row.
        ## 3. Each type of observational unit forms a table.
    data <- read.table(file = "Tidy.txt", header = TRUE)
    View(data)
    
    The resulting data set contains 10299 observations and 66 mean and standard deviation features calculated for each subject and activity.
