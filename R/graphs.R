
# line graphs -------------------------------------------------------------

makeLineGraph = function(dat, vars = c("", ""), color = "green", labs = c("", "")) {
  p = dat %>% ggplot(aes(x = .data[[vars[1]]], y = .data[[vars[2]]])) +
    geom_area(fill = color, alpha = 0.5) +
    geom_line(colour = color, linewidth = 1) +
    labs(x = labs[1], y = labs[2]) +
    scale_x_continuous(breaks = pretty_breaks()) +
    theme_classic()
  
  out = ggplotly(p)%>% config(displayModeBar = FALSE) %>%
    layout(xaxis = list(fixedrange = TRUE), yaxis = list(fixedrange = TRUE))%>%
    style(hoverinfo = "skip", traces = 1)
  
  out
}

# bar graphs --------------------------------------------------------------

makeBarGraph = function(dat, var = "", color = "green", labs = c("", "")) {
  p <- dat %>% ggplot(aes(x = .data[[var]])) +
    geom_bar(fill = color) +
    coord_flip() +
    theme_classic()
  
  out <- ggplotly(p) %>%
    config(displayModeBar = FALSE) %>%
    layout(xaxis = list(fixedrange = TRUE), yaxis = list(fixedrange = TRUE))
  
  out
}


