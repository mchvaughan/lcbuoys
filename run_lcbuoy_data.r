
lib_paths <- .libPaths()   # extract both paths
new_paths <- c("C:/Users/mvaughan/Documents/R_package_library", lib_paths [2])  # change order
.libPaths(new_paths)  # modify

library(rmarkdown)
library(rmdformats)

render("lcbuoy_data.Rmd",
       output_file = "index.html")


  # ftpUpload(what = "buoyPlots_v2.R",
  #           to = "ftp://02d0c8c.netsolhost.com/test_r_script_upload.r",
  #           userpwd = userpwd)
