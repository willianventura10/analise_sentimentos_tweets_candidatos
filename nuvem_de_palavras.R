#Define diretório de trabalho e importa as bibliotecas necessárias
#setwd("D:/Data_Science/Projetos/candidatos_presidencia")
library(dplyr)
library(tidyr)
library(SnowballC)
library(tm)
library(stringr)

#Função Limpeza dos tweets
sub <- function(x){
  y <- str_remove_all(string = x, pattern = '[:emoji:]')
  y <- gsub("/", "",y)
  y <- gsub("@", "",y)
  y <- gsub("\\|", "",y)
  y <- gsub("\n", "",y)
  y <- gsub("/s", "",y)
  return(y)
}

#Função Limpeza dos tweets2
process <- function(df_0){
  df_0 <- df_0[,c(2,5,6)]
  x <- duplicated(df_0$screen_name)
  x <- ifelse(x==FALSE,TRUE,FALSE)
  df_0 <- df_0[x,]
  sum(duplicated(df_0$text))
  df_0 <- data.frame(unique(df_0$text))
  sum(duplicated(df_0$text))
  return(df_0)
}

#Função para processar tweets e devolver palavras mais frequentes
process2 <- function(tweetlist){
  tweetcorpus <- Corpus(VectorSource(tweetlist))
  tweetcorpus <- tm_map(tweetcorpus, removePunctuation)
  tweetcorpus <- tm_map(tweetcorpus, removeNumbers)
  tweetcorpus <- tm_map(tweetcorpus, content_transformer(tolower))
  tweetcorpus <- tm_map(tweetcorpus, function(x)removeWords(x, stopwords("portuguese")))
  tweetcorpus <- tm_map(tweetcorpus, removeWords, c("outra","então","parte","pra","vê","tô","dá","dái","né","aí","vai","lá","tá","ver","ter","ser","vai","ttulo","fez","pro","est","sim","forest","voc","aps","nao","faz","quer")) 
  
  # Convertendo o objeto Corpus para texto plano
  tweetcorpus <- tm_map(tweetcorpus, PlainTextDocument)
  
  #converter para dataframe
  dtm <- TermDocumentMatrix(tweetcorpus)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  return(d)
}

df_0 <-read.csv("tweets.csv")
df_0 <- process(df_0)
df_0 <- data.frame(apply(df_0,1,sub))
freq <- process2(df_0)

write.csv(data.frame(freq), "palavras_freq.csv")

#Código para nuvem de palavras para ser inserido no PowerBI
library(wordcloud)
library(RColorBrewer)
wordcloud(freq$word,freq$freq,random.order=FALSE, colors="gray42",min.freq=50, scale=c(4,.3),rot.per=.15,max.words=100)

