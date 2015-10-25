## Read data from files in test folder
setwd(file.path("~/Desktop/UCI/test/"))
file_list <- list.files()
vectornames <- c()
for (file in file_list){
  # Append data from all files to TestData
  if (exists("TestData")){
    temp_dataset <-read.table(file, header=FALSE)
    TestData <- cbind(TestData, temp_dataset)
    dimdata <- dim(temp_dataset)[2]
    file <- gsub("_test.txt","",file)
    tempnames<- paste(file, 1: dimdata, sep = "") 
    vectornames <- c(vectornames, tempnames)
    rm(temp_dataset)
  }
  # Create TestData and read first file
  if (!exists("TestData")){
    TestData <- read.table(file, header=FALSE)
    dimdata <- dim(TestData)[2]
    file <- gsub("_test.txt","",file)
    tempnames<- paste(file, 1: dimdata, sep = "") 
    vectornames <- c(vectornames, tempnames)
  }  
}
##Rename columns 
colnames(TestData) <- paste(vectornames)


## Read data from files in train folder
setwd(file.path("~/Desktop/UCI/train/"))
train_file_list <- list.files()
train_names <- c()
for (file in train_file_list){
  # # Append data from all files to TrainData
  if (exists("TrainData")){
    temp_dataset <-read.table(file, header=FALSE)
    TrainData <- cbind(TrainData, temp_dataset)
    dimdata2 <- dim(temp_dataset)[2]
    file <- gsub("_train.txt","",file)
    temp_names2<- paste(file, 1: dimdata2, sep = "") 
    train_names <- c(train_names, temp_names2)
    rm(temp_dataset)
  }
  # Create TrainData and read first file
  if (!exists("TrainData")){
    TrainData <- read.table(file, header=FALSE)
    dimdata2 <- dim(TrainData)[2]
    file <- gsub("_train.txt","",file)
    temp_names2<- paste(file, 1: dimdata2, sep = "") 
    train_names <- c(train_names, temp_names2)
  }  
}
##Rename columns 
colnames(TrainData) <- paste(train_names)

##Merge Test and Train data sets together (vertically)
MergedData <- rbind(TestData, TrainData)

#Re-order columns
MergedData <- MergedData[c(1,563,2:562)]

##PART 2 - Extract Means and Standard Deviation for each measurement

#Subset relevant columns
NewMergedData <- MergedData[c(1:8,43:48, 83:88,123:128,163:168, 203:204, 
                              216:217, 229:230, 242:243, 255:256, 268:273, 347:352, 426:431, 505:506, 518:519, 531:532, 544:545)]

#Order data by subject id and activity
ArrangedData <- arrange(NewMergedData, NewMergedData$subject1, NewMergedData$y1)

#For every subject and activity, find the average of the measurements in each column
NewData <- aggregate(. ~ subject1+y1, ArrangedData, mean)
   

##PART 3 - Use descriptive activity names to name the activities in the data set
NewData$y1 <- factor(NewData$y1, 
                        labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs", 
                                   "Sitting", "Standing", "Laying"))

#PART4 - Label data set with descriptive variable names
#Read features.txt to get names
setwd("~/Desktop/UCI")
Names <- read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)

#Create vector of variable names
Names2 <- c(Names[ , 2])

#Create vector with the column names I want to rename in NewData; cbind to Names2
temp_names3<- paste("X", 1:561, sep = "") 
NewNames <- cbind(temp_names3, Names2)

#Match NewNames and replace old variable names in NewData
NewNames <- as.data.frame(NewNames)
#Create a vector of relevant columns to be renamed with features.txt
relcol <- names(NewData[,3:68])
#Create a dataframe of variable names to match relcol with
ColNamesData <- as.data.frame(relcol)
matches <- (ColNamesData$relcol %in% NewNames$temp_names3)
#Get indexes of rows where there are matches
matching_rows <- which(matches)

#Copy dataset to manipuate it
NewData2 <- NewData
#Drop first two rows data of NewData2 in order to replace column names with names from features.txt 
NewData2$subject1 = NULL
NewData2$y1 = NULL
colnames(NewData2) <- Names$V2[matching_rows]

#Drop all but first two rows in NewData
NewData3 <- NewData[ ,1:2]
NewData3 <- rename(NewData3, c("subject1" = "Subject_ID", "y1"= "Activity"))

#Merge NewData2 and NewData3 to get full dataset
NewData <- cbind(NewData3, NewData2)

#Part 5 
#Remove columns with std deviations
NewData6 <- NewData[ ,c("tBodyAccJerkMag-std()", "tBodyAcc-std()-X","tBodyAcc-std()-Y", 
                        "tBodyAcc-std()-Z", "tGravityAcc-std()-X","tGravityAcc-std()-Y",
                        "tGravityAcc-std()-Z", "tBodyAccJerk-std()-X","tBodyAccJerk-std()-Y",
                        "tBodyAccJerk-std()-Z", "tBodyGyro-std()-X", "tBodyGyro-std()-Y", 
                        "tBodyGyro-std()-Z", "tBodyGyroJerk-std()-X", "tBodyGyroJerk-std()-Y", 
                        "tBodyGyroJerk-std()-Z", "tBodyAccMag-std()", "tGravityAccMag-std()",
                        "tBodyGyroJerkMag-std()", "tBodyGyroMag-std()", "fBodyAcc-std()-X", 
                        "fBodyAcc-std()-Y", "fBodyAcc-std()-Z", "fBodyGyro-std()-X", 
                        "fBodyGyro-std()-Y", "fBodyGyro-std()-Z", "fBodyAccMag-std()", 
                        "fBodyBodyAccJerkMag-std()", "fBodyBodyGyroMag-std()", 
                        "fBodyBodyGyroJerkMag-std()", "fBodyAccJerk-std()-X", "fBodyAccJerk-std()-Y",
                        "tBodyAccJerk-std()","fBodyAccJerk-std()-Z"):=NULL]

#Var1
tBodyAccXYZ <- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- c(NewData[i,3:5])
  newtempvector <- paste(tempvector, collapse=", ")
  tBodyAccXYZ <- c(tBodyAccXYZ, newtempvector)
}
NewDataFinal$tBodyAccXYZ<- tBodyAccXYZ


#Var2
tGravityAccXYZ<- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- c(NewData[i,6:8])
  newtempvector <- paste(tempvector, collapse=", ")
  tGravityAccXYZ <- c(tGravityAccXYZ, newtempvector)
}
NewDataFinal$tGravityAccXYZ <- tGravityAccXYZ

#Var3
tBodyAccJerkXYZ<- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,9:11]))
  newtempvector <- paste(tempvector, collapse=", ")
  tBodyAccJerkXYZ <- c(tBodyAccJerkXYZ, newtempvector)
}
NewDataFinal$tBodyAccJerkXYZ <- tBodyAccJerkXYZ

#Var4
tBodyGyroXYZ<- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,10:12]))
  newtempvector <- paste(tempvector, collapse=", ")
  tBodyGyroXYZ <- c(tBodyGyroXYZ, newtempvector)
}
NewDataFinal$tBodyGyroXYZ <- tBodyGyroXYZ

#Var5
tBodyGyroJerkXYZ<- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,13:15]))
  newtempvector <- paste(tempvector, collapse=", ")
  tBodyGyroJerkXYZ <- c(tBodyGyroJerkXYZ, newtempvector)
}
NewDataFinal$tBodyGyroJerkXYZ <- tBodyGyroJerkXYZ

#Var6
tBodyAccMag <- c(NewData$`tBodyAccMag-mean()`)
NewDataFinal$tBodyAccMag <- tBodyAccMag

#Var7
tGravityAccMag <- c(NewData$`tGravityAccMag-mean()`)
NewDataFinal$tGravityAccMag <- tGravityAccMag

#Var8
tBodyAccJerkMag <- c(NewData$`tBodyAccJerkMag-mean()`)
NewDataFinal$tBodyAccJerkMag <- tBodyAccJerkMag

#Var9
tBodyGyroMag <- c(NewData$`tBodyGyroMag-mean()`)
NewDataFinal$tBodyGyroMag <- tBodyGyroMag

#Var10
tBodyGyroJerkMag <- c(NewData$`tBodyGyroJerkMag-mean()`)
NewDataFinal$tBodyGyroJerkMag <- tBodyGyroJerkMag

#Var11
fBodyAccXYZ <- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,21:23]))
  newtempvector <- paste(tempvector, collapse=", ")
  fBodyAccXYZ <- c(fBodyAccXYZ, newtempvector)
}
NewDataFinal$fBodyAccXYZ <- fBodyAccXYZ

#Var12
fBodyAccJerkXYZ <- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,24:26]))
  newtempvector <- paste(tempvector, collapse=", ")
  fBodyAccJerkXYZ <- c(fBodyAccJerkXYZ, newtempvector)
}
NewDataFinal$fBodyAccJerkXYZ <- fBodyAccJerkXYZ

#Var13
fBodyGyroXYZ <- as.numeric(c())
for(i in 1:NROW(NewData)){
  tempvector <- as.numeric(c(NewData[i,27:29]))
  newtempvector <- paste(tempvector, collapse=", ")
  fBodyGyroXYZ <- c(fBodyGyroXYZ, newtempvector)
}
NewDataFinal$fBodyGyroXYZ <- fBodyGyroXYZ

#Var14
fBodyAccMag <- c(NewData$`fBodyAccMag-mean()`)
NewDataFinal$fBodyAccMag <- fBodyAccMag

#Var15
fBodyAccJerkMag <- c(NewData$`fBodyBodyAccJerkMag-mean()`)
NewDataFinal$fBodyAccJerkMag <- fBodyAccJerkMag

#Var16
fBodyGyroMag <- c(NewData$`fBodyBodyGyroMag-mean()`)
NewDataFinal$fBodyGyroMag <- fBodyGyroMag

#Var17
fBodyGyroJerkMag <- c(NewData$`fBodyBodyGyroJerkMag-mean()`)
NewDataFinal$fBodyGyroJerkMag <- fBodyGyroJerkMag

##Write NewDataFinal into a txt doc
setwd("~/Desktop/UCIDataset")
write.table(NewDataFinal, file = "TidyDataSet.txt", row.names = FALSE)








