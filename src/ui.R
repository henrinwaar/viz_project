library(leaflet)

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

        selectInput("v_scale", label = "Choose scale", choices  = list("Academy", "University"), selected = "University"),
        conditionalPanel("input.v_scale", selectInput("v_field", label = "Choose field of studies", choices  = cleanData$field)),
        conditionalPanel("input.v_field",selectInput("v_criteria", label = "Choose a criteria for the ranking", choices  = list("Insertion rate", "Average income", "Quick managers", selected = "Insertion rate")))
      )
    )
  ),

  tabPanel("Data explorer",
    fluidRow(
      column(3,
             selectInput("d_scale", label = "Choose scale", choices  = list("Academy", "University"), selected = "University"),
             selectInput("d_field", label = "Choose field of studies", choices  = cleanData$field),
             selectInput("d_criteria", label = "Choose a criteria for the ranking", choices  = list("Insertion rate", "Average income", "Quick managers", selected = "Insertion rate"))
      ),
    hr(),
    DT::dataTableOutput("table")
    )
  )
)