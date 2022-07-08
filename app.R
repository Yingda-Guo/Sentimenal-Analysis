library(shiny)
library(shinydashboard)
library(shinyWidgets)

# Set python environment
library(reticulate)

# Add a new line
# = use_python("/usr/local/bin/python3")
virtualenv_create('pyDev',python = '/usr/bin/python3')
virtualenv_install("pyDev", packages = c('nltk', 'textblob'))
reticulate::use_virtualenv("pyDev", required = TRUE)

py_run_string("import nltk")
# py_run_string("nltk.download('punkt')")
py_run_string("from textblob import TextBlob")


# Create a Guide
library(cicerone)

guide <- Cicerone$
  new()$ 
  step(
    el = "tai_1",
    title = "Text Input",
    description = "Type in a word or a sentense for sentiment analysis"
  )$
  step(
    "ab_1",
    "Click here for Analysis",
    "Run NPL algorithm for sentiment analysis"
  )

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Sentiment Analysis", titleWidth = 300),
  dashboardSidebar(disable = T),
  dashboardBody(
    tags$style("
              body {
    -moz-transform: scale(1.3, 1.3); /* Moz-browsers */
    zoom: 1.3; /* Other non-webkit browsers */
    zoom: 130%; /* Webkit browsers */}
              "),
    use_cicerone(), # include dependencies
    box(
      title = "Wirte a note for analysis:", solidHeader = TRUE, width = 12, 
      textAreaInput(inputId = "tai_1", label = "", width = "100%", height = "100px", resize = "vertical"),
      div(style="display:inline-block;width:100%;text-align: center;", 
          actionBttn(
            inputId = "ab_1",
            label = "Analysis",
            style = "unite", 
            color = "primary"
          )
      )
    )
  )
)

server <- function(input, output, session) {
  # initialise then start the guide
  guide$init()$start()
  
  observeEvent(input$ab_1,{
    strings <- input$tai_1
    # Run python code
    py_run_string(paste0("blob = TextBlob('",strings,  "')"))
    py_run_string("result = blob.sentiment.polarity")
    r <- py$result
    if(r > 0.1){
      sendSweetAlert(
        session = session,
        title = "Positive !!",
        text = paste0("polarity is ", r),
        type = "success"
      )
    }else if(r < -0.1){
      sendSweetAlert(
        session = session,
        title = "Negative !!",
        text = paste0("polarity is ", r),
        type = "error"
      )
    }else{
      sendSweetAlert(
        session = session,
        title = "Neutral !!",
        text = paste0("polarity is ", r),
        type = "info"
      )
    }
  })
}

shinyApp(ui, server)