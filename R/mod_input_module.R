# Module UI
  
#' @title   mod_input_module_ui and mod_input_module_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_input_module
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_input_module_ui <- function(id){
  ns <- NS(id)
  tagList(
    f7Slider(
      inputId = ns("hours"),
      label = HTML("<h5>","Show Earthquakes within selected hours","</h5>"),
      max = 168,
      min = 0,
      value = 72,
      scaleSteps = 7,
      scaleSubSteps = 1,
      scale = TRUE,
      color = "orange",
      labels = tagList(
        shinyMobile::f7Icon("circle", old=FALSE),
        shinyMobile::f7Icon("circle_fill", old=FALSE)
      )
    )
  )
}
    
# Module Server
    
#' @rdname mod_input_module
#' @export
#' @keywords internal
    
mod_input_module_server <- function(input, output, session){
  ns <- session$ns
  return(
      hours = reactive({ input$hours })
    )
}
    
## To be copied in the UI
# mod_input_module_ui("input_module_ui_1")
    
## To be copied in the server
# callModule(mod_input_module_server, "input_module_ui_1")
 
