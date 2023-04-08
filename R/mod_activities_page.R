
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
            max = as.numeric(format(Sys.Date(), "%Y")) + 4,
            value = c(as.numeric(format(Sys.Date(), "%Y")) - 4, as.numeric(format(Sys.Date(), "%Y"))),
            sep = ""
          )
        ),
        column(
          width = 4,
          selectInput(NS(id, "location_select"),
            label = "Filter location(s)",
            choices = sort(unique(tables$activity_locations$location_narrative)),
            multiple = TRUE
          )
        ),
        column(
          width = 4,
          selectInput(NS(id, "sector_select"),
            label = "Filter sector(s)",
            choices = sort(unique(tables$activity_sectors$name)),
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
      # box(width = 6,
      #     h2("Policy markers", align = "center"),
      #     plotlyOutput(ns("markers_selected"))
      #     ),
      box(width = 12,
          DT::dataTableOutput(ns("titles_selected"))
          )
    )
  ) # tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_activities_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      activities_selected = reactive(
        filterData(tables$activities, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) 
      )
      output$activities_selected <- renderValueBox({
        valueBox(
        activities_selected() %>%
          getCount("iati_identifier"),
        "Activities", icon = icon("list"), color = "green"
        )
      })
      output$orgs_selected <- renderValueBox({
        valueBox(
        activities_selected() %>%
          getCount("participating_org_narrative"),
        "Organisations", icon = icon("sitemap"), color = "red"
        )
      })
        output$budget_selected <- renderValueBox({
          valueBox(
            sprintf("€ %.2f",
            summarise(ungroup(filterBudgetData(tables$activity_budgets, input$year_select[1], input$year_select[2], input$sector_select, input$location_select)
            ), sum(budget_value) / 1000000000)
            ),
            "Total budget (in billions)", icon = icon("money-bill"), color = "blue"
          )
      })
        output$markers_selected <- renderPlotly({
          filterData(tables$activity_markers, input$year_select[1], input$year_select[2], input$sector_select, input$location_select) %>%
           dplyr::mutate(marker = reorder(marker, policy_marker_code, decreasing = TRUE)) %>% 
            dplyr::filter(policy_marker_significance_binary == 1) %>% 
            makeBarGraph("marker", "Set2")
        })
        output$titles_selected <- DT::renderDataTable({
         activities_selected() %>% 
            select(title_narrative, description_narrative) %>% 
            arrange(title_narrative)
        })
    }
  ) # moduleServer
}
