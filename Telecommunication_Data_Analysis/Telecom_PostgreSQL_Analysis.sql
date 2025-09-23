-- Telecom PostgreSQL Analysis--
SELECT * FROM telecom_data;

/* Drop duplicates */
DELETE FROM telecom_data a
USING telecom_data b
WHERE a."customerID" = b."customerID"
  AND a.ctid > b.ctid;



/* Total customers */
SELECT COUNT(*) AS total_customers
FROM telecom_data;

/* Churn distribution */
SELECT "Churn", COUNT(*) AS churn_count
FROM telecom_data
GROUP BY "Churn";

/* Gender distribution */
SELECT "gender", COUNT(*) AS gender_count
FROM telecom_data
GROUP BY "gender";

/* Senior Citizen percentage */
SELECT ROUND(100.0 * SUM(CASE WHEN "SeniorCitizen"=1 THEN 1 ELSE 0 END)/COUNT(*),2) AS senior_percent
FROM telecom_data;

/* Partner distribution */
SELECT "Partner", COUNT(*) AS partner_count
FROM telecom_data
GROUP BY "Partner";


/* Average tenure by contract type */
SELECT "Contract", ROUND(AVG("tenure"),2) AS avg_tenure
FROM telecom_data
GROUP BY "Contract";

/* Distribution of Payment Methods */
SELECT "PaymentMethod", COUNT(*) AS payment_count
FROM telecom_data
GROUP BY "PaymentMethod"
ORDER BY payment_count DESC;

/* Churn by Contract type */
SELECT "Contract", "Churn", COUNT(*) AS count
FROM telecom_data
GROUP BY "Contract", "Churn"
ORDER BY "Contract";

/* Tenure group distribution */
SELECT CASE
         WHEN "tenure" BETWEEN 0 AND 12 THEN '0-12 months'
         WHEN "tenure" BETWEEN 13 AND 24 THEN '13-24 months'
         WHEN "tenure" BETWEEN 25 AND 48 THEN '25-48 months'
         ELSE '49+ months'
       END AS tenure_group,
       COUNT(*) AS customer_count
FROM telecom_data
GROUP BY tenure_group
ORDER BY customer_count DESC;

/* Outlier detection (MonthlyCharges IQR) */
WITH stats AS (
  SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY "MonthlyCharges") AS Q1,
         percentile_cont(0.75) WITHIN GROUP (ORDER BY "MonthlyCharges") AS Q3
  FROM telecom_data
)
SELECT t."customerID", t."MonthlyCharges"
FROM telecom_data t, stats s
WHERE t."MonthlyCharges" < (s.Q1 - 1.5*(s.Q3-s.Q1))
   OR t."MonthlyCharges" > (s.Q3 + 1.5*(s.Q3-s.Q1));

/* Correlation: tenure vs MonthlyCharges */
SELECT corr("tenure", "MonthlyCharges") AS corr_tenure_monthly
FROM telecom_data;

/*  Churn vs InternetService */
SELECT "Churn", "InternetService", COUNT(*) AS count
FROM telecom_data
GROUP BY "Churn", "InternetService"
ORDER BY "Churn";


/* Avg of monthly and total charges */
SELECT ROUND(AVG("MonthlyCharges")::NUMERIC, 2) AS avg_monthly,
       ROUND(AVG(NULLIF("TotalCharges", ' ')::NUMERIC), 2) AS avg_total
FROM telecom_data;


