###################################################
## Validate files against Scidata templates      ## 
##                                               ##  
## Author: SPC                                   ##
## Year: 2026                                    ##
###################################################

# 1. Load libraries ####
rm(list=ls())
source("utils.R")

# 2. Configuration ####
API_BASE_URL <- "https://scidata-validator.fame.spc.int/"
endpoint_validate <- "api/v1/validate"
country_codes <- c("eu")

# csv file that maps files for validation and their associated standards (templates)
templates_pattern <- read.csv("input/mapping_file_pattern.csv") |>
  mutate(file_pattern = na_if(file_pattern, "")) |>
  filter(!is.na(file_pattern))

# 3. Validate files ####
df_files <- build_file_inventory(country_codes, templates_pattern) # organise files to be validated 
  # TIP:if you add "_{fishing_year}" at the end of all your filenames they will also be validated
  # against the timeframe allowed by the current submission year. Eg.: if you are submitting your
  # data in 2026, all your filenames should end as "_2025".csv

gt(df_files)

timerun <- Sys.Date() # get current sys.date - to be used when reporting
res <- validate_files(df_files, base_url = API_BASE_URL, endpoint = endpoint_validate)
write.csv(res, "output/log_validation.csv", row.names = FALSE) # save results

# 4. Generate report ####
quarto::quarto_render(
  input          = "validation_report.qmd",
  execute_params = list(last_run = as.character(timerun))
)

if (file.exists("validation_report.html")){
  file.rename(
    "validation_report.html",
    file.path("output", paste0("validation_report_", timerun, ".html"))
  )
}


  