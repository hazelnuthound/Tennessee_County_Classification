# Tennessee_County_Classification
A helper file that provides a classification of Tennessee counties based on (1) economic development, (2) urban/rural descriptors, and (3) other criteria.

When analyzing county-level data, it is often useful to consider factors such as rural status, relative economic development, and a county’s intrastate region. This repository includes an R script that generates a file containing several variables describing Tennessee counties. The file is designed to integrate seamlessly with Census data using the GEOID field, which is available through the Census API or in datasets downloaded from data.census.gov. The script _TN_County_Classification.R_ includes classifications of Tennessee counties based on the following criteria:

1. Appalachian Regional Commission (ARC) distressed county status for FY2017 through FY2025;
2. Membership in a Core-Based Statistical Area, such as a Metropolitan Statistical Area (MSA);
3. Tennessee Development District;
4. Rurality, as determined by the Tennessee Department of Economic and Community Development;
5. USDA Rural-Urban Continuum Codes - 2013 and 2023 vintages;
6. Tennessee Grand Divisions;
7. Tennessee Department of Transportation (TDOT) District; and 
8. County number.

Most of the data used in this script are housed in comma separated or Excel files.  These files are downloaded as temporary files.  The output file is saved in the users home directory using the _here()_ function.  The output file _tn_county_classification.csv_ was generated on June 30, 2025.   Linked files may not be available or available at the same URL in the future.  The file _tn_grand_divisions_tdot_regions.csv_ is provided if the reader would like to create their own output file. 

## Variables in tn_county_classification.csv output file

The resulting file includes the following twenty-seven (27) variables:
1. geoid - (character) Five digit county FIPS code. 
2. county_long - County name including "County" after name
3. county - County name without "County after name
4. arc_county - Indicates if county is covered by Appalachian Regional Commission (ARC)      
5. distress_fy25 - ARC County status (Distressed, At-Risk , Transitional, Competitive, Attainment) for FY25
6. distress_fy24 - ARC County status for FY24
7. distress_fy23 - ARC County status for FY23
8. distress_fy22 - ARC County status for FY22   
9. distress_fy21 - ARC County status for FY21
10. distress_fy20 - ARC County status for FY20
11. distress_fy19 - ARC County status for FY19
12. distress_fy18 - ARC County status for FY18   
13. distress_fy17 - ARC County status for FY217
14. cbsa_code - code identifier for county in Core-Based Statistical Area (CBSA)
15. cbsa_title - name of the CBSA
16. metro_micro - indicator of whether the CBSA is a Micropolitan or Metropolitan statistical area    
17. central_outlying - indicator of whether the county is central or outlying in the statistical area
18. dev_dist_name - Name of Tennnessee Development District
19. dev_dist_acronym - Acronym for Tennnessee Development District
20. ecd_rural - Tennessee Department of Economic and Community Development county rurality designation      
21. rucc_2013 - US Department of Agriculture (USDA) Rural-Urban Continuum Codes (RUCC) for 2013        
22. rucc_2013_desc - Metadata for 2013 USDA RUCC
23. rucc_2023 - USDA RUCC for 2023
24. rucc_2023_desc - Metadata for 2023 USDA RUCC  
25. county_number - Tennessee county number assigned alphabetically
26. grand_division  - County assignment to Tennessee Grand Division 
27. tdot_region - County assignment to Tennessee Department of Transportation (TDOT) Region

## Background on Variables

### Appalachian Regional Commission (ARC) Distressed County Status 
You have likely heard the term  “distressed county.”  The ARC produces the classification system that is source of distressed county classification. [Background Information including Methodology for ARC’s Classification System](https://www.arc.gov/distressed-designation-and-county-economic-status-classification-system/).

### Membership in a Core Based Statistical Area (CBSA)
This is the familiar Metropolitan Statistical Area (MSA) classification.
[2023 OMB standards for delineating CBSAs](https://www.whitehouse.gov/wp-content/uploads/2023/07/OMB-Bulletin-23-01.pdf/). All 95 counties will not be in data set because not all counties are part of a CBSA. 

###  Tennessee Development District
Development districts are regional planning and economic organizations owned and operated by the cities and counties of Tennessee. The nine development districts were established by the general assembly under the Tennessee Development District Act of 1965.  Data provided by the [Tennessee State Data Center](https://tnsdc.utk.edu/).
[A narrative on Development Districts](https://tennesseeencyclopedia.net/entries/development-districts/)

### Rurality as determined by the Tennessee Department of Economic and Community Development
Data provided by the [Tennessee State Data Center](https://tnsdc.utk.edu/).

### USDA Rural-Urban Continuum Codes - 2013 and 2023 vintages
Per the USDA “The 2023 Rural-Urban Continuum Codes distinguish U.S. metropolitan (metro) counties by the population size of their metro area, and nonmetropolitan (nonmetro) counties by their degree of urbanization and adjacency to a metro area. The division of counties as either metro or nonmetro, based on the 2023 Office of Management and Budget (OMB) delineation of metro areas, is further subdivided into three metro and six nonmetro categories. Each county and census-designated county-equivalent in the United States, including those in outlying territories, is assigned one of these nine codes. The codes allow researchers, policy makers, and others to view county-level data by finer residential groups—beyond metro and nonmetro—when analyzing trends related to population density and metro influence.” ([USDA Source\(https://www.ers.usda.gov/data-products/rural-urban-continuum-codes/documentation/)

### Tennessee Grand Divisions
Tennessee Grand Divisions are codified in state law at Tennessee Code Annotated 4-1-201 et. seq. Free access to Tennessee code [here](https://www.tncourts.gov/Tennessee%20Code/). 

[Discussion of Tennessee Grand Divisions - East, Middle & West](https://en.wikipedia.org/wiki/Grand_Divisions_of_Tennessee/)
 
### Tennessee Department of Transportation (TDOT) District
Data taken from a  [map on TDOT website](https://www.tn.gov/tdot/about/county-outline-map.html/).

### County number
A number from 1 to 95 assigned by alphabetical order.

