### ----------------------
### ACS data helper script
###

# This script creates a list of acs5 variables and a function for pulling them
# according to a user-selected year. The value in this script comes from
# the ability of the user to come in and edit the variable list and 
# the fields that end up in the final dataset according to project needs.
# To find variables and their corresponding variable codes, please
# reference the variables for a selected year using tidycensus::load_variables

# List of variables to pull with readable names for the output.
# More information for working with tidycensus can be found at
# https://walker-data.com/tidycensus/articles/basic-usage.html
acs5_vars <- c(
  total_housing_units = "B25002_001",
  vacant_housing_units = "B25002_003",
  gini_index = "B19083_001",
  # median_gross_rent = "B25031_001",
  # Median gross rent by bedroom is missing data at tract level
  # median_gross_rent_br_0 = "B25031_002",
  # median_gross_rent_br_1 = "B25031_003",
  # median_gross_rent_br_2 = "B25031_004",
  # median_gross_rent_br_3 = "B25031_005",
  # median_gross_rent_br_4 = "B25031_006",
  # median_gross_rent_br_grtoeq_5 = "B25031_007",
  total_households = "B25013_001",
  rental_households = "B25013_007",
  ba_households_own = "B25013_006",
  ba_households_rent = "B25013_011",
  total_families = "B17019_001",
  families_below_poverty_level = "B17019_002",
  # _b in varname to identify which total_households came from which table
  total_households_b = "B22003_001",
  snap_households_b = "B22003_002",
  median_hh_income = "B19013_001",
  total_households_c = "B25070_001",
  household_rentburden_30_34 = "B25070_007",
  household_rentburden_35_39 = "B25070_008", 
  household_rentburden_40_49 = "B25070_009",
  household_rentburden_grtoeq_50 = "B25070_010",
  rent_occ_total = "B25068_001"
)

# Pulling data for Zip Code tabulation areas
# user provides a list of ZCTAs and the year
acs5_pull <- function(year, zctas) {
  get_acs(survey = "acs5",
          geography = "zcta",
          variables = acs5_vars,
          zctas = zctas,
          year = year,
          output = "wide") %>%
  # output = "wide" suffixes variables with M(argin of error) and E(stimate)
  select(GEOID, NAME, ends_with("E")) %>%
  # remove the suffixes
  rename_with(.fn = ~ gsub("E$", "", .x),
              .cols = -c(GEOID, NAME)) %>%
  # Set the final data to return
  mutate(
    GEOID,
    NAME,
    year = year,
    tract_gini_index = gini_index,
    # tract_median_gross_rent = median_gross_rent,
    tract_vacant_housing_units = vacant_housing_units / total_housing_units,
    tract_percent_ba = (ba_households_own + ba_households_rent) / total_households,
    tract_percent_below_poverty = families_below_poverty_level / total_families,
    tract_percent_unaffordable = (household_rentburden_30_34 + household_rentburden_35_39 + 
                                    household_rentburden_40_49 + household_rentburden_grtoeq_50) / total_households_c,
    tract_median_hh_income = median_hh_income,
    tract_percent_snap_recipients = snap_households_b / total_households_b,
    .keep = "none"
  )
  
  message(paste0("ACS ", year, " 5-year estimates pulled."))
}