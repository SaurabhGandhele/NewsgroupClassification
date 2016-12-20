# NewgroupClassification

Instructions for executing the NewsgroupClassification.r file

1) We are using four libraries namely 'tm','gmodels','plyr' and'randomForest'.

tm library is used for cleaning the document and creating the document term matrix.

gmodels library is used for displaying the crosstable confusion matrix.

plyr library is used for splitting the newsgroup and model data into training and testing

randomForest library is used for building the model and predicting the data

install.packages("tm")
install.packages("gmodels")
install.packages("plyr")
install.packages("randomForest")

2) Also, we need to place all of the newsgroup source files in the working directory of R Studio. We can check this details with the following two commands:

getwd()

setwd("path")

The path provided for the server source files '~tmh/pub/newsgroups' should be appended with the working directory.

3) The target source files with newsgroups should be kept in the source folder. For example, if we are text mining on the following five newsgroups:

"comp.sys.ibm.pc.hardware"
"misc.forsale"
"rec.sport.hockey"
"sci.space"
"talk.politics.guns"

All the files inside respective 5 folders should be present for the list.dirs() command to find the path and process the files.
Training and tesing data will be selected dynamically on the number of files present in each folder.
For example, if there are only 400 files in one of the folder, then 300 files will be selected for training and remaining 100 for testing.

4) There are some output and summary statements in the code to recheck the calculations and properties such as dimensions, counts and data types of the models built.
