#Define diretório de trabalho e importa as bibliotecas necessárias
#setwd("D:/Data_Science/Projetos/candidatos_presidencia")

library(syuzhet)
library(stringr)
library(tidyr)
library(dplyr)

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

#Função analisa sentimentos de tweets
sent <- function(tweetlist){
  sentimentos_df <- get_nrc_sentiment(get_tokens(tweetlist[1,]), lang="portuguese")
  df = data.frame(matrix(
    vector(), 0, 10, dimnames=list(c(), c(colnames(sentimentos_df)))),
    stringsAsFactors=F)
  for(i in row.names(tweetlist)){
    palavras <- get_tokens(tweetlist[i,])
    sentimentos_df <- get_nrc_sentiment(palavras, lang="portuguese")
    soma_sent<-summarise_all(sentimentos_df,sum)
    df<-rbind(df,soma_sent)
  }
  return(df)
}

#Lê o arquivo .csv e limpa tweets
df_0 <-read.csv("tweets_candidato.csv")
df_0 <-process(df_0)
sum(duplicated(df_0))
df_0 <- data.frame(apply(df_0,1,sub))

#Faz analise dos sentimentos com a bilioteca 'syuzhet'
df <-sent(df_0)

#Classifica tweets positivos x negativos
df$class <- ifelse(df$positive>df$negative,"POSITIVO",ifelse(df$positive==df$negative,"NEUTRO","NEGATIVO"))
table(df$class)

#salva resultado em arquivo .csv
write.csv(data.frame(df), "tweets_candidato_sent.csv")



#MONTA DATAFRAME FINAL COM 5000 TWEETS ANALISADOS E CLASSIFICADOS DE CADA CANDIDATO

df1<-read.csv("tweets_bolsonaro_sent.csv")
amostra <- sample(1:nrow(df1), size = 5000, replace = FALSE)
df1 <- df1[amostra,-1]

df2<-read.csv("tweets_lula_sent.csv")
amostra <- sample(1:nrow(df2), size = 5000, replace = FALSE)
df2 <- df2[amostra,-1]

df3<-read.csv("tweets_ciro_sent.csv")
amostra <- sample(1:nrow(df3), size = 5000, replace = FALSE)
df3 <- df3[amostra,-1]

df4<-read.csv("tweets_tebet_sent.csv")
amostra <- sample(1:nrow(df4), size = 5000, replace = FALSE)
df4 <- df4[amostra,-1]

df_final <- df1
df_final[,"Bolsonaro"] <- data.frame(df1$class)
df_final[,"Lula"] <- data.frame(df2$class)
df_final[,"Ciro"] <- data.frame(df3$class)
df_final[,"Tebet"] <- data.frame(df4$class)
df_final <- df_final[,c(12:15)]

#salva resultado em arquivo .csv
write.csv(df_final, "df_sent_final.csv")
