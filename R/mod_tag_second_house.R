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
    column(width = 12, visNetwork::visNetworkOutput(ns("plot_network")))
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
      tidyr::gather(key = "key", value = "tag", -c(Title,price)) %>% 
      filter(!is.na(tag)) %>% group_by(tag)  %>% mutate(price = as.numeric(price)) %>% 
      bwplot(tag ~ price, data = ., panel = panel.bpplot,                   
             scale = list(cex = c(1.2,1)),
             box.ratio = 0.5, cex.n = 1.1)
    
    })
  
  output$plot_network <- visNetwork::renderVisNetwork({
    tag = c("VR看装修","VR房源", "房本满两年", 
          "房本满五年", "随时看房", "近地铁")
    #browser()
    
    df1 = df %>% 
      mutate(VR看装修 = str_extract(Tags,"VR看装修"), 
             随时看房= str_extract(Tags,"随时看房"), 
             近地铁 = str_extract(Tags, "近地铁"), 
             VR房源 = str_extract(Tags, "VR房源"),
             房本满两年 = str_extract(Tags, "房本满两年"), 
             房本满五年 = str_extract(Tags, "房本满五年"))  %>% 
      select(VR看装修,VR房源, 房本满两年, 
             房本满五年, 随时看房, 近地铁, price, Title)
    
    df_grid = t(combn(tag,2)) %>% as.data.frame()
    count_n <- function(df, key1, key2){
      k1 = as.name(key1)
      k2 = as.name(key2)
      n = filter(df, !is.na(!!k1) & !is.na(!!k2)) %>% nrow()
      return(n)
    }
    colnames(df_grid) = c("tag1","tag2")
    count = c()
    for (i in c(1:nrow(df_grid))){
      count[i] = count_n(df1,
                         key1 = df_grid$tag1[i], 
                         key2 = df_grid$tag2[i])
      
    }
    df_grid$count = count
    node = data.frame(id = tag, 
                      label = tag,
                      shape = c("circle","circle",
                                "box","box",
                                "triangle","triangle")
    )
    #browser()
    colnames(df_grid) = c("from","to","value")
    #browser()
    visNetwork::visNetwork(nodes = node, edges = df_grid) %>%
      visNetwork::visIgraphLayout()
    
  })
}
    
## To be copied in the UI
# mod_tag_second_house_ui("tag_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_tag_second_house_server, "tag_second_house_ui_1")
 
