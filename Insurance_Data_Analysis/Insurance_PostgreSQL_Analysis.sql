---Insurance postgreSQL Analysis---

SELECT * FROM insurance_data;


/* Deleting duplicates */
DELETE FROM insurance_data a
USING insurance_data b
WHERE a.ctid < b.ctid
  AND a.policy_number = b.policy_number;


/* Average claim amount by fraud reported */
SELECT 
    fraud_reported, 
    AVG(total_claim_amount) AS avg_claim
FROM insurance_data
GROUP BY fraud_reported;


/* Average claim amount by gender */
SELECT 
    insured_sex,
    AVG(total_claim_amount) AS avg_claim,
    COUNT(*) AS total_claims
FROM insurance_data
GROUP BY insured_sex
ORDER BY avg_claim DESC;



/* Maximum claim amount by auto model */
SELECT 
    auto_model, 
    MAX(total_claim_amount) AS max_claim
FROM insurance_data
GROUP BY auto_model
ORDER BY max_claim DESC
LIMIT 10;



/* Total number of claims by auto make */
SELECT 
    auto_make, 
    COUNT(*) AS total_claims, 
    SUM(total_claim_amount) AS total_claim_value
FROM insurance_data
GROUP BY auto_make
ORDER BY total_claim_value DESC;


/*Rank customers by total claim amount */
SELECT 
    months_as_customer,
    total_claim_amount,
    RANK() OVER (ORDER BY total_claim_amount DESC) AS claim_rank
FROM insurance_data;



/* Fraud percentage by policy state */
SELECT 
    policy_state,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN fraud_reported='Y' THEN 1 ELSE 0 END) AS fraud_claims,
    ROUND(SUM(CASE WHEN fraud_reported='Y' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS fraud_percentage
FROM insurance_data
GROUP BY policy_state
ORDER BY fraud_percentage DESC;



/* Total claims per policy state */
SELECT 
    policy_state, 
    COUNT(*) AS total_claims, 
    SUM(total_claim_amount) AS total_claim_amount
FROM insurance_data
GROUP BY policy_state
ORDER BY total_claim_amount DESC;



/* Count of claims per claim type */
SELECT 
    SUM(injury_claim) AS injury_total,
    SUM(property_claim) AS property_total,
    SUM(vehicle_claim) AS vehicle_total
FROM insurance_data;


/* Top 10 incident types by total claim amount */
SELECT 
    incident_type,
    COUNT(*) AS total_claims,
    SUM(total_claim_amount) AS total_claim_amount
FROM insurance_data
GROUP BY incident_type
ORDER BY total_claim_amount DESC
LIMIT 10;



/* Fraud percentage by policy type */
SELECT 
    policy_state,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN fraud_reported='Y' THEN 1 ELSE 0 END) AS fraud_claims,
    ROUND(SUM(CASE WHEN fraud_reported='Y' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS fraud_percentage
FROM insurance_data
GROUP BY policy_state
ORDER BY fraud_percentage DESC;



/* Fraud count by auto make*/
SELECT 
    auto_make, 
    COUNT(*) AS fraud_claims
FROM insurance_data
WHERE fraud_reported='Y'
GROUP BY auto_make
ORDER BY fraud_claims DESC;


/* Correlation between different claim types */
SELECT 
    CORR(injury_claim, property_claim) AS corr_injury_property,
    CORR(injury_claim, vehicle_claim) AS corr_injury_vehicle,
    CORR(property_claim, vehicle_claim) AS corr_property_vehicle
FROM insurance_data;


/* Claims with unusually high amounts (outliers) */
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_claim_amount) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_claim_amount) AS Q3
    FROM insurance_data
)
SELECT *
FROM insurance_data, stats
WHERE total_claim_amount < Q1 - 1.5 * (Q3 - Q1)
   OR total_claim_amount > Q3 + 1.5 * (Q3 - Q1);



/* total claim amount by policy deductible range */
SELECT 
    CASE 
        WHEN policy_deductable <= 500 THEN 'Low'
        WHEN policy_deductable <= 1000 THEN 'Medium'
        ELSE 'High'
    END AS deductable_range,
    COUNT(*) AS total_claims,
    SUM(total_claim_amount) AS total_claim_amount
FROM insurance_data
GROUP BY deductable_range
ORDER BY total_claim_amount DESC;




















