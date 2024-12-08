library(shiny)
library(shinydashboard)
library(shinythemes)
library(collapsibleTree)
library(shinycssloaders)
library(leaflet)
library(DT)
library(tigris)
library(markdown)
library(plotly)


shinyUI(fluidPage(
  
  # load custom stylesheet
  includeCSS("www/style.css"),
  
  # load google analytics script
  #tags$head(includeScript("www/google-analytics-bioNPS.js")),
  
  # remove shiny "red" warning messages on GUI
  # tags$style(type="text/css",
  #            ".shiny-output-error { visibility: hidden; }",
  #            ".shiny-output-error:before { visibility: hidden; }"
  # ),
  # 
  # load page layout
  dashboardPage(
    
    skin = "green",
      
    # header
    dashboardHeader(title="Taiwan Biodiversity Data Gap", titleWidth = 300,
                    
                    # language icon
                    tags$li(class = "dropdown",
                            tags$a(href = "https://biodivdatagap.tbiadata.tw", 
                                   icon("globe"), class = "nav-link", target = "_blank")),
                    
                    # github icon
                    tags$li(class = "dropdown",
                            tags$a(href = "https://github.com/daphnehoh/BiodiversityDataGapTW", 
                                   icon("github"), class = "nav-link", target = "_blank"))
                    ),
    
    # sidebar
    dashboardSidebar(width = 300,
      sidebarMenu(
        HTML(paste0(
          "<br>",
          "<a href='https://tbiadata.tw' target='_blank'>
          <img style='display: block; margin-left: auto; margin-right: auto;' src='TBIA_logo_white.png' width='270'></a>",
          "<br>"
          )),
        menuItem(HTML("&nbsp;Home"), tabName = "home", icon = icon("home")),
        menuItem(HTML("&nbsp;Description"), tabName = "descriptions", icon = icon("pencil")),
        menuItem(HTML("&nbsp;Taxon data overview"), tabName = "taxa", icon = icon("tree")),
        menuItem(HTML("&nbsp;Taxon tree"), tabName = "tree", icon = icon("tree")),
        menuItem(HTML("&nbsp;Temporal data overview"), tabName = "time", icon = icon("clock")),
        menuItem(HTML("&nbsp;Spatial data overview"), tabName = "map", icon = icon("map-location-dot")),
        menuItem(HTML("&nbsp;Fill the gap!"), tabName = "fillgap", icon = icon("map-marked-alt")),
        menuItem(HTML("&nbsp;Call for Data"), tabName = "callfordata", icon = icon("phone")),
        menuItem(HTML("&nbsp;Release & Reference"), tabName = "releases", icon = icon("tasks")),
        
        HTML(paste0(
        "<br>",
        "<br>",
        "<div style='text-align: center;'>
          <div style='display: inline-block; margin: 10px;'>
            <a href='mailto:tbianoti@gmail.com' target='_blank'><i class='fa-solid fa-envelope'></i></a><br>
          </div>
          <div style='display: inline-block; margin: 10px;'>
            <a href='https://www.youtube.com/@tbia4945' target='_blank'><i class='fab fa-youtube fa-lg'></i></a><br>
          </div>
        </div>"),
        
        HTML(paste0(
         "<p style = 'text-align: center;'><large>&copy; <a href='https://tbiadata.tw/' target='_blank'>TBIA 臺灣生物多樣性資訊聯盟</a>",
          "<div style='text-align: center; font-size: small;'>Last update: 2024-10-27</div>")
        ))
      )
      
    ), # end dashboardSidebar
    
    
    # body
    dashboardBody(
      
      tags$style(HTML(".content-wrapper { overflow-y: hidden; }")),
      
      tags$script(HTML('
        $(document).on("change", "#taxaSubGroup", function(){
          
          // When the selectize input changes
          var selectedOptions = $("#taxaSubGroup").val();
          
          // Set the value of the checkbox based on whether there are selected options
          $("#showAll").prop("checked", selectedOptions == null || selectedOptions.length === 0);
        
        });
      ')),
      
      tabItems(
        
        # Section: Home # --------------------------------------------------------------------
        tabItem(tabName = "home", 
                includeMarkdown("www/home.md")
                ),
        
        
        
        # Section: Descriptions # --------------------------------------------------------------------
        tabItem(tabName = "descriptions", 
                fluidRow(
                  HTML("<h3>&nbsp;&nbsp;Data descriptions</h3>"),
                  br(),
                  valueBox(value = paste("22,510,389"), subtitle = "All TBIA Data (ver20241026)", icon = icon("database"), color = "red"),
                  valueBox(value = paste("21,031,819"), subtitle = "Cleaned TBIA Data", icon = icon("broom"), color = "orange")),
                includeMarkdown("www/descriptions.md")
                ),
        
        
        
        # Section: Taxonomic Gap # --------------------------------------------------------------------
        tabItem(tabName = "taxa",
                includeMarkdown("www/taxa.md"),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                HTML("<h4><b>TBIA records in TaiCOL:</b></h4>"),
                
                fluidRow(
                  column(6,
                         div(HTML("<b>Record matched to highest Linnaean taxon rank</b>"), style = "margin-bottom: 10px;"),
                         plotlyOutput("taxa.pie.taxonRank", height = 400)),
                  column(6,
                         div(HTML("<b>Species (& infraspecies) recorded in TBIA</b>"), style = "margin-bottom: 10px;"),
                         plotlyOutput("taxa.pie.TaiCOL", height = 400))),
                
                br(),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                
                fluidRow(
                  column(4,
                         div(HTML("<b>Taxon group and record count:</b>"), style = "margin-bottom: 10px;"),
                         br(),
                         div(DTOutput("df_allOccCount_grid_table"), style = "width: 100%;")),
                  
                  column(8,
                         div(HTML("<b>Taxon group and basis of record:</b>"), style = "margin-bottom: 10px;"),
                         HTML("This plot allow you to view the record distribution across taxon groups and its basis of record. The lighter the color, the greater the record count."),
                         br(),
                         plotlyOutput("df_bof", height = 800))
                  ),
                
                br(),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                
                HTML("<h4><b>Taxon group on their habitat (based on TaiCOL):</b></h4>"),
                HTML("Note: Some records contain species that have not yet been included in TaiCOL, so there may be cases where the number of species “Recorded in TBIA” is greater than the “Total species count in TaiCOL”. This currently applies only to Amphibians and Ferns."),
                br(),
                HTML("The bar chart can be enlarged by selecting the range. Double-click to return to the default mode."),
                br(),
                br(),
                column(2, uiOutput("taxa.landtype.taxa.prop"), br()),
                br(),
                column(12,
                       div(HTML("<b>Recorded and unrecorded species in TBIA (excluding infraspecies)</b>"), style = "margin-bottom: 10px;"),
                       plotlyOutput("taxa.bar.unrecorded.taxa", height = 500))
        ),
      
        
        
        # Section: Species Tree # --------------------------------------------------------------------
        tabItem(tabName = "tree",
                includeMarkdown("www/tree.md"),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                column(3, uiOutput("taxa.treeSubGroup")),
                column(2, downloadButton("downloadData", "Download species list currently not recorded on TBIA")),
                column(12, 
                       box(width = 12, style = "overflow-y: scroll; height: 5000px;",
                       collapsibleTreeOutput('tree', height = '5000px')))
                ),
        
        
        
        # Section: Temporal Gap # --------------------------------------------------------------------
        tabItem(
          tabName = "time",
          includeMarkdown("www/temporal.md"),
          HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
          fluidRow(
            column(3,
                   selectizeInput(
                     inputId = "time.taxaSubGroup",
                     label = "Select taxon group:",
                     choices = NULL,
                     multiple = TRUE,
                     options = list(create = TRUE)
                   ),
                   br(),
                   sliderInput("time.year", "Select year range:", min = 1900, max = 2024, value = c(1900, 2024), step = 1),
                   br(),
                   selectizeInput(
                     inputId = "time.month",
                     label = "Select month:",
                     choices = 1:12,
                     selected = 1:12,
                     multiple = TRUE,
                     options = list(create = TRUE)
                   )
            ),
            column(9,
                   fluidRow(
                     column(12, 
                            box(width = 12, title = "Year", plotlyOutput("time.yearBarChart"))
                     ),
                     column(12, 
                            box(width = 12, title = "Month", plotlyOutput("time.monthBarChart"))
                     )
                   )
            )
          )
        ),
      
        
        
        # Section: Spatial Gap # --------------------------------------------------------------------
        tabItem(
          tabName = "map",
          includeMarkdown("www/spatial.md"),
          HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
          fluidRow(
            column(
              width = 4,
              box(
                width = 12,
                checkboxInput("showAll", HTML("<b>Show all records</b>"), value = T),
                HTML("<b>OR</b>"), br(), br(),
                selectizeInput(
                  inputId = "spatial.taxaSubGroup",
                  label = "Select taxon group:",
                  choices = NULL,
                  multiple = T,
                  options = list(create = T)
                )))),
            fluidRow(
              column(
                width = 12,
                leafletOutput("spatialMap", height = 900))
            )
          ),

        
        
        # Section: Fill the Gap! # --------------------------------------------------------------------
        tabItem(tabName = "fillgap",
                includeMarkdown("www/fillgap.md"),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                fluidRow(valueBox(4387, "Number of priority grids to fill", icon = icon("triangle-exclamation"), color = "maroon"),
                         valueBox(390, "Number of recommended grids to fill", icon = icon("star"), color = "purple"),
                         valueBox(1028, "Number of grids with above average record count", icon = icon("thumbs-up"), "blue")),
                fluidRow(column(width = 4, uiOutput("gap.priority"))),
                fluidRow(column(width = 8, leafletOutput("gapMap", height = 650)),
                         column(width = 4, DTOutput("gapCount")))
                ),
        
        
        
        # Section: Call for data # --------------------------------------------------------------------
        tabItem(tabName = "callfordata", 
                includeMarkdown("www/callfordata.md")
        ),
        
        
        
        # Section: Releases & Ref # --------------------------------------------------------------------
        tabItem(tabName = "releases", 
                includeMarkdown("www/releases.md"),
                HTML("<hr style='border-color: darkgreen; border-width: 1px; border-style: solid;'>"),
                includeMarkdown("www/references.md"))
        
        
        ) # end tabItems
    
      ) # end dashboardBody
  
  ) # end dashboardPage

)) # end fluidPage