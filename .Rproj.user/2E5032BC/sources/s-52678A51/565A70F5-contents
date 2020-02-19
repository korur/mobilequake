#' @import shiny
#' @import shinyMobile
#' @import leaflet
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    f7Page(
      title = "Earthquake Tracker",
      dark_mode = TRUE,
      init = f7Init(
        skin = "auto", 
        theme = "dark"
      ),
      f7SingleLayout(
        navbar = f7Navbar(
          title = "Earthquake Tracker",
          hairline = TRUE,
          shadow = TRUE,
          left_panel = TRUE,
          right_panel = FALSE
        ), 
        mod_map_module_ui("map_module_ui_1"),leafletOutput("mapp")
      ))
    
  ) #taglist
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'mobilequake')
  )
  
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
