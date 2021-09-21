# Homework for digital skills 03 - webscraping of Rbloggers 

# Clear dataset
.rs.restartR()
rm(list = ls())

#loading packages 
library(rvest)
library(tidyverse)


#Setting working directionary
getwd()
setwd("C:/Users/Bruger/Desktop/Political Data Science/3 - Digital - Scraping the open web (rvest)")

#Set user agent 
httr::set_config(httr::user_agent("201808827@post.au.dk; Student at Aarhus University"))

if(!dir.exists("blogs_archive")) dir.create("blogs_archive")


# base url & security signatures
url <- "https://www.r-bloggers.com/page/"

# create empty data set with titles
cols <- c("title", "link", "date", "excerpt")
dat <- cols %>% t %>% as_tibble(.name_repair = "unique") %>% `[`(0, ) %>% rename_all(~cols)

# page number to add to url
pages <- 1

# Starting my while loop

while (T) {
  
  # report progress to console
  print(paste("Pulling pages", pages, "through", (pages + 1)))
  
  # fixes the problem with differnt url on first page 
  if (url == "https://www.r-bloggers.com"){
    final.url <- "https://www.r-bloggers.com"
  } else {
    final.url <- str_c(url, pages)
    
  }
  
  
  # check if file already exists -- if so, open it -- if not, download it
  file.name <- str_c("./blogs_archive/", "2021-09-19", " -- R-bloggers article ", pages, "-", (pages + 1), ".html")
  
  
  ###########################################
  # check if file already downloaded
  if (file.exists(file.name)) { # if already downloaded, do this
    page <- read_html(file.name)
    
  } else {# if NOT already downloaded, do this
    
    # don't forget to delay, we're pulling more than one page
    Sys.sleep(21 + runif(1)*10)
    
    # download page
    page <- read_html(final.url)
    
    # extract raw html text
    to.archive <- as.character(page)
    
    # archive page for later
    write(to.archive, file.name)
  }
  ###########################################
  
  
  # pull out and trim post titles
  titles <- page %>% html_nodes('.loop-title a') %>% html_text(trim = T)
  
  # break out of loop when new titles can't be found
  if (pages == 21) break
  
  # pull out links to posts
  links <- page %>% html_nodes('.loop-title a') %>% html_attr("href")
  
  # pull out and trim the date of the blogs
  date <- page %>%
    html_nodes('.meta') %>%
    html_text(trim = T)
  
  #removes the author name from the date
  
  date <- str_remove_all(date, "[|].+")
  
  # pull out and trim the exerpt names
  excerpt <- page %>%
    html_nodes('.mh-excerpt') %>%
    html_text(trim = T)
  
  # build data frame from data
  dat <- dat %>% add_row(
    title = titles,
    link = links,
    excerpt = excerpt,
    date = date)
  
  # iterate page count
  pages <- pages + 1
} 


# I only want blogs that contains the words "machine learning", "artificial intelligence", "visualization"


dat_machine <- dat[grep("[Mm]achine learning", dat$excerpt), ]



dat_ai <- dat[grep("[Aa]rtificial intelligence", dat$excerpt), ]



dat_visualization <- dat[grep("[Vv]isualization", dat$excerpt), ]


# Making the new dataset with blogs that contains the words "machine learning", "artificial intelligence", "visualization"


data_2 <- rbind(dat_ai, dat_ai, dat_visualization)

view(data_2)

