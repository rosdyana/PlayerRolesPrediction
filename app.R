library(shiny)
library(shinydashboard)
library(ROpenDota)
library(randomForest)
library(digest)

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "Player Roles Prediction - Dota 2",
                  titleWidth = 330),
  ## Sidebar content
  dashboardSidebar(width = 230,
                   sidebarMenu(
                     menuItem(
                       "Introduction",
                       tabName = "introduction_tab",
                       icon = icon("info-circle")
                     ),
                     menuItem(
                       "Player Roles Prediction",
                       tabName = "prediction_tab",
                       icon = icon("pied-piper-alt")
                     ),
                     div(style = "display:inline-block", actionButton("about", "About", icon = icon("user-md"))),
                     div(
                       style = "display:inline-block",
                       actionButton(
                         "github",
                         "Github",
                         icon = icon("github"),
                         onclick = "window.open('https://github.com/rosdyana/PlayerRolesPrediction', '_blank')"
                       )
                     )
                   )),
  dashboardBody(tags$head(tags$style(
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
                h2('Big Data Analytic on DotA2 to Analyzing Player
                     Roles', align = "center"),
                hr(),
                h4(
                  'State-of-the-art, Computer games are big
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
                    suited to this domain.',
                  align = "justify"
                ),
                h4(
                  'This Web interface should help to understand our research work.',
                  align = "justify"
                )
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
                textInput("inputId", "Input match ID", width = 200, placeholder = "e.g.3250523435"),
                actionButton("go_predict", "Predict"),
                hr(),
                verbatimTextOutput("result"),
                hr(),
                p("Database updated : 6/17/2017.")
              )
            ))
  ))
)

server <- function(input, output) {
  prepro_data <- function(match_id) {
    x = get_match_details(match_id)
    kda = x$players$kda
    NK = x$players$neutral_kills
    if (is.null(NK))
      NK = 0
    GPM = x$players$gold_per_min
    if (is.null(GPM))
      GPM = 0
    XPM = x$players$xp_per_min
    if (is.null(XPM))
      XPM = 0
    DN = x$players$denies
    if (is.null(DN))
      DN = 0
    HD = x$players$hero_damage
    if (is.null(HD))
      HD = 0
    HH = x$players$hero_healing
    if (is.null(HH))
      HH = 0
    eff = x$players$lane_efficiency
    if (is.null(eff))
      eff = 0
    lane = x$players$lane_role
    if (is.null(lane))
      lane = 0
    checkMe = data.frame(x$players$purchase)
    Observer = 0
    Sentry = 0
    if (!is.na(checkMe)) {
      Observer = x$players$purchase$ward_observer
      Observer[is.na(Observer)] = 0
      Sentry = x$players$purchase$ward_sentry
      Sentry[is.na(Sentry)] = 0
    }
    
    y = data.frame(lane, eff, HD, GPM, XPM, DN, HH, NK, Observer, Sentry)
    y[is.na(y)] <- 0
    
    
    datasets <- y
    colnames(datasets) <-
      c("lane",
        "eff",
        "HD",
        "GPM",
        "XPM",
        "DN",
        "HH",
        "NK",
        "Observer",
        "Sentry")
    datasets$account_id <- NULL
    filename <- sapply(input$inputId, digest, algo="md5")
    write.table(
      datasets,
      file = paste0("./",filename,".csv", sep = ""),
      row.names = FALSE,
      col.names = FALSE,
      sep = ",",
      append = F,
      quote =
    )
    random_forest(paste0("./",filename,".csv", sep = ""))
  }
  
  random_forest <- function(datasets) {
    super_model <- readRDS("./final_model.rds")
    aa = read.csv(datasets, sep = ",", header = F)
    final_predictions <- predict(super_model, aa)
    output$result <- renderPrint({
      print(final_predictions)
    })
  }
  
  observeEvent(input$go_predict, {
    prepro_data(input$inputId)
  })
  
  observeEvent(input$about, {
    showModal(modalDialog(
      title = span(tagList(icon("info-circle"), "About")),
      div(
        style = "display:inline-block",
        HTML(
          "<img src='https://scontent-tpe1-1.xx.fbcdn.net/v/t1.0-9/14432999_10209025211221091_6098375426366577073_n.jpg?oh=e8e6d7d3c7f7afe6b35ac7a699f5683f&oe=599C9151' width=150><br/><br/>",
          "<p>Ardian Rianto</br><a href=mailto:ardian151551@gmail.com>Email</a></br><a href='https://www.facebook.com/ardian2404' target=blank>FB</a></p>"
        )
      ),
      div(
        style = "display:inline-block",
        HTML(
          "<img src='https://avatars1.githubusercontent.com/u/4516635?v=3&s=460' width=150><br/><br/>",
          "<p>Rosdyana Kusuma</br><a href=mailto:rosdyana.kusuma@gmail.com>Email</a></br><a href='https://www.linkedin.com/in/rosdyanakusuma/' target=blank>linkedin</a></p>"
        )
      ),
      easyClose = TRUE
    ))
  })
}

shinyApp(ui, server)
