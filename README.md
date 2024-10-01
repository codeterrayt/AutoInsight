# AutoInsight

## Project Overview

**AutoInsight** is an automated data analysis tool designed to analyze CSV files containing any number of columns and rows. The tool generates a variety of insights, including summary statistics, correlation analysis, visualizations of distributions, outlier detection, and Principal Component Analysis (PCA). AutoInsight aims to provide a flexible and comprehensive platform for users to quickly understand their data.

## Features

- **Data Loading**: Reads CSV files with an unknown structure.
- **Summary Statistics**: Provides descriptive statistics for each column.
- **Missing Values Handling**: Identifies and imputes missing values using mean for numeric columns and mode for categorical columns.
- **Correlation Analysis**: Computes and visualizes correlations among numeric columns.
- **Visualizations**: Generates histograms, boxplots, and bar plots for a variety of data insights.
- **Outlier Detection**: Identifies outliers using the Interquartile Range (IQR) method.
- **PCA Visualization**: Conducts PCA for dimensionality reduction and visualizes the results.

# OUTPUTS

![image](https://github.com/user-attachments/assets/32df0f6a-9d2c-4142-8a54-664ffc351291)
![image](https://github.com/user-attachments/assets/639a7177-5568-4d02-9dcd-c411aaafccc6)
![image](https://github.com/user-attachments/assets/f5ce319a-0658-4f8c-a415-08fd5c1be2db)
![image](https://github.com/user-attachments/assets/3ddd3e69-9ff5-45f7-8193-832a70b5388f)
![image](https://github.com/user-attachments/assets/ef6d7cde-28e3-4f8c-a1be-6a79a484a6cf)
![image](https://github.com/user-attachments/assets/54aa0a6f-5c27-4b90-a9bf-7774cacb0ef0)
![image](https://github.com/user-attachments/assets/7fb6cc1f-71d3-4dd7-92b9-4d0cc813221d)
![image](https://github.com/user-attachments/assets/ceba74af-e610-4ad4-ab8c-6018b8434afe)
![image](https://github.com/user-attachments/assets/3bea7fa1-5f2f-426b-b1c9-a8cd9786d988)
![image](https://github.com/user-attachments/assets/15e10444-42d4-48c1-8922-2d946b5a5082)





## Installation

To run **AutoInsight**, ensure that R is installed on your system. You will need the following R packages:

```r
install.packages(c("ggplot2", "dplyr", "corrplot", "reshape2", "gridExtra", "FactoMineR", "factoextra"))
```

## Usage

1. **Load Necessary Libraries**: The following libraries are loaded at the beginning of the script:

```r
library(ggplot2)
library(dplyr)
library(corrplot)
library(reshape2)
library(gridExtra)
library(FactoMineR)
library(factoextra)
```

2. **Function Definitions**:
   - **getmode**: A utility function that computes the mode of a vector.
   - **analyze_csv_data**: The main function for performing data analysis.

3. **Function Arguments**:
   - `file_path`: A string that specifies the path to the CSV file to be analyzed.

4. **Example Usage**:

```r
file_path <- "/kaggle/input/data-csv/Housing.csv"  # Replace with your file path
analyze_csv_data(file_path)
```

## Detailed Functionality

### 1. Read CSV Data

The function begins by reading the specified CSV file:

```r
data <- read.csv(file_path, stringsAsFactors = FALSE)
```

### 2. Display Initial Data

It prints the first few rows of the data and displays the data types:

```r
print(head(data))
print("Data Types:")
print(sapply(data, class))
```

### 3. Summary Statistics

The function calculates and prints summary statistics for all columns:

```r
print("Summary Statistics:")
print(summary(data))
```

### 4. Missing Values Analysis

The function checks for missing values and displays the count of missing entries in each column:

```r
print("Missing Values:")
print(colSums(is.na(data)))
```

### 5. Imputation of Missing Values

Numeric columns are imputed with the mean, while categorical columns are filled with the mode:

```r
for (col in numeric_cols) {
    data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
}
for (col in categorical_cols) {
    data[[col]][is.na(data[[col]])] <- as.character(getmode(data[[col]]))
}
```

### 6. Correlation Analysis

The function calculates the correlation matrix for numeric columns and visualizes it using `corrplot` and a heatmap:

```r
correlation_matrix <- cor(numeric_data, use = "pairwise.complete.obs")
corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", addCoef.col = "grey")
heatmap(correlation_matrix, main = "Heatmap of Correlations", col = heat.colors(256), margins = c(10, 10))
```

### 7. Histograms and Boxplots

The function generates histograms and boxplots for each numeric column, arranged in a grid:

```r
ggplot(numeric_data, aes_string(x = col)) +
geom_histogram(...)  # for histograms
ggplot(numeric_data, aes_string(y = col)) +
geom_boxplot(...)    # for boxplots
```

### 8. Pairwise Scatter Plots

If there are multiple numeric columns, it creates pairwise scatter plots:

```r
pairs(numeric_data, main = "Pairwise Plot of Numeric Variables")
```

### 9. Categorical Variables Visualization

The function creates bar plots for categorical variables:

```r
ggplot(data, aes_string(x = col)) +
geom_bar(...)
```

### 10. Outlier Detection

It identifies outliers in numeric columns using the IQR method and prints them:

```r
Q1 <- quantile(numeric_data[[col]], 0.25, na.rm = TRUE)
Q3 <- quantile(numeric_data[[col]], 0.75, na.rm = TRUE)
```

### 11. Principal Component Analysis (PCA)

If applicable, PCA is performed for dimensionality reduction, and the results are visualized:

```r
pca_res <- PCA(numeric_data, graph = FALSE)
fviz_pca_ind(pca_res, ...)
```

## Conclusion

**AutoInsight** offers a robust framework for analyzing CSV data, providing various statistical and visual insights. It can be easily extended with additional features or customized according to user needs. This tool is ideal for anyone looking to automate their data analysis process and gain insights from their datasets quickly.

---
