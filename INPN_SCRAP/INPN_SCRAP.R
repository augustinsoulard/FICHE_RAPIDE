#Choisir l'environnement de tavail
WD = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(WD)

# Installation si necessaire et chargement des packages

if (!require("rvest")) {install.packages("rvest")}+library("rvest") # API GBIF
if (!require("tidyverse")) {install.packages("tidyverse")}+library("tidyverse")
if (!require("xlsx")) {install.packages("xlsx")}+library("xlsx") # API GBIF
if (!require("xlsx")) {install.packages("xlsx")}+library("xlsx") # API GBIF


SILENE_3CAPS <- readxl::read_excel("C:/Users/MTDA-029/Downloads/SILENE 3CAPS.xlsx")
SILENE_3CAPS$bing = 'ERREUR'
for(i in 1:nrow(SILENE_3CAPS)){
  cat(i,"\n")
  if(is.na(SILENE_3CAPS$`NOM VERNACULAIRE`[i])){
    EspURL = SILENE_3CAPS$nom_valide[i]
  }else{
    EspURL = SILENE_3CAPS$`NOM VERNACULAIRE`[i]
  }
  url <- paste0("https://www.bing.com/search?q=Statut+de+menace+de+",gsub(" ","+",EspURL),"+en+france+et+en+PACA")
  url=  iconv(url,to = "ASCII//TRANSLIT")
   page <- read_html(url)
   titre = "ERREUR"
  titre <- page %>% html_nodes(".b_caption > .b_algoSlug") %>% html_text()
  if(length(titre)>0){  SILENE_3CAPS$bing[i] = titre}

}









for(i in 470:nrow(tabESPbrut)){
  cat(i,"\n")
  url <- paste0("https://inpn.mnhn.fr/espece/cd_nom/",tabESPbrut$cd_nom[i],"/tab/statut")
  page <- read_html(url)
  titre <- page %>% html_nodes("#section") %>% html_text()
  if(length(titre)>0){
    tabESPbrut$V1[i] = titre
  }

}

tabESPbrut = data.frame(tabESPbrut)




SILENE_3CAPS = left_join(tabESPbrut,SILENE_3CAPS,by=c("cd_nom"="cd_ref"))
SILENE_3CAPS$V2 = gsub("\\t", "",gsub("\\n", "", gsub("\\r", "", SILENE_3CAPS$V1)))


for(i in 1:nrow(SILENE_3CAPS)){
  cat("\n",i)
  if(SILENE_3CAPS$V2[i]=="Statuts dans les territoiresStatuts biogéographiquesTerritoireStatut biogéographiqueSourcesStatuts d'évaluation, de protection et de menaceStatuts d'évaluation, de protection et de menaceévaluéeprotégéemenacéeEuropeMondeListe rougeespèce déterminante ZNIEFF  Voir les statuts d’évaluation Espèce évaluée sur Liste RougeScopeNomCatégorieCritèreListe rougeEspèce déterminante de l'inventaire ZNIEFFDonnées ZNIEFF continentalesRégionSourcesListeDonnées ZNIEFF marinesRégionSourcesListeEspèce réglementéeInternationalCommunautaireDe portée nationaleOutre-merDe portée régionaleDe portée départementaleRéglementation préfectoraleEspèce non réglementée"){
    SILENE_3CAPS$test[i] = 'retirer'
    cat(": retirer")
  } else{
    SILENE_3CAPS$test[i] = 'garder'
  }
}


write.xlsx(SILENE_3CAPS,"SILENE_3CAPS_AS2.xlsx")
