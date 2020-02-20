# Module UI

#' @title   mod_map_module_ui and mod_map_module_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_map_module
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom stats time
mod_map_module_ui <- function(id){
  
  ns <- shiny::NS(id)
  
  f7Card(
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
    ))
}

# Module Server

#' @rdname mod_map_module
#' @export
#' @keywords internal

mod_map_module_server <- function(input, output, session){
  
  ns <- session$ns
  
  map <- reactive({
    url <- ("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv")
    df <- readr::read_csv(url, col_types = readr::cols())
    dt <- as.POSIXlt(Sys.time(), tz = "UTC")
    # If no file is selected, don't do anything
    new.dt <- dt - as.difftime(input$hours, units="hours")
    df <- df %>% dplyr::filter(time >= new.dt)
    
    df$size <- cut(df$mag,breaks = c(-Inf, 3.9, 4.9, 5.9, 6.9, 7.9, Inf),
                   labels=c("minor", "light", "moderate", "strong", "major", "great 8+"))
    
    # Create popup in HTML
    pop <- paste("<h3>",
                 "<b>Place:</b>", df$place, "<br>",
                 "<b>Time:</b>", df$time, "<br>",   # Format nicer
                 "<b>Mag:</b>", as.character(df$mag), "<br>",
                 "<b>Depth:</b>", as.character(df$depth), "km<br>", "</h3>"
    )
    
    # Create colour pallet
    col_rainbow<- c("#66ffff","#1aff1a","#f07900","#ff0000","#b30000","#b30059")
    pallet <- leaflet::colorFactor(col_rainbow, df$size)
    
    map <- leaflet::leaflet(df, options = leaflet::leafletOptions(minZoom = 2)) %>% 
      
      leaflet::addProviderTiles(leaflet::providers$CartoDB.DarkMatter) %>%
      leaflet::setView(100.65, 120.0285, zoom = 1) %>%
      leaflet::setView(24, 10, zoom=2) %>%
      leaflet::addCircles( ~longitude, ~latitude,  
                  weight= ~ifelse(mag < 4, 1, 6),
                  color= ~pallet(size),
                  radius = ~ifelse(mag < 4, 2, 5), # add ifs
                  popup = pop
      )    %>% 
      leaflet::addLegend( "bottomright", pal = pallet,
                 values = sort(df$size),
                 title = "Magnitude")
  })
  return(map)
  
}

## To be copied in the UI
# mod_map_module_ui("map_module_ui_1")

## To be copied in the server
# callModule(mod_map_module_server, "map_module_ui_1")

