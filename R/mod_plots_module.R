# Module UI
  
#' @title   mod_plots_module_ui and mod_plots_module_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_plots_module
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_plots_module_ui <- function(id){
  ns <- NS(id)
  
  ns <- shiny::NS(id)
  tagList(
    
    f7Card(f7Col(leafletOutput(ns("mapp")))), f7Card(f7Col(echarts4rOutput(ns("timeline"))))
    
  )
}
    
# Module Server
    
#' @rdname mod_plots_module
#' @export
#' @keywords internal
    
mod_plots_module_server <- function(input, output, session, dataset, time_window){
  
  ns <- session$ns

  qqq <- reactive({
  selected_dt <- current_time - as.difftime(time_window(), units="hours")
  quake_selected <- quake_df %>% dplyr::filter(time >= selected_dt)
  return(quake_selected)
  })
  
  mapp <- reactive({
    
    # Create popup in HTML
    pop <- paste("<h3>",
                 "<b>Place:</b>", qqq()$place, "<br>",
                 "<b>Time:</b>", qqq()$time, "<br>",   # Format nicer
                 "<b>Mag:</b>", as.character(qqq()$mag), "<br>",
                 "<b>Depth:</b>", as.character(qqq()$depth), "km<br>", "</h3>"
    )
    
    # Create colour pallet
    col_rainbow<- c("#66ffff","#1aff1a","#f07900","#ff0000","#b30000","#b30059")
    pallet <- leaflet::colorFactor(col_rainbow, qqq()$size)
    
    # Create the map
    map <- leaflet::leaflet(qqq(), options = leaflet::leafletOptions(minZoom = 2)) %>% 
      
      leaflet::addProviderTiles(leaflet::providers$CartoDB.DarkMatter) %>%
      leaflet::setView(100.65, 120.0285, zoom = 1) %>%
      leaflet::setView(24, 10, zoom=2) %>%
      leaflet::addCircles( ~longitude, ~latitude,  
                           weight= ~ifelse(mag < 4, 1, 6),
                           color= ~pallet(size),
                           radius = ~ifelse(mag < 4, 2, 5), # add ifs
                           popup = pop) %>% 
      leaflet::addLegend( "bottomright", pal = pallet,
                          values = sort(qqq()$size))
    return(map)
  })
  # Leaflet map output
  
  output$mapp <- leaflet::renderLeaflet({
    mapp()
  })
  
  # Earthquake timeline echarts4r output
  
  output$timeline <- renderEcharts4r({

   qqq() %>%  
      e_charts(time) %>%
      e_bar(mag) %>% 
      e_axis_labels(x = "Date",y= "Magnitute") %>% # axis labels
      e_title("Timeline" ) %>%  # Add title 
      e_theme("halloween") %>%  # theme
      e_legend(show = FALSE) %>%  # move legend to the bottom
      e_tooltip(trigger = "axis")  %>% #tooltip
      e_visual_map(mag, orient = "horizontal",
                   right = "center",
                   top = 5,
                   textStyle = list(color = "#fff"), scale = NULL)  
    
  }) 
  
  
}
    
## To be copied in the UI
# mod_plots_module_ui("plots_module_ui_1")
    
## To be copied in the server
# callModule(mod_plots_module_server, "plots_module_ui_1")
 
