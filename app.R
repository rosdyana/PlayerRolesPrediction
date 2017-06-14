library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "Player Roles Prediction - Dota 2",
  titleWidth = 330),
  ## Sidebar content
  dashboardSidebar(
    width = 330,
    sidebarMenu(
      menuItem("Introduction", tabName = "top_scorer_ranks", icon = icon("male")),
      menuItem("Player Roles Prediction", tabName = "team_profile", icon = icon("shield")),
      div(style="display:inline-block",actionButton("about", "About", icon = icon("info-circle"))),
      div(style="display:inline-block", actionButton(
        "github",
        "Github",
        icon = icon("github"),
        onclick = "window.open('https://github.com/rosdyana/PlayerRolesPrediction', '_blank')"
      ))
    )
  ),
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
