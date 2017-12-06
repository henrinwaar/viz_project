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

universities <- sqldf::sqldf("SELECT name, COUNT(*) AS NumberOfMasters, Lat, Long FROM cleanData Group BY name, Lat, Long")
academies <- sqldf::sqldf("SELECT academy, COUNT(*) AS NumberOfMasters, AVG(Lat) AS Lat, AVG(Long) AS Long FROM cleanData Group BY academy")

