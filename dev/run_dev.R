# Set options here
options(golem.app.prod = FALSE)

# Comment this if you don't want the app to be served on a random port
options(shiny.port = 5000)
options(shiny.fullstacktrace = TRUE)
options(launch.browser = TRUE)
options(browser = "/usr/bin/firefox")

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

logger::log_threshold(logger::DEBUG)

# Run the application
run_app()
