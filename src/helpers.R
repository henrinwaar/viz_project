library(dplyr)
library(sqldf)

utf8decode <- function(string){
  string = gsub("Ã©", "é", string)
  string = gsub("Ãª", "ê", string)
  string = gsub("Ã¨", "è", string)
  string = gsub("Ã¶", "ö", string)
  string = gsub("Ã«", "ë", string)
  string = gsub("Ã§", "ç", string)
  string = gsub("Ã¢", "â", string)
  string = gsub("Ã´", "ô", string)
  string = gsub("Ã®", "î", string)
  string = gsub("Ã", "à", string)
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

