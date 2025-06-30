library(tidyverse)
library(readxl)
library(httr)
library(here)

######################## Import County FIPS code data from census.gov
tn_counties_link <- "https://www2.census.gov/geo/docs/reference/codes2020/cou/st47_tn_cou2020.txt" 

tn_counties <- read_delim(tn_counties_link, 
                          delim = "|") |>
  mutate(geoid = paste0(STATEFP, COUNTYFP)) |>
  select(geoid, COUNTYNAME) |>
  rename(county_long = COUNTYNAME) |>
  mutate(county = substr(county_long, 1, nchar(county_long) - 7)) 


######################## ARC Distressed Counties
### Links to 9 years of distressed county data from ARC
distress_fy25 <- "https://www.arc.gov/wp-content/uploads/2024/06/CountyEconomicStatusandDistressAreasFY2025DataTables.xlsx"
distress_fy24 <- 'https://www.arc.gov/wp-content/uploads/2023/06/CountyEconomicStatusandDistressAreasFY2024DataTables.xls'
distress_fy23 <- 'https://www.arc.gov/wp-content/uploads/2022/06/CountyEconomicStatusandDistressAreasFY2023DataTables.xls'
distress_fy22 <- 'https://www.arc.gov/wp-content/uploads/2021/12/CountyEconomicStatusandDistressAreasFY2022DataTables_Revised_2021-11-15.xls'
distress_fy21 <- 'https://www.arc.gov/wp-content/uploads/2020/08/County-Economic-Status_FY2021_Data_revised_2021-03-10.xls'
distress_fy20 <- 'https://www.arc.gov/wp-content/uploads/2020/09/County-Economic-Status_FY2020_Data-4.xls'
distress_fy19 <- 'https://www.arc.gov/wp-content/uploads/2020/06/County-Economic-Status_FY2019_Data.xls'
distress_fy18 <- 'https://www.arc.gov/wp-content/uploads/2020/06/County-Economic-Status_FY2018_Data.xls'
distress_fy17 <- "https://www.arc.gov/wp-content/uploads/2020/06/County-Economic-Status_FY2017_Data.xls"

sheet <- 'US Counties'
skip = 4

### FY16 data does not have classifications for all Tennessee counties, just
### those in the ARC footprint
distressed_counties <- c(distress_fy25, distress_fy24, distress_fy23, 
                         distress_fy22, distress_fy21, distress_fy20, 
                         distress_fy19, distress_fy18, distress_fy17)

z <- c(25:17)

t <- c(".xlsx", rep.int(".xls", times = 8))

distress <- function(x, t, z) {
  temp <- tempfile(pattern = "dis", fileext = t)
  GET(x, write_disk(temp, overwrite = TRUE))
  y <- read_excel(temp, sheet = sheet, 
                  skip = skip,
                  .name_repair = "universal") |>
    select(1:5) |>
    mutate(fy = z)
  
  names(y)[5] <- "status"
  
  return(y)
}

distressed <- pmap(list(distressed_counties, t, z), distress) |> 
  bind_rows() |>
  filter(State == "Tennessee") |> 
  rename(geoid = FIPS,
         arc_county = ARC.County) |>
  mutate(arc_county = ifelse(is.na(arc_county), "No", arc_county)) |>
  pivot_wider(values_from = status, 
              names_from = fy,
              names_prefix = "distress_fy") |>
  select(-c(State, County))

######################## Core Based Statistical Areas (CBSA)
cbsa_2023_link <- "https://www2.census.gov/programs-surveys/metro-micro/geographies/reference-files/2023/delineation-files/list1_2023.xlsx"

temp <- tempfile(pattern = "cbsa", fileext = ".xlsx")

GET(cbsa_2023_link, write_disk(temp, overwrite = TRUE))

cbsa_2023 <- read_excel(temp, 
                        skip = 2,
                        .name_repair = "universal") |>
  filter(FIPS.State.Code == "47") |>
  mutate(geoid = paste0(FIPS.State.Code, FIPS.County.Code)) |>
  select(geoid, CBSA.Code, CBSA.Title,
         Metropolitan.Micropolitan.Statistical.Area, Central.Outlying.County) |>
  rename(cbsa_code = CBSA.Code,
         cbsa_title = CBSA.Title,
         metro_micro = Metropolitan.Micropolitan.Statistical.Area,
         central_outlying = Central.Outlying.County)

######################## Tennessee Development Districts & 
######################## Tennessee ECD Rural Classification
tn_sdc <- "https://tnsdc.utk.edu/wp-content/uploads/sites/94/2025/02/TN_CountyGeoClassifier_2024.csv"
tn_sdc <- read_csv(tn_sdc) |> 
  rename_with(\(x) tolower(x)) |>
  mutate(geoid = as.character(geoid)) |>
  select(geoid, dev_dist_name, dev_dist_acronym, ecd_rural)
  
######################## USDA Rural-Urban Continuum Codes (RUCC)
##### RUCC 2013
rucc_2013_link <- "https://ers.usda.gov/sites/default/files/_laserfiche/DataFiles/53251/ruralurbancodes2013.xls?v=14396"

temp <- tempfile(pattern = "rucc", fileext = ".xls")

GET(rucc_2013_link, write_disk(temp, overwrite = TRUE))

rucc_2013 <- read_excel(temp) |> 
  filter(State == "TN") |>
  select(FIPS, RUCC_2013, Description) |>
  rename(geoid = FIPS,
         rucc_2013 = RUCC_2013,
         rucc_2013_desc = Description)

##### RUCC 2023
rucc_2023_link <- "https://ers.usda.gov/sites/default/files/_laserfiche/DataFiles/53251/Ruralurbancontinuumcodes2023.csv?v=58868"

rucc_2023 <- read_csv(rucc_2023_link) |>
  filter(State == "TN") |>
  pivot_wider(names_from = Attribute, values_from = Value) |> 
  select(-c(State, Population_2020, County_Name)) |>
  rename(geoid = FIPS,
         rucc_2023 = RUCC_2023,
         rucc_2023_desc = Description)
  
###################### Grand Divisions, TDOT District, and County Number
tn_grand_div_tdot <- file.path(here(), "tn_grand_divisions_tdot_regions.csv")

tn_grand_div_tdot <- read_csv(tn_grand_div_tdot, col_types = "ccccc") |>
  select(-county)
  
######################## Combine dataframes
tn_list <- list(tn_counties, distressed, cbsa_2023,
                tn_sdc, rucc_2013, rucc_2023, 
                tn_grand_div_tdot)

tn_county_geo_classification <- tn_list |> reduce(left_join, by = "geoid")


########## Write the csv
write_csv(tn_county_geo_classification, "tn_county_classification.csv")
