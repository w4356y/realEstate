#' count_second_house UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_count_second_house_ui <- function(id){
  ns <- NS(id)
  F_COUNT_ICON_TEMPLATE = "./inst/app/www/modules/count_icon/index.html"
  shiny::htmlTemplate(
    filename = F_COUNT_ICON_TEMPLATE,
    icon = "icon-phone",
    count_to = uiOutput(ns("count_to")),
    icon_text = "Second House"
  )
}
    
#' count_second_house Server Function
#'
#' @noRd 
mod_count_second_house_server <- function(input, output, session, df){
  ns <- session$ns
  #price = df_loupan %>% filter(!is.na(Unit_price) & Type == "住宅") %>% pull(Unit_price) %>% as.numeric() %>% median()
  #browser()
  output$count_to <- renderUI({
    shiny::HTML(sprintf('<h3 class="count-to font-alt" data-countto="%g" style="color: blue"></h3>',  sum(df$HouseNum)))
    #HTML(sprintf('<h3  style="color: red">%s</h3>',  paste0("10000+")))
  })
 
}
    
## To be copied in the UI
# mod_count_second_house_ui("count_second_house_ui_1")
    
## To be copied in the server
# callModule(mod_count_second_house_server, "count_second_house_ui_1")
 
