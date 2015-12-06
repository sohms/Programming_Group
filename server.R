library(shiny)
library(ggplot2)
library(RMySQL)
library(ggmap)

shinyServer(
  function(input, output, session) {

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
    
    #Read the whole table
    full_table = dbGetQuery(mydb, "select * from restaurants")
    
    dbDisconnect(mydb)
    
    #Generate plot
    output$dataPlot <- renderPlot({
      
      #Get values based on user input
      chosenstate <- input$ddmstate
      chosenrating <- input$ddmrating
      chosenprice <- input$ddmprice
      chosencategory <- input$ddmcategory
      
      if (chosenstate=="DC") { 
        #Create a subset of data for DC restaurants
        df_subset <- subset(full_table,(state=="DC" & rating>=chosenrating & price==chosenprice) )#| categories==chosencategory)
        
        #Combines all the addresses
        locn <- c(df_subset$address)
        
        #Gets the coordinates for the addresses
        locn_coords <- geocode(locn, source = "google")
        
        #Creates a dataframe with the names of the restaurants
        where.df <- data.frame(locn=c(df_subset$name))
        
        #Combines the names and coordinates 
        myLocs <- data.frame(where.df, locn_coords)
        
        #Gets the map of the location
        myMap <- get_map(
          location = "Logan Circle, Washington, DC",
          zoom = 14, 
          maptype = "roadmap"
        )
        p <- ggmap(myMap)
        
        #Descriptive features of the Point and Text
        p <- p + geom_point(data = myLocs, aes(x=lon, y=lat, shape = locn, colour = locn, size = 100))
        p <- p + geom_text(data = myLocs, aes(x = lon, y=lat, label = locn, colour = locn), hjust = -.2)
        
        # legend positioning
        p <- p + theme(legend.position = "none",
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       axis.text = element_blank(),
                       axis.title = element_blank(),
                       axis.ticks = element_blank()
        )
        #Prints maps
        print(p)
      } 
      if (chosenstate=="MD") { 
        #Create a subset of data for MD restaurants
        df_subset <- subset(full_table,(state=="MD" & rating>=chosenrating & price==chosenprice) )#| categories==chosencategory)
        
        locn <- c(df_subset$address)
        
        locn_coords <- geocode(locn, source = "google")
        
        where.df <- data.frame(locn=c(df_subset$name))
        
        myLocs <- data.frame(where.df, locn_coords)
        
        myMap <- get_map(
          location = "Bethesda, MD",
          zoom = 12, 
          maptype = "roadmap"
        )
        p <- ggmap(myMap)
        
        p <- p + geom_point(data = myLocs, aes(x=lon, y=lat, shape = locn, colour = locn, size = 100))
        p <- p + geom_text(data = myLocs, aes(x = lon, y=lat, label = locn, colour= locn), hjust = -.2, size = 6)
        
        # legend positioning
        p <- p + theme(legend.position = "none",
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       axis.text = element_blank(),
                       axis.title = element_blank(),
                       axis.ticks = element_blank()
        )
        print(p)
      }      
      if (chosenstate=="VA") { 
        #Create a subset of data for VA restaurants
        df_subset <- subset(full_table,(state=="VA" & rating>=chosenrating & price==chosenprice) )#| categories==chosencategory)
        
        locn <- c(df_subset$address)
        
        locn_coords <- geocode(locn, source = "google")
        
        where.df <- data.frame(locn=c(df_subset$name))
        
        myLocs <- data.frame(where.df, locn_coords)
        
        myMap <- get_map(
          location = "6751 Wilson Blvd, Falls Church, VA 22044",
          zoom = 12, 
          maptype = "roadmap"
        )
        p <- ggmap(myMap)
        
        p <- p + geom_point(data = myLocs, aes(x=lon, y=lat, shape = locn, colour = locn, size = 100))
        p <- p + geom_text(data = myLocs, aes(x = lon, y=lat, label = locn, colour = locn), hjust = -.2, size = 7)
        
        # legend positioning
        p <- p + theme(legend.position = "none",
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       axis.text = element_blank(),
                       axis.title = element_blank(),
                       axis.ticks = element_blank()
        )
        print(p)
      }   
    }, height = 750, width = 750)
  }
)
