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
    column(width = 12, echarts4r::echarts4rOutput(ns("plot_med_price"), height = "450px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_type"), height = "300px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_status"), height = "300px")),
    #column(width = 12, shiny::div(style = 'overflow-x: scroll; overflow-y: scroll; color:"blue"', DT::dataTableOutput(ns("house_info")))),
    column(width = 6, echarts4r::echarts4rOutput(ns("distrib_total_price"), height = "300px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("distrib_unit_price"), height = "300px"))
    
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
      mutate(count = n_distinct(Title),
             med_price = median(as.numeric(Unit_price))) %>% 
      select(District, med_price,count)  %>% 
      distinct() %>%  arrange(desc(med_price))  %>% 
      e_charts(District) %>%
      e_bar(med_price, name = "Median unit price", stack = 1) %>% 
      e_scatter(count, y_index = 1, symbol = "pin",symbol_size = 15) %>%
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
        style = c( "decimal"))) %>% e_theme("vintage")
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
        style = c( "decimal"))) %>% e_theme("essos")
  })
  # output$house_info <- DT::renderDataTable({
  #   #browser()
  #   DT::datatable(df %>% 
  #                   select(-c(Location,Tags, Unit_Price, Total_Price,Area_small,Area_big)), 
  #                 extensions = 'Buttons', 
  #                 options = list(
  #                   pageLength = 8,
  #                   dom = 'Bfrtip',
  #                   initComplete = DT::JS(
  #                     "function(settings, json) {",
  #                     "$(this.api().table().header()).css({'background-color': '#42f', 'color': '#fff'});",
  #                     "$(this.api().table().content()).css({'background-color': '#42f', 'color': '#fff'});",
  #                     "}"),
  #                   buttons = c('print','excel')
  #                 )
  #   )
  # })
  output$distrib_total_price <- renderEcharts4r({
    
    filter(df, !is.na(T_price)) %>% 
      pull(T_price) %>% 
      stringr::str_replace_all(.,"\\s","") %>%
      as.numeric() %>% cut(., breaks = c(0,50,100,150,200,240,280,300, 9000)) %>% 
      table(dnn = "T_price") %>% 
      as.data.frame() %>% 
      e_chart(T_price) %>% 
      e_line(Freq) %>% e_title("Distribution of total price") %>% 
      e_x_axis(axisLabel = list(
        rotate = 45, 
        color = "black"
      )
      ) %>% 
      e_legend(show = FALSE) %>% 
      e_tooltip(trigger = "axis") %>%
      e_theme("essos") 
    
    })
  
  output$distrib_unit_price <- renderEcharts4r({
    
    df %>% 
      filter(!is.na(Unit_price)) %>% 
      pull(Unit_price) %>% 
      as.numeric() %>% 
      cut(., breaks = c(0,10000, 15000,20000, 
                        25000,30000, 100000),na.rm = T) %>%
      table(dnn = "Unit_price") %>% 
      as.data.frame() %>% 
      mutate(price = c("0~10k","10k~15k",
                       "15k~20k","20k~25k",
                       "25k~30k","30k+")) %>% 
      e_chart(price)  %>% e_line(Freq) %>% e_title("Distribution of unit price") %>% 
      e_x_axis(axisLabel = list(
        rotate = 45, 
        color = "black")) %>% 
      e_legend(show = FALSE) %>% 
      e_tooltip(trigger = "axis") %>%
      e_theme("vintage") 
    
  })
}
    
## To be copied in the UI
# mod_stat_new_house_ui("stat_new_house_ui_1")
    
## To be copied in the server
# callModule(mod_stat_new_house_server, "stat_new_house_ui_1")
 
