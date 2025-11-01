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

# This theme would need some work.
dark_space_theme <- bs_theme(
  # Set the dark mode background (a near-black dark blue)
  bg = "#151525", 
  # Set the light foreground text color
  fg = "#F0F0FF", 
  # Set an accent color for buttons/links (e.g., a nebula blue)
  primary = "#327ECF", 
  base_font = font_google("Space Mono") # Optional: Use a space-themed font
)

# Define the UI
ui <- fluidPage(
  # theme=dark_space_theme,
  title="Exoplanet Astronomy",
  titlePanel("Exploration of Exoplanets - Check it out"),
  sidebarLayout(
    sidebarPanel(
      width=3,
      tags$head(
        tags$style(HTML(".well {font-size: 12px;}"))
      ),
      h3("Subset for Exoplanets"),
      hr(),
      # A slider to show bounds of years of discovery.
      sliderInput(inputId="subset_discYear", 
                  label="Years of Discovery",
                  # Min and Max values taken directly from the NASA dataset.
                  min=1992, 
                  max=2023,
                  value=c(1992, 2023),
                  sep=""
      ),
      
      # In the habitability zone, based on Insolation Flux
      # Using Kopparapu et al. (2013/2014) for OPTIMISTIC HABITABLE ZONES.
      # (`pl_insol` between 0.32 and 1.77)
      radioButtons(inputId="subset_habitable",
                   label="Within the Habitable Zone",
                   choices=c("All", "Yes", "No"),
                   selected="All",
                   inline=TRUE
      ),
      
      # Size of the planet - based on `pl_bmasse`
      selectInput(inputId="subset_planetSize",
                  label="NASA/PHL Planet Type",
                  choices=c("All", 
                            "Terrestrial",  # m < 2M
                            "Super-Earth",  # 2M <= m < 10M
                            "Neptunian",    # 10M <= m < 50M
                            "Jovian"),      # 50M <= m
                  selected="All"
      ),
      
      # Discovery was space-based or land-based? `facility_type=1` if space-based.
      radioButtons(inputId="subset_whereMade",
                   label="Choose origin of discovery",
                   choices=c("All", "Earth-based (observatories)", "Space-based (satellites)"),
                   selected="All",
      ),
      
      # Discovery methods - 
      # WOBBLES: Radial Velocity, Astrometry, Pulsar Timing, Transit Timing Variations (TTV), Disk Kinematics
      # - based on reflex motion on star or neighboring bodies by the mass of the planet.
      # FLASHES: Transit, Microlensing, Imaging, Eclipse Timing Variations, Orbital Brightness Modulation, Pulsation Timing Variations
      # - measure changes in brightness to a star or an object behind it. Lead to measurement of a radius or a brightness property.
      radioButtons(inputId="subset_discMethods",
                   label="Methods of Discovery",
                   choiceNames=c("All",
                                 "by Wobbles (mass detection)",
                                 "by Flashes (radius detection)"),
                   choiceValues=c("all", "mass", "radius"),
                   # Start with all options selected.
                   selected="All"
      ),
      
      # Distance in parsecs from SOL to this star system.
      sliderInput(inputId="subset_distance",
                  label="Distance away (in parsecs)",
                  min=1,
                  max=8500,
                  value=c(1,8500),
                  sep="",
                  ticks=100
      ),
      
      hr(),
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
                   uiOutput("downloadUI")
                   # downloadButton("rawdataDownload", "Download Subset", disabled=TRUE)
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
                   h1("Here is for data exploration."),
                   p("Suggestions:"),
                   p("1. Mass versus Radius. (Separate by discovery method?)"),
                   p("2. Habitable zone diagrame - Seff versus stellar temperature? stellar size?"),
                   p("3. Discovery counts by year, facet by method (flash vs wobble)?"),
                   p("4. Orbital period versus size?"),
                   p("5. Stellar metallicity (FE/H ratio of star) versus number of planets per star?"),
                   p("6. Planet size distribution within the habitable zone?"),
                   p("7. Eccentricity of planet versus its habitability? Or size? Or period?"),
                   p("8. Planet Radius versus Stellar Age"),
                   p("9. Planet Mass versus Density"),
                   p("10. Size of planets versus distance to stars. I feel like this can also be grouped based on ... some other categorical variable.")
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
    output$downloadUI <- renderUI({
      downloadButton("rawdataDownload", "Download Subset")
    })
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