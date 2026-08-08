# Indian Ride Sharing Analytics Dashboard

## Overview

This project analyzes ride-sharing booking data to understand customer behavior, booking trends, revenue performance, cancellations, and operational efficiency. The analysis combines Python for data cleaning and exploration, MySQL for business queries, and Power BI for building an interactive dashboard.

The objective was to transform raw booking data into meaningful insights that can help improve business decisions and customer experience.

---

## Business Problem

Ride-sharing companies generate a large volume of booking data every day. Without proper analysis, it becomes difficult to identify revenue trends, understand customer preferences, monitor cancellations, or evaluate operational performance.

This project focuses on answering key business questions such as:

- Which vehicle types generate the highest revenue?
- What are the most popular pickup locations?
- What percentage of bookings are successfully completed?
- Which payment methods are preferred by customers?
- How does revenue change over time?

---

## Dataset

The dataset contains approximately **150,000 ride booking records** with information such as:

- Booking Date & Time
- Booking Status
- Vehicle Type
- Pickup & Drop Location
- Booking Value
- Ride Distance
- Driver Rating
- Customer Rating
- Payment Method
- Cancellation Details

---

## Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- MySQL
- Power BI
- Microsoft Excel

---

## Project Workflow

### 1. Data Cleaning (Python)

The dataset was cleaned using Pandas by:

- Handling missing values
- Removing duplicate records
- Converting data types
- Standardizing column names
- Creating additional columns for analysis

---

### 2. Exploratory Data Analysis

Performed exploratory analysis to identify patterns and trends through visualizations, including:

- Booking status distribution
- Vehicle type analysis
- Revenue trends
- Ride distance analysis
- Payment method distribution
- Pickup and drop location analysis
- Customer and driver rating analysis
- Cancellation trends

A total of **15 exploratory visualizations** were created.

---

### 3. SQL Analysis

Imported the cleaned dataset into MySQL and wrote **30 SQL queries** covering:

- Revenue analysis
- Booking trends
- Vehicle performance
- Payment analysis
- Cancellation analysis
- Window functions
- Common Table Expressions (CTEs)
- Ranking and aggregation

---

### 4. Power BI Dashboard

Built an interactive dashboard featuring:

- KPI Cards
- Revenue Analysis
- Booking Status Distribution
- Revenue by Vehicle Type
- Revenue Trend
- Top Pickup Locations
- Payment Method Analysis
- Interactive Filters and Slicers

---

## Dashboard Preview

<p align="center">
  <img src="Dashboard Images/dashboard.png" width="900">
</p>

---

## Key Insights

- Completed rides account for the majority of total bookings.
- Auto and Go Mini contribute the highest share of total revenue.
- Digital payment methods are preferred over cash.
- Revenue remains relatively stable with moderate day-to-day fluctuations.
- A small number of pickup locations generate a significant share of bookings.

---

## Project Structure

```
Indian-Ride-Sharing-Analytics/
│
├── Dataset/
│   └── ride_cleaned.csv
│
├── Python/
│   ├── Ride_Analytics.ipynb
│   └── EDA Charts/
│
├── SQL/
│   └── ride_analytics_queries.sql
│
├── Power BI/
│   └── Ride_Analytics.pbix
│
├── Dashboard Images/
│   └── dashboard.png
│
└── README.md
```

---

## Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis (EDA)
- Data Visualization
- SQL Query Writing
- Business Intelligence
- Dashboard Design
- Data Storytelling

---

## Future Improvements

Potential enhancements for this project include:

- Geographic mapping of rides
- Customer segmentation
- Revenue forecasting
- Time-series analysis
- Predictive models for ride cancellations

---

## Contact

**Ananya Rawat**

Email: ananyarawat2824@gmail.com

GitHub: https://github.com/Ananya3283
