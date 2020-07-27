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
mod_stat_second_house_server <- function(input, output, session, df){
  ns <- session$ns
  output$plot_med_price <- renderEcharts4r({
    df %>% filter(!is.na(Unit_price))  %>% 
      group_by(District)  %>% 
      mutate(count = n_distinct(Title),
             med_price = median(as.numeric(Unit_price))) %>% 
      select(District, med_price,count)  %>% 
      distinct() %>%  arrange(desc(med_price))  %>% 
      e_charts(District) %>%
      e_bar(med_price, name = "Median unit price", stack = 1) %>% 
      e_scatter(count, y_index = 1, symbol = "pin",symbol_size = 12) %>%
      e_legend(show = FALSE) %>%
      e_tooltip(trigger = "axis")  %>% 
      e_x_axis(axisLabel = list(
        rotate = 45, 
        color = "white"
      )
      ) %>% 
      e_y_axis(index = 0, axisLabel= list(color = "white",
                                          splitNumber = 8)) %>% 
      e_y_axis(index = 1, splitLine = list(show = FALSE)) %>% 
      e_y_axis(index = 1, axisLabel= list(color = "white",
                                          splitNumber = 8))
    
  })
}
    
## To be copied in the UI
# mod_stat_second_house_ui("stat_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_stat_second_house_server, "stat_second_house_ui_1")
 
