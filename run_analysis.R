#reading data into R
testdata<-read.table("test/subject_test.txt")
traindata<-read.table("train/subject_train.txt")
testdata1<-read.table("test/X_test.txt")
traindata1<-read.table("train/X_train.txt")
testdata1_labels<-read.table("test/y_test.txt")
traindata1_labels<-read.table("train/y_train.txt")
features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")

#combining test and training datasets
combineddata<-rbind(testdata, traindata)
combineddata1<-rbind(testdata1, traindata1)
combineddata1_labels<-rbind(testdata1_labels, traindata1_labels)

#merging data for all measurements
names(combineddata)<-"SubjectId"
names(combineddata1_labels)<-"ActivityId"
combineddata_all<-cbind(combineddata,combineddata1_labels,combineddata1)

#selecting only relevant features
library(dplyr)
combineddata_all_t<-tbl_df(combineddata_all)
names(features)<-c("Id","FeatureName")

#creating vector of feature codes which contain mean or std in their description
columnNames<-features[sapply(features[2],function(x){grepl("mean",x)|grepl("std",x)}),]
columnNames1<-sapply(columnNames[,1],function(x)paste("V",x,sep=""))

#extracting only mean and std values from the dataset
cleandata1<-subset(combineddata_all_t,select=c("SubjectId","ActivityId",columnNames1))

#replacing activity labels with Activity names
names(activity_labels)<-c("Id","Activity")
cleandata2<-merge(cleandata1,activity_labels,by.x = "ActivityId",by.y = "Id",all=TRUE)
cleandata3<-subset(cleandata2,select=c("SubjectId","Activity",columnNames1))

#replacing feature codes with feature names
names(cleandata3)<-c("SubjectId","Activity",as.vector(columnNames[,2]))

#grouping dataset by Subject and Activity
library(reshape2)
mcleandata<-melt(cleandata3, id=c("SubjectId","Activity"))
cleandata4<-dcast(mcleandata,SubjectId+Activity~variable,mean)

#writing dataset to a file
write.table(cleandata4, "tidydataset.txt",row.names=FALSE)

#creaing codeBook
codeBook<-cbind(seq_along(names(cleandata4)),names(cleandata4))
codeBook<-as.data.frame(codeBook)
codeBook[,1]<-as.integer(as.character(codeBook[,1]))
write.table(codeBook, "CodeBook.md", row.names = FALSE, col.names = FALSE)
