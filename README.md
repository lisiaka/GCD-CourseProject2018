---
title: "README.md"
author: "Maria Ruchko"
date: "August 22, 2015"
output: html_document
---
 
 The test and training datasets were first loaded into R using read.table() function. 
 Then all the corresponding datasets for test and training data were combined using function rbind(). We received 3 variables: 
 * combineddata - contains the the data with the Subject Identifier, 
 * combineddata1 - contains the data for 561 fetures, 
 * combineddata1_labels - contains the data with activity labels.
 
 Each combined dataset contains 10299 rows which represents data for number of observations for 30 subjects and 6 different activities.
 
 In the next step we are merging 3 datasets with the cbind() function and receive one common data frame which contains all the measurements and dimensions.
 
 In the following steps we select relevant data from the conbined dataset. 
 By relevant data we mean features which contain word "mean" or "std" in the description.
 We extract the vector of relevant features using function grepl() on the vector of features (this vector was also read into R from original dataset, file features.txt). 
 
 As a result we receive 2 vectors 
 * columnNames (descriptions of relevant columns) 
 * columnNames1 (the actual names of columns which follow pattern V1,V2 ... V552).
 
 We use library dplyr and function subset() to select only relevant data. The relevant columns are defined with the vector columnNames1.
 Next we use data from activity_labels.txt to replace activity labels with activity descriptions. We use function merge to achieve that and function subset/select to extract only description (instead of both activity description and Id) to the final dataset.
 
 Then we replace non-descriptive names which come from feature vector with meaningful names using vector columnNames (feature descriptions which come from features.txt). We are using function names() to achieve that.
 
 Finally we use library reshape2 to regroup the dataset. We are using function melt() to receive the long dataset with Id SubjectId and Activity. Subsequently we use function dcast with function mean to turn dataset into wide dataset and provide average values for all the variables.
 
 Function write.table() is being used to create a file with the final dataset.
 
 The last step - listing all the column names and writing the data to the code_book.txt
 
 
 