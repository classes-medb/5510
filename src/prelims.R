suppressMessages(suppressWarnings(library(lubridate)))
suppressMessages(suppressWarnings(library(magrittr)))
dat1 <- as.Date("2019-01-21", format="%Y-%m-%d")
d <- dat1+(0:15)*7
f <- "%A, %B %d, %Y"
mon <- format(d, f)
tue <- format(d+1, f)
wed <- format(d+2, f)
thu <- format(d+3, f)
fri <- format(d+4, f)
read_text <- function(fn, due="", path="data") {
  "../" %>%
    paste0(path) %>%
    paste0("/") %>%
    paste0(fn) %>% 
    paste0(".txt") %>%
    readLines %>% 
    gsub("<<due date>>", due, .) %>% 
    paste0(collapse="\n") %>%
    return
}
