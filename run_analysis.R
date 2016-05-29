run_analysis <- function() {
    ## Data:
    ## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    ##
    ## 1. Merges the training and the test sets to create one data set.
    ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
    ## 3. Uses descriptive activity names to name the activities in the data set
    ## 4. Appropriately labels the data set with descriptive variable names.
    ## 5. From the data set in step 4, creates a second, independent tidy data set 
    ##    with the average of each variable for each activity and each subject.
    
    ## 1. Merges the training and the test sets to create one data set
    ## Download zip file
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./data/z.zip", method = "curl")
    unzip(zipfile = "./data/z.zip", exdir = "./data")

    mypath <- "./data/UCI HAR Dataset"
    
    list.files(mypath, recursive = TRUE)
    
    ## Read training and test data sets listed in README file
    ## test/subject_test.txt
    ## test/X_test.txt
    ## test/y_test.txt
    ## train/subject_train.txt
    ## train/X_train.txt
    ## train/y_train.txt
    
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
    
    ## Merge dataMergedSel with activityLabels
    dataMergedFinal <- merge(x = dataMergedSel, y = activityLabels, by = "activityNum")
    
    ## Sort data by two key columns
    dataMergedFinal <- arrange(dataMergedFinal, subjectID, activityNum)
    
    
    ## 5. From the data set in step 4, creates a second, independent tidy data set 
    ##    with the average of each variable for each activity and each subject.
    TidyDataMerged <- data.table(dataMergedFinal)
    
    ## Use lapply function to calculate mean() by subjectID and activityNum
    TidyData <- TidyDataMerged[, lapply(.SD, mean), by = c("subjectID", "activityNum")]
    
    ## Output TidyData to file Tidy.txt
    write.table(TidyData, file = "Tidy.txt")
    
    ## View Tidy.txt
    ## Verify:
    ## 1. Each variable forms a column.
    ## 2. Each observation forms a row.
    ## 3. Each type of observational unit forms a table.
    data <- read.table(file = "Tidy.txt", header = TRUE)
    View(data)
    
}