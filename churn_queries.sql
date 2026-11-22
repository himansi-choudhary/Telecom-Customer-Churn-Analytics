-- ============================================================================
-- PROJECT: Telecom Customer Churn Analysis
-- AUTHOR: Himansi Choudhary (GitHub: himansi-choudhary)
-- DATABASE: MySQL 8.0
-- DATA IMPORT NOTE: Cleaned CSV (7,043 rows, 21 columns) imported via MySQL
--                   Workbench Table Data Import Wizard into `telco_churn_cleaned`.
-- ============================================================================

-- 1. Database Setup & Row Count Verification
CREATE DATABASE IF NOT EXISTS churn_project;
USE churn_project;

SELECT COUNT(*) AS total_records FROM telco_churn_cleaned;


-- 2. Overall Churn Rate & Snapshot Monthly Recurring Revenue (MRR) Impact
-- Business Question: What percentage of accounts are flagged churned, and how much MRR is tied to them?
SELECT 
    Churn,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn_cleaned), 2) AS churn_percentage,
    ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue
FROM telco_churn_cleaned
GROUP BY Churn;


-- 3. Churn Rate & Revenue Loss Concentration by Contract Type (Window Function)
-- Business Question: Which contract type drives the highest churn rate and share of total lost MRR?
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 100.0 /
        SUM(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)) OVER (), 
    2) AS pct_of_total_mrr_loss
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
-- Business Question: Which payment method is most strongly associated with customer churn?
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- 6. Churn Rate by Tech Support Add-On
-- Business Question: How does churn differ between customers with and without Tech Support?
SELECT 
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
GROUP BY TechSupport
ORDER BY churn_rate_pct DESC;


-- 7. Multi-Variable Confounder Check: Contract Type x Tech Support
-- Business Question: Does the Tech Support churn gap hold within each contract type (excluding no-internet users)?
SELECT 
    Contract,
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM telco_churn_cleaned
WHERE InternetService <> 'No'
GROUP BY Contract, TechSupport
ORDER BY Contract, churn_rate_pct DESC;


-- 8. Churn Rate by Customer Tenure Lifecycle (Chronological Bucketing)
-- Business Question: How does churn evolve across customer tenure stages?
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
ORDER BY MIN(tenure);


-- 9. Retention Target Segment: Active Month-to-Month Subscribers
-- Business Question: How many active Month-to-month accounts exist, and what is their total and average MRR?
SELECT 
    COUNT(*) AS active_m2m_customers,
    ROUND(SUM(MonthlyCharges), 2) AS segment_mrr,
    ROUND(AVG(MonthlyCharges), 2) AS avg_bill
FROM telco_churn_cleaned
WHERE Churn = 'No' AND Contract = 'Month-to-month';
