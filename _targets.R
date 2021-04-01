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
      col_types = readr::cols(.default = readr::col_character()))
  ),
  tar_target(
    name = merged_list,
    command = merge_tables(ihh_list, asfis_list, asfis_divisions)
  ),
  tar_target(
    name = output_list_csv,
    command = (function(x, file) {readr::write_csv(x, file); file})(merged_list, "data/processed/species_list_isscaap.csv"),
    format = "file"
  )
)

