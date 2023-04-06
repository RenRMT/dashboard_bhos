
# 0. init -----------------------------------------------------------------

library(dplyr)
library(purrr)
library(tidyr)

# 1. functions ------------------------------------------------------------
# general function to grab a specific IATI attribute from the list of activities
getIatiAttr <- function(dat, attr) {
  x = purrr::map(
    dat,
    ~ purrr::pluck(., attr)
  )
  x[sapply(x, is.null)] <- list(list(NA))
x
}

# function to create list of columns in each table
listColnames <- function() {
  list(
    activities = c(
      "iati_identifier", "title_narrative", "description_narrative", "sector_code",
      "activity_status_code", "default_aid_type_code", "conditions_attached",
      "collaboration_type_code", "last_updated_datetime"
    ),
    budget = c(
      "iati_identifier", "budget_value", "budget_period_start_iso_date",
      "budget_period_end_iso_date"
    ),
    dates = c(
      "iati_identifier", "activity_date_iso_date", "activity_date_type"
      ),
    disbursements = c(
      "iati_identifier", "planned_disbursement_value",
      "planned_disbursement_period_start_iso_date",
      "planned_disbursement_period_end_iso_date"
    ),
    markers = c(
      "iati_identifier", "policy_marker_code", "policy_marker_significance"
      ),
    orgs = c(
      "iati_identifier", "participating_org_ref", "participating_org_role",
      "participating_org_narrative"
    ),
    orgs_ref = c(
      "participating_org_ref", "participating_org_type",
      "participating_org_narrative"
    ),
    transactions = c(
      "iati_identifier", "transaction_receiver_org_narrative",
      "transaction_transaction_type_code", "transaction_value",
      "transaction_transaction_date_iso_date"
    ),
    recipients = c(
      "iati_identifier", "recipient_country_code", "recipient_country_narrative",
      "recipient_country_percentage", "recipient_region_code",
      "recipient_region_narrative", "recipient_region_percentage"
    )
  )
}

# function to create table from iati activities file with columns as specified by
# listColnames function
createTable <- function(dat, cols) {
  df <- data.frame(matrix(NA_character_, nrow = length(dat), ncol = 0))

  for (i in cols) {
    df[[i]] <- getIatiAttr(dat, i)
  }

  out <- unnest(df, cols = colnames(df), keep_empty = TRUE)
  out = purrr::map_df(out, unlist)
  
  for(i in names(out)) {
    tryCatch({
      out[[i]] = as.numeric(out[[i]])},
      warning=function(w){out[[i]] = out[[i]]}
    )
  }
  out
}

# 2. run ------------------------------------------------------------------
files <- readRDS("iati_data_all.rds")
colnames <- listColnames()
tables <- purrr::map(colnames, function(x) createTable(files, x))

# for orgs_ref we only want to keep unique values
tables$orgs_ref <- unique(tables$orgs_ref)

# save the bunch because this script is supposed to be run onl once
saveRDS(tables, "iati_tables.rds")
