#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    # fluidPage(
    #   h1("realEstate")
    # ),
    
    
    #mod_basic_stat_ui("basic_stat_ui_1"),
    htmlTemplate(
      filename = "./inst/app/www/index.html",
      new_house = mod_page_design_ui("page_design_ui_1"),
      new_house_price = mod_price_new_house_ui("price_new_house_ui_1"),
      second_house = mod_count_second_house_ui("count_second_house_ui_1"),
      second_house_price = mod_price_second_house_ui("price_second_house_ui_1"),
      last_refresh = uiOutput("last_refresh"),
      stat_new_house = mod_stat_new_house_ui("stat_new_house_ui_1"),
      tag_new_house = mod_tag_new_house_ui("tag_new_house_ui_1")
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'realEstate'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

