
# UI ----------------------------------------------------------------------

mod_activities_ui = function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      box(
      h1("Activities")
      )
    ) # fluidRow
  ) #tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_activities_server = function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  }) #moduleServer
} #budgetServer