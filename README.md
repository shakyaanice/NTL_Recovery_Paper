# Nighttime Light-Based Recovery Following Hurricane Harvey

This repository contains Stata and Google Earth Engine code used to analyze nighttime light-based recovery following Hurricane Harvey in Harris County, Texas.

## Stata analysis scripts

- **[NFIP_IHP_model.do](NFIP_IHP_model.do):** Estimates associations between National Flood Insurance Program (NFIP) and Individuals and Households Program (IHP) indicators and nighttime light-based recovery across three four-month periods following Hurricane Harvey.
- **[Equity_model.do](Equity_model.do):** Estimates NFIP and IHP main effects and their interactions with race to examine racial differences in nighttime light-based recovery.

## Google Earth Engine script

**[VIIRS_NTL_download.js](VIIRS_NTL_download.js)** retrieves monthly NOAA VIIRS Day/Night Band (DNB) nighttime-light radiance data for the study area using Google Earth Engine.

## Data availability

The Stata scripts require merged datasets containing both publicly available data and restricted information. These merged datasets cannot be shared and are therefore excluded from this repository. Running the Stata analyses requires access to these input datasets.

The NOAA VIIRS DNB data are publicly available and can be retrieved using the provided Google Earth Engine script.

## Software requirements

The analysis scripts require Stata and the packages specified in each `.do` file. The nighttime-light retrieval script requires access to Google Earth Engine. Update the file paths in the Stata scripts to match your local project directory before running them.
