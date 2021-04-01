merge_tables <- function(ihh_list, asfis_list, asfis_divisions){

  isscaap_group <- asfis_list %>%
    rename(ISSCAAP_GROUP_CODE = ISSCAAP)

  isscaap_division <- asfis_divisions %>%
    rename(ISSCAAP_DIVISION_CODE = ISSCAAP_Code,
           ISSCAAP_DIVISION_NAME = Name_En)

  ihh_list %>%
    left_join(select(isscaap_group, Scientific_name, ISSCAAP_GROUP_CODE),
              by = c("species_main" = "Scientific_name")) %>%
    mutate(ISSCAAP_DIVISION_CODE = substr(ISSCAAP_GROUP_CODE, 1, 1)) %>%
    left_join(select(isscaap_division, ISSCAAP_DIVISION_CODE, ISSCAAP_DIVISION_NAME),
              by = "ISSCAAP_DIVISION_CODE") %>%
    janitor::clean_names()

}

