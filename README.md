# CourseProject
==================================================================

Included:
Project_README.txt
CodeBook.txt
run_analysis.R
==================================================================

COLLECTION OF DATA
I used data from the Human Activity Recognition Using Smartphones Data Set from UCI's Machine Learnign Repository
Link to data used: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

DESCRIPTION OF SCRIPT

The R script is divided into 5 parts - one for each part of the assignment. 
Part 1 involves reading the two data sets and merging them into one data frame. 
Part 2 involves subsetting the data frame in order to extract the mean and standard deviations for each measurement. I also arranged the data by subject id and activity to make it easier to read.
Part 3 creates a factor variable for the Activity column with 6 different labels for the different activities. 
In Part 4, I read in features.txt in order to obtain a list of descriptive variable names. The script then matches the names in the subsetted data with the list of variable names in txt file. Any matching names are then used to name the variables in the subsetted data. 
Lastly, in Part 5, I remove all columns with standard deviations since the assignment asked for the means of each variable. Since X,Y,Z variables are not independent of each other, I combined them into one measurement. The final tidy dataset provides an average of each variable for each activity and each subject.


