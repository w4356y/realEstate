#' price_new_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_price_new_house_ui <- function(id){
  ns <- NS(id)
  F_COUNT_ICON_TEMPLATE = "./inst/app/www/modules/count_icon/index.html"
  htmlTemplate(
      filename = F_COUNT_ICON_TEMPLATE,
      icon = "icon-flag",
      count_to = uiOutput(ns("count_to")),
      icon_text = "New house price"
  )
  
}
    
#' price_new_house Server Function
#'
#' @noRd 
mod_price_new_house_server <- function(input, output, session, df){
  ns <- session$ns
  #n_price = nrow(df)
  #browser()
  price = df %>% filter(!is.na(Unit_price)) %>% pull(Unit_price) %>% as.numeric() %>% median()
  output$count_to <- renderUI({
    HTML(sprintf('<h3 class="count-to font-alt" data-countto="%g" style="color: red"></h3>',price))
    #HTML(sprintf('<h3  style="color: red"><font face = "Arial" size = "5">%s</font></h3>',  paste0(price)))
  })
}
    
## To be copied in the UI
# mod_price_new_house_ui("price_new_house_ui_1")
    
## To be copied in the server
# callModule(mod_price_new_house_server, "price_new_house_ui_1")
 
