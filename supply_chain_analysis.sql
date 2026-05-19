USE supply_chain_db;

-- Query 1: Defect Rate by Product Type
SELECT 
    `Product type`,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate,
    COUNT(*) AS total_products,
    SUM(CASE WHEN `Inspection results` = 'Fail' THEN 1 ELSE 0 END) AS failed_inspections,
    SUM(CASE WHEN `Inspection results` = 'Pass' THEN 1 ELSE 0 END) AS passed_inspections
FROM supply_chain_data2
GROUP BY `Product type`
ORDER BY avg_defect_rate DESC;

-- Query 2: Supplier Quality Ranking
SELECT 
    `Supplier name`,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate,
    COUNT(*) AS total_products,
    SUM(CASE WHEN `Inspection results` = 'Fail' THEN 1 ELSE 0 END) AS failed_inspections,
    ROUND((SUM(CASE WHEN `Inspection results` = 'Fail' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) AS failure_rate_pct
FROM supply_chain_data2
GROUP BY `Supplier name`
ORDER BY avg_defect_rate DESC;

-- Query 3: Stock Risk Analysis
SELECT 
    `Product type`,
    `Supplier name`,
    ROUND(AVG(`Stock levels`), 0) AS avg_stock,
    ROUND(AVG(`Lead times`), 0) AS avg_lead_time,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate,
    CASE 
        WHEN AVG(`Stock levels`) < 20 AND AVG(`Defect rates`) > 2 THEN 'HIGH RISK'
        WHEN AVG(`Stock levels`) < 40 AND AVG(`Defect rates`) > 1.5 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_level
FROM supply_chain_data2
GROUP BY `Product type`, `Supplier name`
ORDER BY avg_defect_rate DESC;

-- Query 4: Transportation Mode Impact on Defects
SELECT 
    `Transportation modes`,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate,
    COUNT(*) AS total_shipments,
    ROUND(AVG(`Shipping costs`), 2) AS avg_shipping_cost,
    SUM(CASE WHEN `Inspection results` = 'Fail' THEN 1 ELSE 0 END) AS failed_inspections
FROM supply_chain_data2
GROUP BY `Transportation modes`
ORDER BY avg_defect_rate DESC;

-- Query 5: Revenue vs Defect Analysis by Product Type
SELECT 
    `Product type`,
    ROUND(SUM(`Revenue generated`), 0) AS total_revenue,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate,
    ROUND(AVG(`Order quantities`), 0) AS avg_order_qty,
    ROUND(SUM(`Revenue generated`) / COUNT(*), 0) AS revenue_per_product,
    SUM(CASE WHEN `Inspection results` = 'Fail' THEN 1 ELSE 0 END) AS total_failures
FROM supply_chain_data2
GROUP BY `Product type`
ORDER BY total_revenue DESC;

-- Query 6: Revenue at Risk by Supplier
SELECT 
    `Supplier name`,
    ROUND(SUM(`Revenue generated`), 0) AS total_revenue,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate_pct,
    ROUND(SUM(`Revenue generated` * (`Defect rates` / 100)), 0) AS revenue_at_risk,
    ROUND((SUM(`Revenue generated` * (`Defect rates` / 100)) / SUM(`Revenue generated`)) * 100, 1) AS pct_revenue_at_risk
FROM supply_chain_data2
GROUP BY `Supplier name`
ORDER BY revenue_at_risk DESC;

-- Query 7: Revenue at Risk by Transport Mode
SELECT 
    `Transportation modes`,
    COUNT(*) AS total_shipments,
    ROUND(AVG(`Defect rates`), 2) AS avg_defect_rate_pct,
    ROUND(SUM(`Revenue generated`), 0) AS total_revenue,
    ROUND(SUM(`Revenue generated` * (`Defect rates` / 100)), 0) AS revenue_at_risk
FROM supply_chain_data2
GROUP BY `Transportation modes`
ORDER BY revenue_at_risk DESC;

-- Query 8: Corrective Action Priority Table
-- This is what you hand to an ops manager
SELECT 
    `Product type`,
    `Supplier name`,
    ROUND(AVG(`Defect rates`), 2) AS defect_rate_pct,
    ROUND(SUM(`Revenue generated`), 0) AS total_revenue,
    ROUND(SUM(`Revenue generated` * (`Defect rates` / 100)), 0) AS revenue_at_risk,
    CASE 
        WHEN AVG(`Defect rates`) >= 3 THEN 'CRITICAL'
        WHEN AVG(`Defect rates`) >= 2 THEN 'HIGH'
        WHEN AVG(`Defect rates`) >= 1 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS priority,
    CASE
        WHEN AVG(`Defect rates`) >= 3 THEN 'Immediate CAP + supplier audit + incoming inspection gate'
        WHEN AVG(`Defect rates`) >= 2 THEN 'Increase cycle count frequency on this SKU range'
        WHEN AVG(`Defect rates`) >= 1 THEN 'Flag for next ops review'
        ELSE 'Standard process — monitor only'
    END AS recommended_action
FROM supply_chain_data2
GROUP BY `Product type`, `Supplier name`
ORDER BY revenue_at_risk DESC;
