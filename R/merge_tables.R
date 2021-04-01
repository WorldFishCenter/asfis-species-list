merge_asfis_info <- function(asfis_divisions, asfis_list){

  isscaap_division <- asfis_divisions %>%
    janitor::clean_names() %>%
    rename(isscaap_division_code = isscaap_code,
           isscaap_division_name = name_en)

  asfis_list %>%
    janitor::clean_names() %>%
    rename(isscaap_group_code = isscaap) %>%
    mutate(isscaap_division_code = substr(isscaap_group_code, 1, 1)) %>%
    left_join(isscaap_division,by = "isscaap_division_code") %>%
    mutate(genus = str_extract(scientific_name, "^[A-Za-z]+")) %>%
    select(isscaap_division_code, isscaap_division_name, isscaap_group_code,
           scientific_name, genus, family) %>%
    filter(!is.na(isscaap_group_code), !is.na(scientific_name))

}

get_genus_specified_info <- function(isscaap_sp_info){
  isscaap_sp_info %>%
    filter(str_detect(scientific_name, "spp$"))
}

derive_genus_info <- function(isscaap_sp_info){
  isscaap_sp_info %>%
    group_by(genus) %>%
    filter(n_distinct(isscaap_group_code) == 1) %>%
    select(1:3, genus) %>%
    distinct() %>%
    ungroup()
}

derive_family_info <- function(isscaap_sp_info){
  isscaap_sp_info %>%
    group_by(family) %>%
    filter(n_distinct(isscaap_group_code) == 1) %>%
    select(1:3, family) %>%
    distinct() %>%
    ungroup()
}

match_record <- function(species, genus, family, isscaap_sp_info,
                         isscaap_genus_specific_info, isscaap_genus_derived_info,
                         isscaap_family_info){

  species_match <- isscaap_sp_info[isscaap_sp_info$scientific_name == species, 1:3]

  if (nrow(species_match) == 1) {
    return(species_match)
  }

  genus_given_match <- match_genus(genus, isscaap_genus_specific_info, isscaap_genus_derived_info)

  if (nrow(genus_given_match) == 1) {
    return(genus_given_match)
  }

  genus_infered_match <- match_genus(str_extract(species, "^[A-Za-z]+"), isscaap_genus_specific_info, isscaap_genus_derived_info)

  if (nrow(genus_infered_match) == 1) {
    return(genus_infered_match)
  }

  family_match <- isscaap_family_info[isscaap_family_info$family == family, 1:3]

  if (nrow(family_match) == 1) {
    out <- family_match %>%
      mutate(note = "warning: matched using derived family information")
    return(out)
  }

  NULL

}

match_genus <- function(genus, isscaap_genus_specific_info, isscaap_genus_derived_info){

  genus_sp_match <- isscaap_genus_specific_info[isscaap_genus_specific_info$genus == genus, 1:3]

  if (nrow(genus_sp_match) == 1) {
    out <- genus_sp_match %>%
      mutate(note = "warning: matched using genus information")
    return(out)
  }

  genus_sp_derived_match <- isscaap_genus_derived_info[isscaap_genus_derived_info$genus == genus, 1:3]

  if (nrow(genus_sp_derived_match) == 1) {
    out <- genus_sp_derived_match %>%
      mutate(note = "warning: matched using derived genus information")
    return(out)
  }

  tibble(dummy = integer())
}


fill_list <- function(ihh_list, isscaap_species_info,isscaap_genus_specific_info, isscaap_genus_derived_info, isscaap_family_derived_info){

  ihh_list %>%
    filter(!is.na(species_main)) %>%
    rowwise() %>%
    mutate(data = list(match_record(species_main, genus_main, family_main,
                                    isscaap_species_info,
                                    isscaap_genus_specific_info,
                                    isscaap_genus_derived_info,
                                    isscaap_family_derived_info))) %>%
    unnest(cols = c(data), keep_empty = TRUE)
}
