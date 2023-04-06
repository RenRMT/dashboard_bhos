library(shiny)
library(shinydashboard)
source("../R/mod_activities_page.R", local = TRUE)
source("../R/mod_budget_page.R", local = TRUE)
source("../R/mod_recipients_page.R", local = TRUE)
source("../R/mod_about_page.R", local = TRUE)

# Define UI for application that draws a histogram

ui <- function() {
  tagList(
    dashboardPage(

      # Header ------------------------------------------------------------------
      header = dashboardHeader(title = "Dutch Development Cooperation"),

      # Sidebar -----------------------------------------------------------------

      sidebar = dashboardSidebar(
        sidebarMenu(
          id = "tabs",
          menuItem("Activities", tabName = "activities", icon = icon("list-check")),
          menuItem("Budget", tabName = "budget", icon = icon("money-bill-trend-up")),
          menuItem("Recipients", tabName = "recipients", icon = icon("people-arrows")),
          menuItem("About", tabName = "about", icon = icon("circle-info"))
        ) # sidebarMenu
      ),

      # Body --------------------------------------------------------------------

      body = dashboardBody(
        tabItems(
          tabItem("activities", mod_activities_ui("activities_ui_1")),
          tabItem("budget", mod_budget_ui("budget_ui_1")),
          tabItem("recipients", mod_recipients_ui("recipients_ui_1")),
          tabItem("about", mod_about_ui("about_ui_1"))
        ) # tabItems
      ) # dashboardBody
    ) # dashboardpage
  ) # tagList
} # ui function

# server ------------------------------------------------------------------

# Define server logic
server <- function(input, output) {
  mod_activities_server("activities_1")
  mod_budget_server("budget_1")
  mod_recipients_server("server_1")
  mod_about_server("about_1")
}

# Run the application
shinyApp(ui = ui, server = server)
