# Prepare workspace -------------------------------------------------------

options(tidyverse.quiet = TRUE)
library(targets)
library(tidyverse)

# load functions
f <- lapply(list.files(path = here::here("R"), full.names = TRUE,
                       include.dirs = TRUE, pattern = "*.R"), source)

# Plan analysis ------------------------------------------------------------

list(
  tar_target(
    name = asfis_list,
    command = readr::read_csv(
      file = "data/raw/ASFIS_sp_2020.txt",
      col_types = readr::cols(.default = readr::col_character()))
  ),
  tar_target(
    name = asfis_divisions,
    command = readr::read_csv(
      file = "data/raw/CL_FI_SPECIES_ISSCAAP_DIVISION.csv",
      col_types = readr::cols(.default = readr::col_character()))
  ),
  tar_target(
    name = ihh_list,
    command = readr::read_csv(
      file = "data/raw/IHH_species_list.csv",
      col_types = readr::cols(.default = readr::col_character()),
      locale = locale(encoding = "ISO-8859-1"))
  ),
  tar_target(
    name = isscaap_species_info,
    command = merge_asfis_info(asfis_divisions, asfis_list)
  ),
  tar_target(
    name = isscaap_genus_specific_info,
    command = get_genus_specified_info(isscaap_species_info)
  ),
  tar_target(
    name = isscaap_genus_derived_info,
    command = derive_genus_info(isscaap_species_info)
  ),
  tar_target(
    name = isscaap_family_derived_info,
    command = derive_family_info(isscaap_species_info)
  ),
  tar_target(
  name = merged_list,
  command = fill_list(ihh_list, isscaap_species_info,
                      isscaap_genus_specific_info, isscaap_genus_derived_info,
                      isscaap_family_derived_info)
  ),
  tar_target(
  name = output_list_csv,
  command = (function(x, file) {readr::write_csv(x, file); file})(merged_list, "data/processed/species_list_isscaap.csv"),
  format = "file"
  )
)

