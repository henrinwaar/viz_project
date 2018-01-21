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
                   popup = paste("Number of masters: ", universities$numberOfMasters, "<br>Number of students: ", universities$population, "<br>Percentage of women: ",  round((universities$womenNum / universities$population)*100,2), "%<br>Average insertion rate: ", round(universities$insertionRate, 2), "%<br>Average income: ", round(universities$income, 0), " euros", sep = ""), 
                   options = markerOptions(riseOnHover = TRUE), 
                   clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
        setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
    else if(input$v_scale == "Academy"){
      leaflet() %>%
        addTiles()%>% 
        addMarkers(lng = academies$Long, 
                   lat = academies$Lat, 
                   label = utf8decode(academies$academy), 
                   popup = paste("Number of masters: ", academies$numberOfMasters, "<br>Number of students: ", academies$population, "<br>Percentage of women: ",  round((academies$womenNum/academies$population)*100,2), "<br>Average insertion rate: ", round(academies$insertionRate, 2), "%<br>Average income: ", round(academies$income, 0), " euros", sep = ""), 
                   options = markerOptions(riseOnHover = TRUE), 
                   clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)) %>%
        setView(lng = 2.9252801, lat = 47.3824086, zoom = 6) 
    }
  })
  
  ## University ranking barplots ####
  ## Diagram for income by university
  tableIncUni <- data.frame(x = universitiesRankedByInc$name, y = universitiesRankedByInc$income);
  tableIncUni$x <- factor(tableIncUni$x, levels = universitiesRankedByInc$name);
  
  plotIncUni <- plot_ly(tableIncUni, x = ~x, y = ~y, type = 'bar', name = 'University') %>%
    add_trace(y = universitiesRankedByInc$incomeReg, name = 'Region', opacity = 0.5) %>%
    layout(yaxis = list(title = 'Average income (euros)', range = c(23000, 32000)), xaxis = list(title = ""), barmode = 'overlay')
  output$diagramIncUni <- renderPlotly(plotIncUni)
  
  ## Diagram for insertion rate by university
  tableIRUni <- data.frame(x = universitiesRankedByIR$name, y = universitiesRankedByIR$insertionRate);
  tableIRUni$x <- factor(tableIRUni$x, levels = universitiesRankedByIR$name);
  
  plotIRUni <- plot_ly(tableIRUni, x = ~x, y = ~y, type = 'bar', name = 'University') %>%
    layout(yaxis = list(title = 'Insertion rate (%)', range = c(84, 92)), xaxis = list(title = ""))
  output$diagramIRUni <- renderPlotly(plotIRUni)
  
  ## Diagram for managers by university
  tableManaUni <- data.frame(x = universitiesRankedByManag$name, y = universitiesRankedByManag$managerNum);
  tableManaUni$x <- factor(tableManaUni$x, levels = universitiesRankedByManag$name);
  
  plotManaUni <- plot_ly(tableManaUni, x = ~x, y = ~y, type = 'bar', name = 'University') %>%
    layout(yaxis = list(title = 'Percentage of quick managers'), xaxis = list(title = ""))
  output$diagramManaUni <- renderPlotly(plotManaUni)
  
  
  ## Academy ranking barplots ####
  ## Diagram for income by academy
  tableIncAca <- data.frame(x = academiesRankedByInc$academy, y = academiesRankedByInc$income);
  tableIncAca$x <- factor(tableIncAca$x, levels = academiesRankedByInc$academy);
  
  plotIncAca <- plot_ly(tableIncAca, x = ~x, y = ~y, type = 'bar', name = 'Academy') %>%
    add_trace(y = academiesRankedByInc$incomeReg, name = 'Region', opacity = 0.5) %>%
    layout(yaxis = list(title = 'Average income (euros)', range = c(24000, 32000)), xaxis = list(title = ""), barmode = 'overlay')
  output$diagramIncAca <- renderPlotly(plotIncAca)
  
  ## Diagram for managers by academy
  tableManaAca <- data.frame(x = academiesRankedByManag$academy, y = academiesRankedByManag$managerNum);
  tableManaAca$x <- factor(tableManaAca$x, levels = academiesRankedByManag$academy);
  
  plotManaAca <- plot_ly(tableManaAca, x = ~x, y = ~y, type = 'bar', name = 'Academy') %>%
    layout(yaxis = list(title = 'Percentage of quick managers'), xaxis = list(title = ""))
  output$diagramManaAca <- renderPlotly(plotManaAca)
  
  ## Diagram for insertion rate by academy
  tableIRAca <- data.frame(x = academiesRankedByIR$academy, y = academiesRankedByIR$insertionRate);
  tableIRAca$x <- factor(tableIRAca$x, levels = academiesRankedByIR$academy);
  
  plotIRAca <- plot_ly(tableIRAca, x = ~x, y = ~y, type = 'bar', name = 'Academy') %>%
    layout(yaxis = list(title = 'Insertion rate (%)', range = c(84, 92)), xaxis = list(title = ""))
  output$diagramIRAca <- renderPlotly(plotIRAca)
  
  ## Clustering ####

  # output$plot1 <- renderPlot({
  #   palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
  #             "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
  #   plot(selectedData,
  #        col = clusters$cluster,
  #        pch = 20, cex = 3)
  #   points(clusters$centers, pch = 4, cex = 4, lwd = 4)
  # })
  
  plot2bis <- plot_ly(universities, x = ~income, y = ~insertionRate, text = ~name, color = ~grade, colors = c('#0037B9', '#B9000C', '#00B92B')) %>%
    add_markers() %>%
    layout(xaxis = list(title = 'Average Income'),
           yaxis = list(title = 'Insertion Rate'),
           title = "Universities grouped by grade"
           )
  output$plot2 <- renderPlotly(plot2bis)
  
  
  ## Universities info ####
  
  output$grade <- renderText({
    inputbis <- gsub(" ", "_", input$university)
    df1 <- universities %>%
      filter(
        name == inputbis
      )
    
    paste("The university of", input$university, " has ", df1$grade, ".")
  }) 
  
  output$recapTable1 <- renderTable({
    df1 <- cleanTable %>%
      filter(
        name == input$university
      )
    df1 <- sqldf::sqldf("SELECT name, SUM(population) AS Population, SUM(womenNum) AS Women, AVG(insertionRate) AS InsertionRate, AVG(income) AS Income, AVG(scholarPer) AS PercentScholar, (SUM(managerNum)/SUM(population)) AS QuickManagers FROM df1 GROUP BY name")
    df1$InsertionRate <- paste(round(df1$InsertionRate, 2), "%", sep = "")
    df1$Income <- paste(round(df1$Income), "euros", sep = " ")
    df1$PercentScholar <- paste(round(df1$PercentScholar, 2), "%", sep = " ")
    df1$QuickManagers <- paste(round(df1$QuickManagers * 100, 2), "%", sep = " ")
    df1 <- df1[ , !(names(df1) %in% "name")]
    df1 <- df1[ , !(names(df1) %in% "Freq")]
    table(df1)
  })
  
  output$recapTable2 <- DT::renderDataTable({
    df2 <- cleanTable %>%
      filter(
        name == input$university
      )
    df2 <- sqldf::sqldf("SELECT Field, SUM(population) AS Population, SUM(womenNum) AS Women, AVG(insertionRate) AS InsertionRate, AVG(income) AS Income, AVG(scholarPer) AS PercentScholar, (SUM(managerNum)/SUM(population)) AS QuickManagers FROM df2 GROUP BY field")
    df2$InsertionRate <- paste(round(df2$InsertionRate, 2), "%", sep = "")
    df2$Income <- paste(round(df2$Income), "euros", sep = " ")
    df2$PercentScholar <- paste(round(df2$PercentScholar, 2), "%", sep = " ")
    df2$QuickManagers <- paste(round(df2$QuickManagers * 100, 2), "%", sep = " ")
    DT::datatable(df2, escape = FALSE)
  })
}