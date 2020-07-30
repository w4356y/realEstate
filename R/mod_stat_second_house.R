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
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_type"), height = "300px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_size"), height = "300px")),
    #column(width = 6, echarts4r::echarts4rOutput(ns("plot_house_type"), height = "300px")),
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_decoration_pie"), height = "300px")),
    column(width = 6, shiny::plotOutput(ns("plot_decoration_box"),width = "auto", height = "300px")),
    column(width = 12, echarts4r::echarts4rOutput(ns("plot_year_trend"), height = "300px")),
    column(width = 6, shiny::plotOutput(ns("plot_build_height"), width = "auto", height = "300px")),
    column(width = 6, shiny::plotOutput(ns("plot_build_type"),width = "auto", height = "300px")),
    column(width = 6, shiny::plotOutput(ns("plot_follow_price"), width = "auto", height = "300px")),
    column(width = 6, shiny::plotOutput(ns("plot_day_price"),width = "auto", height = "300px"))
  )
}
    
#' stat_second_house Server Function
#'
#' @noRd 
mod_stat_second_house_server <- function(input, output, session, df, df_stat){
  ns <- session$ns
  output$plot_med_price <- renderEcharts4r({
    df %>% group_by(District) %>% 
      summarise(med_price = median(as.numeric(price))) %>%
      left_join(df_stat, by = c("District" = "District")) %>% 
      select(District, med_price,HouseNum)  %>% 
      distinct() %>%  arrange(desc(med_price))  %>% 
      e_charts(District) %>%
      e_bar(med_price, name = "Median unit price", stack = 1) %>% 
      e_scatter(HouseNum, y_index = 1, symbol = "pin",symbol_size = 12) %>%
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
  
  output$plot_house_type <- renderEcharts4r({
    df %>%  mutate(size = stringr::str_extract(HouseInfo,"\\d室\\d厅")) %>% 
      pull(size) %>% base::table(dnn = "Configuration") %>% 
      as.data.frame() %>% arrange(desc(Freq)) %>% 
      dplyr::filter(Freq >10)  %>% 
      e_charts(Configuration) %>% 
      e_polar() %>% 
      e_angle_axis(Configuration,axisLabel = list(
        color = "white")) %>% 
      e_radius_axis(axisLabel= list(color = "white",splitNumber = 8)) %>% 
      e_bar(Freq, coord_system = "polar",color = "purple") %>% 
      e_tooltip(trigger = "item")
    
  })
  output$plot_house_size <- renderEcharts4r({
    #browser()
    df %>%  mutate(area = str_extract(HouseInfo,"\\d+\\.*\\d+平米")) %>% 
      mutate(area = as.numeric(str_replace(area,"平米",""))) %>%  
      filter(area<300) %>% e_chart() %>% 
      e_histogram(area, breaks = 60,color = "skyblue") %>% 
      e_tooltip(trigger = "axis")  %>% 
      e_x_axis(axisLabel = list(
        color = "white",size = 4)) %>% 
      e_y_axis(axisLabel= list(color = "white",
                                          splitNumber = 8))
    
  })
  output$plot_decoration_pie <-  renderEcharts4r({ 
    df %>% tidyr::separate(HouseInfo, c("Size","Area","direction","decoration","height","year","building_type"), 
                           sep = "\\|", remove = FALSE)  %>%   
      filter(decoration %in% c(" 精装 "," 简装 "," 毛坯 "," 其他 "))  %>% 
      pull(decoration)
    df %>% tidyr::separate(HouseInfo, c("Size","Area","direction","decoration","height","year","building_type"), 
                           sep = "\\|", remove = FALSE)  %>%   
      filter(decoration %in% c(" 精装 "," 简装 "," 毛坯 "," 其他 "))  %>% 
      pull(decoration)  %>% table(.,dnn="decoration") %>% 
      as.data.frame() %>% e_chart(decoration) %>%   
      e_pie(Freq, roseType = "radius") %>% e_tooltip(trigger = "item")
    })
  output$plot_decoration_box <- renderPlot({
    df %>% 
      tidyr::separate(HouseInfo, c("Size","Area","direction",
                                   "decoration","height","year","building_type"), 
                      sep = "\\|", remove = FALSE)  %>% 
      filter(decoration %in% c(" 精装 "," 简装 "," 毛坯 "," 其他 ")) %>%  
      mutate(price = as.numeric(str_extract(Unit_Price,"\\d+"))) %>% 
      bwplot(decoration ~ price, data = ., 
             panel = panel.bpplot, scale = list(cex = c(1.2,1)),
                                                                                                                                                                                                                                                                                            box.ratio = 0.5, cex.n = 1.1)
  })
  
  output$plot_year_trend <- renderEcharts4r({ 
    df %>% tidyr::separate(HouseInfo, 
                    c("Size","Area","direction",
                      "decoration","height","year",
                      "building_type"), 
                    sep = "\\|", remove = FALSE) %>% 
      mutate(year = as.numeric(str_extract(year,"\\d+"))) %>% 
      filter(!is.na(year) & year >1990) %>% 
      group_by(year) %>% mutate(price = as.numeric(price)) %>%  
      summarise(n_house = n_distinct(Title), 
                med_price = median(as.numeric(price))) %>% 
      select(year, n_house,med_price) %>% 
      mutate(year = as.factor(year)) %>% 
      e_charts(year) %>% e_scatter(n_house,symbol_size = 8) %>% 
      e_line(med_price,y_index = 1) %>% 
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
  output$plot_build_height <- renderPlot({
    df %>% tidyr::separate(HouseInfo, c("Size","Area","direction",
                                               "decoration","height","year",
                                               "building_type"), 
                                  sep = "\\|", remove = FALSE) %>% 
      mutate(louceng = str_extract(height,"\\w楼层")) %>% 
      mutate(price = as.numeric(str_extract(Unit_Price,"\\d+"))) %>% 
      bwplot(louceng ~ price, data = ., panel = panel.bpplot, 
             scale = list(cex = c(1.2,1)),
             box.ratio = 0.5, cex.n = 1.1)
    
  })
  output$plot_build_type <- renderPlot({ 
    df %>% tidyr::separate(HouseInfo, 
                                  c("Size","Area","direction",
                                    "decoration","height","year","building_type"), 
                                  sep = "\\|", remove = FALSE) %>% 
      mutate(year = as.numeric(str_extract(year,"\\d+"))) %>% 
      mutate(price = as.numeric(str_extract(Unit_Price,"\\d+")), 
             building_type = str_replace(building_type,"\\s",""))  %>%  
      mutate(building_type = str_replace(building_type, "\\s","")) %>%  
      lattice::bwplot(building_type ~ price, data = ., panel = panel.bpplot, 
             scale = list(cex = c(1.2,1)),box.ratio = 0.5, cex.n = 1.1)
    
    })
  
  output$plot_follow_price <- renderPlot({ 
    d = df %>% mutate(follower = str_extract(FollowInfo,"\\d*人"), 
                             time = str_extract(FollowInfo,"(\\w*年)|(\\w*月)|(\\d*天)"))  %>% 
      mutate(time = str_replace_all(time,c("个" = "","一年" = "365","天" = ""))) %>% 
      mutate(time1 = ifelse(str_detect(time,"月"), 30, 1)) %>% 
      mutate(time = str_replace(time,"月","")) %>% 
      mutate(day = as.numeric(time)*time1)  %>% 
      mutate(price = as.numeric(str_extract(Unit_Price,"\\d+")), 
             follower = as.numeric(str_replace(follower,"人",""))) 
    with(d %>% filter(follower < 250), 
         Hmisc::ggfreqScatter(follower, price/1000, 
                       xbreaks = c(5,10,20,30,50,100,150) , 
                       cuts = c(5,10,15,20,25,30,35), fcolor = viridis::viridis(6)) + 
           theme_bw() + xlab("Followers") + ylab("Unit_Price") + 
           theme(axis.title = element_text(size= 15), 
                 axis.text = element_text(size= 12), 
                 axis.text.x = element_text(angle = 90, vjust = 0.5)))
    
    })
  output$plot_day_price <- renderPlot({  
    
    d = df %>% mutate(follower = str_extract(FollowInfo,"\\d*人"), 
                      time = str_extract(FollowInfo,"(\\w*年)|(\\w*月)|(\\d*天)"))  %>% 
      mutate(time = str_replace_all(time,c("个" = "","一年" = "365","天" = ""))) %>% 
      mutate(time1 = ifelse(str_detect(time,"月"), 30, 1)) %>% 
      mutate(time = str_replace(time,"月","")) %>% 
      mutate(day = as.numeric(time)*time1)  %>% 
      mutate(price = as.numeric(str_extract(Unit_Price,"\\d+")), 
             follower = as.numeric(str_replace(follower,"人",""))) 
    with(d %>% filter(day <300 ), 
         Hmisc::ggfreqScatter(day, price/1000, 
                       xbreaks = c(0,10,20,30,60,90,150), 
                       cuts = c(5,10,15,20,25,30,35), 
                       fcolor = viridis::viridis(6)) + 
           theme_bw() + xlab("Online_days") + 
           ylab("Unit_Price") + 
           theme(axis.title = element_text(size= 15), 
                 axis.text = element_text(size= 12), 
                 axis.text.x = element_text(angle = 90, vjust = 0.5)))
    
    })
  
}
    
## To be copied in the UI
# mod_stat_second_house_ui("stat_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_stat_second_house_server, "stat_second_house_ui_1")
 
