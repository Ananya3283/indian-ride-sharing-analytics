CREATE DATABASE ride_analytics;
USE ride_analytics;
CREATE TABLE rides (
    date DATE,
    time TIME,
    booking_id VARCHAR(50),
    booking_status VARCHAR(50),
    customer_id VARCHAR(50),
    vehicle_type VARCHAR(50),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    avg_vtat FLOAT,
    avg_ctat FLOAT,
    cancelled_rides_by_customer FLOAT,
    customer_cancellation_reason VARCHAR(255),
    cancelled_rides_by_driver FLOAT,
    driver_cancellation_reason VARCHAR(255),
    incomplete_rides FLOAT,
    incomplete_rides_reason VARCHAR(255),
    booking_value FLOAT,
    ride_distance FLOAT,
    driver_rating FLOAT,
    customer_rating FLOAT,
    payment_method VARCHAR(50)
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
USE ride_analytics;

LOAD DATA LOCAL INFILE 'C:/Temp/ride_cleaned.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
date,
time,
booking_id,
booking_status,
customer_id,
vehicle_type,
pickup_location,
drop_location,
avg_vtat,
avg_ctat,
cancelled_rides_by_customer,
customer_cancellation_reason,
cancelled_rides_by_driver,
driver_cancellation_reason,
incomplete_rides,
incomplete_rides_reason,
booking_value,
ride_distance,
driver_rating,
customer_rating,
payment_method
);
DROP TABLE IF EXISTS rides;
USE ride_analytics;
CREATE TABLE test_table (
    id INT,
    name VARCHAR(50)
);
USE ride_analytics;

SHOW TABLES;
SELECT COUNT(*) FROM rides;
SELECT * FROM rides LIMIT 5;
SHOW VARIABLES LIKE 'secure_file_priv';
USE ride_analytics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ride_cleaned.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
TRUNCATE TABLE rides;
USE ride_analytics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ride_cleaned.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
date,
time,
booking_id,
booking_status,
customer_id,
vehicle_type,
pickup_location,
drop_location,
avg_vtat,
avg_ctat,
cancelled_rides_by_customer,
customer_cancellation_reason,
cancelled_rides_by_driver,
driver_cancellation_reason,
incomplete_rides,
incomplete_rides_reason,
booking_value,
ride_distance,
driver_rating,
customer_rating,
payment_method
);
DESCRIBE rides;
DROP TABLE rides;
CREATE TABLE rides (
    date DATE,
    time TIME,
    booking_id VARCHAR(50),
    booking_status VARCHAR(50),
    customer_id VARCHAR(50),
    vehicle_type VARCHAR(50),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    avg_vtat FLOAT,
    avg_ctat FLOAT,
    cancelled_rides_by_customer FLOAT,
    customer_cancellation_reason VARCHAR(255),
    cancelled_rides_by_driver FLOAT,
    driver_cancellation_reason VARCHAR(255),
    incomplete_rides FLOAT,
    incomplete_rides_reason VARCHAR(255),
    booking_value FLOAT,
    ride_distance FLOAT,
    driver_rating FLOAT,
    customer_rating FLOAT,
    payment_method VARCHAR(50)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ride_cleaned.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
DROP TABLE IF EXISTS rides;
CREATE TABLE rides (
    date DATE,
    time TIME,
    booking_id VARCHAR(20),
    booking_status VARCHAR(50),
    customer_id VARCHAR(20),
    vehicle_type VARCHAR(50),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    avg_vtat FLOAT,
    avg_ctat FLOAT,
    cancelled_rides_by_customer FLOAT,
    customer_cancellation_reason VARCHAR(255),
    cancelled_rides_by_driver FLOAT,
    driver_cancellation_reason VARCHAR(255),
    incomplete_rides FLOAT,
    incomplete_rides_reason VARCHAR(255),
    booking_value FLOAT,
    ride_distance FLOAT,
    driver_rating FLOAT,
    customer_rating FLOAT,
    payment_method VARCHAR(50)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ride_mysql.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
@date,
@time,
@booking_id,
@booking_status,
@customer_id,
@vehicle_type,
@pickup_location,
@drop_location,
@avg_vtat,
@avg_ctat,
@cancelled_rides_by_customer,
@customer_cancellation_reason,
@cancelled_rides_by_driver,
@driver_cancellation_reason,
@incomplete_rides,
@incomplete_rides_reason,
@booking_value,
@ride_distance,
@driver_rating,
@customer_rating,
@payment_method
)
SET
date = NULLIF(@date,''),
time = NULLIF(@time,''),
booking_id = NULLIF(@booking_id,''),
booking_status = NULLIF(@booking_status,''),
customer_id = NULLIF(@customer_id,''),
vehicle_type = NULLIF(@vehicle_type,''),
pickup_location = NULLIF(@pickup_location,''),
drop_location = NULLIF(@drop_location,''),
avg_vtat = NULLIF(@avg_vtat,''),
avg_ctat = NULLIF(@avg_ctat,''),
cancelled_rides_by_customer = NULLIF(@cancelled_rides_by_customer,''),
customer_cancellation_reason = NULLIF(@customer_cancellation_reason,''),
cancelled_rides_by_driver = NULLIF(@cancelled_rides_by_driver,''),
driver_cancellation_reason = NULLIF(@driver_cancellation_reason,''),
incomplete_rides = NULLIF(@incomplete_rides,''),
incomplete_rides_reason = NULLIF(@incomplete_rides_reason,''),
booking_value = NULLIF(@booking_value,''),
ride_distance = NULLIF(@ride_distance,''),
driver_rating = NULLIF(@driver_rating,''),
customer_rating = NULLIF(@customer_rating,''),
payment_method = NULLIF(@payment_method,'');
USE ride_analytics;

-- =====================================================
-- BASIC SQL QUERIES
-- =====================================================

-- 1. Total Bookings
SELECT COUNT(*) AS total_bookings
FROM rides;

-- 2. Booking Status Distribution
SELECT
    booking_status,
    COUNT(*) AS total_rides
FROM rides
GROUP BY booking_status
ORDER BY total_rides DESC;

-- 3. Total Revenue
SELECT
    ROUND(SUM(booking_value), 2) AS total_revenue
FROM rides;

-- 4. Average Booking Value
SELECT
    ROUND(AVG(booking_value), 2) AS avg_booking_value
FROM rides;

-- 5. Average Ride Distance
SELECT
    ROUND(AVG(ride_distance), 2) AS avg_ride_distance
FROM rides;

-- 6. Vehicle-wise Ride Count
SELECT
    vehicle_type,
    COUNT(*) AS total_rides
FROM rides
GROUP BY vehicle_type
ORDER BY total_rides DESC;

-- 7. Revenue by Vehicle Type
SELECT
    vehicle_type,
    ROUND(SUM(booking_value), 2) AS revenue
FROM rides
GROUP BY vehicle_type
ORDER BY revenue DESC;

-- 8. Average Driver Rating by Vehicle Type
SELECT
    vehicle_type,
    ROUND(AVG(driver_rating), 2) AS avg_driver_rating
FROM rides
GROUP BY vehicle_type
ORDER BY avg_driver_rating DESC;

-- 9. Payment Method Distribution
SELECT
    payment_method,
    COUNT(*) AS total_transactions
FROM rides
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 10. Top 10 Pickup Locations
SELECT
    pickup_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY pickup_location
ORDER BY total_rides DESC
LIMIT 10;

-- =====================================================
-- INTERMEDIATE SQL QUERIES
-- =====================================================

-- 11. Top 10 Drop Locations
SELECT
    drop_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY drop_location
ORDER BY total_rides DESC
LIMIT 10;

-- 12. Daily Revenue
SELECT
    date,
    ROUND(SUM(booking_value), 2) AS daily_revenue
FROM rides
GROUP BY date
ORDER BY date;

-- 13. Monthly Revenue
SELECT
    MONTH(date) AS month,
    ROUND(SUM(booking_value), 2) AS monthly_revenue
FROM rides
GROUP BY MONTH(date)
ORDER BY month;

-- 14. Booking Completion Rate
SELECT
    ROUND(
        SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS completion_rate;

-- 15. Average Fare by Payment Method
SELECT
    payment_method,
    ROUND(AVG(booking_value), 2) AS avg_fare
FROM rides
GROUP BY payment_method
ORDER BY avg_fare DESC;

-- =====================================================
-- ADVANCED SQL QUERIES
-- =====================================================

-- 16. Highest Revenue Pickup Locations
SELECT
    pickup_location,
    ROUND(SUM(booking_value), 2) AS revenue
FROM rides
GROUP BY pickup_location
ORDER BY revenue DESC
LIMIT 10;

-- 17. Rank Vehicle Types by Revenue
SELECT
    vehicle_type,
    ROUND(SUM(booking_value), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(booking_value) DESC) AS revenue_rank
FROM rides
GROUP BY vehicle_type;

-- 18. Cancellation Analysis
SELECT
    booking_status,
    COUNT(*) AS total_rides
FROM rides
WHERE booking_status <> 'Completed'
GROUP BY booking_status
ORDER BY total_rides DESC;

-- 19. Highest Rated Vehicle Types
SELECT
    vehicle_type,
    ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM rides
GROUP BY vehicle_type
ORDER BY avg_customer_rating DESC;

-- 20. Busiest Pickup Location
SELECT
    pickup_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY pickup_location
ORDER BY total_rides DESC
LIMIT 1;
-- =====================================================
-- ADVANCED SQL QUERIES (21-30)
-- =====================================================

-- 21. Top 5 Highest Revenue Dates
SELECT
    date,
    ROUND(SUM(booking_value),2) AS revenue
FROM rides
GROUP BY date
ORDER BY revenue DESC
LIMIT 5;

---------------------------------------------------------

-- 22. Average Booking Value by Booking Status
SELECT
    booking_status,
    ROUND(AVG(booking_value),2) AS avg_booking_value
FROM rides
GROUP BY booking_status
ORDER BY avg_booking_value DESC;

---------------------------------------------------------

-- 23. Vehicle Type Performance
SELECT
    vehicle_type,
    COUNT(*) AS total_rides,
    ROUND(SUM(booking_value),2) AS total_revenue,
    ROUND(AVG(driver_rating),2) AS avg_driver_rating
FROM rides
GROUP BY vehicle_type
ORDER BY total_revenue DESC;

---------------------------------------------------------

-- 24. Top 10 Pickup-Drop Route Combinations
SELECT
    pickup_location,
    drop_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY pickup_location, drop_location
ORDER BY total_rides DESC
LIMIT 10;

---------------------------------------------------------

-- 25. Revenue Contribution (%) by Vehicle Type
SELECT
    vehicle_type,
    ROUND(SUM(booking_value),2) AS revenue,
    ROUND(
        SUM(booking_value) * 100 /
        (SELECT SUM(booking_value) FROM rides),
        2
    ) AS revenue_percentage
FROM rides
GROUP BY vehicle_type
ORDER BY revenue DESC;

---------------------------------------------------------

-- 26. Dense Rank Vehicle Types by Revenue
SELECT
    vehicle_type,
    ROUND(SUM(booking_value),2) AS revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(booking_value) DESC
    ) AS revenue_rank
FROM rides
GROUP BY vehicle_type;

---------------------------------------------------------

-- 27. Top 5 Days with Maximum Completed Rides
SELECT
    date,
    COUNT(*) AS completed_rides
FROM rides
WHERE booking_status='Completed'
GROUP BY date
ORDER BY completed_rides DESC
LIMIT 5;

---------------------------------------------------------

-- 28. CTE - Top Revenue Pickup Locations
WITH pickup_revenue AS
(
SELECT
    pickup_location,
    ROUND(SUM(booking_value),2) AS revenue
FROM rides
GROUP BY pickup_location
)

SELECT *
FROM pickup_revenue
ORDER BY revenue DESC
LIMIT 10;

---------------------------------------------------------

-- 29. Window Function - Running Revenue
SELECT
    date,
    ROUND(SUM(booking_value),2) AS daily_revenue,
    ROUND(
        SUM(SUM(booking_value))
        OVER(ORDER BY date),
        2
    ) AS running_revenue
FROM rides
GROUP BY date
ORDER BY date;

---------------------------------------------------------

-- 30. Overall Business Summary
SELECT
    COUNT(*) AS total_bookings,
    ROUND(SUM(booking_value),2) AS total_revenue,
    ROUND(AVG(booking_value),2) AS avg_booking_value,
    ROUND(AVG(ride_distance),2) AS avg_ride_distance,
    ROUND(AVG(driver_rating),2) AS avg_driver_rating,
    ROUND(AVG(customer_rating),2) AS avg_customer_rating
FROM rides;
