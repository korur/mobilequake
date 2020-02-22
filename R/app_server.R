#' @import shiny
app_server <- function(input, output,session) {
  
time_window <- callModule(mod_input_module_server, "input_module_ui_1")
    
callModule(mod_plots_module_server, "plots_module_ui_1", dataset = quake_df, time_window=time_window)

Sys.sleep(1.6)
waiter::waiter_hide()

}
