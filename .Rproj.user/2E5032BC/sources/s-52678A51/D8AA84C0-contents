#' @import shiny
app_server <- function(input, output,session) {
  datafile <- callModule(mod_map_module_server, "map_module_ui_1")
  
  output$mapp <- leaflet::renderLeaflet({
    datafile()
  })
  # List the first level callModules here
}
