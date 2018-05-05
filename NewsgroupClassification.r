## Authors

## Saurabh Gandhele (smg6512@rit.edu)
## Surabhi Marathe  (srm6226@rit.edu)
## Saurabh Wani     (saw4058@rit.edu)

## This program will read the source files and analyze the text to perform text mining on it 
## and classify the content text of the file in its appropriate newsgroups.
## By applying Kmeans() clustering and Random Forest algorithm.

## One time install commands for installing the R library packages 'tm','gmodels','plyr','randomForest'  

# install.packages("tm")
# install.packages("gmodels")
# install.packages("plyr")
# install.packages("randomForest")

# Use all the libraries installed
library('tm')
library('gmodels')
library('plyr')
library('randomForest')

# check the working directory of R and append the source file path
working.direct.path <- getwd()

# specify the path of the source files
server.path <- paste(working.direct.path,'~tmh/pub/newsgroups')

# use list.dirs() command to extract all the folder names with full source path
folders <- list.dirs(path=server.path)
folders

# use substring to remove the initial common path and find only the newsgroup names
newsGroups <- substr(folders, nchar(path)+2, nchar(folders))
newsGroups
finalPath <- paste(path, newsGroups, sep="/")

# use the Corpus function to read all the files present in respective newsgroup folders.
# also specify the encoding file format "UTF-8"
classified.docs <- Corpus(DirSource(directory=finalPath ,encoding="UTF-8"))
summary(classified.docs)

# clean the contents of the text documents read by the Corpus using the tm_map function.
# remove the stopwords, punctuation, whitespaces, numbers and lowercase the text
classified.docs <- tm_map(classified.docs, removeWords,stopwords("english"))
classified.docs <- tm_map(classified.docs, stripWhitespace)
classified.docs <- tm_map(classified.docs, removePunctuation)
classified.docs <- tm_map(classified.docs, content_transformer(tolower))
classified.docs <- tm_map(classified.docs, removeNumbers)


# generate a document term matrix of the cleaned text content
newsgroup.matrix <- DocumentTermMatrix(classified.docs)

# we need to iterate this document term matrix and remove the zero frequency words
for(i in 1:nrow(newsgroup.matrix))
	{
	for(j in 1:ncol(newsgroup.matrix)
		{
			if(newsgroup.matrix[i,j].$count == 0)
			{
				newsgroup.matrix[!(i,j) %in% remove]
			}
		}
	}
	
# we now check and find some words in the newsgroup matrix that are frequently occuring
newsgroup.matrix <- DocumentTermMatrix(classified.docs, control=list(wordLengths=c(8,30), bounds=list(global=c(7,35))))
summary(newsgroup.matrix)

# take the summation of columns of the matrix
document.frequency <- colSums(as.matrix(newsgroup.matrix))

# sort by using function order in dercreasing alphabeticals
high.frequency <- order(document.frequency, decreasing = T)

# display the most frequent words
document.frequency[head(high.frequency)]

# display the least frequent words
document.frequency[tail(high.frequency)]

# store the newsgroup names in a list 
newsgroups.target <- list(s.apply(newsgroups!=""))

# create the corpus model by converting the columns of a matrix to rows for a sequential list
newsgroup.corpus.model[,1] <- newsgroup.matrix[,1:ncol(newsgroup.matrix)]
newsgroup.corpus.model[,2] <- newsgroup.matrix[1:row(newsgroup.matrix),]
summary(newsgroup.corpus.model)

# apply Kmeans clustering algorithm, to the above generated corpus model with 5 clusters
Kmeans.model <- kmeans(newsgroups.corpus.model, 5) 
Cluster <- CrossTable(Kmeans.model$cluster, newsgroups.target,prop.chisq = FALSE, prop.t = FALSE, prop.tbl = FALSE, prop.row = FALSE, prop.coll = FALSE)
Cluster.elements <- sum(Cluster$t[4,])
total.elements <- sum(Cluster$t)
overall.accuracy <- Cluster.elements / total.elements * 100
overall.accuracy

# using the newsgroup corpus model find the training and testing data
set.seed(3)
train.data <- sample(1:nrow(newsgroup.corpus.model), size = length(newsgroup.corpus.model) * 0.75)
test.data <- newsgroup.corpus.model[1:nrow(-train.data)]

# as we have divided the data in 75 and 25 %, length will be the count of these percentages of documents
length(train.data)
length(test.data)

# select seperately only train data and test data for the newsgroup model
train.model.data <- newsgroup.corpus.model[train.data, ]
test.model.data <- newsgroup.corpus.model[test.data, ]

# select seperately only train data and test data for our newsgroups to be classified from target folders
train.newsgroups <- newsgroups.target[train.data]
test.newsgroups <- newsgroups.target[test.data]

# applying random forest to the above training data and then predicting it against the training data
randomForest.model <- randomForest(train.model.data, train.newsgroups)
randomForest.predict <- predict(randomForest.model, newdata = test.model.data)
confusion.Matrix <- CrossTable(randomForest.predict, test.newsgroups, prop.chisq = FALSE, prop.t = FALSE, dnn = c('Predicted newsgroups','Actual newsgroups'))
diagonal.elements <- sum(diag(confusion.Matrix$t))
total.elements <- sum(confusion.Matrix$t)
overall.accuracy <- diagonal.elements / total.elements * 100
overall.accuracy
