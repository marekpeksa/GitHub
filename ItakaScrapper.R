
# LIBRARIES ---------------------------------------------------------------
library(rvest)
library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(mgcv)
library(ggplot2)
library(writexl)
library(tidyverse)


glowna <- read_html(paste0("https://www.itaka.pl/last-minute/?duration=from7to8&review-rate=30&order=popular"))
link=html_attr(html_nodes(glowna, "a"), "href")
linki <- link[grepl(pattern = "wczasy", link, fixed = TRUE)==TRUE]
linki <- paste0("https://itaka.pl",linki)
linki <- linki[!duplicated(linki)]


rp=rep(NA,length(linki))

df=data.frame(Cena=rp,
              Kraj=rp,
              Hotel=rp,
              Ocena=rp,
              Data=rp,
              Wyzywienie=rp,
              Wylot=rp)

Hotels=c()
Prices=c()
Countries=c()
Dates=c()
Rates=c()
Board=c()
Departure=c()


for (i in 1:length(linki)) {
  simple <- read_html(linki[i])


Hotel = simple %>%
  html_nodes("span.productName-holder") %>%
  html_text() %>%
  gsub(c("\n"), "",.)
Hotels=append(Hotels,Hotel)


df$Cena[i] = simple %>%
  html_nodes("#form-and-offers > div.product-search-mobile-form-holder.disabled > div.summary-box > div.price-box > span.price.price-black > strong") %>%
  html_text()
Prices=append(Prices, df$Cena[i])


Kraj = simple %>%
  html_nodes("#product-code > div.old-h2 > span.destination-title.destination-country-region") %>%
  html_text()
Countries=append(Countries, Kraj)

 
df$Data[i] = simple %>%
   html_nodes("#search-form > div.fRow.fDates > div.dropdown > a") %>% 
   html_text()
Dates=append(Dates, df$Data[i])

df$Ocena[i] = simple %>%
  html_nodes("div.event-opinion-flag") %>%
  html_text()
Rates=append(Rates, df$Ocena[i])

df$Wyzywienie[i] = simple %>%
  html_nodes("#search-form > div:nth-child(21) > div.dropdown > a") %>%
  html_text()
Board=append(Board, df$Wyzywienie[i])


df$Wylot[i] = simple %>%
  html_nodes("#search-form > div:nth-child(17) > div.dropdown > a") %>%
  html_text()
Departure=append(Departure, df$Wylot[i])

}

df2=data.frame(Hotel=Hotels,
               Cena=Prices,
               Kraj=Countries,
               Data=Dates,
               Ocena=Rates,
               Wyżywienie=Board,
               Wylot=Departure)
