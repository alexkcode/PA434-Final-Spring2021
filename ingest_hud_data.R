### -------------------
### ingesting HUD data
###

### Cmbine all of these datasets into one tidy, long data object
# where the unit of observation is the ZIP Code-year and the final 
# columns are: year, ZIP, br_0, br_1, br_2, br_3, br_4

hud_2021 <- readxl::read_xlsx(here("Data", "HUD", "fy2021_safmrs_revised.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) %>% # 371 ZIP Codes
  select("ZIP" = `ZIP\nCode`, 
         "br_0" = `SAFMR\n0BR`,
         "br_1" = `SAFMR\n1BR`,
         "br_2" = `SAFMR\n2BR`,
         "br_3" = `SAFMR\n3BR`,
         "br_4" = `SAFMR\n4BR`) %>%
  mutate(year = 2021, .before = "ZIP")

hud_2020 <- readxl::read_xlsx(here("Data", "HUD", "fy2020_safmrs_rev.xlsx")) %>%
  filter(str_detect(Areaname20, "Chicago")) %>% # 344 ZIP Codes
  select("ZIP" = zcta,
         "br_0" = safmr_0br,
         "br_1" = safmr_1br,
         "br_2" = safmr_2br,
         "br_3" = safmr_3br,
         "br_4" = safmr_4br) %>%
  mutate(year = 2020, .before = "ZIP")

hud_2019 <- readxl::read_xlsx(here("Data", "HUD", "fy2019_safmrs_rev.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) %>% # 344 ZIP Codes
  select("ZIP" = `ZIP\r\nCode`, 
         "br_0" = `SAFMR\r\n0BR`,
         "br_1" = `SAFMR\r\n1BR`,
         "br_2" = `SAFMR\r\n2BR`,
         "br_3" = `SAFMR\r\n3BR`,
         "br_4" = `SAFMR\r\n4BR`) %>%
  mutate(year = 2019, .before = "ZIP")

hud_2018 <- readxl::read_xlsx(here("Data", "HUD", "fy2018_advisory_safmrs_revised_feb_2018.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) %>% # 340 ZIP Codes
  select("ZIP" = `ZIP\nCode`, 
         "br_0" = `SAFMR\n0BR`,
         "br_1" = `SAFMR\n1BR`,
         "br_2" = `SAFMR\n2BR`,
         "br_3" = `SAFMR\n3BR`,
         "br_4" = `SAFMR\n4BR`) %>%
  mutate(year = 2018, .before = "ZIP")

hud_2017 <- readxl::read_xlsx(here("Data", "HUD", "FY2017_hypothetical_safmrs.xlsx")) %>%
  filter(str_detect(metro_name, "Chicago")) %>% # 457 ZIP Codes
  select("ZIP" = zip_code,
         "br_0" = area_rent_br0,
         "br_1" = area_rent_br1,
         "br_2" = area_rent_br2,
         "br_3" = area_rent_br3,
         "br_4" = area_rent_br4) %>%
  mutate(year = 2017, .before = "ZIP")

hud_2016 <- readxl::read_xlsx(here("Data", "HUD", "final_fy2016_hypothetical_safmrs.xlsx")) %>%
  filter(str_detect(metro_name, "Chicago")) %>% # 526 ZIP Codes
  select("ZIP" = zip_code,
         "br_0" = area_rent_br0,
         "br_1" = area_rent_br1,
         "br_2" = area_rent_br2,
         "br_3" = area_rent_br3,
         "br_4" = area_rent_br4) %>%
  mutate(year = 2016, .before = "ZIP")

hud_2015 <- readxl::read_xls(here("Data", "HUD", "small_area_fmrs_fy2015f.xls")) %>%
  filter(str_detect(cbnsmcnm, "Chicago")) %>% # 479 ZIP Codes
  select("ZIP" = zipcode,
         "br_0" = area_rent_br0,
         "br_1" = area_rent_br1,
         "br_2" = area_rent_br2,
         "br_3" = area_rent_br3,
         "br_4" = area_rent_br4) %>%
  mutate(year = 2015, .before = "ZIP")

hud_2014 <- readxl::read_xls(here("Data", "HUD", "small_area_fmrs_fy2014.xls")) %>%
  filter(str_detect(`CBSA Name`, "Chicago")) %>% # 496 ZIP Codes
  select("ZIP" = ZIP,
         "br_0" = area_rent_br0,
         "br_1" = area_rent_br1,
         "br_2" = area_rent_br2,
         "br_3" = area_rent_br3,
         "br_4" = area_rent_br4) %>%
  mutate(year = 2014, .before = "ZIP")

hud_data_raw <- list(hud_2021, hud_2020, hud_2019, hud_2018,
                     hud_2017, hud_2016, hud_2015, hud_2014) %>%
  reduce(bind_rows)

# We only want to have the hud_data_raw object in the environment
# when this script finishes
rm(list=setdiff(ls(), "hud_data_raw"))