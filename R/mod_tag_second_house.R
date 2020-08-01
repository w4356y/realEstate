#' tag_second_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tag_second_house_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(width = 6, shiny::plotOutput(ns("plot_tag_box"),width = "auto", height = "500px")),    
    column(width = 6, echarts4r::echarts4rOutput(ns("plot_tag_wordcloud"), height = "500px")),
    
  )
}
    
#' tag_second_house Server Function
#'
#' @noRd 
mod_tag_second_house_server <- function(input, output, session, df){
  ns <- session$ns
  output$plot_tag_wordcloud <- renderEcharts4r({
    df$Title %>% str_split(" ") %>% unlist() %>% table(dnn = "Tag") %>% 
      as.data.frame() %>% 
      arrange(desc(Freq)) %>% filter(Freq>5) %>% filter(Tag != "") %>% e_color_range(Freq, color) %>% 
      e_charts() %>% 
      e_cloud(Tag, Freq, 
              color, shape = "square", 
              sizeRange = c(10, 42))  %>% 
      e_tooltip(trigger = "item") 
    })
  
  output$plot_tag_box <- renderPlot({
    df %>% 
      mutate(VR看装修 = str_extract(Tags,"VR看装修"), 
             随时看房= str_extract(Tags,"随时看房"), 
             近地铁 = str_extract(Tags, "近地铁"), 
             VR房源 = str_extract(Tags, "VR房源"),
             房本满两年 = str_extract(Tags, "房本满两年"), 
             房本满五年 = str_extract(Tags, "房本满五年"))  %>% 
      select(VR看装修,VR房源, 房本满两年, 
             房本满五年, 随时看房, 近地铁, price, Title) %>% 
      gather(key = "key", value = "tag", -c(Title,price)) %>% 
      filter(!is.na(tag)) %>% group_by(tag)  %>% mutate(price = as.numeric(price)) %>% 
      bwplot(tag ~ price, data = ., panel = panel.bpplot,                   
             scale = list(cex = c(1.2,1)),
             box.ratio = 0.5, cex.n = 1.1)
    
    })
 
}
    
## To be copied in the UI
# mod_tag_second_house_ui("tag_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_tag_second_house_server, "tag_second_house_ui_1")
 
