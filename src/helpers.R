library(dplyr)
library(sqldf)

utf8decode <- function(string){
  string = gsub("_", " ", string)
}










#giveTheListOfMasters <- function(university){
  #listOfMasters <- sqldf(paste("SELECT DISTINCT field FROM cleanData WHERE name = '", university, "'", sep = ""));
  #tmp <-  "";
  #for (element in listOfMasters){
  #  tmp <- paste(tmp, "<br>- ", element);
  #}
  #content <- paste("There are ", universit, " masters in this university: ", tmp);
  #return(content);
#}

