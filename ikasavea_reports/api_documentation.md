# API Documentation

This document summarises SPC Coastal Fisheries API endpoints used in the Jupyter notebook `report.ipynb`.

The goal of this document is to describe the request attributes and response model of each endpoint to help users interact with the API.

## 1. `/account/SignIn` - Authentication
**Method:** POST  
**Purpose:** Authenticate user and establish session cookies  

**Request Attributes:**
- `username` (string, **mandatory**) - Your SPC portal username
- `password` (string, **mandatory**) - Your SPC portal password

**Response Model:**
Returns JSON object with authentication status.

---

## 2. `/FieldSurveys/LdsStatistics/GetAuthorities` - Retrieve Available Authorities
**Method:** POST  
**Purpose:** Get list of authorities accessible to the authenticated user  

**Request Attributes:**
- No data parameters required (empty data object: `{}`)
- Requires authentication cookies from SignIn

**Response Model:**
Returns array of authority objects with fields:
- `Name` (string) - Authority name/identifier
- Additional authority metadata fields

---

## 3. `/FieldSurveys/LdsStatistics/GetSurveys` - Get Survey Information
**Method:** POST  
**Purpose:** Retrieve survey information for specified authorities  

**Request Attributes:**
- `authorities` (array of strings, **optional**) - List of authority names to filter surveys

**Response Model:**
Returns array of survey objects with fields:
- `Name` (string) - Survey name
- Additional survey metadata fields

---

## 4. `/FieldSurveys/LdsStatistics/GetSpecies` - List Available Species
**Method:** POST  
**Purpose:** Get species information for specified authorities  

**Request Attributes:**
- `authorities` (array of strings, **optional**) - List of authority names to filter species

**Response Model:**
Returns array of species objects with fields:
- `Species` (string) - Species name
- `SpeciesGroup` (string) - Species group classification
- Additional species metadata fields

---

## 5. `/FieldSurveys/LdsStatistics/GetReports` - Get Available Reports
**Method:** POST  
**Purpose:** Retrieve list of available landing survey reports  

**Request Attributes:**
- No data parameters required (empty data object: `{}`)
- Requires authentication cookies

**Response Model:**
Returns array of report objects with fields:
- `Id` (string) - Unique report identifier (UUID)
- `Name_EN` (string) - Report name in English
- Additional report metadata fields

---

## 6. `/FieldSurveys/LdsStatistics/ExportDataAsJson` - Export Data as JSON
**Method:** POST  
**Purpose:** Export landing survey data in JSON format  

**Request Attributes:**
- `reportId` (string, **mandatory**) - UUID of the report to export
- `authorities` (array of strings, **optional**) - Filter by specific authorities
- `surveyIds` (array of strings, **optional**) - Filter by specific survey IDs
- `speciesIds` (array of strings, **optional**) - Filter by specific species IDs

**Response Model:**
Returns JSON object with:
- `data` (array) - Array of data records with survey information
- Additional metadata fields

---

## 7. `/FieldSurveys/LdsStatistics/ExportDataAsCsv` - Export Data as CSV
**Method:** POST  
**Purpose:** Export landing survey data in CSV format  

**Request Attributes:**
- `reportId` (string, **mandatory**) - UUID of the report to export
- `authorities` (array of strings, **optional**) - Filter by specific authorities
- `surveyIds` (array of strings, **optional**) - Filter by specific survey IDs
- `speciesIds` (array of strings, **optional**) - Filter by specific species IDs

**Response Model:**
Returns CSV formatted text data with survey records.