
# UI ----------------------------------------------------------------------

mod_budget_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # controls
    fluidRow(
      box(
        width = 12,
        column(
          width = 4,
          sliderInput(
            NS(id, "year_select"),
            label = "Filter by year",
            min = 2001,
            max = 2045,
            value = c(2015, 2023),
            sep = ""
          )
        ),
        column(
          width = 4,
          selectInput(NS(id, "location_select"),
            label = "Filter location(s)",
            choices = sort(unique(activity_locations$location_narrative)),
            multiple = TRUE
          )
        ),
        column(
          width = 4,
          selectInput(NS(id, "sector_select"),
            label = "Filter sector(s)",
            choices = sort(unique(activity_sectors$name)),
            multiple = TRUE
          )
        )
      )
    ), # fluidRow (controls)
    fluidRow(
      box(
        width = 5,
        h2("Total budget in million €", align = "center"),
        plotlyOutput(ns("budget_graph"))
      ),
      box(
        width = 5,
        h2("Total transactions in million €", align = "center"),
        plotlyOutput(ns("transaction_graph"))
      )
    ) # fluidRow
  ) # tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_budget_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$budget_graph <- renderPlotly(
        filterBudgetData(activity_budgets, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) %>%
          dplyr::group_by(year) %>% dplyr::summarise(Year = year, Budget = round(sum(budget_value) / 1000000, 2), .groups = "keep") %>%
          makeLineGraph(vars = c("Year", "Budget"), color = "red")
      )
      output$transaction_graph <- renderPlotly(
        filterBudgetData(activity_transactions, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) %>%
          dplyr::group_by(year) %>% dplyr::summarise(Year = year, Transactions = round(sum(disbursement, na.rm = TRUE) / 1000000, 2), .groups = "keep") %>%
          makeLineGraph(vars = c("Year", "Transactions"), color = "green")
      )
    }
  ) # moduleServer
} # budgetServer
