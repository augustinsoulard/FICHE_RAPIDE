#Choisir l'environnement de tavail
setwd("C:/Users/Augustin Soulard/Documents/Programmation/Github/FICHE_RAPIDE")

# Installation si necessaire et chargement des packages

if (!require("rgbif")) {install.packages("rgbif")}+library("rgbif") # API GBIF
if (!require("tidyverse")) {install.packages("tidyverse")}+library("tidyverse")

occurrences <- occ_search(hasCoordinate = TRUE, limit = 10000,gadmGid = "BWA",taxonKey = 11592253)


media = occurrences$media
SC_NAME = unique(occurrences$data$scientificName)
data = data.frame(ID = 1:length(SC_NAME),SC_NAME = SC_NAME,IMG_URL = NA)

for(i in 1:length(media)){
  if(!is.null(media[[i]][[occurrences$data$key[i]]][[1]][["identifier"]])){
    data[data$SC_NAME == occurrences$data$scientificName[i],]$IMG_URL = media[[i]][[occurrences$data$key[i]]][[1]][["identifier"]]
  }
  
}

#Standardisation des taille d'image
data$IMG_URL = str_replace(data$IMG_URL,"original","medium")



con <- file("FICHE_RAPIDE.Rmd", open = "wt", encoding = "UTF-8")
sink(con,split=T)
cat("---
title: \"FICHE RAPIDE\"
date: \"`r Sys.Date()`\"
output:
  html_document: 
    toc: TRUE
    toc_float: TRUE
    theme: flatly
    highlight: zenburn
---
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
``` \n \n")
for(i in 1:nrow(data)){
  cat("*\`r data$SC_NAME[",i,"]\`* <br>")
  cat("![](`r data$IMG_URL[",i,"]\`) <br>  ")
  cat("<br><br><br>")
}
sink()
close(con)

#Test knit
rmarkdown::render("FICHE_RAPIDE.Rmd",output_format = "html_document",output_file = "FICHE_RAPIDE.html")



# Avec méthode stockage photo
# Création du fichier de stockage photo
dir.create("IMG_FICHE_RAPIDE")

for(i in 1:nrow(data)){
  download.file(data$IMG_URL[i],paste0("IMG_FICHE_RAPIDE/",data$ID[i],".jpg"), mode = 'wb')
}
