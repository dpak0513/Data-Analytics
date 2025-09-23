--Taxi PostgreSQL Analysis--
SELECT * FROM taxi_data;


/* Droping duplicates*/
DELETE FROM taxi_data a
USING taxi_data b
WHERE a.ctid < b.ctid
  AND a.tpep_pickup_datetime = b.tpep_pickup_datetime;



/* Count trips by passenger count */
SELECT 
	passenger_count,
	COUNT(*) as trip_count
FROM taxi_Data
GROUP BY passenger_count
ORDER BY trip_count DESC;


/* Sort trips by trip distance ascending */
SELECT *
FROM taxi_Data
ORDER BY trip_distance ASC;

/* coverting data type */
ALTER TABLE taxi_Data 
ALTER COLUMN tpep_pickup_datetime TYPE TIMESTAMP
USING TO_TIMESTAMP(tpep_pickup_datetime, 'MM/DD/YYYY HH12:MI:SS AM');

/* coverting data type */
ALTER TABLE taxi_Data 
ALTER COLUMN tpep_dropoff_datetime TYPE TIMESTAMP
USING TO_TIMESTAMP(tpep_dropoff_datetime, 'MM/DD/YYYY HH12:MI:SS AM');


/* Hourly trip count & average fare */
SELECT 
  EXTRACT(HOUR FROM tpep_pickup_datetime::timestamp) AS pickup_hour,
  COUNT(*) AS trip_count,
  ROUND(AVG(fare_amount)::numeric, 2) AS avg_fare
FROM taxi_Data
GROUP BY pickup_hour
ORDER BY pickup_hour;



/* Average fare amount by passenger count */
SELECT 
	passenger_count,
	AVG(fare_amount) AS avg_fare
FROM taxi_Data
GROUP BY passenger_count
ORDER BY passenger_count;


/* Most common trip distance (mode approximation) */
SELECT
	trip_distance,
	COUNT(*) as frequency
FROM taxi_Data
GROUP BY trip_distance
ORDER BY frequency DESC;


/* Top 10 longest trips */
SELECT *
FROM taxi_Data
ORDER BY trip_distance DESC
LIMIT 10;

/* Average fare amount overall */
SELECT 
	AVG(fare_amount) AS overall_avg_fare
FROM taxi_Data;


/* Total revenue per trip (fare + tip) */
SELECT 
	trip_distance,
	fare_amount + tip_amount AS total_revenue
FROM taxi_Data
ORDER BY trip_distance DESC;

 

/* Average fare by payment type */
SELECT
	payment_type,
	AVG(fare_amount) AS avg_fare
FROM taxi_Data
GROUP BY payment_type
ORDER BY payment_type;


/* Revenue by day of week */
SELECT 
  TO_CHAR(tpep_pickup_datetime, 'Day') AS day_of_week,
  SUM(fare_amount + tip_amount) AS total_revenue
FROM taxi_Data
GROUP BY day_of_week
ORDER BY total_revenue DESC;


/* Top 10 pickup locations by trip count */
SELECT 
  "PULocationID", 
  COUNT(*) AS trip_count
FROM taxi_Data
GROUP BY 1
ORDER BY trip_count DESC
LIMIT 10;


/* Average tip percentage by payment type */
SELECT 
  payment_type, 
  AVG(CASE WHEN fare_amount > 0 THEN (tip_amount / fare_amount) * 100 ELSE 0 END) AS avg_tip_pct
FROM taxi_Data
GROUP BY payment_type;


/* Trips longer than 30 miles and their average fare */
SELECT 
  COUNT(*) AS long_trips,
  AVG(fare_amount) AS avg_fare_long_trips
FROM taxi_Data
WHERE trip_distance > 30;


/* Busiest hour by total trips and average trip duration in minutes */
SELECT 
  EXTRACT(HOUR FROM tpep_pickup_datetime) AS pickup_hour,
  COUNT(*) AS total_trips,
  AVG(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/60) AS avg_trip_duration_minutes
FROM taxi_Data
GROUP BY pickup_hour
ORDER BY total_trips DESC
LIMIT 1;



/* Average total amount (fare + tip + tolls) by passenger count */
SELECT 
  passenger_count,
  AVG(fare_amount + tip_amount + tolls_amount) AS avg_total_amount
FROM taxi_Data
GROUP BY passenger_count
ORDER BY passenger_count;


/* Top 5 longest average trips per RatecodeID */
SELECT 
  "RatecodeID",
  AVG(trip_distance) AS avg_trip_distance
FROM taxi_Data
GROUP BY 1
ORDER BY avg_trip_distance DESC
LIMIT 5;


/* Count of trips where store_and_fwd_flag is 'Y' */
SELECT 
  COUNT(*) AS store_and_fwd_trips
FROM taxi_Data
WHERE store_and_fwd_flag = 'Y';


 

