tables <- readRDS("../data/iati_tables.rds")
codelists <- readRDS("../data/codelists.rds")

activity_years <- tables$dates %>%
  tidyr::pivot_wider(names_from = activity_date_type, values_from = activity_date_iso_date) %>%
  dplyr::mutate(
    start_date = as.Date(coalesce(`2`, `1`)), end_date = as.Date(coalesce(`4`, `3`)),
    start_year = as.numeric(format(start_date, "%Y")), end_year = as.numeric(format(end_date, "%Y"))
  ) %>%
  dplyr::select(-c(`1`, `2`, `3`, `4`))

activity_sectors <- dplyr::left_join(
  select(tables$activities, iati_identifier, sector_code),
  codelists$Sector,
  by = c("sector_code" = "code")
)

activity_locations <- dplyr::mutate(tables$recipients,
  location_code = dplyr::coalesce(recipient_country_code, as.character(recipient_region_code)),
  location_narrative = stringr::str_to_title(
    dplyr::coalesce(recipient_country_narrative, recipient_region_narrative)
  )
) %>%
  select(iati_identifier, location_code, location_narrative)

activity_budgets <- dplyr::mutate(tables$budget, year = as.numeric(format(as.Date(budget_period_start_iso_date), "%Y"))) %>%
  dplyr::select(iati_identifier, year, budget_value) %>%
  dplyr::group_by(iati_identifier, year) %>%
  dplyr::summarise(budget_value = sum(budget_value)) %>%
  dplyr::left_join(activity_locations, by = "iati_identifier") %>%
  dplyr::left_join(activity_sectors, by = "iati_identifier")

activity_transactions <- dplyr::mutate(tables$transactions, year = as.numeric(format(as.Date(transaction_transaction_date_iso_date), "%Y"))) %>%
  tidyr::pivot_wider(names_from = "transaction_transaction_type_code", values_from = "transaction_value") %>%
  dplyr::left_join(activity_locations, by = "iati_identifier") %>%
  dplyr::left_join(activity_sectors, by = "iati_identifier") %>%
  dplyr::rename(commitment = `2`, disbursement = `3`)

activity_markers <- tables$markers %>%
  dplyr::mutate(policy_marker_significance_binary = if_else(policy_marker_significance == 0, 0, 1)) %>%
  dplyr::left_join(codelists$PolicyMarker, by = c("policy_marker_code" = "code")) %>%
  dplyr::rename(marker = name) %>%
  dplyr::left_join(activity_years, by = "iati_identifier") %>%
  dplyr::left_join(activity_locations, by = "iati_identifier") %>%
  dplyr::left_join(activity_sectors, by = "iati_identifier")

activities <- dplyr::left_join(tables$activities, activity_sectors, by = c("iati_identifier", "sector_code")) %>%
  dplyr::left_join(activity_years, by = "iati_identifier") %>%
  dplyr::left_join(activity_locations, by = "iati_identifier") %>%
  dplyr::left_join(dplyr::filter(tables$orgs, participating_org_role == 4), by = "iati_identifier")
