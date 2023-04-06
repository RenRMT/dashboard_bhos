
# UI ----------------------------------------------------------------------

mod_budget_ui = function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      h1("Budget")

    ) # fluidRow
  ) #tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_budget_server = function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  }) #moduleServer
} #budgetServer