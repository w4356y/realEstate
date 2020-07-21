#' tag_new_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tag_new_house_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(width = 6, shiny::plotOutput(ns("plot_tag_box"),width = "auto", height = "500px")),    
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_tag_wordcloud"), height = "500px")),
    
  )
}
    
#' tag_new_house Server Function
#'
#' @noRd 
mod_tag_new_house_server <- function(input, output, session, df){
  ns <- session$ns
  output$plot_tag_wordcloud <- renderEcharts4r({
    df$Tags %>% str_split(" ") %>% unlist() %>%
      table(dnn ="tags") %>% as.data.frame() %>%   e_color_range(Freq, color) %>% 
      e_charts() %>% 
      e_cloud(tags, Freq, 
              color, shape = "circle", 
              sizeRange = c(10, 42))  %>% 
      e_tooltip(trigger = "item") 
    
    })
  output$plot_tag_box <- renderPlot({
    tag_names = df$Tags %>% 
      str_split(" ") %>% unlist() %>% 
      table(dnn = "Tag") %>% 
      as.data.frame() %>% 
      arrange(desc(Freq)) %>% 
      slice(1:14) %>% 
      pull(Tag) %>% 
      as.character()
    lapply(tag_names, 
           function(x) filter(df, 
                              str_detect(Tags, x)) %>% 
             filter(!is.na(Unit_price))  %>% 
             mutate(Unit_price = as.numeric(Unit_price))  %>% 
             filter(Unit_price > 10000) %>% 
             select(District, Status, Type, Unit_price) %>% 
             mutate(tag = x))  %>% bind_rows() %>% 
      filter(Type == "住宅") %>% 
      lattice::bwplot(tag  ~ Unit_price, 
                      data = ., panel = panel.bpplot, 
                      xlim =c(10000 ,50000) , 
                      xlab ='House Price', 
                      scale = list(cex = c(1.2,1)),
                      box.ratio = 0.5, cex.n = 1.1)
    
  })
}
    
## To be copied in the UI
# mod_tag_new_house_ui("tag_new_house_ui_1")
    
## To be copied in the server
# callModule(mod_tag_new_house_server, "tag_new_house_ui_1")
 
