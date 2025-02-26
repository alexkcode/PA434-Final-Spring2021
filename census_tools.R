### ----------------------
### ACS data helper 
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
  rent_occ_total = "B25068_001",
  population_total = "B02001_001",
  population_black = "B02001_003"
)

# Pulling data for Zip Code tabulation areas
# user provides a list of ZCTAs and the year
acs5_pull <- function(year, zctas) {
  df <- get_acs(survey = "acs5",
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
      gini_index = gini_index,
      vacant_housing_units = vacant_housing_units / total_housing_units,
      percent_ba = (ba_households_own + ba_households_rent) / total_households,
      percent_below_poverty = families_below_poverty_level / total_families,
      percent_unaffordable = (household_rentburden_30_34 + household_rentburden_35_39 + 
                                household_rentburden_40_49 + household_rentburden_grtoeq_50) / total_households_c,
      median_hh_income = median_hh_income,
      percent_snap_recipients = snap_households_b / total_households_b,
      percent_black_pop = population_black / population_total,
      .keep = "none"
    )
  
  message(paste0("ACS ", year, " 5-year estimates pulled."))
  
  return(df)
}