 
library(shiny)
library(shinythemes)
library(markdown)   
 
# Define UI for application that draws a histogram   
ui <- navbarPage(title = "Data of Thrones",
                 #theme = "bootstrap.css",
                 theme = shinytheme("cerulean"), # united
                 tabPanel("Overview", fluidPage(fluidRow(
                   column(12,includeMarkdown("overview.md"))))),
                 tabPanel("Data Acquisition", 
                         fluidPage(fluidRow(
                            column(6, includeMarkdown("acquisition.md"),
                            br()),
                           column(6,  img(src='rating0.png', class="img_border",align = "right"), br()),
                            column(12, img(src='rating1.png', class="adjust_top", class="img_border", align="right"))
                          ))),
                 tabPanel("Data Analysis", "initial analysis, visualizations"),
                 tabPanel("Prediction Model", "steps to build our model"),
                 tabPanel("Results", "describe show results"),
                 tags$head(
                  tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
                 )
)

# Define server logic required to draw a histogram
server <- function(input, output) {}
# Run the application 
shinyApp(ui = ui, server = server)

