library(shiny)
library(ggplot2)
library(RMySQL)
library(ggmap)

#MySQL Database Connection
mysql_host <- "localhost"
mysql_port <- 3306
mysql_user <- "root"
mysql_pass <- "root"
mysql_dbname <- "GroupProj"

mydb = dbConnect(MySQL(), 
                 user=mysql_user, 
                 password=mysql_pass, 
                 dbname=mysql_dbname, 
                 host=mysql_host,
                 port=mysql_port)

#Gets distinct states, rating, category for the dropdownmenu
showState = dbGetQuery(mydb, "select distinct state from restaurants")
showRating= dbGetQuery(mydb, "select distinct rating from restaurants order by rating asc")
showCategory= dbGetQuery(mydb, "select distinct categories from restaurants order by categories asc")
showPrice= dbGetQuery(mydb, "select distinct price from restaurants order by price asc")

dbDisconnect(mydb)

# Define UI
shinyUI(fluidPage(
  # Application title
  titlePanel(title="Interactive Top 100 Washingtonian Restaurants of 2015"),
  sidebarLayout(
    #Sidebar with a drop down menu of states, rating, price
    sidebarPanel(
      #Select state, rating, price
      selectInput("ddmstate", label = h3("Location"), choices = showState, selected = "DC", multiple = FALSE)
      , selectInput("ddmrating", label = h3("Rating(and above)"), choices = showRating, selected = 3.0, multiple = FALSE)
      , selectInput("ddmprice", label = h3("Price"), choices = showPrice, selected = "$", multiple = FALSE)
      #, selectizeInput("ddmcategory", label = h3("Category"), choices = showCategory, selected = "American (New)", multiple = TRUE)
    ),
                mainPanel(
        plotOutput("dataPlot")
    )
  )
))
