# SPC Coastal Fisheries Web Application Python Client

This project provides a Jupyter notebook to connect and interact with the SPC Coastal Fisheries Web Application. 

Go to folder `python` if you want to run the process in a Jupyter notebook or to `R` if you prefer to use R and qmd files. 

The Jupyter notebook (`python/report.ipynb`) and Quarto (`R/report.qmd`) in the `python` folder allows you to:

After going through the `Setup Instructions` (found in the README.md file in the `R` and `python` folder), open `report.[qmd/ipynb]` and run the cells sequentially to:
   - Connect to the API (SPC Coastal Fisheries Web Application)
   - Explore and retrieve information about authorities, surveys, and species
   - Export data in JSON and CSV formats

The Jupyter notebook interacts with the following SPC Coastal Fisheries API endpoints:

- `/account/SignIn` - Authentication
- `/FieldSurveys/LdsStatistics/GetAuthorities` - Retrieve available authorities
- `/FieldSurveys/LdsStatistics/GetSurveys` - Get survey information
- `/FieldSurveys/LdsStatistics/GetSpecies` - List available species
- `/FieldSurveys/LdsStatistics/GetReports` - Get available reports
- `/FieldSurveys/LdsStatistics/ExportDataAsJson` - Export data as JSON
- `/FieldSurveys/LdsStatistics/ExportDataAsCsv` - Export data as CSV

The file `api_documentation.md` goes into more detail on how you can interact with each endpoint(request and response models).

This is a **public repository** never commit sensitive credentials and **always** use the `.env` file for storing credentials (The `.env` file is already included in `.gitignore` to prevent accidental commits)

## Troubleshooting

1. **Authentication Failed**: Verify your credentials in the `.env` file
2. **Module Not Found**: Ensure you've activated the virtual environment and installed requirements
3. **Connection Issues**: Check your internet connection and API endpoint availability

Contact the SPC Data Team (Coastal or Oceanic) for API-related issues