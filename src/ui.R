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
                      column(3,
                             selectInput("d_scale", label = "Choose scale", choices  = list("Academy", "University"), selected = "University"),
                             selectInput("d_criteria", label = "Choose a criteria for the ranking", choices  = list("Insertion rate", "Average income", "Quick managers", selected = "Insertion rate"))
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
           
           
           tabPanel("Universities\' info",
                    h1("tableau de données classiques avec fonction de recherche de l\'université afin de consulter
                       la liste des masters disponibles + la note/grade attribuée avec un clustering (kmeans)")
                    )
)

