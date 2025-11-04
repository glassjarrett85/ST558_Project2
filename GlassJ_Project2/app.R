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

source("helpers.R")

# Details of the columns:
# https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html

# Define the UI
ui <- fluidPage(
  # Add a spacey theme.
  theme=bs_theme(
    bg = "#151525",
    fg = "#F0F0FF",
    primary = "#327ECF",
    base_font = font_google("Space Mono")
  ),
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
                  selected="All",
      ),
      
      # Discovery was space-based or land-based? `facility_type=1` if space-based.
      radioButtons(inputId="subset_whereMade",
                   label="Choose origin of discovery",
                   choiceNames=c("All origins", "Earth-based (observatories)", "Space-based (satellites)"),
                   choiceValues=c("all", "earth", "space"),
                   selected="all",
                   inline=FALSE
      ),
      
      # Discovery methods - 
      radioButtons(inputId="subset_discMethods",
                   label="Methods of Discovery",
                   choiceNames=c("All methods",
                                 "by Wobbles (mass detection)",
                                 "by Flashes (radius detection)"),
                   choiceValues=c("all", "mass", "radius"),
                   # Start with all options selected.
                   selected="all",
                   inline=FALSE
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
                 # Display the subsetted data. Does not appear until the "Generate Subset" button is pressed.
                 mainPanel(
                   h2("Raw Data Subset"),
                   p("Use the input fields in the sidebar to the left to produce a subset of the data you wish to explore."),
                   p("This tab will allow you to visualize the raw data based on the subsetting indicated, and to download a .CSV file."),
                   DTOutput("downloadTable", width="150%"),
                   uiOutput("downloadUI"),
                   br()
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
                   layout_column_wrap(width=1/2,
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Mass versus Radius"),
                                        plotOutput(outputId="graph_1"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Habitable Zone Diagram, S_eff versus Stellar Temp"),
                                        plotOutput(outputId="graph_2"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Discovery Counts by Year and Discovery Method"),
                                        plotOutput(outputId="graph_3"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Metal Content versus Brightness (Grouped by discovery method)"),
                                        plotOutput(outputId="graph_4"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Stellar Metallicity versus numebr of planets?"),
                                        plotOutput(outputId="graph_5"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Size of planets within habitable zone?"),
                                        plotOutput(outputId="6"),
                                      ),
                                      card(
                                        class="border-5 shadow-lg",
                                        full_screen = TRUE,
                                        card_header("Size of a planet and its orbital period."),
                                        plotOutput(outputId="graph_9")
                                      )
                   )
                 )
        )
      )
    )
  )
)


server <- function(input, output, session) { 
  out <- reactiveVal(value=NULL)
  observeEvent(input$data_subset_action, {
    # Generate Filtered Set based on the subset information from sidebar.
    filtered_set <- fullData %>% 
      filter(disc_year >= input$subset_discYear[1] & disc_year <= input$subset_discYear[2]) %>%               # Filter years of discovery
      filter(sy_dist >= input$subset_distance[1] & sy_dist <= input$subset_distance[2]) %>%                   # Filter by Distance from Sol to this star system
      {if (input$subset_habitable != "All") filter(., habitable == input$subset_habitable) else .} %>%        # Filter for whether it is within the habitable zone
      {if (input$subset_planetSize != "All") filter(., planetSize == input$subset_planetSize) else .} %>%     # Filter for planet size
      {if (input$subset_whereMade != "all") filter(., based == input$subset_whereMade) else .} %>%            # Land or space-based discovery
      {if (input$subset_discMethods != "all") filter(., methods == input$subset_discMethods) else .}          # Discovery methods - whether by mass or by radius
    
    out(filtered_set)
    output$downloadUI <- renderUI({
      downloadButton("rawdataDownload", "Download Subset")
    })
  })
  output$downloadTable <- renderDT({
    out()
  })
  # Pressing the DOWNLOAD SUBSET button will download the subset data table contents to a file.
  output$rawdataDownload <- downloadHandler(
    filename = function() { paste("exoplanet_", Sys.Date(), ".csv", sep="") },
    content = function(file) { write.csv(out(), file) }
  )
  
  # Add the plots for each Card.
  
  #   card_header("Planet Mass versus Planet Radius"),
  #   plotOutput(outputId="graph_1"),
  output$graph_1 <- renderPlot({
    ggplot(data=out(), aes(x=pl_bmasse, y=pl_rade)) +
      geom_point()
  })
  
  #   card_header("Habitable Zone Diagram, S_eff versus Stellar Temp"),
  #   plotOutput(outputId="graph_2"),
  output$graph_2 <- renderPlot({
    ggplot(data=out(), aes(x=pl_insol, y=st_teff, color=habitable)) +
      geom_point()
  })
  
  #   card_header("Discovery Counts by Year and Discovery Method"),
  #   plotOutput(outputId="graph_3"),
  #   Maybe this one would be good as a heat map?
  output$graph_3 <- renderPlot({
    ggplot(data=out(), aes(x=disc_year, color=discoverymethod)) +
      geom_histogram()
  })

  #   card_header("Host Star Metal Content versus Brightness (Grouped by discovery method)"),
  #   plotOutput(outputId="graph_4"),
  output$graph_4 <- renderPlot({
    ggplot(data=out(), aes(x=st_met, y=sy_gaiamag, group=methods)) +
      geom_point()
  })
  
  #   card_header("Stellar Metallicity versus number of planets?"),
  #   plotOutput(outputId="graph_5"),
  output$graph_5 <- renderPlot({
    ggplot(data=out() |> group_by(hostname) |> summarize(n=n(), metallicity=mean(st_met)),
           aes(x=metallicity, y=n)) +
      geom_point()
  })
  
  #   card_header("Size of planets within habitable zone?"),
  #   plotOutput(outputId="6"),
  output$graph_6 <- renderPlot({
    ggplot(data=out() |> filter(habitable=="Yes"),
           aes(x=st_met, y=sy_gaiamag, group=methods)) +
      geom_point()
  })
  
  #   card_header("Size of a planet and its orbital period."),
  #   plotOutput(outputId="graph_9")
  output$graph_9 <- renderPlot({
    ggplot(data=out(), aes(x=pl_rade, y=pl_orbper)) +
      geom_point()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)