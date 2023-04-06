
# UI ----------------------------------------------------------------------

mod_activities_ui <- function(id) {
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
    # summaries
    fluidRow(
        column(width = 4,
        valueBoxOutput(ns("activities_selected"), width = 12)
        ),
        column(width = 4,
               valueBoxOutput(ns("orgs_selected"), width = 12)
               ),
        column(width = 4,
        valueBoxOutput(ns("budget_selected"), width = 12)
        )
    ), # fluidRow (summaries)
    fluidRow(
      box(width = 6,
          
          )
    )
  ) # tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_activities_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$activities_selected <- renderValueBox({
        valueBox(
        filterData(acts, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) %>%
          getCount("iati_identifier"),
        "Activities", icon = icon("list"), color = "green"
        )
      })
      output$orgs_selected <- renderValueBox({
        valueBox(
        filterData(acts, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) %>%
          getCount("participating_org_narrative"),
        "Organisations", icon = icon("sitemap"), color = "red"
        )
      })
        output$budget_selected <- renderValueBox({
          valueBox(
            sprintf("€ %.2f",
            summarise(ungroup(filterBudgetData(activity_budgets, input$year_select[1], input$year_select[2], input$sector_select, input$location_select)
            ), sum(budget_value) / 1000000000)
            ),
            "Total budget (in billions)", icon = icon("money-bill"), color = "blue"
          )
      })
    }
  ) # moduleServer
}
