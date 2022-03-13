
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


glowna <- read_html(paste0("https://www.itaka.pl/last-minute/"))
link=html_attr(html_nodes(glowna, "a"), "href")
linki <- link[grepl(pattern = "wczasy", link, fixed = TRUE)==TRUE]
linki <- paste0("https://itaka.pl",linki)
linki <- linki[!duplicated(linki)]


rp=rep(NA,length(linki))

df=data.frame(Cena=rp,
              Kraj=rp,
              Hotel=rp)

for (i in (1:length(linki))) {
  simple <- read_html(linki[i])


df$Hotel[i] = simple %>%
  html_nodes("span.productName-holder") %>% #<span class="offer-price__number">63 950<span class="offer-price__currency">PLN</span>
  html_text()
df$Hotel[i] <- gsub(c("\n"), "", df$Hotel[i])


df$Cena[i] = simple %>%
  html_nodes("span.price.price-black") %>% #<span class="offer-price__number">63 950<span class="offer-price__currency">PLN</span>
  html_text()
df$Cena[i] <- gsub(c("\n"), "", df$Cena[i])
df$Cena[i] <- gsub(c("pln"), "", df$Cena[i])
df$Cena[i] <- gsub(c("pln"), "", df$Cena[i])
df$Cena[i]=as.numeric(parse_number(str_replace_all(string=df$Cena[i], pattern=" ", repl="")))


df$Kraj[i] = simple %>%
  html_nodes("span.destination-title.destination-country-region") %>% #<span class="offer-price__number">63 950<span class="offer-price__currency">PLN</span>
  html_text()

}
