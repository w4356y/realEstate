# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file
#Sys.setlocale(category = "LC_ALL", locale = "chs")
pkgload::load_all()
options( "golem.app.prod" = TRUE)
#source('R/run_app.R')
run_app()