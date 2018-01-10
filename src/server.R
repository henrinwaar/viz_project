library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(sqldf)
library(htmltools)
library(ggplot2)
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
  
  ## Diagram for income by university
  tableIncUni <- data.frame(x = universitiesRankedByInc$name, y = universitiesRankedByInc$income);
  tableIncUni$x <- factor(tableIncUni$x, levels = universitiesRankedByInc$name);
  
  plotIncUni <- plot_ly(tableIncUni, x = ~x, y = ~y, type = 'bar', name = 'University') %>%
    add_trace(y = universitiesRankedByInc$incomeReg, name = 'Region', opacity = 0.5) %>%
    layout(yaxis = list(title = 'Average income (euros)'), xaxis = list(title = ""), barmode = 'overlay')
  output$diagramIncUni <- renderPlotly(plotIncUni)
  
  ## Diagram for managers by university
  tableManaUni <- data.frame(x = universitiesRankedByManag$name, y = universitiesRankedByManag$managerNum);
  tableManaUni$x <- factor(tableManaUni$x, levels = universitiesRankedByManag$name);
  
  plotManaUni <- plot_ly(tableManaUni, x = ~x, y = ~y, type = 'bar') %>%
    layout(yaxis = list(title = 'Number of quick managers'), xaxis = list(title = ""))
  output$diagramManaUni <- renderPlotly(plotManaUni)
  
  ## Diagram for insertion rate by university
  tableIRUni <- data.frame(x = universitiesRankedByIR$name, y = universitiesRankedByIR$insertionRate);
  tableIRUni$x <- factor(tableIRUni$x, levels = universitiesRankedByIR$name);
  
  plotIRUni <- plot_ly(tableIRUni, x = ~x, y = ~y, type = 'bar') %>%
    layout(yaxis = list(title = 'Insertion rate (%)'), xaxis = list(title = ""))
  output$diagramIRUni <- renderPlotly(plotIRUni)
  
  ## Diagram for income by university
  tableIncUni <- data.frame(x = universitiesRankedByInc$name, y = universitiesRankedByInc$income);
  tableIncUni$x <- factor(tableIncUni$x, levels = universitiesRankedByInc$name);
  
  plotIncUni <- plot_ly(tableIncUni, x = ~x, y = ~y, type = 'bar', name = 'University') %>%
    add_trace(y = universitiesRankedByInc$incomeReg, name = 'Region', opacity = 0.5) %>%
    layout(yaxis = list(title = 'Average income (euros)'), xaxis = list(title = ""), barmode = 'overlay')
  output$diagramIncUni <- renderPlotly(plotIncUni)
  
  #####
  ## Diagram for income by academy
  tableIncAca <- data.frame(x = academiesRankedByInc$academy, y = academiesRankedByInc$income);
  tableIncAca$x <- factor(tableIncAca$x, levels = academiesRankedByInc$academy);
  
  plotIncAca <- plot_ly(tableIncAca, x = ~x, y = ~y, type = 'bar', name = 'Academy') %>%
    add_trace(y = academiesRankedByInc$incomeReg, name = 'Region', opacity = 0.5) %>%
    layout(yaxis = list(title = 'Average income (euros)'), xaxis = list(title = ""), barmode = 'overlay')
  output$diagramIncAca <- renderPlotly(plotIncAca)
  
  ## Diagram for managers by academy
  tableManaAca <- data.frame(x = academiesRankedByManag$academy, y = academiesRankedByManag$managerNum);
  tableManaAca$x <- factor(tableManaAca$x, levels = academiesRankedByManag$academy);
  
  plotManaAca <- plot_ly(tableManaAca, x = ~x, y = ~y, type = 'bar') %>%
    layout(yaxis = list(title = 'Number of quick managers'), xaxis = list(title = ""))
  output$diagramManaAca <- renderPlotly(plotManaAca)
  
  ## Diagram for insertion rate by academy
  tableIRAca <- data.frame(x = academiesRankedByIR$academy, y = academiesRankedByIR$insertionRate);
  tableIRAca$x <- factor(tableIRAca$x, levels = academiesRankedByIR$academy);
  
  plotIRAca <- plot_ly(tableIRAca, x = ~x, y = ~y, type = 'bar') %>%
    layout(yaxis = list(title = 'Insertion rate (%)'), xaxis = list(title = ""))
  output$diagramIRAca <- renderPlotly(plotIRAca)
  
}