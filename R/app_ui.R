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
      filename = "./inst/app/www/index.html"
      #blog_counter = mod_page_design_ui("page_design_ui_1")
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

