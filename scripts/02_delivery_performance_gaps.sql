/* PART 2: Delivery Performance & Dynamic ETA Analysis

INSIGHT: 
Data shows a significant gap between Promised ETA and Actual Delivery during bad weather. 
In 'Moderate Rain' and 'Heavy Storm', customers wait 14-20 minutes longer than expected.

STRATEGIC RECOMMENDATION:
1. Update the ETA algorithm to include a 'Weather Buffer' based on real-time precipitation.
2. Proactively notify customers about potential delays when the weather exceeds a 2.0mm threshold.
*/

-- Analyzing the gap between Promised ETA and Actual Delivery Time
SELECT
    CASE
        WHEN weather_precipitation = 0 THEN 'Clear Sky'
        WHEN weather_precipitation <= 2.0 THEN 'Light Rain'
        WHEN weather_precipitation <= 14.0 THEN 'Moderate Rain'
        ELSE 'Heavy Storm'
    END AS weather_category,
    ROUND(AVG(delivery_duration_actual)::numeric, 2) AS avg_actual_min,
    ROUND(AVG(delivery_duration_estimated)::numeric, 2) AS avg_estimated_min,
    -- The core metric for customer dissatisfaction: the delay gap
    ROUND(AVG(delivery_duration_actual)::numeric - AVG(delivery_duration_estimated)::numeric, 2) AS avg_delay_gap
FROM
    food_delivery
WHERE
    order_status = 'completed'
GROUP BY
    1
ORDER BY
    avg_delay_gap DESC;
