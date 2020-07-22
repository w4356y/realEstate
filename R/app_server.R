#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session) {
  # List the first level callModules here
  Sys.setlocale(category = "LC_ALL", locale = "chs")
  load("data/df_loupan.rda")
  library(dplyr)
  library(glue)
  library(echarts4r)
  library(Hmisc)
  #callModule(mod_basic_stat_server, "basic_stat_ui_1")
  #callModule(mod_page_design_server, "page_design_ui_1")
  #d_data_model <- reactive({ readRDS("data/app-data-model.rds") })
  #callModule(, "blog_counter", d_data_model, "n_blogs")
  callModule(mod_page_design_server, "page_design_ui_1", df = df_loupan)
  callModule(mod_price_new_house_server, "price_new_house_ui_1", df = df_loupan)
  callModule(mod_count_second_house_server, "count_second_house_ui_1", df = df_ershou)
  callModule(mod_price_second_house_server, "price_second_house_ui_1", df = df_ershou)
  callModule(mod_stat_new_house_server, "stat_new_house_ui_1", df = df_loupan)
  callModule(mod_tag_new_house_server, "tag_new_house_ui_1",df = df_loupan)
  
  output$last_refresh <- renderUI({
    last_refresh_formatted <- strftime(Sys.Date(), format = "%Y-%m-%d")
    HTML(glue('<h4 style="color: purple">Last data refresh occurred on <strong>{ last_refresh_formatted }</strong></h4>.'))
  })
}
