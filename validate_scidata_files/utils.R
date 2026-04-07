library(httr)
library(jsonlite)
library(tidyverse)
library(tidyr)
library(gt)

options(scipen = 999)
# Helper function for null coalescing
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# Function to list available templates
list_latest_templates <- function(base_url,
                                  endpoint) {
  url <- paste0(base_url, endpoint)
  
  response <- GET(url)
  
  if (status_code(response) != 200) {
    stop("Failed to fetch templates: ", status_code(response))
  }
  
  content <- content(response, as = "text", encoding = "UTF-8")
  result <- fromJSON(content, flatten = TRUE)
  
  cat("Available Templates:\n")
  for (i in seq_len(nrow(result$templates))) {
    template <- result$templates[i, ]
    cat("\n", i, ". ", template$name, "\n", sep = "")
  }
  
  return(invisible(result$templates))
}


get_template_details <- function(base_url,
                                 endpoint,
                                 template_name = NULL) {
  
  # Build URL with optional template_name parameter
  url <- if (!is.null(template_name)) {
    paste0(base_url, endpoint, "?template_name=", template_name)
  } else {
    paste0(base_url, endpoint)
  }
  
  # Make API request
  response <- httr::GET(url)
  
  # Check if request was successful
  if (httr::http_error(response)) {
    stop(sprintf("API request failed with status %s: %s", 
                 httr::status_code(response),
                 httr::content(response, "text", encoding = "UTF-8")))
  }
  
  # Parse JSON response
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, simplifyVector = FALSE)
  
  # Check if templates exist
  if (is.null(data$templates) || length(data$templates) == 0) {
    warning("No templates found")
    return(data.frame())
  }
  
  # Process each template and flatten the structure
  result_list <- lapply(seq_along(data$templates), function(i) {
    template <- data$templates[[i]]
    
    # Extract template-level info
    template_info <- data.frame(
      template_name = template$template_name %||% NA_character_,
      alias_name = template$alias_name %||% NA_character_,
      version = template$version %||% NA_character_,
      stringsAsFactors = FALSE
    )
    
    # Extract column specifications
    if (!is.null(template$definition$columns)) {
      columns <- template$definition$columns
      
      column_details <- lapply(names(columns), function(col_name) {
        col_spec <- columns[[col_name]]
        
        # Create a data frame with all possible column specification fields
        data.frame(
          column_name = col_name,
          type = col_spec$type %||% NA_character_,
          nullable = col_spec$nullable %||% NA,
          min = col_spec$min %||% NA_real_,
          max = col_spec$max %||% NA_real_,
          min_length = col_spec$min_length %||% NA_integer_,
          max_length = col_spec$max_length %||% NA_integer_,
          default = as.character(col_spec$default %||% NA_character_),
          description = col_spec$description %||% NA_character_,
          stringsAsFactors = FALSE
        )
      })
      
      # Combine column details
      column_df <- do.call(rbind, column_details)
      
      # Cross join template info with column details
      result <- merge(template_info, column_df, by = NULL)
      
    } else {
      # No columns defined
      result <- template_info
      result$column_name <- NA_character_
    }
    
    return(result)
  })
  
  # Combine all results into a single data frame
  final_df <- do.call(rbind, result_list)
  
  # Reset row names
  rownames(final_df) <- NULL
  
  return(final_df)
}

# Function to list available templates
example_data_template <- function(base_url,
                                  endpoint,
                                  template_name
                                  ) {
  url <- paste0(base_url, endpoint, "/", template_name)
  
  response <- GET(url)
  
  if (status_code(response) != 200) {
    stop("Failed to fetch templates: ", status_code(response))
  }
  
  content <- content(response, as = "text", encoding = "UTF-8")
  result <- fromJSON(content, flatten = TRUE)
  
  df <- result$data |>
    data.frame()
  
  # df$version <- result$template_version
  # df$name <- result$template_name  
  return(df)
}

# Function to validate CSV file
validate_csv <- function(base_url,
                         endpoint,
                         template_name,
                         file_path,
                         submission_year,
                         return_details = FALSE
                         ) {
  
  # Check if file exists
  if (!file.exists(file_path)) {
    stop("File not found: ", file_path)
  }
  
  # Check if file is CSV
  if (!grepl("\\.csv$", file_path, ignore.case = TRUE)) {
    stop("File must be a CSV file")
  }
  
  # Construct endpoint URL
  url <- paste0(base_url, endpoint, "/", template_name)
  
  # Add query parameter if needed
  if (return_details) {
    url <- paste0(url, "?return_details=true")
  }else{
    url <- paste0(url, "?return_details=false")
  }
  if (submission_year){
    url <- paste0(url, "&?submission_years=", as.character(submission_year))
  }
  
  # Make POST request
  cat("Validating file:", file_path, "\n")
  cat("Using template:", template_name, "\n")
  
  response <- POST(
    url = url,
    body = list(file = upload_file(file_path)),
    encode = "multipart"
  )
  
  # Parse response
  content <- content(response, as = "text", encoding = "UTF-8")
  result <- fromJSON(content, flatten = TRUE)
  
  # Handle response based on status code
  if (status_code(response) == 200) {
    cat("\n✓ Validation PASSED\n")
    cat("Rows validated:", result$rows_validated, "\n")
    cat("Columns validated:", result$columns_validated, "\n")
    cat("Message:", result$message, "\n")
    
    return(invisible(result))
    
  } else if (status_code(response) == 422) {
    cat("\n✗ Validation FAILED\n")
    cat("Rows processed:", result$rows_processed, "\n")
    cat("Error count:", result$error_count, "\n")
    cat("Message:", result$message, "\n\n")
    
    if (!is.null(result$error_summary)) {
      cat("Error Summary:\n")
      for (error_type in names(result$error_summary)) {
        cat("  -", error_type, ":", result$error_summary[[error_type]], "occurrences\n")
      }
    }
    
    if (!is.null(result$hint)) {
      cat("\n", result$hint, "\n")
    }
    
    if (!is.null(result$errors) && length(result$errors) > 0) {
      cat("\nDetailed Errors:\n")
      print(as.data.frame(result$errors))
    }
    
    return(invisible(result))
    
  } else if (status_code(response) == 404) {
    stop("Template '", template_name, "' not found")
    
  } else if (status_code(response) == 400) {
    stop("Bad request: ", result$detail)
    
  } else {
    stop("API error (", status_code(response), "): ", result$detail)
  }
}

## 1. Prepare data to be validated ####

build_file_inventory <- function(country_codes, templates_pattern) {
  results <- list()
  
  for (cc in country_codes) {
    cc_dir <- paste0(tolower(cc), "_files/")
    all_files <- list.files(cc_dir)
    
    for (i in seq_len(nrow(templates_pattern))) {
      pattern <- paste0(templates_pattern$file_pattern[i], "_")
      matched <- all_files[grepl(pattern, all_files)]
      
      if (length(matched) == 0) next
      
      results[[length(results) + 1]] <- data.frame(
        files         = paste0(cc_dir, matched),
        file_pattern  = templates_pattern$file_pattern[i],
        template_name = templates_pattern$template_name[i],
        scidata_portal = templates_pattern$data_submission[i],
        country_code  = cc
      )
    }
  }
  
  bind_rows(results) |>
    mutate(submission_year = parse_number(files))
}


## 4. Validate a CSV file ####

validate_files <- function(df_files, base_url, endpoint) {
  results <- list()
  
  for (i in seq_len(nrow(df_files))) {
    r <- validate_csv(
      base_url        = base_url,
      endpoint        = endpoint,
      template_name   = df_files$template_name[i],
      file_path       = df_files$files[i],
      submission_year = df_files$submission_year[i],
      return_details  = TRUE
    )
    
    if (r$message == "Validation failed") {
      r_df <- data.frame(errors = r$errors, status = r$message)
    } else {
      r_df <- data.frame(status = r$message)
    }
    
    r_df$filename     <- df_files$files[i]
    r_df$country_code <- df_files$country_code[i]
    results[[i]]      <- r_df
  }
  
  bind_rows(results)
}
