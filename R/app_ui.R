#' @import shiny
#' @import shinyMobile
#' @import leaflet
#' @import echarts4r
#' @import shinyscroll
#' @import waiter
#' @import dplyr



url <- ("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv")
quake_df <- readr::read_csv(url, col_types = readr::cols())
quake_df <- quake_df %>% filter(!is.na(quake_df$mag))
quake_df$size <- cut(quake_df$mag,breaks = c(-Inf, 3.9, 4.9, 5.9, 6.9, 7.9, Inf),
               labels=c("minor", "light", "moderate", "strong", "major", "great 8+"))
current_time <- as.POSIXlt(Sys.time(), tz = "UTC")

loader <- tagList(
  waiter::spin_3circles(),
  br(),br(),
  h3("Accessing real-time data...")
)

app_ui <- function() {
  version <- paste0("v", packageVersion("mobilequake"))
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    f7Page(
      shinyscroll::use_shinyscroll(),
      sever::use_sever(),
      waiter::use_waiter(), # dependencies
      waiter::waiter_show_on_load(loader, color = "#000000"),
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
        f7Panel(
          title = "About", 
          side = "left", 
          theme = "dark",
          effect = "cover",
          p("Dashboard to track Earthquakes in real-time, based on USGS data. Built with shinyMobile & echarts4r & leaflet & Golem. The code is open-source so you can deploy it yourself."),
          f7Link(label = "Author", src = "https://dataatomic.com", external = TRUE),
          f7Link(label = "Code", src = "https://github.com/korur/mobilequake", external = TRUE),
          f7Link(label = "USGS", src = "https://earthquake.usgs.gov/", external = TRUE),
          f7Link(label = "Coronavirus Tracker", src = "http://tools.dataatomic.com/shiny/CoronaOutbreak/", external = TRUE)
        ),
        
        f7Card(mod_input_module_ui("input_module_ui_1")),
        mod_plots_module_ui("plots_module_ui_1")
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
