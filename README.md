# FC Supply Chain Quality Analytics Dashboard

## Overview
End-to-end supply chain quality analysis built to replicate ICQA analyst workflows in Amazon fulfilment centres. Analyses defect patterns, root cause distribution, supplier performance, and transportation impact using SQL and Power BI.

## Tools Used
- MySQL — data storage and query design
- Power BI — interactive dashboard
- HTML/Chart.js — web-based dashboard
- Dataset: [Supply Chain Analysis — Kaggle](https://www.kaggle.com/datasets/harshsingh2209/supply-chain-analysis)

## Key Findings
- Haircare has the highest average defect rate (2.48%) across all product types
- Supplier 4 has the worst failure rate at 66.7% — highest priority for quality review
- Road transport produces 44% higher defect rates than air despite lower shipping cost
- Skincare generates the highest revenue (£241,628) but carries elevated defect risk
- Cosmetics/Supplier 3 combination has the highest defect rate at 3.87%

## Files
| File | Description |
|------|-------------|
| `supply_chain_analysis.sql` | 5 SQL queries covering defect analysis, supplier ranking, stock risk, transport impact, revenue vs defects |
| `index.html` | Interactive web dashboard — open in any browser |
| `power bi.pbix` | Power BI dashboard with slicer filtering by product type |
| `supply_chain_data2.csv` | Cleaned dataset used for analysis |
| `dashboard_screenshot.png` | Power BI dashboard preview |

## Dashboard Preview
![Dashboard](dashboard_screenshot.png)

## SQL Queries Covered
1. Defect rate by product type
2. Supplier quality ranking with failure rate %
3. Stock risk analysis — HIGH / MEDIUM / LOW classification
4. Transportation mode impact on defect rates
5. Revenue vs defect rate by product type
