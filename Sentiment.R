library(tidyverse)
library(sentimentr)
library(syuzhet)
library(qdapDictionaries)
library(SentimentAnalysis)
library(qdap)
library(lexicon)
library(tm)

SentimentMyLife <- function(text){
#Preliminary Functions & creating backend data frames:

LexiconExpansion <- rbind(lexicon::hash_sentiment_emojis,
                        lexicon::hash_sentiment_huliu,
                        lexicon::hash_sentiment_loughran_mcdonald,
                        lexicon::hash_sentiment_nrc,
                        lexicon::hash_sentiment_senticnet,
                        lexicon::hash_sentiment_sentiword,
                        lexicon::hash_sentiment_slangsd,
                        lexicon::hash_sentiment_socal_google,
                        lexicon::hash_sentiment_jockers,
                        lexicon::hash_sentiment_jockers_rinker)



new.Pos <- merge(subset(LexiconExpansion, y > 0), subset(key.pol, y > 0 ), by = "x", all.x = TRUE) %>%
  select(x, y.x) %>%
  rename(x = x, y = y.x)
new.Neg <- merge(subset(LexiconExpansion, y < 0), subset(key.pol, y < 0 ), by = "x", all.x = TRUE) %>%
  select(x, y.x) %>%
  rename(x = x, y = y.x)

LexiconExpansion <- sentiment_frame(positives = new.Pos$x, 
                                  negatives = new.Neg$x,
                                  pos.weights = new.Pos$y,
                                  neg.weights = new.Neg$y)
rm(new.Pos, new.Neg)

#### Preprocessing:

# Remove excessive whitespace
text <- stripWhitespace(text)

# Remove all abbreviations
#text <- replace_abbreviation(text)

# Lowercase all text - makes it easier for polarity
text <- tolower(text)

# Regex to break apart the sentences by either .!? We need to find a way to ensure that if there are mutliple
# our function doesn't get fucked.

clean.msg <- text %>%
  tibble() %>%
  str_split(pattern = "[.!?]", simplify = TRUE)

dim(clean.msg) <- c(length(clean.msg),1)
colnames(clean.msg) <- "sentences"


## Polarity Parameters - we can tune these as needed
Negate.Words <- c("","",
                  negation.words)

Amp.Words <- c("fuck", "motherfucking",
                amplification.words)

DeAmp.Words <- c("ADDWORDHERE", "ADDWORDHERE",
               deamplification.words)

output.polarity <- suppressWarnings(polarity(clean.msg,
         polarity.frame = LexiconExpansion,
         grouping.var = NULL,
         constrain = TRUE,
         amplifiers = Amp.Words,
         deamplifiers = DeAmp.Words,
         amplifier.weight = 2))


output <- output.polarity$group %>%
  select(ave.polarity) %>%
  as.numeric()


AllResults <- output.polarity$all %>%
  filter(wc > 0) %>%
  select(polarity, pos.words, neg.words, text.var) %>%
  rename(Polarity = polarity, PositiveWords = pos.words, NegativeWords = neg.words, OriginalText = text.var)

return(output)

}
SentimentMyLife(text)

####
####
#### Example:
####
####

##### Comparison of default polarity() compared to tuned polarity()
# 
# # Angry Text:
# Text1 <- "Fuck you, I hate you. You are the absolute motherfucking worst. You fill me with despair because you are evil.You are evil and enrage me. We are enemies."
# suppressWarnings(polarity(Text1, constrain = TRUE)$all$polarity)
# SentimentMyLife(Text1)
# 
# # Hyper angry Text:
# Angry <- "whore slut bitch die death fuck shit kill hate"
# suppressWarnings(polarity(Text2, constrain = TRUE)$all$polarity)
# SentimentMyLife(Text2)
# 
# # Happy text
# Text2 <-  "I love you so much. You make me cherish every moment we share together. I am so happy that I met you because you make me laugh."
# suppressWarnings(polarity(Text2, constrain = TRUE)$all$polarity)
# SentimentMyLife(Text2)
# 
# # Hyper Happy Text:
# Happy <- "joy, cherish, happy, laugh"
# suppressWarnings(polarity(Happy, constrain = TRUE)$all$polarity)
# SentimentMyLife(Happy)
