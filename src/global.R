library(dplyr)
library(sqldf)
source("helpers.R")

## General loads and queries ####
data <- read.csv("Data/fr-esr-insertion_professionnelle-master1.csv", header = TRUE, sep = ";")

cleanData <- data %>%
  select(
    name = NameOfUni,
    diplome = diplome,
    academy = academie,
    field = discipline,
    answerRate = taux_de_reponse,
    insertionRate = taux_dinsertion,
    population = nombre_de_reponses,
    income = salaire_brut_annuel_estime,
    scholarPer = de_diplomes_boursiers,
    unemployRateReg = taux_de_chomage_regional,
    managerNum = emplois_cadre,
    womenNum = femmes,
    incomeReg = salaire_net_mensuel_median_regional,
    employExtReg = emplois_exterieurs_a_la_region_de_luniversite,
    Lat = Latitude,
    Long = Longitude
)

cleanData$insertionRate[cleanData$insertionRate == 0] <- mean(cleanData$insertionRate[cleanData$insertionRate != 0])
cleanData$insertionRate <- round(cleanData$insertionRate, 2)
cleanData$income[is.na(cleanData$income)] <- mean(cleanData$income[!is.na(cleanData$income)])
cleanData$income <- round(cleanData$income, 0)
cleanData$population[cleanData$population == 0] <- round(mean(cleanData$population[cleanData$population != 0]), 0)
cleanData$name <- gsub( "'", "_", cleanData$name)

## Specific queries ####
cleanTable <- sqldf::sqldf("SELECT name, field, population, womenNum, insertionRate, income, scholarPer, managerNum FROM cleanData")
cleanTable$name <- utf8decode(cleanTable$name)
cleanTable$field <- utf8decode(cleanTable$field)

universities <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum, (SUM(managerNum)/SUM(population)) AS managerNum, AVG(income) AS income, Lat, Long FROM cleanData Group BY name, Lat, Long")
academies <- sqldf::sqldf("SELECT academy, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum, (SUM(managerNum)/SUM(population)) AS managerNum, AVG(income) AS income, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy")
universities$name <- utf8decode(universities$name)

universitiesRankedByIR <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, AVG(100-unemployRateReg) AS unemployRateReg, SUM(population) AS population, SUM(womenNum) AS womenNum, AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY insertionRate DESC")
universitiesRankedByInc <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY income DESC")
universitiesRankedByManag <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY managerNum DESC")
universitiesRankedByManag$managerNum <- paste(round(universitiesRankedByManag$managerNum * 100, 1), "%")
universitiesRankedByIR$insertionRate <- round(universitiesRankedByIR$insertionRate, 2)
universitiesRankedByInc$income <- round(universitiesRankedByInc$income, 0)
universitiesRankedByInc$incomeReg <- round(universitiesRankedByInc$incomeReg, 0)
universitiesRankedByInc$name <- utf8decode(universitiesRankedByInc$name)
universitiesRankedByIR$name <- utf8decode(universitiesRankedByIR$name)
universitiesRankedByManag$name <- utf8decode(universitiesRankedByInc$name)


academiesRankedByIR <- sqldf::sqldf("SELECT academy, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, AVG(100-unemployRateReg) AS unemployRateReg, SUM(population) AS population, SUM(womenNum) AS womenNum, AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy ORDER BY insertionRate DESC")
academiesRankedByInc <- sqldf::sqldf("SELECT academy, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy ORDER BY income DESC")
academiesRankedByManag <- sqldf::sqldf("SELECT academy, COUNT(DISTINCT field) AS numberOfMasters, AVG(insertionRate) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, (SUM(managerNum)/SUM(population)) AS managerNum, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy ORDER BY managerNum DESC")
academiesRankedByManag$managerNum <- paste(round(academiesRankedByManag$managerNum * 100, 1), "%")
academiesRankedByIR$insertionRate <- round(academiesRankedByIR$insertionRate, 2)
academiesRankedByInc$income <- round(academiesRankedByInc$income, 0)
academiesRankedByInc$incomeReg <- round(academiesRankedByInc$incomeReg, 0)
academiesRankedByInc$academy <- utf8decode(academiesRankedByInc$academy)
academiesRankedByIR$academy <- utf8decode(academiesRankedByIR$academy)
academiesRankedByManag$academy <- utf8decode(academiesRankedByManag$academy)


## Clustering ####
selectedData <- sqldf::sqldf("SELECT name, AVG(income) AS income, AVG(insertionRate) AS insertionRate FROM cleanData Group BY name")
selectedData[is.na(selectedData)] <- 0
selectedData$income[selectedData$income == 0] <- mean(selectedData$income)
selectedData$insertionRate[selectedData$insertionRate == 0] <- mean(selectedData$insertionRate)
selectedData <- selectedData[ , !(names(selectedData) %in% "name")]

set.seed(5)
clusters <- kmeans(selectedData, 3)
universities["grade"] <- clusters$cluster
universities$grade[universities$grade == 2] <- "Grade A"
universities$grade[universities$grade == 3] <- "Grade B"
universities$grade[universities$grade == 1] <- "Grade C"