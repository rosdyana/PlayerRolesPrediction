library(shiny)
library(shinydashboard)
library(ROpenDota)
library(randomForest)
library(digest)
library(DT)
library(rmarkdown)
options(shiny.sanitize.errors = FALSE)



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
                ))
              #,
              # box(
              #   title = tagList(shiny::icon("fa-thumbs-o-up") , "Credit"),
              #   width = NULL,
              #   status = "primary",
              #   solidHeader = TRUE,
              #   collapsible = TRUE,
              #   collapsed = TRUE,
              #   hr(),
              #   h4(
              #     'The authors would like to thank to :',
              #     align = "justify"
              #   ),
              #   div(
              #     style = "display:inline-block",
              #     HTML('<ul><li>Muhammad Ramadhan</li></ul>'))
              # )
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
                uiOutput("radiant_bar"),
                DT::dataTableOutput("result_rad"),
                uiOutput("dire_bar"),
                DT::dataTableOutput("result_dir"),
                hr(),
                p("Database updated : 6/17/2017.")
              )
            ))
  ))
)

server <- function(input, output) {
  get_hero_icon <- function(id){
    if (id == 1) return("antimage.png")
    if (id == 2) return("axe.png")
    if (id == 3) return("bane.png")
    if (id == 4) return("bloodseeker.png")
    if (id == 5) return("crystal_maiden.png")
    if (id == 6) return("drow_ranger.png")
    if (id == 7) return("earthshaker.png")
    if (id == 8) return("juggernaut.png")
    if (id == 9) return("mirana.png")
    if (id == 10) return("morphling.png")
    if (id == 11) return("nevermore.png")
    if (id == 12) return("phantom_lancer.png")
    if (id == 13) return("puck.png")
    if (id == 14) return("pudge.png")
    if (id == 15) return("razor.png")
    if (id == 16) return("sand_king.png")
    if (id == 17) return("storm_spirit.png")
    if (id == 18) return("sven.png")
    if (id == 19) return("tiny.png")
    if (id == 20) return("vengefulspirit.png")
    if (id == 21) return("windrunner.png")
    if (id == 22) return("zuus.png")
    if (id == 23) return("kunkka.png")
    if (id == 25) return("lina.png")
    if (id == 26) return("lion.png")
    if (id == 27) return("shadow_shaman.png")
    if (id == 28) return("slardar.png")
    if (id == 29) return("tidehunter.png")
    if (id == 30) return("witch_doctor.png")
    if (id == 31) return("lich.png")
    if (id == 32) return("riki.png")
    if (id == 33) return("enigma.png")
    if (id == 34) return("tinker.png")
    if (id == 35) return("sniper.png")
    if (id == 36) return("necrolyte.png")
    if (id == 37) return("warlock.png")
    if (id == 38) return("beastmaster.png")
    if (id == 39) return("queenofpain.png")
    if (id == 40) return("venomancer.png")
    if (id == 41) return("faceless_void.png")
    if (id == 42) return("skeleton_king.png")
    if (id == 43) return("death_prophet.png")
    if (id == 44) return("phantom_assassin.png")
    if (id == 45) return("pugna.png")
    if (id == 46) return("templar_assassin.png")
    if (id == 47) return("viper.png")
    if (id == 48) return("luna.png")
    if (id == 49) return("dragon_knight.png")
    if (id == 50) return("dazzle.png")
    if (id == 51) return("rattletrap.png")
    if (id == 52) return("leshrac.png")
    if (id == 53) return("furion.png")
    if (id == 54) return("life_stealer.png")
    if (id == 55) return("dark_seer.png")
    if (id == 56) return("clinkz.png")
    if (id == 57) return("omniknight.png")
    if (id == 58) return("enchantress.png")
    if (id == 59) return("huskar.png")
    if (id == 60) return("night_stalker.png")
    if (id == 61) return("broodmother.png")
    if (id == 62) return("bounty_hunter.png")
    if (id == 63) return("weaver.png")
    if (id == 64) return("jakiro.png")
    if (id == 65) return("batrider.png")
    if (id == 66) return("chen.png")
    if (id == 67) return("spectre.png")
    if (id == 68) return("ancient_apparition.png")
    if (id == 69) return("doom_bringer.png")
    if (id == 70) return("ursa.png")
    if (id == 71) return("spirit_breaker.png")
    if (id == 72) return("gyrocopter.png")
    if (id == 73) return("alchemist.png")
    if (id == 74) return("invoker.png")
    if (id == 75) return("silencer.png")
    if (id == 76) return("obsidian_destroyer.png")
    if (id == 77) return("lycan.png")
    if (id == 78) return("brewmaster.png")
    if (id == 79) return("shadow_demon.png")
    if (id == 80) return("lone_druid.png")
    if (id == 81) return("chaos_knight.png")
    if (id == 82) return("meepo.png")
    if (id == 83) return("treant.png")
    if (id == 84) return("ogre_magi.png")
    if (id == 85) return("undying.png")
    if (id == 86) return("rubick.png")
    if (id == 87) return("disruptor.png")
    if (id == 88) return("nyx_assassin.png")
    if (id == 89) return("naga_siren.png")
    if (id == 90) return("keeper_of_the_light.png")
    if (id == 91) return("wisp.png")
    if (id == 92) return("visage.png")
    if (id == 93) return("slark.png")
    if (id == 94) return("medusa.png")
    if (id == 95) return("troll_warlord.png")
    if (id == 96) return("centaur.png")
    if (id == 97) return("magnataur.png")
    if (id == 98) return("shredder.png")
    if (id == 99) return("bristleback.png")
    if (id == 100) return("tusk.png")
    if (id == 101) return("skywrath_mage.png")
    if (id == 102) return("abaddon.png")
    if (id == 103) return("elder_titan.png")
    if (id == 104) return("legion_commander.png")
    if (id == 105) return("techies.png")
    if (id == 106) return("ember_spirit.png")
    if (id == 107) return("earth_spirit.png")
    if (id == 108) return("abyssal_underlord.png")
    if (id == 109) return("terrorblade.png")
    if (id == 110) return("phoenix.png")
    if (id == 111) return("oracle.png")
    if (id == 112) return("winter_wyvern.png")
    if (id == 113) return("arc_warden.png")
    if (id == 114) return("monkey_king.png")
  }
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
    x = get_match_details(input$inputId)
    playerName = x$players$personaname
    playerName[is.na(playerName)] = "Anonymous"
    heroId = x$players$hero_id
    m_roles = data.frame(final_predictions)
    colnames(m_roles) = "Roles"
    m_img = c()
    for (i in heroId){
      heroIconx = get_hero_icon(i)
      m_img <- c(m_img, heroIconx)
    }
    m_kill = x$players$kills
    m_death = x$players$deaths
    m_assist = x$players$assists
    dat <- data.frame(
      Name = playerName,
      Hero = m_img,
      Kill = m_kill,
      Death = m_death,
      Assist = m_assist,
      Roles = m_roles
    )
    dat$Hero <- sprintf('<img src="%s" height="33" title="%s"></img>', m_img,m_img)
    radiant = dat[1:5,]
    dire = dat[6:10,]
    output$radiant_bar <- renderUI({
      hr()
      h3("Radiant Team", align="center")
    })
    output$result_rad <- DT::renderDataTable({
      DT::datatable(radiant, escape = FALSE) # HERE
    })
    output$dire_bar <- renderUI({
      hr()
      h3("Dire Team", align="center")
    })
    output$result_dir <- DT::renderDataTable({
      DT::datatable(dire, escape = FALSE) # HERE
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
