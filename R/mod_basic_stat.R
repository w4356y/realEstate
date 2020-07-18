#' basic_stat UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_basic_stat_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 12, echarts4r::echarts4rOutput(ns("plot1"), height = "200px")),
      column(width = 4, echarts4r::echarts4rOutput(ns("plot2"), height = "250px")),
      column(width = 4, echarts4r::echarts4rOutput(ns("plot3"), height = "250px")),
      column(width = 4, echarts4r::echarts4rOutput(ns("plot4"), height = "250px")),
    )
 
  )
}
    
#' basic_stat Server Function
#'
#' @noRd 
mod_basic_stat_server <- function(input, output, session){
  ns <- session$ns
  output$plot1 <- echarts4r::renderEcharts4r({
    df <- data.frame(x = 1:100, y = seq(1, 200, by = 2))
    mtcars %>% 
      e_charts(qsec) %>%
      e_line(mpg)
    
  })
  output$plot2 <- echarts4r::renderEcharts4r({
    cars %>%
      e_charts(speed) %>%
      e_line(dist) %>%
      e_x_axis(speed) %>%
      e_y_axis(dist)
     
    
  })
  output$plot3 <- echarts4r::renderEcharts4r({
    CO2 %>%
      group_by(Plant) %>%
      e_charts(conc) %>%
      e_area(uptake) %>%
      e_tooltip(trigger = "axis")
    
    
  })
 
}
    
## To be copied in the UI
# mod_basic_stat_ui("basic_stat_ui_1")
    
## To be copied in the server
# callModule(mod_basic_stat_server, "basic_stat_ui_1")
 