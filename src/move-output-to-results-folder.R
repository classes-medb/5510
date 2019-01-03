project_name <- getwd()
src_path <- paste(project_name, "src", sep="/")
res_path <- paste(project_name, "results", sep="/")
doc_path <- paste(project_name, "doc", sep="/")
html_list <- list.files(src_path, pattern="*.html")
for (i in html_list) {
  fn <- paste(src_path, i, sep="/")
  file.copy(fn, res_path, overwrite=TRUE)
  file.remove(fn)
}
cat("\n\n")
cat(length(html_list))
cat(" html file(s) moved: ")
cat(paste(html_list, collapse=", "))

pptx_list <- list.files(src_path, pattern="*.pptx")
for (i in pptx_list) {
  fn <- paste(src_path, i, sep="/")
  file.copy(fn, doc_path, overwrite=TRUE)
  file.remove(fn)
}
cat("\n\n")
cat(length(pptx_list))
cat(" pptx file(s) moved: ")
cat(paste(html_list, collapse=", "))

