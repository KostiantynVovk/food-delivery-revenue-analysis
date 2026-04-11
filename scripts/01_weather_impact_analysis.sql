/* PROJECT: Food Delivery Analysis
PART 1: Weather Impact & Order Status Overview
PURPOSE: Identify how precipitation levels affect order cancellation rates.
*/

-- 1. General Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS count_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM
    food_delivery
GROUP BY
    order_status;

-- 2. Cancellation Rate by Precipitation (Raw Values)
SELECT
    weather_precipitation,
    COUNT(*) AS count_orders,
    SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancelled_percent
FROM
    food_delivery
GROUP BY
    weather_precipitation
ORDER BY
    weather_precipitation DESC;

-- 3. Cancellation Rate by Weather Category (Business Logic)
SELECT
    CASE
        WHEN weather_precipitation = 0 THEN 'Clear Sky'
        WHEN weather_precipitation <= 2.0 THEN 'Light Rain'
        WHEN weather_precipitation <= 14.0 THEN 'Moderate Rain'
        ELSE 'Heavy Storm'
    END AS weather_category,
    COUNT(*) AS total_orders,
    MAX(weather_precipitation) AS max_precip,
    SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM
    food_delivery
GROUP BY
    1
ORDER BY
    cancellation_rate DESC;
