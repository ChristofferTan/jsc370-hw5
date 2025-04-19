library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(plotly)
library(caret)
library(randomForest)


df <- read.csv("merged_data.csv")

p1 <- plot_ly(
  data = df,
  x = ~hour,
  y = ~total_trips,
  type = "box",
  boxpoints = "suspectedoutliers",  # Show only unusual outliers
  jitter = 0.3,
  pointpos = -1.8,  # Adjusts how far points are from box
  marker = list(size = 4, opacity = 0.4, color = "#1f77b4"),
  line = list(color = "#1f77b4"),
  fillcolor = "rgba(173, 216, 230, 0.4)"
) %>%
  layout(
    title = list(
      text = "Hourly Distribution of Total Bike Trips",
      x = 0.5,
      font = list(size = 18, family = "Arial", color = "#222")
    ),
    xaxis = list(
      title = "Hour of the Day",
      tickmode = "linear",
      tick0 = 0,
      dtick = 1
    ),
    yaxis = list(
      title = "Total Trips",
      rangemode = "tozero"
    ),
    margin = list(l = 60, r = 30, t = 80, b = 60),
    plot_bgcolor = "#fff",
    paper_bgcolor = "#fff",
    font = list(family = "Arial", size = 12)
  )


set.seed(123)
split_index <- createDataPartition(df$total_trips, p = 0.8, list = FALSE)
train_df <- df[split_index, ]
test_df  <- df[-split_index, ]

rf_train <- train_df
rf_test <- test_df

rf_formula <- total_trips ~ temp + pressure + humidity + wind_speed +
  cloudiness + hour + weather_main

final_rf <- randomForest(
  rf_formula,
  data = rf_train,
  mtry = 4,
  ntree = 500,
  nodesize = 10,
  importance=TRUE
)

imp_raw <- importance(final_rf)
importance_df <- data.frame(
  Variable = rownames(imp_raw),
  Importance = imp_raw[, "%IncMSE"]
)

importance_df <- importance_df |>
  arrange(Importance) |>
  mutate(
    Label = paste0(round(Importance, 1), "%"),
    Variable = factor(Variable, levels = Variable)
  )

p2 <- plot_ly(
  data = importance_df,
  x = ~Importance,
  y = ~Variable,
  type = "bar",
  orientation = "h",
  text = ~Label,
  textposition = "inside",
  insidetextanchor = "start",
  textfont = list(size = 10, color = "black"),  # 👈 Smaller font for value inside bar
  marker = list(
    color = ~Importance,
    colorscale = list(
      c(0, "#FFFFB2"), c(0.25, "#FECC5C"),
      c(0.5, "#FD8D3C"), c(0.75, "#F03B20"), c(1, "#BD0026")
    ),
    line = list(color = "black", width = 0.5)
  ),
  hovertemplate = paste(
    "<b>%{y}</b><br>",
    "Importance: %{x:.1f}%<extra></extra>"
  ),
  height = 500
)


pred_vs_actual <- tibble(
  actual = rf_test$total_trips,
  predicted = predict(final_rf, newdata = rf_test)
) %>%
  mutate(abs_error = abs(actual - predicted))

# Compute R²
rsq <- cor(pred_vs_actual$actual, pred_vs_actual$predicted)^2

pred_vs_actual <- pred_vs_actual %>%
  mutate(residual = abs(predicted - actual))

axis_min <- min(pred_vs_actual$actual, pred_vs_actual$predicted)
axis_max <- max(pred_vs_actual$actual, pred_vs_actual$predicted)

p3 <- plot_ly() %>%
  add_trace(
    data = pred_vs_actual,
    x = ~actual,
    y = ~predicted,
    type = "scatter",
    mode = "markers",
    marker = list(
      color = ~residual,
      colorscale = "YlOrRd",
      colorbar = list(title = "Absolute Error"),
      opacity = 0.6,
      size = 6
    ),
    text = ~paste("Actual:", actual,
                  "<br>Predicted:", round(predicted, 1),
                  "<br>Absolute Error:", round(residual, 1)),
    hoverinfo = "text",
    name = "Predictions"
  ) %>%
  add_trace(
    x = c(axis_min, axis_max),
    y = c(axis_min, axis_max),
    type = "scatter",
    mode = "lines",
    line = list(dash = "dash", color = "gray"),
    showlegend = FALSE,
    hoverinfo = "none"
  ) %>%
  layout(
    title = list(text = "Predicted vs. Actual Bike Trip Counts (Random Forest - Best Model)<br><sup>Colored by Absolute Error</sup>", x = 0.5),
    xaxis = list(title = "Actual Bike Trips"),
    yaxis = list(title = "Predicted Bike Trips"),
    hovermode = "closest"
  )


