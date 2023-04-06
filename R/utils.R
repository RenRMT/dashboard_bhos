filterData <- function(dat, start, end, sectors, locations) {
  dat_filtered <- filter(dat, start_year <= end & end_year >= start)
  if(!is.null(sectors)){dat_filtered <- filter(dat_filtered, name %in% sectors)}
  if(!is.null(locations)){dat_filtered <- filter(dat_filtered, location_narrative %in% locations)}
  dat_filtered
}

filterBudgetData <- function(dat, start, end, sectors, locations) {
  dat_filtered <- dplyr::filter(dat, year >= start & year <= end)
  if(!is.null(sectors)){dat_filtered <- dplyr::filter(dat_filtered, name %in% sectors)}
  if(!is.null(locations)){dat_filtered <- dplyr::filter(dat_filtered, location_narrative %in% locations)}
  dat_filtered
}

getCount = function(dat, col) {
  count = length(unique(dat[[col]]))
}
