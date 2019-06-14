### Health GIS Tutorial 
### Author: Richard Johansen
### Date: 5-30-2019

#install.packages(c("tidyverse", "tmap","tmaptools","sf"))
library(tidyverse)
library(tmap)
library(tmaptools)
library(sf)

### Introduction ---------------------------------------------------------------
# Upload data
df <- read.csv("data-raw/states_health.csv")

View(df)

#Popular functions to explore data
str(df)

head(df)
tail(df)

# stats overview
summary(df)
pastecs::stat.desc(df)

# exploration using visualization
boxplot(df$obesity)
boxplot(df$diabetes)

hist(df$obesity)
hist(df$diabetes)




### Merging spatial and non-spatial data----------------------------------------
# Load csv data frame (non-spatial data)
df <- read.csv("data-raw/states_health.csv")

browseURL("https://www.census.gov/cgi-bin/geo/shapefiles/index.php")
states <-  st_read("data-raw/US_States.shp")

### Popular Functions
View(states)
str(states)
plot(states[3])

### Join spatial and non-spatial objects
# Create identical join field on the data frame so it makes with spatial data frame
#df$join_name <- df$name

df$STATE_NAME <- df$State

# Use the merge function to combine these data frames together into a new R object
browseURL("https://www.dummies.com/programming/r/how-to-use-the-merge-function-with-data-sets-in-r/")
States_Health <- merge(states,df, by = "STATE_NAME")
plot(States_Health[7])




### Reading and writing spatial data -------------------------------------------
# Saving a shapefile 
st_write(States_Health, "data-processed/States_Health.shp")

# Saving a geopackage
st_write(States_Health, "data-processed/States_Health2.gpkg")

#Reading in a shapefile
States_Health <- st_read("data-processed/States_Health.shp")

### Mapping with tmap ----------------------------------------------------------
browseURL("https://github.com/mtennekes/tmap")

# Plotting spatial data
tm_shape(States_Health) +
  tm_fill()

# Add boarders to states
tm_shape(States_Health) +
  tm_fill() +
  tm_borders()

# Fill in states using a numeric variable (obesity rate of adults)
# HINT: The default style is pretty (rounded numbers)
tm_shape(States_Health) +
  tm_fill(col = "obesity") +
  tm_borders()

### Alternative legend settings for quantitative values
# Manually defining breaks
my_breaks = c(0,10, 20, 30, 40)
tm_shape(States_Health) +
  tm_fill(col = "obesity", breaks = my_breaks) +
  tm_borders()

# Manually defining breaks using seq
my_breaks2 = seq(20,45, by =2.5)
tm_shape(States_Health) +
  tm_fill(col = "obesity", breaks = my_breaks2) + 
  tm_borders() 

# Using jenks
tm_shape(States_Health) +
  tm_fill(col = "obesity", style = "jenks") + 
  tm_borders() 

# Continuous
tm_shape(States_Health) +
  tm_fill(col = "obesity", style = "cont") + 
  tm_borders()

# palette options
tmaptools::palette_explorer()
tm_shape(States_Health) +
  tm_fill(col = "obesity", style = "cont", palette = "magma") + 
  tm_borders() 

### Mapping catagorical values
# Add random catagorical variable (just A through D repeating)
States_Health$fake_cat <- LETTERS[1:4]

tm_shape(States_Health) +
  tm_fill(col = "fake_cat", style = "cat") + 
  tm_borders()



































### Adding additional cartographic and visual elements -------------------------
#Reading in a shapefile
States_Health <- st_read("data-processed/States_Health.shp")

?tm_layout()

tm_shape(States_Health) +
  tm_fill(col = "obesity", style = "cont", palette = "-RdYlGn")+
  tm_borders() +
  tm_layout(title = "Adult Diabetes Rate by State",
            frame = FALSE,
            inner.margins = 0.1,
            legend.text.size = 0.75,
            title.size = 2,
            legend.outside = TRUE) +
  tm_compass(type = "arrow", position = c("right", "top"), size = 1) +
  tm_scale_bar(breaks = c(0,500,1000), size = 0.5, position = c("right", "bottom"))

tm_shape(States_Health) +
  tm_fill(col = "obesity", style = "cont", palette = "-RdYlGn")+
  tm_borders() +
  tm_facets(by = "fake_cat") +
  tm_layout(title = "Adult Diabetes Rate by State",
            frame = FALSE,
            inner.margins = 0.1,
            legend.text.size = 0.75,
            title.size = 2,
            legend.outside = TRUE) +
  tm_compass(type = "arrow", position = c("right", "top"), size = 1) +
  tm_scale_bar(breaks = c(0,500,1000), size = 0.5, position = c("right", "bottom"))













### Interactive Mapping with Leaflet -------------------------------------------
#install.packages("leaflet")
library(leaflet)

my_map <- tm_shape(States_Health) +
  tm_fill(col = "obesity",
          style = "cont",
          palette = "-RdYlGn",
          id = "STATE_NAME",
          popup.vars = c("STATE_NAME", "obesity", "diabetes"))

tmap_leaflet(my_map)

### Additional Resources--------------------------------------------------------

###General: Mapping & Geospatial analysis with R 
browseURL("https://geocompr.robinlovelace.net/")
browseURL("https://mgimond.github.io/Spatial/index.html") 

#Web-based mapping with R environment:
#Step 1: Click Launch Binder
#Step 2: Navigate to Mapping_in_R>Mapping_in_R.ipynb to launch jupyter notebook.
browseURL("https://github.com/RAJohansen/BindeR")

### Package References
tidyverse
tmap
tmaptools
leaflet
sf

### Data
# Census
browseURL("https://www.census.gov/cgi-bin/geo/shapefiles/index.php")

# Data.gov
browseURL("https://www.data.gov/")

# Contact Me
Richard A. Johansen
Email: Richard.Johansen@uc.edu
Website: https://libraries.uc.edu/research/research-data-services.html
Phone: 513-558-0381
GitHub: RAJohansen
ORCID: 0000-0003-4287-9677
Twitter: Johansen_PhD