
# UI ----------------------------------------------------------------------

mod_recipients_ui = function(id) {
  ns <- NS(id)
  tagList(
    # controls
    fluidRow(
      box(
        width = 12,
        column(
          width = 4,
          selectizeInput(
            NS(id, "org_select"),
            label = "Select organisation",
            choices = NULL
          )
        ),
        column(
          width = 4,
          selectizeInput(NS(id, "org_type_select"),
                         label = "Filter Organisation type(s)",
                         choices = sort(unique(activity_orgs$org_type_name)),
                         multiple = TRUE
          )
        ),
        column(
          width = 4 #,
          # selectInput(NS(id, "sector_select"),
          #             label = "Filter sector(s)",
          #             choices = sort(unique(activity_sectors$name)),
          #             multiple = TRUE
          # )
        )
      )
    ), # fluidRow (controls)
    #summaries
    fluidRow(
      column(width = 4,
             valueBoxOutput(ns("activities_selected"), width = 12)
      ),
      column(width = 4,
             valueBoxOutput(ns("locations_selected"), width = 12)
      ),
      column(width = 4,
             valueBoxOutput(ns("sectors_selected"), width = 12)
      )
    ), # fluidRow (summaries)
    # table
    fluidRow(
      box(
        width = 12,
        DT::dataTableOutput(ns("activities_table"))
      )
    ) #fluidRow (table)
  ) #tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_recipients_server = function(id) {
  moduleServer(
    id, 
    function(input, output, session) {
      orgs_filtered <- reactiveValues()
      observeEvent(
        {
          input$org_type_select
        },
        {
          orgs_filtered$participating_org_narrative <- filterOrgData(
            activity_orgs,
            input$org_type_select) %>%
            dplyr::select(participating_org_narrative) %>%
            unlist()
          
          updateSelectizeInput(session, "org_select",
                               choices = sort(unique(orgs_filtered$participating_org_narrative)),
                               server = TRUE
          )
        },
        ignoreNULL = FALSE
      )
    activities_filtered = reactive({
      dplyr::filter(activities, participating_org_narrative == input$org_select)
    })
    
    output$activities_selected <- renderValueBox({
      valueBox(
        activities_filtered() %>%
          getCount("iati_identifier"),
        "Activities", icon = icon("list"), color = "green"
      )
    })
    output$locations_selected <- renderValueBox({
      valueBox(
        activities_filtered() %>%
          getCount("location_narrative"),
        "Locations", icon = icon("location-dot"), color = "red"
      )
    })
    output$sectors_selected <- renderValueBox({
      valueBox(
        activities_filtered() %>%
          getCount("name"),
        "Sectors", icon = icon("building"), color = "blue"
      )
    })
    output$activities_table = DT::renderDataTable(
      arrange(
      rename(
      select(activities_filtered(), title_narrative, description_narrative),
      Title = title_narrative, Description = description_narrative),
      Title
      )
    )
  }) #moduleServer
} #budgetServer