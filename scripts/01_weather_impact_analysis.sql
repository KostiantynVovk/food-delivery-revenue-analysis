/*
PROJECT: Food Delivery Revenue Analysis
SECTION: Weather Impact & Order Status Overview

BUSINESS QUESTION:
How does precipitation severity affect order cancellation rates?

WHY IT MATTERS:
If weather meaningfully increases cancellations, the business should adapt ETA expectations and customer communication.

DATA USED:
- order_id
- order_status
- weather_precipitation

LOGIC:
1. Measure the baseline order status distribution
2. Measure cancellation rates by raw precipitation values
3. Group weather into stakeholder-friendly categories
4. Compare cancellation rates across weather groups

KEY FINDING:
Heavy Storm has the highest cancellation rate (12.07%), compared to Clear Sky (7.99%).

BUSINESS RECOMMENDATION:
Use weather-aware ETA adjustments and proactive alerts during severe weather.
*/


-- =========================================================
-- STEP 1: Baseline order status distribution
-- PURPOSE: Measure the overall share of completed vs cancelled orders
-- =========================================================

select
	order_status,
	COUNT(*) as count_orders,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) over(), 2) as percentage
from
	food_delivery
group by
	order_status;


-- -------------------------
-- FINDING:
-- -------------------------
-- The dataset has a healthy completion rate (92.25%), while cancellations account for 7.75% of all orders.
-- This sets the baseline for deeper cancellation analysis.


-- =========================================================
-- STEP 2: Cancellation rate by raw precipitation values
-- PURPOSE: Explore how cancellation behavior changes across exact precipitation values
-- =========================================================

select
	weather_precipitation,
	COUNT(*) as count_orders,
	SUM(case when order_status = 'cancelled' then 1 else 0 end) as cancelled_orders,
	ROUND(SUM(case when order_status = 'cancelled' then 1 else 0 end) * 100.0 / COUNT(*), 2) as cancelled_percent
from
	food_delivery
group by
	weather_precipitation
order by
	weather_precipitation desc;


-- -------------------------
-- FINDING:
-- -------------------------
-- Exact precipitation values are too granular for business reporting,
-- but they indicate that higher precipitation tends to correlate with higher cancellation frequency.


-- =========================================================
-- STEP 3: Cancellation rate by weather category
-- PURPOSE: Convert raw precipitation values into business-friendly weather groups
-- =========================================================

select
	case
		when weather_precipitation = 0 then 'Clear Sky'
		when weather_precipitation <= 2.0 then 'Light Rain'
		when weather_precipitation <= 14.0 then 'Moderate Rain'
		else 'Heavy Storm'
	end as weather_category,
	COUNT(*) as total_orders,
	MAX(weather_precipitation) as max_precip,
	SUM(case when order_status = 'cancelled' then 1 else 0 end) as cancelled_orders,
	ROUND(SUM(case when order_status = 'cancelled' then 1 else 0 end) * 100.0 / COUNT(*), 2) as cancellation_rate
from
	food_delivery
group by
	1
order by
	cancellation_rate desc;


-- -------------------------
-- FINAL INSIGHT:
-- -------------------------
-- Heavy Storm shows the highest cancellation rate (12.07%),
-- significantly above Clear Sky (7.99%), confirming that severe weather increases cancellation risk.

-- -------------------------
-- BUSINESS ACTION:
-- -------------------------
-- The platform should adjust ETA estimates dynamically and send proactive delay notifications
-- during severe weather conditions to reduce customer frustration and order abandonment.
