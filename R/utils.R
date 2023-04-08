
# line graphs -------------------------------------------------------------

makeLineGraph = function(dat, vars = c("", ""), color = "green", labs = c("", "")) {
  if(nrow(dat)==1){p <- dat %>% ggplot2::ggplot(ggplot2::aes(x = .data[[vars[1]]], y = .data[[vars[2]]])) +
    ggplot2::geom_bar(fill = color, alpha = 0.5, stat = "identity") +
    ggplot2::scale_x_continuous(limits = c(dat[[vars[1]]] - 1, dat[[vars[1]]] + 1),
                                breaks = scales::extended_breaks()) +
    ggplot2::theme_classic()
  } else{
    p = dat %>% ggplot2::ggplot(ggplot2::aes(x = .data[[vars[1]]], y = .data[[vars[2]]])) +
      ggplot2::geom_area(fill = color, alpha = 0.5) +
      ggplot2::geom_line(colour = color, linewidth = 1) +
      ggplot2::labs(x = labs[1], y = labs[2]) +
      ggplot2::scale_y_continuous(labels = scales::label_comma()) +
      ggplot2::scale_x_continuous(breaks = scales::extended_breaks()) +
      ggplot2::theme_classic()
  }
  out = plotly::ggplotly(p) %>% plotly::config(displayModeBar = FALSE) %>%
    plotly::layout(xaxis = list(fixedrange = TRUE), yaxis = list(fixedrange = TRUE))%>%
    plotly::style(hoverinfo = "skip", traces = 1)
  
  out
}

# bar graphs --------------------------------------------------------------

makeBarGraph = function(dat, var = "", col_palette = "Set1", labs = c("", "")) {
  p <- dat %>% ggplot2::ggplot(ggplot2::aes(x = .data[[var]], fill = .data[[var]])) +
    ggplot2::geom_bar() +
    ggplot2::coord_flip() +
    ggplot2::scale_fill_brewer(palette = col_palette) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      legend.position = "none"
    )
  
  out <- plotly::ggplotly(p) %>%
    plotly::config(displayModeBar = FALSE) %>%
    plotly::layout(xaxis = list(fixedrange = TRUE), yaxis = list(fixedrange = TRUE)) %>% 
    plotly::style(hoverinfo = "skip", traces = 1)
  out
}

filterData <- function(dat, start, end, sectors, locations) {
  dat_filtered <- dplyr::filter(dat, start_year <= end & end_year >= start)
  if(!is.null(sectors)){dat_filtered <- dplyr::filter(dat_filtered, name %in% sectors)}
  if(!is.null(locations)){dat_filtered <- dplyr::filter(dat_filtered, location_narrative %in% locations)}
  dat_filtered
}

filterBudgetData <- function(dat, start, end, sectors, locations) {
  dat_filtered <- dplyr::filter(dat, year >= start & year <= end)
  if(!is.null(sectors)){dat_filtered <- dplyr::filter(dat_filtered, name %in% sectors)}
  if(!is.null(locations)){dat_filtered <- dplyr::filter(dat_filtered, location_narrative %in% locations)}
  dat_filtered
}

filterOrgData <- function(dat, org_type) {
  dat_filtered <- dat
  if(!is.null(org_type)){dat_filtered <- dplyr::filter(dat_filtered, org_type_name %in% org_type)}
  dat_filtered
}

getCount = function(dat, col) {
  count = length(unique(dat[[col]]))
}

returnIdentifier = function(dat, colname, value) {
  x = dplyr::filter(dat, dat[[colname]] == value) %>% 
    dplyr::select(iati_identifier) %>% 
    unlist() %>% 
    unique() %>% 
    as.character()
  x
}
