#Define diretório de trabalho e importa as bibliotecas necessárias
#setwd("D:/Data_Science/Projetos/candidatos_presidencia")
library(rtweet)

#função para baixar tweets com a biblioteca rtweet
baixa_tt <- function(pesquisa,num){
  tweetdata <- search_tweets(pesquisa, n = num,
                             include_rts = FALSE,
                             token = NULL, lang='pt')
  return(tweetdata)
}


#Cria dataframe para acumular os tweets 
df = data.frame(matrix(
  vector(), 0, 90, dimnames=list(c(), c(colnames(baixa_tt("hoje",1))))),
  stringsAsFactors=F)

#Adiciona tweets ao DF
tweetdata <- baixa_tt("candidato",5)
df <- rbind(df,tweetdata)
df <- apply(df,2,as.character)
df<-data.frame(df)

#salva tweets em arquivo .csv
write.csv(data.frame(df), "tweets_candidato.csv")

