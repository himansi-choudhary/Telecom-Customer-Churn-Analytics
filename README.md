# Telecom Customer Churn Analysis (Excel · MySQL · Power BI)

## 📌 Business Problem & Objective
Customer churn is one of the biggest revenue leaks in the telecom industry, where acquiring a new customer costs **5–7× more** than retaining an existing one. 

In this end-to-end analytics project, I analyzed **7,043 customer records** from a telecom provider to:
* Quantify overall customer churn and direct monthly revenue at risk.
* Identify the primary behavioral, contractual, and service-level drivers behind cancellations.
* Segment high-risk active customers to recommend targeted, high-ROI retention strategies.

---

## 🛠️ Tech Stack & Workflow
* **Microsoft Excel:** Initial data profiling, missing value imputation, categorical standardization, and duplicate auditing.
* **MySQL 8.0:** Exploratory Data Analysis (EDA), `CASE WHEN` conditional aggregations, revenue loss calculation, and lifecycle tenure bucketing.
* **Power BI:** Custom DAX measures & calculated columns, interactive button slicers, and a 2-page executive dashboard (`Executive Overview` & `Churn Drivers`).

---

## 📂 Repository Structure
* `WA_Fn-UseC_-Telco-Customer-Churn.csv` — Raw dataset (7,043 rows, 21 columns)
* `Telco_Churn_Cleaned.xlsx` — Cleaned Excel workbook
* `Telco_Churn_Cleaned.csv` — Cleaned CSV imported into MySQL
* `churn_queries.sql` — Documented MySQL queries answering key business questions
* `Telco_Churn_Dashboard.pbix` — Interactive 2-page Power BI report
* `dashboard_page1_overview.png` — Dashboard Screenshot: Executive Overview
* `dashboard_page2_drivers.png` — Dashboard Screenshot: Churn Drivers & Actionable List

---

## 🧹 Data Cleaning & Quality Log (Excel)
Before running SQL queries or building visuals, the raw dataset was audited and cleaned:
1. **Missing Value Imputation:** Identified **11 blank spaces** in the `TotalCharges` column. Cross-checking revealed all 11 records had `tenure = 0` (newly onboarded accounts not yet billed). Imputed these blanks with `0` rather than dropping valid customer records.
2. **Readability Standardization:** Converted `SeniorCitizen` values from binary (`0` / `1`) to descriptive labels (`No` — 5,901 records / `Yes` — 1,142 records) for clear dashboard reporting.
3. **Duplicate Audit:** Verified primary key integrity across `customerID` — **0 duplicate records** found across all 7,043 rows.

---

## 🔍 Key Analytical Findings (MySQL & Power BI)

| Metric / Segment | Key Finding | Business Implication |
| :--- | :--- | :--- |
| **Overall Churn & Revenue Loss** | **26.54%** churn rate (1,869 of 7,043 customers) | **$139,130.85** in direct monthly recurring revenue lost. |
| **Contract Type** | Month-to-month: **42.71%** vs. 1-Year: **11.27%** vs. 2-Year: **2.83%** | Month-to-month users churn at **15× the rate** of 2-year contract holders. |
| **Customer Tenure** | `0–1 Year`: **47.44%** vs. `4+ Years`: **9.51%** | **55.5%** of all churned customers (1,037 of 1,869) leave within their first 12 months. |
| **Internet Service** | Fiber optic: **41.89%** ($91.50 avg bill) vs. DSL: **18.96%** ($58.10 avg bill) | High-paying Fiber users leave at more than double the rate of DSL users—pointing to service expectations or quality issues. |
| **Payment Method** | Electronic check: **45.29%** vs. Auto-pay (Bank/Card): **15.24%–16.71%** | Manual payment friction drives nearly **3× higher churn** than automatic payments. |
| **Tech Support Add-On** | Without TechSupport: **41.64%** vs. With TechSupport: **15.17%** | Value-added support services create strong ecosystem stickiness. |

---

## 📊 Power BI Dashboard

### Page 1: Executive Overview
*High-level KPIs (`Total Customers`, `Churned Customers`, `Churn Rate %`, `Monthly Revenue Lost`), interactive button slicers (`InternetService`, `Contract`), overall retention split, and churn breakdowns by contract and payment method.*

![Executive Overview](dashboard_page1_overview.png)

### Page 2: Churn Drivers & Actionable Retention List
*Lifecycle churn trend across `Tenure Group` buckets, impact of `TechSupport`, and a pre-filtered table of active (`Churn = No`) Month-to-month customers for immediate outreach.*

![Churn Drivers](dashboard_page2_drivers.png)

---

## 💡 Strategic Business Recommendations
1. **Contract Migration Campaign (Highest Impact):** Target active Month-to-month subscribers (isolated in Page 2's actionable table) with a **10–15% loyalty discount** to upgrade to a 1-year contract.
2. **Structured 90-Day Onboarding Sequence:** Since nearly half of first-year users churn, introduce proactive check-in calls at **Day 7, Day 30, and Day 90** alongside a 6-month milestone perk.
3. **Auto-Pay Enrollment Incentive:** Offer a one-time **$5–$10 bill credit** to migrate Electronic check users onto automatic bank transfer or credit card billing.
4. **Complimentary 3-Month TechSupport Trial:** Bundle free `TechSupport` for the first 90 days for new Fiber optic customers to improve early satisfaction and product stickiness.

---

## 📬 Contact & Links
* **Author:** Himansi Prakash
* **Tools:** Microsoft Excel · MySQL · Power BI
* **Dataset Source:** [IBM Telco Customer Churn (Kaggle)](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
