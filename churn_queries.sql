-- ============================================================================
-- PROJECT: Telecom Customer Churn Analysis
-- AUTHOR: Himansi Prakash
-- DATABASE: MySQL 8.0
-- ============================================================================

-- 1. Database Setup & Row Count Verification
CREATE DATABASE IF NOT EXISTS churn_project;
USE churn_project;

SELECT COUNT(*) AS total_records FROM telco_churn_cleaned;


-- 2. Overall Churn Rate & Direct Monthly Revenue Lost
-- Business Question: What percentage of customers churned, and how much monthly revenue is lost?
SELECT 
    Churn,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn_cleaned), 2) AS churn_percentage,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue
FROM telco_churn_cleaned
GROUP BY Churn;


-- 3. Churn Rate by Contract Type
-- Business Question: Which contract type has the highest churn rate?
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- 4. Churn Rate by Internet Service Type
-- Business Question: Are Fiber Optic users churning more despite paying higher monthly bills?
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_bill
FROM telco_churn_cleaned
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- 5. Churn Rate by Payment Method
-- Business Question: Which payment method correlates most strongly with customer churn?
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- 6. Churn Rate by Customer Tenure Lifecycle (Data Bucketing)
-- Business Question: In which tenure window are customers most likely to leave?
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-1 Year'
        WHEN tenure <= 24 THEN '1-2 Years'
        WHEN tenure <= 48 THEN '2-4 Years'
        ELSE '4+ Years'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;