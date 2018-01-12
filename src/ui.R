library(leaflet)
library(plotly)
source("helpers.R")


# Choices for drop-downs

navbarPage("Insertion", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Selection"),
                                      
                                      selectInput("v_scale", label = "Choose scale you want:", choices  = list("Academy", "University"), selected = "University")
                        )
                    )
           ),
           
           tabPanel("Ranking",
                    fluidRow(
                      column(3, offset = 1,
                             selectInput("d_scale", label = "Choose scale", choices  = list("Academy", "University"), selected = "University"),
                             selectInput("d_criteria", label = "Choose a criteria for the ranking", choices  = list("Average income", "Insertion rate", "Quick managers"), selected = "Average income")
                      )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'University' & input.d_criteria == 'Insertion rate'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramIRUni")
                                     )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'University' & input.d_criteria =='Average income'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramIncUni")
                                     )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'University' & input.d_criteria =='Quick managers'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramManaUni")
                                     )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'Academy' & input.d_criteria == 'Insertion rate'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramIRAca")
                                     )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'Academy' & input.d_criteria =='Average income'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramIncAca")
                                     )
                    ),
                    conditionalPanel(condition = "input.d_scale == 'Academy' & input.d_criteria =='Quick managers'",
                                     fluidRow(
                                       hr(),
                                       plotlyOutput("diagramManaAca")
                                     )
                    )
           ),
           
           tabPanel("Universities' info",
                    fluidRow(
                      plotlyOutput("plot2")
                    ),
                    fluidRow(
                      hr(),
                      column(6, offset = 1,
                             selectInput("university", label = "Choose a university", choices  = utf8decode(universities$name), selected = utf8decode(universities$name[1]))
                      ),
                      column(6, offset = 1,
                             textOutput("grade"),
                             br(),
                             tableOutput("recapTable1")
                             )
                    ),
                    fluidRow(
                          conditionalPanel(condition = "input.university",
                            fluidRow(
                              column(10, offset = 1,
                                     br(),
                                     h4("List of masters: "),
                                     hr(),
                                     DT::dataTableOutput("recapTable2")
                              )
                            )
                          )
                      )
                    )
           )



