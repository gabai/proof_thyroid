#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Thyroid"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         
        sliderInput("tsh", 
                     "TSH",
                     min=0.01,
                     max=10,
                     value = 2.5
                     ),
         
         sliderInput("t4",
                     "T4",
                     min=4,
                     max=12,
                     value = 6
                     )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tableOutput("distTable")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
     output$distTable <- renderTable({
       usertest<- data.frame(tsh=input$tsh,input$t4)
      #Evaluate model
      model %>%
         evaluate(usertest,
                  testlabel)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

