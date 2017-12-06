library(shiny)
library(leaflet) 
library(htmltools)

source("helpers.R") 
data <- read.csv("data/insertionPro1.csv", header = TRUE, sep = ",")

ui <- fluidPage(
  
  titlePanel("censusVis"),
  
    sidebarPanel(
      
      selectInput(
        "scale",     # will be called after by using input$var in the output function 
        label = "Choose the scale",
        choices = list("Region", "City", "University"),
        selected = "University"
      ),
      
      selectInput(
        "course",     # will be called after by using input$var in the output function 
        label = "Choose the domain of studies",
        choices = insertionPro1$discipline,
        selected = "University"
      )
    ),
  mainPanel(
    #     textOutput("selected_var"),
    #     textOutput("min_max"),
    
    #m <- leaflet(data) %>% setView(lng = 2.9252801, lat = 47.3824086, zoom = 6)%>% addTiles()%>% addMarkers( popup = ~htmlEscape(data$cle_etab))
    leafletOutput("mymap"),
    p()
    
    # plotOutput("map")
    #The functions have to be defined in the sever part
  )
)

server <- function(input, output,session) {
  
  # Definition des fonctions render qui permettent un affichage en temps reel
  
  #  output$selected_var <- renderText({ 
  #    paste("You have selected", input$var)
  #  })
  
  #  output$min_max <- renderText({ 
  #    paste("You have chosen a range that goes from",
  #          input$range[1], "to", input$range[2])
  #  })
  
  
  output$mymap <- renderLeaflet({
    leaflet(data) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(popup = ~htmlEscape(data$cle_etab))
  })
}

shinyApp(ui, server)