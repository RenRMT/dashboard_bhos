
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
          selectizeInput(
            NS(id, "activity_select"),
            label = "Select activity",
            choices = NULL
          )
        ),
        column(
          width = 4,
          selectizeInput(NS(id, "location_select"),
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
          ),
          radioButtons(
            NS(id, "transaction_type"),
            label = "Transaction type",
            choices = c("commitment", "disbursement"),
            inline = TRUE
          )
        )
      )
    ), # fluidRow (controls)
    fluidRow(
      box(
        width = 6,
        h2("Activity budget in €", align = "center"),
        plotlyOutput(ns("budget_graph"))
      ),
      box(
        width = 6,
        h2("Activity transactions in €", align = "center"),
        plotlyOutput(ns("transaction_graph"))
      ),
    ) # fluidRow
  ) # tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_budget_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      activities_filtered <- reactiveValues()
      observeEvent(
        {
          input$sector_select
          input$location_select
        },
        {
          activities_filtered$title_narrative <- filterData(
            activities,
            2001,
            2045,
            input$sector_select,
            input$location_select) %>%
            dplyr::select(title_narrative) %>%
            unlist()

          updateSelectizeInput(session, "activity_select",
            choices = sort(unique(activities_filtered$title_narrative)),
            server = TRUE
          )
        },
        ignoreNULL = FALSE
      )

      output$budget_graph <- renderPlotly({
        activity_budgets[activity_budgets$iati_identifier == returnIdentifier(activities, "title_narrative", input$activity_select), ] %>%
          dplyr::group_by(year) %>%
          dplyr::summarise(Year = year, Budget = round(sum(budget_value, na.rm = TRUE), 2), .groups = "keep") %>%
          makeLineGraph(vars = c("Year", "Budget"), color = "red")
      })
      output$transaction_graph <- renderPlotly({
        activity_transactions[activity_transactions$iati_identifier == returnIdentifier(activities, "title_narrative", input$activity_select), ] %>%
          dplyr::group_by(year) %>%
          dplyr::summarise(Year = year, Transaction = round(sum(.data[[input$transaction_type]], na.rm = TRUE), 2), .groups = "keep") %>%
          makeLineGraph(vars = c("Year", "Transaction"), color = "darkgreen")
      })
    }
  ) # moduleServer
} # budgetServer
