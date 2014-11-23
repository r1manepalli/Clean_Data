require("data.table")
require("plyr")
require("reshape2")


##Extracting all Data
X_datatest <- read.table("X_test.txt") 
y_datatest <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt") 

X_datatrain <- read.table("X_train.txt")
y_datatrain <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

activity_labels <- read.table("activity_labels.txt")
activities <- activity_labels [,2]

features <- read.table("features.txt")
features_2 <- features [,2]
mean_features <- grepl("mean|std", features_2)

##Assigning Names to datasets
names(X_datatest) = features
names(X_datatrain) = features

y_datatest[,2] = activities [y_datatest[,1]] 
y_datatrain[,2] = activities [y_datatrain[,1]] 

names(y_datatrain) = c("Activity", "Activity_Label") 
names(y_datatrain) = c("Activity", "Activity_Label") 
names(subject_train) = "subject" 
names(subject_test) = "subject" 

## Deriving Meanfeatures of X Factor

mean_X_datatest <- X_datatest[,mean_features]
mean_X_datatrain <- X_datatrain[,mean_features]

## Preparing data for test and training
mytestdata <- cbind(as.data.table(subject_test), y_datatest, mean_X_datatest) 
mytraindata <- cbind(as.data.table(subject_train), y_datatrain, mean_X_datatrain) 

## Mearging training and test dataset

Mergeddata <- rbind.fill(mytestdata,mytraindata) 

## Labels
 Id_labels  <- c("subject", "Activity", "Activity_Label") 
 data_labels <- setdiff(colnames(Mergeddata), Id_labels) 
 melt_data   <- melt(data, id = Id_labels, measure.vars = data_labels) 
##Writing Data
 clean_data1 <- dcast(melt_data, subject + Activity_Label ~ variable, mean) 
 write.table(clean_data1, file = "./clean_data1.txt",row.names=FALSE) 
