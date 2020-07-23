#' stat_second_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_stat_second_house_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(width = 12, echarts4r::echarts4rOutput(ns("plot_med_price"), height = "300px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_type"), height = "200px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_status"), height = "200px"))
  )
}
    
#' stat_second_house Server Function
#'
#' @noRd 
mod_stat_second_house_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_stat_second_house_ui("stat_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_stat_second_house_server, "stat_second_house_ui_1")
 
