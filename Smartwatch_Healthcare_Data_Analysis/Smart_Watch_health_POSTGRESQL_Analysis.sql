SELECT * FROM smartwatch_health_data;

/* Preview the first 10 rows */
SELECT * FROM smartwatch_health_data LIMIT 10;

/* Count total rows */
SELECT COUNT(*) AS total_records FROM smartwatch_health_data;

/* Count distinct users */
SELECT COUNT(DISTINCT "User ID") AS unique_users FROM smartwatch_health_data;

/* Average step count per user */
SELECT "User ID", AVG("Step Count") AS avg_steps
FROM smartwatch_health_data
GROUP BY "User ID"
ORDER BY avg_steps DESC;

/* Maximum heart rate per user */
SELECT "User ID", MAX("Heart Rate (BPM)") AS max_hr
FROM smartwatch_health_data
GROUP BY "User ID"
ORDER BY max_hr DESC;

/* Minimum sleep hours per user */
SELECT "User ID", MIN("Sleep Duration (hours)") AS min_sleep
FROM smartwatch_health_data
GROUP BY "User ID"
ORDER BY min_sleep ASC;

/* Average stress level per activity level */
SELECT "Activity Level", AVG("Stress Level") AS avg_stress
FROM smartwatch_health_data
GROUP BY "Activity Level";

/* Users with average step count below 5,000 */
SELECT "User ID", AVG("Step Count") AS avg_steps
FROM smartwatch_health_data
GROUP BY "User ID"
HAVING AVG("Step Count") < 5000;

/* Correlation proxy between heart rate and stress (using covariance/variance) */
SELECT
    (AVG("Heart Rate (BPM)" * "Stress Level") - AVG("Heart Rate (BPM)") * AVG("Stress Level")) /
    (STDDEV("Heart Rate (BPM)") * STDDEV("Stress Level")) AS correlation_hr_stress
FROM smartwatch_health_data;

/* Top 5 users with highest average sleep hours */
SELECT "User ID", AVG("Sleep Duration (hours)") AS avg_sleep
FROM smartwatch_health_data
GROUP BY "User ID"
ORDER BY avg_sleep DESC
LIMIT 5;

/* Distribution of activity levels */
SELECT "Activity Level", COUNT(*) AS count_activity
FROM smartwatch_health_data
GROUP BY "Activity Level";


/* Average heart rate per activity level */
SELECT "Activity Level", AVG("Heart Rate (BPM)") AS avg_hr
FROM smartwatch_health_data
GROUP BY "Activity Level"
ORDER BY avg_hr DESC;



/* Users with consistently high stress (avg stress > 7) */
SELECT "User ID", AVG("Stress Level") AS avg_stress
FROM smartwatch_health_data
GROUP BY "User ID"
HAVING AVG("Stress Level") > 7
ORDER BY avg_stress DESC;



