## run_analysis.R
#Assumes initial working directory contains the UCI HAR subdirectory
## First set the working director to the UCI HAR Dataset subdirectory
setwd("UCI HAR Dataset")
#read the activity labels, the features table and find the columns of interest.
activity_labels<-read.table("activity_labels.txt")["V2"]  #reading only the V2 column
features.table<-read.table("features.txt")["V2"]
mean.and.std_dev.cols<-grep("mean|std",features.table$V2) # find indces of columns corresponding to mean/std data 
# Go to the training subdirectory
setwd("train")
#Read the full dataset of X training data
X.data.train<-read.table("X_train.txt")  #May take a minute
#Replace the names with col 2 of the reatures table
names(X.data.train)<-features.table$V2
#Read the Y training table
Y.data.train<-read.table("Y_train.txt")
names(Y.data.train)<-"labels"

training.subjects<-read.table("subject_train.txt")
names(training.subjects)<-"subjects"

setwd("../test/")
X.data.test<-read.table("X_test.txt")
names(X.data.test)<-features.table$V2

Y.data.test<-read.table("y_test.txt")
names(Y.data.test)<-"labels"

test.subjects<-read.table("subject_test.txt")
names(test.subjects)<-"subjects"

setwd("../../")
## Extract only the measurements on the mean and standard deviation for each measurement
means_and_std_colnames<-colnames(X.data.train)[mean.and.std_dev.cols]

X.data.train.means.and.stdevs<-cbind(training.subjects,Y.data.train,subset(X.data.train,select=means_and_std_colnames))
X.data.test.means.and.stdevs<-cbind(test.subjects,Y.data.test,subset(X.data.test,select=means_and_std_colnames))

## Merge the training and the test sets to create one data set.
untidy.data<-rbind(X.data.train.means.and.stdevs, X.data.train.means.and.stdevs)


#now create a tidy data set from undidy data, omiting the first two columns(which are meaningless to average) 
# and then sort by Subject
tidy.data<-aggregate(untidy.data[,3:ncol(untidy.data)],list(Subject=untidy.data$subjects, Activity=untidy.data$labels), mean)
tidy.data<-tidy.data[order(tidy.data$Subject),]

## First, replace activity names with meaningful labels
tidy.data$Activity<-activity_labels[tidy.data$Activity,]
## Now remove special characters and replace with spaces for readability
pretty.names <- names(tidy.data)
pretty.names <- gsub('-std', ' Std Dev ', pretty.names) # Replace `-std' by ' Std Dev ' with spaces
pretty.names <- gsub('-mean', ' Mean ', pretty.names) # Replace `-mean' by ` Mean 'with spaces
#final removal of "-" and "()" not accomplished by the above
pretty.names <- gsub('[()-]', '', pretty.names) # get rid of remaining cumbersome characters, () and -
setnames(tidy.data, pretty.names)
write.table(tidy.data, file="tidydata.txt", sep="\t", row.names=FALSE)

