
#Here are the data for the project:
  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




#This script assumes the data is already in a "UCI HAR Dataset" directory under the present working directory.  
#If not, then the user should change the file paths as appropriate or uncomment the download code and download the files
#
#url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url,destfile = "script_data.zip")
#unzip("script_data.zip", list = FALSE, overwrite = TRUE)

subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
Y_test<-read.table("UCI HAR Dataset/test/Y_test.txt")

subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
Y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")

activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)

#(task 1) merge datasets
#Put test and train together using rowbind
merged_data<-rbind(X_test,X_train)
merged_testtype<-rbind(Y_test,Y_train)
merged_subjects<-rbind(subject_test,subject_train)

#Put columns together
complete_set<-cbind(merged_subjects,merged_testtype,merged_data)

#create columname vector
new_column_names <- c("Subject","ActivityType",features$V2)
colnames(complete_set)<-new_column_names


#(task 2) get the columns with -mean() and -std() in the name
colnam_vec<-colnames(complete_set)
mean_std_cols<-colnam_vec[grep("-mean\\(\\)|-std\\(\\)",colnam_vec, ignore.case=TRUE)]
mean_std_cols <-c("Subject","ActivityType",mean_std_cols)
filtereddataframe<-complete_set[,mean_std_cols]



#(task 3) merge in the activity descriptions
descriptive_activity<-merge(filtereddataframe,activity_labels,by.x="ActivityType",by.y="V1")

#merge reorders columns, put them back where they should be and replace the activity number with the descriptive activity text
colnum<-ncol(descriptive_activity)
filtered_data<-descriptive_activity[c(2,colnum,3:(colnum-1))]

#(task 4) - set all the column names to descriptive text
colnames(filtered_data)<-mean_std_cols


#(task 5) create second data set with average of each activity and each subject
numcol<-ncol(filtered_data)

averagedset<-aggregate(filtered_data[,3:numcol],list(filtered_data$Subject,filtered_data$ActivityType),mean)
#column name gets changed by aggregate function, change them back
colnames(averagedset)[1]<-"Subject"
colnames(averagedset)[2]<-"ActivityType"

sortedtidydataset<-averagedset[with(averagedset,order(Subject)),]

write.table(sortedtidydataset, file="Assignment Output - Tidy Data Set.txt",row.names=FALSE)

