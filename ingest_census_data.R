# Set the year that the ACS data is pulled for
# Generally the ACS 5 year estimate data is released near the end
# of the year. Depending on when the data is ingested for modeling
# this may need to be changed. 
survey_year <- max_year - 1

# List of variables to pull with readable names for the output.
# More information for working with tidycensus can be found at
# https://walker-data.com/tidycensus/articles/basic-usage.html
acs5_vars <- c(
  total_housing_units = "B25002_001",
  vacant_housing_units = "B25002_003",
  gini_index = "B19083_001",
  median_gross_rent = "B25031_001",
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

# Pulling data for census tracts
acs5_data <- get_acs(survey = "acs5",
                     geography = "tract",
                     variables = acs5_vars,
                     county = "Cook",
                     state = "IL",
                     year = survey_year,
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
    tract_gini_index = gini_index,
    tract_median_gross_rent = median_gross_rent,
    tract_vacant_housing_units = vacant_housing_units / total_housing_units,
    tract_percent_ba = (ba_households_own + ba_households_rent) / total_households,
    tract_percent_below_poverty = families_below_poverty_level / total_families,
    tract_percent_unaffordable = (household_rentburden_30_34 + household_rentburden_35_39 + 
                                    household_rentburden_40_49 + household_rentburden_grtoeq_50) / total_households_c,
    tract_median_hh_income = median_hh_income,
    tract_percent_snap_recipients = snap_households_b / total_households_b,
    .keep = "none"
  )

message(paste0("ACS ", survey_year, " 5-year estimates pulled."))
rm(acs5_vars, survey_year)