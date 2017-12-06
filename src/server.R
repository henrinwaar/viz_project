library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(sqldf)
library(htmltools)

source("helpers.R")


function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    if(input$v_scale == "University"){
      leaflet() %>%
        addTiles()%>% 
        addMarkers(universities$Long, universities$Lat, label = universities$name, popup = giveTheListOfMasters(universities$name), options = markerOptions(riseOnHover = TRUE), clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
        setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
    else if(input$v_scale == "Academy"){
      leaflet() %>%
        addTiles()%>% 
        addMarkers(academies$Long, academies$Lat, label = htmlEscape(academies$academy), options = markerOptions(riseOnHover = TRUE), clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
        setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
  })
  
  output$table <- DT::renderDataTable({
    df <- cleanData
    action <- DT::dataTableAjax(session, df)
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
  
}