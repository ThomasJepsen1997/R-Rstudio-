library(rvest)
library(tidyverse)

url <- "https://www.ft.dk/da/dokumenter/dokumentlister/lovforslag?pageSize=279&totalNumberOfRecords=279"
page <- read_html(url)
Titel <- page %>% 
  html_nodes('.highlighted+ .column-documents .column-documents__icon-text') %>% 
  html_text(trim = T)

Nr <- page %>% 
  html_nodes('.highlighted .column-documents__icon-text') %>% 
  html_text(trim = T)
Udvalg <- page %>% 
  html_nodes('.hidden-xs:nth-child(3) .column-documents__icon-text') %>% 
  html_text(trim = T)
Status <- page %>% 
  html_nodes('.hidden-xs+ .hidden-xs .column-documents__icon-text') %>% 
  html_text(trim = T)
df <- tibble(Nr = Nr,
               Titel = Titel,
               Udvalg = Udvalg,
               Status = Status)

View(df)
