
# UI ----------------------------------------------------------------------

mod_about_ui = function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      h1("About")
      
    ) # fluidRow
  ) #tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_about_server = function(id) {
  moduleServer(id, function(input, output, session) {
    
  }) #moduleServer
} #budgetServer