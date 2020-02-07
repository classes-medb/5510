semester_start <- "2020-01-20"

suppressMessages(suppressWarnings(library(lubridate)))
suppressMessages(suppressWarnings(library(magrittr)))
suppressMessages(suppressWarnings(library(stringr)))
suppressMessages(suppressWarnings(library(tidyverse)))


source(file="standard_functions.R", echo=FALSE)

dat1 <- as.Date(semester_start, format="%Y-%m-%d")
d <- dat1+(0:15)*7
f <- "%A, %B %d, %Y"
mon <- format(d, f)
tue <- format(d+1, f)
wed <- format(d+2, f)
thu <- format(d+3, f)
fri <- format(d+4, f)
read_text <- function(fn, due="", path="data", char_max=999999, start_line=1) {
  "../" %>%
    paste0(path) %>%
    paste0("/") %>%
    paste0(fn) %>% 
    paste0(".txt") %>%
    readLines  -> text_lines
  n_lines <- length(text_lines)
  text_lines <- text_lines[start_line:n_lines]
  text_lines %>%
    nchar %>%
    cumsum %>%
    pmax(char_max) -> line_count
  n <- sum(line_count==char_max)
  if (n==0) {n <- 1}
  if (n < length(text_lines)) {
    text_lines <- text_lines[start_line:n]
    text_lines[n+1] <- "..."
  }  
  text_lines %>% 
    gsub("<<due date>>", due, .) %>% 
    paste0(collapse="\n") %>%
    return
}
