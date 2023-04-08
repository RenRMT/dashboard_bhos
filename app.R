library(dplyr)
library(DT)
library(ggplot2)
library(plotly)
library(purrr)
library(scales)
library(shiny)
library(shinydashboard)
library(stringr)
library(tidyr)

# module files
source("./R/mod_activities_page.R", local = TRUE)
source("./R/mod_recipients_page.R", local = TRUE)
source("./R/mod_budget_page.R", local = TRUE)

# script files
source("./R/utils.R", local = TRUE)

# data files
tables = readRDS("./data/tables.rds")
codelists = readRDS("./data/codelists.rds")
# ui ----------------------------------------------------------------------

ui <- function() {
  dashboardPage(

    # Header ------------------------------------------------------------------
    header = dashboardHeader(title = "Dutch Development Activities"),

    # Sidebar -----------------------------------------------------------------

    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Activities", tabName = "activities", icon = icon("list-check")),
        menuItem("Recipients", tabName = "recipients", icon = icon("people-arrows")),
        menuItem("Budget", tabName = "budget", icon = icon("money-bill-trend-up"))

      ) # sidebarMenu
    ),

    # Body --------------------------------------------------------------------

    body = dashboardBody(
      tabItems(
        tabItem("activities", mod_activities_ui("activities_1")),
        tabItem("recipients", mod_recipients_ui("recipients_1")),
        tabItem("budget", mod_budget_ui("budget_1"))
      ) # tabItems
    ) # dashboardBody
  ) # dashboardpage
} # ui function

# server ------------------------------------------------------------------

# Define server logic
server <- function(input, output) {
  mod_activities_server("activities_1")
  mod_recipients_server("recipients_1")
  mod_budget_server("budget_1")

}

# Run the application
shinyApp(ui, server)
