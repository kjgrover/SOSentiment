library(tidyverse)
library(tidytext)
library(sentimentr)
library(syuzhet)
library(qdapDictionaries)
library(SentimentAnalysis)


# nrclib <- syuzhet:::nrc %>%
#   filter(sentiment %in% c("postive", "negative"), lang == "english") %>%
#   select(-lang) %>%
#   mutate(value = ifelse(sentiment == "negative", value * -1, value)) %>%
#   mutate(library = "nrc") %>%
#   #group_by(word) %>%
#   select(word, value, sentiment, library)



afinnlib <- syuzhet:::afinn %>%
  mutate(sentiment = ifelse(value < 0, "negative", "postive")) %>%
  mutate(library = "afinn") #%>%
  #group_by(word)

#binglib <- syuzhet:::bing %>%
#  mutate(sentiment = ifelse(value < 0, "negative", "postive")) %>%
#  mutate(library = "bing")# %>%
#  #group_by(word)



# Text1Tibble %>%
#   unnest_tokens(word, text) %>%
#   anti_join(stop_words) %>%
#   merge(nrclib, by = "word") %>%
#   merge(afinnlib, by = "word") %>%
#   merge(binglib, by = "word") %>%
#   mutate(score = sum(value.x, value.y, value)) %>%
#   select(word, score)

Text1 <- "Fuck you, Jack. You are a peice of shit and I wish I would have never met you. You are evil and enrage me. We are enemies. I am glad that I let go of you on that door."
msg <- tibble(line = 1:1, text = Text1)

Text2 <- "Oh Jack, I love you so much. Kind The time we spent together is like an excellent euphoria. I will never let go of you."
msg <- tibble(line = 1:1, text = Text2)

output <- msg %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  #merge(nrclib, by = "word") %>%
  merge(afinnlib, by = "word") %>%
  #merge(binglib, by = "word") %>%
  #mutate(score = sum(value.x, value.y, value)) %>%
  mutate(score = value) %>%
  select(score)


output <- as.numeric(sum(output$score))

