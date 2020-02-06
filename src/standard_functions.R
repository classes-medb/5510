# standard_functions.R
# written by Steve Simon
# created 2020-01-17

# This program provides some standard functions
# that I use across multiple projects.

if (!exists("verbose")) verbose <- FALSE

# general functions

# These functions join strings in various ways.

"%0%" <- function(x, y) {paste0(x        , y)}
"%1%" <- function(x, y) {paste0(x, "\n"  , y)}
"%2%" <- function(x, y) {paste0(x, "\n\n", y)}
"%b%" <- function(x, y) {paste0(x, ' '   , y)}
"%c%" <- function(x, y) {paste0(x, ','   , y)}
"%C%" <- function(x, y) {paste0(x, ', '  , y)}
"%d%" <- function(x, y) {paste0(x, "."   , y)}
"%D%" <- function(x, y) {paste0(x, ". "  , y)}
"%s%" <- function(x, y) {paste0(x, "/"   , y)}
"%.%" <- function(x, y) {paste0(x, ". "  , y)}
"% %" <- function(x, y) {paste0(x, " "   , y)}

"%p%" <- function(x, y) {paste0(x,  '(', y, ')')}
"%P%" <- function(x, y) {paste0(x, ' (', y, ')')}
"%q%" <- function(x, y) {paste0(x,  '"', y, '"')}
"%Q%" <- function(x, y) {paste0(x, ' "', y, '"')}
"%[%" <- function(x, y) {paste0(x,  "[", y, "]")}

brack <- function(x) {"" %[% x}
paren <- function(x) {"" %p% x}
quote <- function(x) {"" %q% x}

br <- function(x, n=1) {x %0% str_c(rep("\n", n), collapse="")}

# Test these functions
if (verbose) {
  cat("\n\n***Testing various string infix operators***\n")
  x <- "abc"
  y <- "def"
  br("") %>% cat
  '"abc" %0% "def" produces: ' %1% x %0% y      %>% br    %>% cat
  '"abc" %1% "def" produces: ' %1% x %1% y      %>% br    %>% cat
  '"abc" %2% "def" produces: ' %1% x %2% y      %>% br(2) %>% cat
  
  '"abc" %b% "def" produces: ' %1% x %b% y      %>% br    %>% cat
  '"abc" %c% "def" produces: ' %1% x %c% y      %>% br    %>% cat
  '"abc" %C% "def" produces: ' %1% x %C% y      %>% br    %>% cat
  '"abc" %d% "def" produces: ' %1% x %d% y      %>% br    %>% cat
  '"abc" %D% "def" produces: ' %1% x %D% y      %>% br    %>% cat
  '"abc" %s% "def" produces: ' %1% x %s% y      %>% br    %>% cat
  '"abc" %.% "def" produces: ' %1% x %.% y      %>% br(2) %>% cat
  
  '"abc" %p% "def" produces: ' %1% x %p% y      %>% br    %>% cat
  '"abc" %P% "def" produces: ' %1% x %P% y      %>% br    %>% cat
  '"abc" %q% "def" produces: ' %1% x %q% y      %>% br    %>% cat
  '"abc" %Q% "def" produces: ' %1% x %Q% y      %>% br    %>% cat
  '"abc" %[% "def" produces: ' %1% x %[% y      %>% br(2) %>% cat
  
  'br("abc", 1) produces: '    %1% br("abc", 1) %>% br    %>% cat
  'br("abc", 2) produces: '    %1% br("abc", 2) %>% br(2) %>% cat
  
  'brack("abc") produces: '    %1% brack(x)     %>% br    %>% cat
  'paren("abc") produces: '    %1% paren(x)     %>% br    %>% cat
}

# This function adds a leading zeros to digits less than 10

zpad <- function(x) {
  message_tail <- " in zzzpad may produce nonsensical results"
  if(any(x<0))           message("Note: Negative values", message_tail)
  if(any(x != trunc(x))) message("Note: Fractional values", message_tail)
  if(any(x>99))        message("Note: Values > 9999", message_tail)
  case_when(
    x <   10 ~ paste0("0", x),
    TRUE     ~ as.character(x)
  ) %>% return
}

# Test this function
if (verbose) {
  cat("\n\n***Testing zzzpad***\n")
  zpad(c(8:12)) %>% print
}
# If you have the time and energy, check out
# these cases as well.
# if (verbose) zpad(-3)
# if (verbose) zpad(0.5)
# if (verbose) zpad(98:103)

zzzpad <- function(x) {
  message_tail <- " in zzzpad may produce nonsensical results"
  if(any(x<0))           message("Note: Negative values", message_tail)
  if(any(x != trunc(x))) message("Note: Fractional values", message_tail)
  if(any(x>9999))        message("Note: Values > 9999", message_tail)
  case_when(
    x <   10 ~ paste0("000", x),
    x <  100 ~ paste0( "00", x),
    x < 1000 ~ paste0(  "0", x),
    TRUE     ~ as.character(x)
  ) %>% return
}

# Test this function
if (verbose) {
  cat("\n\n***Testing zzzpad***\n")
  zzzpad(c(8:12, 98:102, 998:1002)) %>% print
}
# If you have the time and energy, check out
# these cases as well.
# if (verbose) zzzpad(-3)
# if (verbose) zzzpad(0.5)
# if (verbose) zzzpad(9998:10003)

