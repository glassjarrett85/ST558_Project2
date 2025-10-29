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

df <- read.csv("exoplanetsdata.csv", header=TRUE) |>
  mutate(across(c(pl_name, hostname, sy_snum, sy_pnum, discoverymethod, disc_year, disc_facility), factor))

# Which columns do I want to keep? I don't think I need all 85 columns. 
# Details of the columns:
# https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html

# To start: I just copied text in directly from our last homework assignemnt, and I can tweak from here.

# Number of stars: sy_num
# Number of planets: sy_pnum
# Number of moons: sy_mnum
# YES OR NO: Planet orbits binary star system? : cb_flag

# Planet discovery method: discoverymethod
# Discovery year: disc_year

source("helpers.R")

# Define UI
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
      actionButton("corr_sample","Get a Sample!")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Info", mainPanel(
          h1("This is the Main Panel"),
          "I can put whatever I want",
          br(),
          h2("To add later.")
        )),
        tabPanel("Stars"),
        tabPanel("Planets")
      )
    )
  )
)


server <- function(input, output, session) { }

# Run the application 
shinyApp(ui = ui, server = server)