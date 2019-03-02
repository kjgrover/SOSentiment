library(plumber)
library(tidyverse)
library(tidytext)
library(syuzhet)

#* Echo 
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  # list(msg = paste0("The message is: '", msg, "'"))
  
afinnlib <- syuzhet:::afinn %>%
  mutate(sentiment = ifelse(value < 0, "negative", "postive")) %>%
  mutate(library = "afinn") #%>%

msg <- tibble(line = 1:1, text = msg)

output <- msg %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  merge(afinnlib, by = "word") %>%
  mutate(score = value) %>%
  select(score)


output <- as.numeric(sum(output$score))

return(output)

}