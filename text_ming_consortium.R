# Carregamento dos Pacotes
# ------------------------------------------------------------------------------
install.packages("tidytuesdayR")  # Instalar o pacote, se necessário
library(tidyverse)
library(tidytuesdayR)
library(wordcloud)
library(RColorBrewer)
library(ggthemes)
library(tm)

# Coleta e Preparação dos Dados
# ------------------------------------------------------------------------------
# Carregando dados do TidyTuesday
tuesdata <- tidytuesdayR::tt_load('2024-02-20')
dados <- tuesdata$isc_grants  # Montar dataframe

# Pré-processamento de Texto para Análise
# ------------------------------------------------------------------------------
# Preparação do Corpus
corpus <- Corpus(VectorSource(dados$summary))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Criação da Matriz de Termos
dtm <- TermDocumentMatrix(corpus)
matrix <- as.matrix(dtm)
words <- sort(rowSums(matrix), decreasing = TRUE)
df <- data.frame(word = names(words), freq = words)

# Criação da Wordcloud
# ------------------------------------------------------------------------------
set.seed(1234)
par(mar = c(5, 4, 4, 2))  # Ajuste das margens
wordcloud(words = df$word, freq = df$freq, min.freq = 1,
          max.words = 100, random.order = FALSE, rot.per = -1.5,
          colors = ggthemes::tableau_color_pal()(10))

# Adição de Título e Subtítulo
title(main = "Palavras-Chave no Universo das Bolsas ISC:\nMapeando Tendências no Desenvolvimento do R", 
      col.main = "black",  
      cex.main = .8,  # Ajuste do tamanho do título
      sub = "Fonte: TidyTuesday - @vit0rmarinh0",
      col.sub = "black",
      cex.sub = .5)  # Ajuste do tamanho do subtítulo

# Salvando a Wordcloud
# ------------------------------------------------------------------------------
png("nuvem_de_palavras.png", width = 19, height = 9, units = "in", res = 300)
# Incluir o código de criação da wordcloud aqui
dev.off()
