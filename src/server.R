library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(sqldf)
library(htmltools)
library(plotly)

source("helpers.R")


function(input, output) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    if(input$v_scale == "University"){
      leaflet() %>%
      addTiles()%>% 
      addMarkers(lng = universities$Long, 
                 lat = universities$Lat, 
                 label = utf8decode(universities$name), 
                 popup = paste("Number of masters: ", universities$numberOfMasters, "<br>Number of students: ", universities$population, "<br>Percentage of women: ",  round((universities$womenNum/universities$population)*100,2), "%<br>Average insertion rate: ", universities$insertionRate, "%<br>Average income: ", universities$income, " euros", sep = ""), 
                 options = markerOptions(riseOnHover = TRUE), 
                 clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
      setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
    else if(input$v_scale == "Academy"){
      leaflet() %>%
        addTiles()%>% 
        addMarkers(lng = academies$Long, 
                   lat = academies$Lat, 
                   label = utf8decode(academies$name), 
                   popup = paste("Number of masters: ", academies$numberOfMasters, "<br>Number of students: ", academies$population, "<br>Percentage of women: ",  round((universities$womenNum/universities$population)*100,2), "<br>Average insertion rate: ", academies$insertionRate, "%<br>Average income: ", academies$income, " euros", sep = ""), 
                   options = markerOptions(riseOnHover = TRUE), 
                   clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
        setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
  })
  
  output$diagram <- renderPlot({
    # Render a barplot
    vector  = universitiesRankedByInc$income - 22000
    barplot(vector)
  })
  
}