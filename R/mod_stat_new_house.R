#' stat_new_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_stat_new_house_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(width = 12, echarts4rOutput(ns("plot_med_price"), height = "300px")),
    column(width = 6, echarts4rOutput(ns("plot_house_type"), height = "200px")),
    column(width = 6, echarts4rOutput(ns("plot_house_status"), height = "200px")),
    column(width = 12, shiny::div(style = 'overflow-x: scroll; overflow-y: scroll; color:"blue"', DT::dataTableOutput(ns("house_info")))),
    column(width = 4, echarts4rOutput(ns("plot_acc_author"), height = "250px")),
  )
}
    
#' stat_new_house Server Function
#'
#' @noRd 
mod_stat_new_house_server <- function(input, output, session, df){
  ns <- session$ns
  output$plot_med_price <- renderEcharts4r({
    df %>% filter(!is.na(Unit_price))  %>% 
      group_by(District)  %>% 
      mutate(med_price = median(as.numeric(Unit_price))) %>% 
      select(District, med_price)  %>% 
      distinct() %>%  arrange(desc(med_price))  %>% 
      e_charts(District) %>%
      e_bar(med_price, name = "Median unit price", stack = 1) %>% 
      e_legend(show = FALSE) %>%
      e_tooltip(trigger = "axis")  %>% 
      e_x_axis(axisLabel = list(
                                rotate = 45, 
                                color = "white"
                                )
               ) %>% 
      e_y_axis(axisLabel= list(color = "white",
                               splitNumber = 8))
    
    })
 
  output$plot_house_status <- renderEcharts4r({
    df$Status %>% 
      table(dnn = "Status") %>% 
      as.data.frame()  %>%
      mutate(Frequency = round(Freq/nrow(df),2)) %>%
      mutate(Status = paste(Status, round(Freq,2))) %>% 
      arrange(desc(Freq)) %>% 
      e_charts(Status, width = 300,) %>% 
      e_pie(Frequency) %>% 
      e_pie_select(dataIndex = 0) %>% 
      e_legend(show = FALSE) %>% 
      e_tooltip(formatter = e_tooltip_pie_formatter(
        style = c( "decimal")))
    })
  output$plot_house_type <- renderEcharts4r({
    df$Type %>% 
      table(dnn = "Type") %>% 
      as.data.frame()  %>% 
      mutate(Frequency = round(Freq/nrow(df),2)) %>%
      mutate(Type = paste(Type, Freq)) %>%
      arrange(desc(Frequency)) %>%
      e_charts(Type, width = 300) %>% 
      e_pie(Frequency) %>% 
      e_pie_select(dataIndex = 0) %>% 
      e_legend(show = FALSE) %>% 
      e_tooltip(formatter = e_tooltip_pie_formatter(
        style = c( "decimal")))
  })
  output$house_info <- DT::renderDataTable({
    #browser()
    DT::datatable(df %>% 
                    select(-c(Location,Tags, Unit_Price, Total_Price,Area_small,Area_big)), 
                  extensions = 'Buttons', 
                  options = list(
                    pageLength = 8,
                    dom = 'Bfrtip',
                    initComplete = DT::JS(
                      "function(settings, json) {",
                      "$(this.api().table().header()).css({'background-color': '#42f', 'color': '#fff'});",
                      "$(this.api().table().content()).css({'background-color': '#42f', 'color': '#fff'});",
                      "}"),
                    buttons = c('print','excel')
                  )
    )
  })
}
    
## To be copied in the UI
# mod_stat_new_house_ui("stat_new_house_ui_1")
    
## To be copied in the server
# callModule(mod_stat_new_house_server, "stat_new_house_ui_1")
 
