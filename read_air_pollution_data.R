# import UK air pollution datasets
library(openair)
library(dplyr)
library(purrr)

# the meta data for the sites is very important and includes the location of them
# there are two main networks we will consider: aurn and kcl 
meta_kcl  <- importMeta(source = "kcl")
meta_aurn <- importMeta(source = "aurn")

# now filter the kcl sites by a longitude and latitude mask
max_lon <- 0.5
min_lon <- -0.5
max_lat <- 51.7
min_lat <- 51.1

# for now we will focus on the kcl sites which are within this area
temp <- subset(meta_kcl, latitude <= max_lat & latitude >= min_lat) 
meta_kcl_sub <- subset(temp, longitude <= max_lon & longitude >= min_lon) 

# loop through every site and put the data into a dataframe within a list
# initalise a list to put the data in
my_data_list <- list()
for( i in 1:length(meta_kcl_sub$code)) {
  # loop through every site listed by meta data
  tryCatch(my_data_list[[i]] <- importKCL(site=as.character(meta_kcl_sub$code[i]), # convert to character from factor
                                          pollutant = "no2", 
                                          year=2006:2020 ), 
           error = function(e) { skip_to_next <<- TRUE})
  if(skip_to_next) { next }     
}

