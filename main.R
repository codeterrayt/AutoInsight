# Load necessary libraries
library(ggplot2)
library(dplyr)
library(corrplot)
library(reshape2)
library(gridExtra)      # For arranging multiple plots
library(FactoMineR)     # For PCA
library(factoextra)      # For visualizing PCA results

# Function to get mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Function to analyze CSV data
analyze_csv_data <- function(file_path) {
  # Read the CSV file
  data <- read.csv(file_path, stringsAsFactors = FALSE)
  
  # Display the first few rows of the data
  print(head(data))
  
  # Display data types
  print("Data Types:")
  print(sapply(data, class))
  
  # Summary statistics
  print("Summary Statistics:")
  print(summary(data))
  
  # Check for missing values
  print("Missing Values:")
  print(colSums(is.na(data)))

  # Imputation of missing values (mean for numeric, mode for categorical)
  numeric_cols <- names(data)[sapply(data, is.numeric)]
  for (col in numeric_cols) {
    data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
  }
  
  categorical_cols <- names(data)[sapply(data, is.character)]
  for (col in categorical_cols) {
    data[[col]][is.na(data[[col]])] <- as.character(getmode(data[[col]]))
  }
  
  # Correlation analysis for numeric columns only
  numeric_data <- data %>% select_if(is.numeric)
  if (ncol(numeric_data) > 1) {
    correlation_matrix <- cor(numeric_data, use = "pairwise.complete.obs")
    
    # Display the correlation matrix
    print("Correlation Matrix:")
    print(correlation_matrix)
    
    # Plot the correlation matrix
    corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", addCoef.col = "grey")
    
    # Heatmap
    heatmap(correlation_matrix, main = "Heatmap of Correlations", col = heat.colors(256), margins = c(10, 10))
  } else {
    print("Not enough numeric columns for correlation analysis.")
  }

  # Generate histograms for numeric columns
  numeric_cols <- names(numeric_data)
  plot_list <- list()
  for (col in numeric_cols) {
    plot_list[[col]] <- ggplot(numeric_data, aes_string(x = col)) +
      geom_histogram(binwidth = (max(numeric_data[[col]], na.rm = TRUE) - min(numeric_data[[col]], na.rm = TRUE)) / 30, fill = "blue", color = "black") +
      labs(title = paste("Histogram of", col), x = col, y = "Frequency") +
      theme_minimal()
  }
  
  # Arrange histogram plots in a grid
  grid.arrange(grobs = plot_list, ncol = 2)

  # Generate boxplots for numeric columns
  plot_list <- list()
  for (col in numeric_cols) {
    plot_list[[col]] <- ggplot(numeric_data, aes_string(y = col)) +
      geom_boxplot(fill = "lightblue") +
      labs(title = paste("Boxplot of", col), y = col) +
      theme_minimal()
  }

  # Arrange boxplot plots in a grid
  grid.arrange(grobs = plot_list, ncol = 2)

  # Generate pairwise scatter plots for numeric columns
  if (ncol(numeric_data) > 1) {
    pairs(numeric_data, main = "Pairwise Plot of Numeric Variables")
  }

  # Visualize categorical variables
  for (col in categorical_cols) {
    ggplot(data, aes_string(x = col)) +
      geom_bar(fill = "orange") +
      labs(title = paste("Bar Plot of", col), x = col, y = "Count") +
      theme_minimal()
  }

  # Outlier detection using IQR
  for (col in numeric_cols) {
    Q1 <- quantile(numeric_data[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(numeric_data[[col]], 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    outliers <- numeric_data[[col]][numeric_data[[col]] < (Q1 - 1.5 * IQR) | numeric_data[[col]] > (Q3 + 1.5 * IQR)]
    print(paste("Outliers in", col, ":"))
    print(outliers)
  }

  # PCA for dimensionality reduction and visualization
  if (ncol(numeric_data) > 1) {
    pca_res <- PCA(numeric_data, graph = FALSE)
    # Plot PCA
    fviz_pca_ind(pca_res, 
                  geom.ind = "point", 
                  col.ind = "cos2", 
                  gradient.cols = c("blue", "yellow", "red"), 
                  title = "PCA - Individuals")
  }
}

# Example usage
file_path <- "/kaggle/input/data-csv/Housing.csv"  # Replace with your file path
analyze_csv_data(file_path)
