#' page_design UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_page_design_ui <- function(id){
  ns <- NS(id)
  F_COUNT_ICON_TEMPLATE = "./inst/app/www/modules/count_icon/index.html"
  htmlTemplate(
      filename = F_COUNT_ICON_TEMPLATE,
      icon = "icon-globe",
      count_to = uiOutput(ns("count_to")),
      icon_text = "New house"
    )
   
}
    
#' page_design Server Function
#'
#' @noRd 
mod_page_design_server <- function(input, output, session, df){
  ns <- session$ns
  
  #Sys.setlocale(category = "LC_ALL", locale = "chs")
  #load("data/df_loupan.rda")
  #browser()
  n_price = nrow(df)
  #price = df_loupan %>% filter(!is.na(Unit_price) & Type == "住宅") %>% pull(Unit_price) %>% as.numeric() %>% median()
  output$count_to <- renderUI({
    HTML(sprintf('<h3 class="count-to font-alt" data-countto="%d" style="color: red"></h3>',  n_price))
  })
}
    
## To be copied in the UI
# mod_page_design_ui("page_design_ui_1")
    
## To be copied in the server
# callModule(mod_page_design_server, "page_design_ui_1")
 
