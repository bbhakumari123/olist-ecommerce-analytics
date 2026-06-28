# 🛒 Olist E-Commerce Analytics
### End-to-End Data Analysis Portfolio Project | MySQL · Python · Power BI

![Dashboard Preview](https://github.com/bbhakumari123/olist-ecommerce-analytics/blob/ce7465c215bbde2b85d08d88e1c7fc1fe874760e/Olist_analytics/Screenshot/Revenue_overview.png)



## 🔗 Live Dashboard
[![Power BI Dashboard](https://img.shields.io/badge/Power%20BI-View%20Live%20Dashboard-F2C811?style=for-the-badge&logo=powerbi)](https://app.powerbi.com/groups/me/reports/c46a591d-5265-4230-8b83-45feecbe50f6/a312b5a821dc05ac6107?experience=power-bi)

---

## 📌 Project Overview

This project performs a full end-to-end analysis of **99,441 real orders** from **Olist**, Brazil's largest e-commerce marketplace, covering the period **2016 to 2018**.

The goal was to simulate a real analyst workflow — from raw data ingestion and quality auditing, through SQL business analysis and Python statistical testing, to an executive-ready Power BI dashboard with actionable recommendations.

> **This is not a tutorial follow-along. Every query, every statistical test, and every dashboard visual was built to answer a specific business question.**

---

## 🗂️ Dataset

**Source:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

| Table | Rows | Description |
|-------|------|-------------|
| orders | 99,441 | Core order lifecycle and status |
| order_items | 112,650 | Products within each order |
| order_payments | 103,886 | Payment methods and values |
| order_reviews | 99,224 | Customer review scores and comments |
| customers | 99,441 | Customer location data |
| sellers | 3,095 | Seller location and identifiers |
| products | 32,951 | Product catalog with dimensions |
| geolocation | 1,000,163 | Brazilian zip code coordinates |
| category_translation | 71 | Portuguese to English category names |

---

## 🔧 Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.12 | Data loading, cleaning, statistical analysis |
| MySQL | 8.0 | Database storage and SQL business queries |
| Power BI Desktop | Latest | Interactive dashboard and DAX measures |
| pandas | Latest | Data manipulation and joining |
| scipy | Latest | Statistical tests — Pearson, Mann-Whitney U |
| SQLAlchemy + pymysql | Latest | Python-MySQL connection |
| Jupyter Notebook | Latest | Analysis and documentation |

---

## 🔍 Business Questions Answered

1. Which product categories drive 80% of revenue? *(Pareto Analysis)*
2. How does late delivery impact customer review scores? *(Statistical Testing)*
3. Which Brazilian states are the most and least profitable delivery zones?
4. Which payment methods correlate with higher order values?
5. Which sellers are underperforming on both revenue and satisfaction?
6. What is the freight cost burden by product category?
7. What are the revenue seasonality patterns across 2016-2018?
8. Which cities generate the most order volume?

---

## 📊 Key Findings

| # | Finding | Metric |
|---|---------|--------|
| 1 | **Revenue concentration** | 18 of 71 categories drive 80% of R$13.59M total revenue |
| 2 | **Delivery destroys satisfaction** | Late deliveries drop avg review score from 4.21 → 2.25 — a 47% decrease |
| 3 | **Geographic inequality** | SP generates R$4.37M net revenue vs RR at R$5,075 — an 860x difference |
| 4 | **Credit card dominance** | 76.92% of all orders paid by credit card |
| 5 | **Seller risk concentration** | 51 sellers flagged as statistical satisfaction outliers via z-score |
| 6 | **Freight margin pressure** | Home comfort categories spend 54-93% of revenue on shipping |
| 7 | **Platform growth** | 21.2% revenue growth from 2017 to 2018 — R$6.03M to R$7.31M |
| 8 | **Delivery time gap** | SP receives orders in 8.7 days — northern states wait 28+ days |

---

## 🔬 Statistical Analysis Results

### A1 — Pearson Correlation: Delivery Delay vs Review Score
```
Correlation:  r = -0.2284
P-value:      p < 0.0001
R-squared:    r² = 0.052 (delivery delay explains 5.2% of score variance)
Sample size:  114,861 orders
Result:       Statistically significant — delivery delay proven to reduce scores
```

> **Note:** While statistically significant, the moderate effect size (r² = 0.052) indicates that delivery delay is one of several drivers of customer dissatisfaction — product quality and seller performance also contribute meaningfully.

| Delivery Timing | Avg Review Score | Order Count |
|----------------|-----------------|-------------|
| Very Early (10+ days early) | 4.23 | 74,379 |
| On Time | 4.16 | 33,114 |
| Slight Delay (1-5 days) | 2.94 | 3,159 |
| Moderate Delay (6-10 days) | 1.77 | 1,874 |
| Severe Delay (10+ days) | 1.71 | 2,335 |

### A2 — Freight Cost Distribution
```
Mean freight as % of item price:    32.21%
Median freight as % of item price:  23.25%
Standard deviation:                 34.82%
Range:                              0% to 2,623%
```

### A3 — Mann-Whitney U Test: On Time vs Late Deliveries
```
H0: No difference in review scores between delivery groups
H1: Late deliveries produce lower review scores

On Time mean score:      4.206  (n = 107,493)
Late mean score:         2.253  (n = 7,368)
Not Delivered mean:      1.755  (n = 2,471)

On Time vs Late:         U = 639,634,166  p < 0.0001  ✅ Reject H0
Late vs Not Delivered:   U = 10,670,024   p < 0.0001  ✅ Reject H0
```

### A4 — Revenue Seasonality
```
Peak months:     May, July, August (10,000+ orders/month)
Black Friday:    November 2017 spike — R$1.03M in single month
Peak order days: Monday (15,701 orders) — Saturday lowest (10,555)
Peak hours:      4PM, 11AM, 2PM, 1PM, 3PM
```

### A5 — Seller Outlier Detection (Z-Score Analysis)
```
Total active sellers (10+ orders): 1,238
High revenue outliers (z > 2):     34 sellers — top seller R$239,791
Low satisfaction outliers (z < -2): 51 sellers — worst scorer 1.93/5
```

---

## 📁 Repository Structure

```
olist-ecommerce-analysis/
│
├── README.md
│
├── sql/
│   ├── phase3_core_queries.sql         # Q1–Q6: Revenue, delivery, sellers, payments
│   └── phase3_supporting_queries.sql   # Q7–Q12: Trends, cities, distribution
│
├── python/
│   ├── 01_data_loading.ipynb   # Data ingestion and MySQL loading
│   ├── 02_data_quality.ipynb       # Null audit, deduplication, geolocation fix
│   └── 03_statistical_analysis.ipynb     # Correlation, hypothesis testing, outliers
│
├── screenshots/
│       ├── db1_revenue_overview.png
│       ├── db2_delivery_satisfaction.png
│       └── db3_insights_recommendations.png
        └── schema.png
```

---

## 🗄️ Database Schema

![Power BI Star Schema](dashboard/screenshots/schema.png)

**Key data engineering decisions:**
- Geolocation deduplicated from 1,000,163 → 19,015 rows (98.1% reduction) to prevent row multiplication on joins
- 610 NULL product categories labeled as 'uncategorized' to prevent revenue leakage in analysis
- 2 missing Portuguese category translations added manually to category_translation table
- Master orders table built in Python (118,310 rows, 43 columns) for SQL analysis — star schema used in Power BI for clean DAX measures

---

## 📈 Dashboard

### Page 1 — Revenue Overview
*Answers: How is the business performing?*

![Revenue Overview](https://github.com/bbhakumari123/olist-ecommerce-analytics/blob/ce7465c215bbde2b85d08d88e1c7fc1fe874760e/Olist_analytics/Screenshot/Revenue_overview.png)

**KPIs:** Total Orders · Total Revenue · Avg Order Value · On Time Delivery Rate · Freight % of Revenue

**Visuals:** Monthly revenue trend (2016-2018) · Top 10 categories by revenue · Revenue by state · Orders by payment method

---

### Page 2 — Delivery & Customer Satisfaction
*Answers: Why are customers unhappy?*

![Delivery & Satisfaction](dashboard/screenshots/db2_delivery_satisfaction.png)

**KPIs:** Avg Review Score · Late Delivery Rate · On Time Delivery Rate · Bad Review Rate · Not Delivered Rate

**Visuals:** Avg delivery days by state · Delivery delay vs review score scatter plot · Avg review score by delivery status · Review score distribution · Delivery status breakdown

---

### Page 3 — Insights & Recommendations
*Answers: What should the business do next?*

![Insights & Recommendations](dashboard/screenshots/db3_insights_recommendations.png)

**KPIs:** Total Active Sellers · Avg Seller Revenue · Underperforming Sellers · 2017→2018 Revenue Growth

**Visuals:** Seller revenue vs satisfaction scatter plot · Top 10 categories by freight burden · Review score by delivery delay bucket · Top 10 cities by order volume · Key recommendations text

---

## 💡 Business Recommendations

### 1. 🚚 Logistics Priority — Highest ROI Action
Reducing late deliveries from **8% to 4%** would push average platform review score from **4.09 toward 4.5+**, directly improving customer retention. The Mann-Whitney U test (p < 0.0001) confirms this is not random — delivery performance has a proven causal relationship with satisfaction.

### 2. 📦 Category Strategy — Focus Investment
**18 categories drive 80% of revenue.** Concentrate marketing, inventory, and logistics investment here. The bottom 16 categories each contribute less than 0.05% of revenue — deprioritize or sunset these.

### 3. 👥 Seller Management — Reduce Platform Risk
**51 sellers** are statistical satisfaction outliers (z-score < -2), all scoring below 2.7 stars. The worst performer scores **1.93/5** with 71% bad review rate. Implement minimum satisfaction thresholds with mandatory performance review.

### 4. 🗺️ Regional Expansion — Fix the North
Northern states (RR, AP, AM) wait **28+ days** for delivery and carry **24-28% freight burden** as % of revenue — nearly double SP's 13.85%. Dedicated regional logistics partnerships are required for northern expansion to be profitable.

### 5. 📈 Sustain Growth Momentum
**21.2% YoY revenue growth** (R$6.03M → R$7.31M) confirms platform maturity. Focus now shifts from acquisition to **retention** — improving delivery performance is the single lever most likely to increase repeat purchase rate.

---

## 📋 SQL Query Index

### Core Queries (phase3_core_queries.sql)
| Query | Business Question |
|-------|-----------------|
| Q1 | Which categories drive 80% of revenue? — Pareto with window functions |
| Q2 | Which states are most/least profitable? — Freight % vs net revenue |
| Q3 | Which sellers underperform on revenue AND satisfaction? |
| Q4 | How does late delivery impact review scores? |
| Q5 | Which payment methods correlate with higher order values? |
| Q6 | Which categories have the highest freight burden? |

### Supporting Queries (phase3_supporting_queries.sql)
| Query | Business Question |
|-------|-----------------|
| Q7 | Monthly revenue trend 2016-2018 |
| Q8 | Order status breakdown — full fulfillment picture |
| Q9 | Average delivery time by state |
| Q10 | Top 15 cities by order volume |
| Q11 | Review score distribution |
| Q12 | Average basket size by payment method |

---

## 🎯 Skills Demonstrated

| Skill | Evidence |
|-------|---------|
| Data Engineering | 9 CSV files loaded into MySQL via Python, master table built with chunked bulk insert |
| Data Quality | Null audit, deduplication, referential integrity checks, missing translation fixes |
| SQL | Window functions, CTEs, CASE statements, multi-table joins, subqueries |
| Statistical Analysis | Pearson correlation, Mann-Whitney U hypothesis testing, z-score outlier detection |
| Data Modeling | Star schema design in Power BI, DAX measures with TREATAS for indirect relationships |
| Business Communication | Every query and analysis has a plain-English business insight |
| Dashboard Design | 3-page narrative arc — What happened → Why → What to do |

---

---

## 👩‍💻 About This Project

I built this project to demonstrate end-to-end data analytics capability — not just Python or just SQL, but the full pipeline a working analyst would actually follow: understanding the data, cleaning it properly, testing assumptions statistically, answering business questions in SQL, and presenting findings in a way a non-technical stakeholder can act on.

Every decision in this project — the statistical test chosen, the geolocation deduplication approach, the star schema over a flat master table in Power BI, the TREATAS DAX for indirect relationships — was made deliberately. The database schema and SQL query index above document the reasoning.

This project reflects the kind of work I want to do professionally: structured, rigorous, and always connected back to a question worth answering.

Connect with me on [LinkedIn](https://www.linkedin.com/in/bibha-kumari-7539ab247/)

Dataset: [Kaggle — Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

*🔗 [View Live Dashboard](https://app.powerbi.com/groups/me/reports/c46a591d-5265-4230-8b83-45feecbe50f6/a312b5a821dc05ac6107?experience=power-bi)*
