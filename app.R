# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file
pkgload::load_all()
#Sys.setlocale(category = "LC_ALL", locale = "chs")
options( "golem.app.prod" = TRUE)
#source('R/run_app.R')
run_app()