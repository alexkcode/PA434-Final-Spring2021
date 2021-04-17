### -------------------
### ingesting HUD data
###

hud_2021 <- readxl::read_xlsx(here("Data", "HUD", "fy2021_safmrs_revised.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) # 371 ZIP Codes

hud_2020 <- readxl::read_xlsx(here("Data", "HUD", "fy2020_safmrs_rev.xlsx")) %>%
  filter(str_detect(Areaname20, "Chicago")) # 344 ZIP Codes

hud_2019 <- readxl::read_xlsx(here("Data", "HUD", "fy2019_safmrs_rev.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) # 344 ZIP Codes

hud_2018 <- readxl::read_xlsx(here("Data", "HUD", "fy2018_advisory_safmrs_revised_feb_2018.xlsx")) %>%
  filter(str_detect(`HUD Metro Fair Market Rent Area Name`, "Chicago")) # 340 ZIP Codes

hud_2017 <- readxl::read_xlsx(here("Data", "HUD", "FY2017_hypothetical_safmrs.xlsx")) %>%
  filter(str_detect(metro_name, "Chicago")) # 457 ZIP Codes

hud_2016 <- readxl::read_xlsx(here("Data", "HUD", "final_fy2016_hypothetical_safmrs.xlsx")) %>%
  filter(str_detect(metro_name, "Chicago")) # 526 ZIP Codes

hud_2015 <- readxl::read_xls(here("Data", "HUD", "small_area_fmrs_fy2015f.xls")) %>%
  filter(str_detect(cbnsmcnm, "Chicago")) # 479 ZIP Codes

hud_2014 <- readxl::read_xls(here("Data", "HUD", "small_area_fmrs_fy2014.xls")) %>%
  filter(str_detect(`CBSA Name`, "Chicago")) # 496 ZIP Codes
