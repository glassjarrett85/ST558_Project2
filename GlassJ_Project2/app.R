# ST558 Project 2
# This will be programmed, submitted to Github, and published to my account
# at shinyapps.io.
# I have already authenticated this laptop, so when I am ready to deploy:
# rsconnect::deployApp('path/to/your/app')

# Topic of this project: EXOPLANETS. Use the exoplanets dataset from kaggle.com.

library(shiny)
library(shinyalert)
library(tidyverse)
library(bslib)
library(DT)

# Details of the columns:
# https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html

# To start: I just copied text in directly from our last homework assignemnt, and I can tweak from here.

# The helpers.R file contains variable listings.
source("helpers.R")

# Define the UI
ui <- fluidPage(
  h2("Exploration of Exoplanets"),
  sidebarLayout(
    sidebarPanel(
      h2("Explore Exoplanets"),
      
      selectInput("corr_x", "First Numeric Variable", numeric_vars[-1]),
      selectInput("corr_y", "Second Numeric Variable", numeric_vars),
      
      h2("Choose a subset of the data:"),
      
      # Options to select for Household Language
      radioButtons("hhl_corr","Household Language", choiceNames=c("All","English only","Spanish", "Other"),
                   choiceValues=c("all","english","spanish","other")),
      
      # Options to select for SNAP Recipients
      radioButtons("fs_corr","SNAP Recipient", choiceNames=c("All", "Yes", "No"),
                   choiceValues=c("all","yes","no")),
      
      # Options to select for Educational Attainment
      radioButtons("schl_corr","Educational attainment",
                   choiceNames=c("All","High School not Completed", "High School or GED", "College Degree"),
                   choiceValues=c("all", "no_hs", "hs", "college")),
      
      h2("Select a Sample Size"),
      sliderInput("corr_n", "", value=20, min=20, max=500),
      actionButton("data_subset_action","Generate Subset")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("About", 
                 # Describe the purpose of the app
                 # Discuss the data, its source; provide a link to the main page
                 # The purpose of the side bar and each tab
                 # Include a related picture to the data
                 mainPanel(
                   h1("This is the Main Panel"),
                   "I can put whatever I want",
                   br(),
                   h2("To add later.")
                 )
        ),
        
        tabPanel("Data Download",
                 
                 # Display data using DT::dataTableOutput() with DT::renderDataTable()
                 # Data should be subsetted when the user selects a subset in sidebar and presses the Go button
                 # Save the subsetted* data as a file, use a download() button
                 
                 mainPanel(
                   h2("Raw Data Subset"),
                   p("Use the input fields in the sidebar to the left to produce a subset of the data you wish to explore."),
                   p("This tab will allow you to visualize the raw data based on the subsetting indicated, and to download a .CSV file."),
                   DTOutput("downloadTable", width="50%"),
                   downloadButton("rawdataDownload", "Download Subset")
                 )
        ),
        
        tabPanel("Data Exploration",
                 # The numerical and graphical summaries from 'Prepare for your App'
                 #      - One- and Two- way contingency tables
                 #      - Numerical summaries (means, medians, sd's) for quantitative variables
                 #            of levels of categorical variables.
                 #      - At least 6 plots -- 
                 #            * Four should be multivariate via type of graph. Use grouping, color, etc
                 #            * All plots should have nice labels and axes
                 #            * Some kind of faceting used somewhere in at least one
                 #            * One plot not covered in class --- a heatmap? I like heatmaps.
                 #
                 # The data to be shown here is based on the subsetting that is done.
                 # User should be able to choose to display the categorical data summaries or the
                 #    numeric variable summaries. Display the graphs and the numbers separately
                 #    or together. 
                 # Create the types of summaries and graphs - one- and two-way contingency tables,
                 #    bar charts, summary stats across categorical variables, etc.
                 # User should be able to choose which variables are summarized or plotted
                 # Account for errors that may pop up in the widget. Use loading spinners for plots
                 #    that may take a while to load.
                 mainPanel(
                   h1("Here is for data exploration.")
                 )
        )
      )
    )
  )
)


server <- function(input, output, session) { 
  out <- reactiveVal(value=NULL)
  observeEvent(input$data_subset_action, {
    out(fullData)
  })
  output$downloadTable <- renderDT(out())
  # Pressing the DOWNLOAD SUBSET button will download the subset data table contents to a file.
  output$rawdataDownload <- downloadHandler(
    filename = function() { paste("exoplanet_", Sys.Date(), ".csv", sep="") },
    content = function(file) { write.csv(out(), file) }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)