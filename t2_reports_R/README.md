# Tufman 2 Data Retrieval Scripts

R-based scripts for retrieving data from the [SPC Tufman 2 reports](https://www.spc.int/ofp/tufman2/data/ReportDefinition).

If you don't have a Tufman 2 account yet, you can create one by following this documention [create_t2_password.pdf](create_t2_password.pdf). Once your account is created, you will need to ask someone from FAME-DM or your local admin to give you a “role” which determines to which modules inside Tufman 2 you have access.

Tufman 2 reports are a series of summarisations based on the data stored in the Tufman 2 database. All these reports are managed by SPC with the goal of providing to countries information they need to answer specific questions. Below are listed some of the reports available: 

- LONGLINE - All species catch and effort - BY VESSEL FLAG AND EEZ" which provides the catch and effort for 
- IATTC Area -- TASK II -- LONGLINE Catch and effort (5x5)
-  PURSE SEINE - Full OBSERVER reconciliation in WCPFC Area - NATIONAL FLEET


## Overview

This repository contains R scripts and documentation that enable Tufman 2 users to programmatically access, filter, and download data from T2 reports. The system provides a streamlined workflow for researchers and analysts to extract data from specific reports based on customizable parameters.

You will need to have a password to connect to Tufman 2. If you only connect to T2 using a social account (gmail), you will need to create a password for T2 by following the documention: [create_t2_password.pdf](create_t2_password.pdf)

### Security Notes

- Never share your `.env` file or credentials
- Tokens are automatically managed and expire after 1 hour

## Setup Instructions

### 1. Environment Configuration
1. Copy the `envtemplate` file to create a new file named `.env`
2. Add your Tufman 2 password to the `.env` file:
   ```
   TUF_PASSWORD=your_password_here
   ```
3. Ensure there's an empty line at the end of the `.env` file
4. **Important**: Never commit the `.env` file to version control

### 2. Configure User Settings
In `report.qmd`, update these variables with your credentials:
```r
user_name = "your_email@spc.int"    # Your Tufman 2 username
country_code = "XX"                  # Your country code (e.g., "VU", "SB")
```

## How to Run

### Option 1: Interactive Analysis (Recommended for Beginners)
0. Clone this repository and open the Rproject (`t2_reports_R.Rproj`)
1. Open `report.qmd` in RStudio and make sure you haveg gone through the `Setup Intructions` above
2. Click "Render" to generate an interactive HTML report
3. Follow the step-by-step workflow in the rendered document

### Option 2: Direct Script Execution
```r
# Load utilities
source("utils.R")

# Set credentials
user_name <- "your_email@spc.int"
country_code <- "SB"

# Authenticate
token <- load_token(user_name, country_code)

# Get available reports
reports <- get_list_of_t2_reports(token, country_code, user_name)

# Filter and download specific reports
filtered_reports <- reports %>% 
  filter(user_report_id %in% c(3039, 3040, 3494))

attrs <- list(flag_code = "SB", year = 2024)

get_reports(token, user_name, country_code, filtered_reports, attrs)
```

## What These Scripts Do

### Core Functionality

1. **Authentication & Token Management** (`utils.R`)
   - Handles secure API authentication with Tufman 2
   - Automatically manages access tokens (generation, validation, refresh)
   - Stores credentials securely using environment variables

2. **Report Discovery** (`utils.R` - `get_list_of_t2_reports(token, country_code, user_name, replace = FALSE)`)
   - Retrieves all available reports for a country/organization
   - Extracts report metadata including available filters and parameters
   - Caches report lists locally to reduce API calls
   - **Parameters**:
        - `replace`: If `FALSE`, uses cached data; if `TRUE`, forces fresh API call
        - **Returns**: Data frame with report metadata


3. **Data Extraction** (`utils.R` - `get_reports(token, user_name, country_code, filtered_reports, attrs, ...)`)
   - Downloads specific reports based on user-defined filters
   - Supports multiple data formats (JSON, CSV)
   - Implements file naming and caching strategies
   - **Parameters**:
        - `filtered_reports`: Subset of reports to download
        - `attrs`: List of filter parameters (e.g., `list(flag_code = "SB", year = 2024)`)
        - `overwrite`: Whether to overwrite existing files
        - `record_current_date`: Whether to include date in filename


4. **Interactive Analysis** (`report.qmd`)
   - Provides a step-by-step guided workflow
   - Includes interactive data tables for report exploration
   - Demonstrates filtering and parameter customization

## File Structure

```
t2_reports_R/
├── README.md             # This documentation
├── report.qmd            # Main interactive analysis document
├── utils.R               # Core utility functions
├── envtemplate           # Environment variable template
├── t2_reports_R.Rproj    # R project file
└── data/
    ├── list_of_t2_reports_[COUNTRY].csv  # Cached reports list 
    └── t2_reports_data/
        ├── [COUNTRY_CODE]_[T2_REPORT_CODE].csv    # Downloaded report data
```

## Why These Scripts Are Important

- Eliminates manual report generation from the Tufman 2 web interface
- Documents exact parameters used for data extraction
- Enables consistent data pulls across different time periods
- Facilitates collaborative research with standardized workflows
- Supports automated reporting pipelines
- Easily adaptable to new report types or parameter changes

## Troubleshooting - Common Issues

1. **Authentication Errors**: Verify credentials in `.env` file
2. **Empty Data Returns**: Check filter parameters match report requirements
3. **Token Expiration**: Tokens auto-refresh; restart R session if issues persist
4. **Network Issues**: Ensure stable internet connection to SPC servers

---

*This toolkit is maintained by the SPC Data Management team. For feature requests or bug reports, please contact jessicals@spc.int*



