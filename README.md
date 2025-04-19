# JSC370 Assignment 5 – Interactive Visualization

This GitHub repository contains my submission for **Assignment 5** of the JSC370 course at the University of Toronto. This assignment explores interactive data visualizations created using RMarkdown, Plotly, and GitHub Pages.

## 🌐 Website

You can view the live website here:  
👉 **[Bike Share & Weather – Interactive Visualization Site](https://christoffertan.github.io/jsc370-a5/)**

---

## 📊 Project Summary

The visualizations are based on my JSC370 final project, which investigates how **weather conditions impact bike share usage in Toronto**. The dataset combines:

- Hourly **weather data** from the [OpenWeather API](https://openweathermap.org/)
- Hourly **bike trip data** from the [Bike Share Toronto Open Data Portal](https://open.toronto.ca/dataset/bike-share-toronto-ridership-data/)

---

## 📁 Repository Structure

- `index.Rmd` — Home page with project description  
- `visuals.Rmd` — Interactive visualizations  
- `merged_data.csv` — Combined and cleaned dataset used for the analysis  
- `data_processing.R` — R script used to preprocess the data  
- `style.css` — Custom styling for the site  
- `footer.html` — HTML footer (includes copyright)
- `_site.yml` — Website configuration  
- `_site/` — Auto-generated website folder (do not edit manually)

---

## 📈 Visualizations

The website includes three interactive visualizations:

1. **Hourly Distribution of Total Bike Trips**  
   Interactive boxplot showing bike usage trends throughout the day.

2. **Feature Importance from Random Forest (Best Model)**  
   A horizontal bar chart highlighting which weather features contribute most to predicting bike trip volume.

3. **Predicted vs. Actual Bike Trip Counts (Random Forest)**  
   A scatter plot comparing model predictions with actual trip counts, colored by absolute prediction error.

---
