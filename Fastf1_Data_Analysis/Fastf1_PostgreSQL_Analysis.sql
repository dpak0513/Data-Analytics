-- Fastf1 PostgreSQL Analysis--
SELECT * FROM fastf1_data;


/* Drop duplicates */
DELETE FROM fastf1_data a
USING fastf1_data b
WHERE a."Time" = b."Time"
  AND a.ctid > b.ctid;



/* Fastest lap per driver */
SELECT "Driver", MIN("LapTime") AS fastest_lap
FROM fastf1_data
GROUP BY "Driver"
ORDER BY fastest_lap ASC;


/* Fastest lap per driver (using window function) */
SELECT DISTINCT "Driver", 
       FIRST_VALUE("LapTime") OVER (PARTITION BY "Driver" ORDER BY "LapTime") AS fastest_lap
FROM fastf1_data
ORDER BY fastest_lap ASC;


/* Rank drivers by fastest lap */
SELECT "Driver", "LapTime",
       RANK() OVER (PARTITION BY "Driver" ORDER BY "LapTime") AS lap_rank
FROM fastf1_data
WHERE "LapTime" IS NOT NULL;


/* Cumulative tyre life per driver */
SELECT "Driver", "LapNumber", "TyreLife",
       SUM("TyreLife") OVER (PARTITION BY "Driver" ORDER BY "LapNumber") AS cumulative_tyre_life
FROM fastf1_data;


/* Stint count per driver */
SELECT "Driver", COUNT(DISTINCT "Stint") AS stint_count
FROM fastf1_data
GROUP BY "Driver"
ORDER BY stint_count DESC;

/* Best sector time per driver */
SELECT DISTINCT "Driver",
       MIN("Sector1Time") OVER (PARTITION BY "Driver") AS best_sector1,
       MIN("Sector2Time") OVER (PARTITION BY "Driver") AS best_sector2,
       MIN("Sector3Time") OVER (PARTITION BY "Driver") AS best_sector3
FROM fastf1_data;


/* Fastest lap overall */
SELECT "Driver", MIN("LapTime") AS fastest_lap
FROM fastf1_data
WHERE "LapTime" IS NOT NULL
GROUP BY "Driver"
ORDER BY fastest_lap ASC
LIMIT 1;


/* Fastest lap per team */
SELECT "Team", MIN("LapTime") AS team_fastest_lap
FROM fastf1_data
WHERE "LapTime" IS NOT NULL
GROUP BY "Team"
ORDER BY team_fastest_lap ASC;

/* Driver with most laps completed */
SELECT "Driver", COUNT(*) AS total_laps
FROM fastf1_data
GROUP BY "Driver"
ORDER BY total_laps DESC;


/* Most used tyre compounds */
SELECT "Compound", COUNT(*) AS usage_count
FROM fastf1_data
GROUP BY "Compound"
ORDER BY usage_count DESC;

/* Average tyre life by compound */
SELECT "Compound", AVG("TyreLife") AS avg_tyre_life
FROM fastf1_data
WHERE "TyreLife" IS NOT NULL
GROUP BY "Compound"
ORDER BY avg_tyre_life DESC;

/* Fresh vs Used tyres per driver */
SELECT "Driver", "FreshTyre", COUNT(*) AS tyre_count
FROM fastf1_data
GROUP BY "Driver", "FreshTyre"
ORDER BY "Driver", "FreshTyre";


/* Driver position improvement (start vs end) */
SELECT "Driver",
       MIN("Position") AS start_position,
       MAX("Position") AS end_position,
       (MIN("Position") - MAX("Position")) AS net_gain
FROM fastf1_data
WHERE "Position" IS NOT NULL
GROUP BY "Driver"
ORDER BY net_gain DESC;


/* correlation for laptimee vs tyrelife */
SELECT corr(EXTRACT(EPOCH FROM "LapTime"::interval), "TyreLife") AS corr_laptime_tyre
FROM fastf1_data
WHERE "LapTime" IS NOT NULL
  AND "TyreLife" IS NOT NULL;




/* Categorize TyreLife */
SELECT "Driver",
       "Compound",
       "TyreLife",
       CASE 
         WHEN "TyreLife" >= 30 THEN 'Long'
         WHEN "TyreLife" BETWEEN 15 AND 29 THEN 'Medium'
         ELSE 'Short'
       END AS tyre_life_category
FROM fastf1_data
WHERE "TyreLife" IS NOT NULL
ORDER BY "Driver";



