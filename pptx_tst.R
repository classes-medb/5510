library(dplyr)
library(magrittr)
library(purrr)
library(slidex)
library(tibble)
library(tidyr)
library(xml2)
source("tst.txt")
sink_reset <- function(){
  for(i in seq_len(sink.number())){
    sink(NULL)
  }
}
author <- "Simon"
title = NULL
sub = NULL
date = Sys.Date()
theme = "default"
highlightStyle = "github"
force = FALSE
writenotes = TRUE
out_dir = "."
fn <- list.files("old")

for (path in paste0("old/", fn)) {
  tst0 <- tst_convert_pptx(path, author="Simon", force=TRUE)
}



if (!file.exists(path)) {
  stop(paste0("Cannot find file ", basename(path), " in directory", 
              "'", dirname(path), "'", ". ", "Note - file paths must be specified with the '.pptx'", 
              "extension."))
}
xml <- extract_xml(path, force = FALSE)
folder <- gsub("\\.pptx", "", basename(path))
basepath <- dirname(xml)
if (file.exists(file.path(out_dir, folder)) & force == FALSE) {
  stop(paste0("This function will create a new folder in this ", 
              "directory with the same name as the PPTX, but a folder with this ", 
              "name already exists here. Please move/delete the folder, ", 
              "specify a new output directory with `out_dir = 'path'`, or rerun ", 
              "with `force = TRUE` to force the function to overwrite the ", 
              "existing folder and all the files within it."))
}
if (file.exists(file.path(out_dir, folder)) & force == TRUE) {
  unlink(file.path(out_dir, folder, recursive = TRUE, force = TRUE))
}
lang_return <- tryCatch(check_lang(xml), error = function(e) e)
if (!is.null(lang_return$message)) {
  unlink("assets", recursive = TRUE)
  stop(lang_return$message)
}
slds <- import_slide_xml(xml)
rels <- import_rel_xml(xml)
title_sld <- slds[[1]]
slds <- slds[-1]
rels <- rels[-1]
rmd <- file.path(basepath, paste0(folder, ".Rmd"))
xml_folder <- xml
sink_error <- tryCatch(sink_rmd(xml, rmd, slds, rels, title_sld, 
                                author, title, sub, date, theme, highlightStyle), error = function(e) e)
if (!is.null(sink_error$message)) {
  unlink(folder, recursive = TRUE)
  stop(sink_error$message)
}
if (length(list.files(file.path(basepath, "assets"))) == 
    0) {
  unlink(file.path(basepath, "assets"), recursive = TRUE)
}
if (writenotes) {
  write_notes(xml)
}
unlink(xml, recursive = TRUE)
file.copy(basepath, out_dir, recursive = TRUE)
unlink(basepath, recursive = TRUE, force = TRUE)
system(paste(Sys.getenv("R_BROWSER"), file.path(out_dir, 
                                                gsub("\\.Rmd", "", basename(rmd)), basename(rmd))))
}

check_lang <- function(xml_folder) {
  pres_xml <- read_xml(file.path(xml_folder, "ppt", "presentation.xml"))
  
  lang <- xml_find_all(pres_xml, "//p:defaultTextStyle/a:defPPr/a:defRPr") %>%
    map_chr(~xml_attr(., "lang"))
  
  if(any(lang != "en-US")) {
    unlink(dirname(xml_folder), recursive = TRUE, force = TRUE)
    stop(paste0("Non-English (US) languages detected. Currently, the only ",
                "language encoding supported is 'en-US'."))
  }
  sink_reset()

# sink_rmd

sld_notes <- import_notes_xml(xml_folder)
sink(rmd)
cat(
  create_yaml(title_sld, author, title, sub, date, theme, highlightStyle)
)
pmap(list(.x = slds, .y = rels, .z = seq_along(slds)),
     function(.x, .y, .z)
       cat("\n---",
           extract_title(.x),
           extract_body(.x),
           tribble_code(extract_table(.x), tbl_num = .z),
           extract_image(.x, .y),
           extract_attr(.y, "link", .x),
           extract_footnote(.x),
#           extract_notes(sld_notes, .z + 1),
           sep = "\n")
)
sink()

# extract_notes

notes <- sld_notes
sld_notes_num <- map_dbl(notes,
                         ~xml_find_all(., "//p:txBody/a:p/a:fld/a:t") %>%
                           xml_text(.) %>%
                           as.numeric())

if(!(sld_num %in% sld_notes_num)) {
  return()
}
note <- notes[sld_num == sld_notes_num][[1]]
note_text <- xml_find_all(note, "//p:txBody/a:p/a:r") %>%
  xml_text(trim = TRUE) %>%
  paste0(collapse = " ")

if(inslides) {
  out <- paste0("\n???\n", note_text, "\n", collapse = "")
  return(out[-grep(paste0("\n???\n", " ", "\n", collapse = ""), out)])
}
if(!inslides) {
  return(paste0(note_text, "\n", collapse = ""))
}


xml_find_all(notes[[1]], "//p:txBody/a:p/a:fld/a:t")

xml_find_all(notes[[2]], "//p:txBody/a:p/a:fld/a:t") %>%
  xml_text(.) %>%
  as.numeric()

sld_notes_num <- map_dbl(notes,
                         ~xml_find_all(., "//p:txBody/a:p/a:fld/a:t"))

sld_notes_num <- map_dbl(notes,
                         ~xml_find_all(., "//p:txBody/a:p/a:fld/a:t") %>%
                           xml_text(.))

sld_notes_num <- map_dbl(notes,
                         ~xml_find_all(., "//p:txBody/a:p/a:fld/a:t") %>%
                           xml_text(.) %>%
                           as.numeric())


tst0 <- tst_convert_pptx(path, author="Simon", force=TRUE)
sink_reset()
