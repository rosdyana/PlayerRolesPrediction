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
      menuItem("Introduction", tabName = "introduction_tab", icon = icon("info-circle")),
      menuItem("Player Roles Prediction", tabName = "prediction_tab", icon = icon("pied-piper-alt")),
      div(style="display:inline-block",actionButton("about", "About", icon = icon("user-md"))),
      div(style="display:inline-block", actionButton(
        "github",
        "Github",
        icon = icon("github"),
        onclick = "window.open('https://github.com/rosdyana/PlayerRolesPrediction', '_blank')"
      ))
    )
  ),
  dashboardBody(
    tags$head(tags$style(
      HTML(
        "
        @import url('//fonts.googleapis.com/css?family=Roboto+Slab');
        body {
        font-family: 'Roboto Slab', serif;
        font-size: 14px;
        }
        .main-header .logo {
        font-family: 'Roboto Slab', serif;
        font-size: 20px;
        }
        "
      )
    )),
    tabItems(
    tabItem(tabName = "introduction_tab",
            fluidPage(
              box(
                title = tagList(shiny::icon("info-circle") , "Introduction"),
                width = NULL,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                p('Abstract—State-of-the-art, Computer games are big
business, which is also reflected in the growing interest
in competitive gaming. Multi-player online battle arena
games are the most successful competitive gaming in
computer games industry. Every player has own specific
roles in this team based game. Dota 2 is the most popular
for this games. This paper analyzing player roles and
their behavior using supervised machine learning and also
investigates the applicability of feature normalization to
enhance the accuracy of prediction result.We provide an
in-depth discussion and novel approaches for constructing
complex attributes from low-level data extracted from
replay files. Using attribute evaluation techniques, we are
able to reduce a larger set of candidate attributes down to
a manageable number. Random Forest the decision trees
algorithm is the most stable and best-performing classifier
in our results. Again, Random Forest although not the best
performing classifier it is proved to be very stable and well
suited to this domain.',al)
              )
            )),
    tabItem(tabName = "prediction_tab",
            fluidPage(
              box(
                title = tagList(shiny::icon("pied-piper-alt") , "Player Roles Prediction"),
                width = NULL,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                textInput("inputId", "Input match ID",width = 200),
                actionButton("go_predict", "Predict")
              )
            ))))
)

server <- function(input, output) { }

shinyApp(ui, server)
