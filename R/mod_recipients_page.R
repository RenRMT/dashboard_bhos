
# UI ----------------------------------------------------------------------

mod_recipients_ui = function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      h1("Recipients")
      
    ) # fluidRow
  ) #tagList
} # budgetUI

# Server ------------------------------------------------------------------

mod_recipients_server = function(id) {
  moduleServer(id, function(input, output, session) {
    
  }) #moduleServer
} #budgetServer