giveTheListOfMasters <- function(university){
  listOfMasters <- sqldf(paste("SELECT cleanData.field FROM cleanData JOIN universities ON cleanData.name = universities.name WHERE universities.name = '", university, "' GROUP BY cleanData.field", sep = ""));
  if (count(listOfMasters) < 1){
    listOfMasters = "No Master";
  }
  content = paste(sep = "<br/>",
                  paste("There are", count(listOfMasters), "masters in this university !", sep = " "),
                  for (element in as.list(listOfMasters)){
                    paste(element,", ", sep = "")
                  }
  )
  return(content)
}