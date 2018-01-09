library(dplyr)
library(sqldf)

data <- read.csv("data/fr-esr-insertion_professionnelle-master.csv", header = TRUE, sep = ";")

cleanData <- data %>%
  select(
    name = NameOfUni,
    diplome = diplome,
    academy = academie,
    field = discipline,
    answerRate = taux_de_reponse,
    insertionRate = taux_dinsertion,
    population = emplois_a_temps_plein,
    income = salaire_brut_annuel_estime,
    scholarPer = de_diplomes_boursiers,
    unemployRate = taux_de_chomage_regional,
    managerNum = emplois_cadre,
    womenNum = femmes,
    incomeReg = salaire_net_mensuel_median_regional,
    employExtReg = emplois_exterieurs_a_la_region_de_luniversite,
    Lat = Latitude,
    Long = Longitude
)

cleanData$name <- gsub( "'", "_", cleanData$name)

universities <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, (100 - AVG(unemployRate)) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum, AVG(income) AS income, Lat, Long FROM cleanData Group BY name, Lat, Long")
academies <- sqldf::sqldf("SELECT academy, COUNT(DISTINCT field) AS numberOfMasters, (100 - AVG(unemployRate)) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum, AVG(income) AS income, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy")

universitiesRankedByIR <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, (100 - AVG(unemployRate)) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum, AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, SUM(managerNum) AS managerNum, Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY insertionRate DESC")
universitiesRankedByInc <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, (100 - AVG(unemployRate)) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, SUM(managerNum) AS managerNum,Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY income DESC")
universitiesRankedByManag <- sqldf::sqldf("SELECT name, COUNT(DISTINCT field) AS numberOfMasters, (100 - AVG(unemployRate)) AS insertionRate, SUM(population) AS population, SUM(womenNum) AS womenNum,AVG(income) AS income, (incomeReg * 12 * 1.23) AS incomeReg, SUM(managerNum) AS managerNum,Lat, Long FROM cleanData Group BY name, Lat, Long ORDER BY managerNum DESC")
