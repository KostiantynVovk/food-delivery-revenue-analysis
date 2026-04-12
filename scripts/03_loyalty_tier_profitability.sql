/*
PROJECT: Food Delivery Revenue Analysis
SECTION: Loyalty Tier Profitability & Revenue Leakage

BUSINESS QUESTION:
Which customer segment generates the highest revenue leakage, and is the issue operational or behavioral?

WHY IT MATTERS:
If one loyalty segment drives a disproportionate share of lost revenue,
the business should focus retention efforts there instead of applying broad, inefficient actions.

DATA USED:
- customer_loyalty_tier
- weather_precipitation
- order_status
- order_id
- total_amount
- delivery_fee

LOGIC:
1. Segment orders by loyalty tier and weather condition
2. Compare completed vs cancelled orders across segments
3. Measure total revenue and average order value by segment
4. Identify which customer group drives the largest share of revenue leakage

KEY FINDING:
Over 62% of total revenue leakage comes from the Bronze segment.
Most of these losses occur in Clear Sky conditions, suggesting the problem is behavioral rather than operational.

BUSINESS IMPACT:
The business is losing revenue not because service conditions are unstable,
but because low-loyalty users are more likely to abandon the platform.

BUSINESS ACTION:
Focus retention efforts on Bronze users instead of broad operational fixes.

- Introduce loyalty incentives for repeat completed orders
- Add behavioral friction before cancellation
- Build a Bronze-to-Silver progression mechanism
*/

-- =========================================================
-- STEP 1: Revenue and order behavior by loyalty tier
-- PURPOSE: Compare completed vs cancelled orders across customer segments
-- =========================================================

select
	customer_loyalty_tier as loyalty_tier,
	case
		when weather_precipitation = 0 then 'Clear Sky'
		else 'Rain/Storm'
	end as weather_condition,
	order_status,
	COUNT(order_id) as total_orders,
	ROUND(SUM(total_amount)::numeric, 2) as total_revenue,
	ROUND(AVG(total_amount)::numeric, 2) as average_order_value,
	ROUND(AVG(delivery_fee)::numeric, 2) as avg_delivery_fee
from
	food_delivery
group by
	1, 2, 3
order by
	1, 2, order_status desc;


-- =========================================================
-- -------------------------
-- FINDING:
-- -------------------------
-- Bronze users generate the largest concentration of cancelled-order revenue.
-- Crucially, most of this loss appears during Clear Sky conditions,
-- where operational disruption is minimal.
-- =========================================================

-- =========================================================
-- -------------------------
-- FINAL INSIGHT:
-- -------------------------
-- Over 62% of total revenue leakage comes from Bronze users.
-- Since the majority of this leakage occurs in Clear Sky conditions,
-- the issue is more behavioral than operational.
-- This segment shows the weakest platform commitment and the highest churn risk.
-- =========================================================

-- =========================================================
-- -------------------------
-- BUSINESS ACTION:
-- -------------------------
-- Retention strategy should focus on Bronze users:
-- - Reward streaks of completed orders
-- - Add cancellation friction for low-loyalty users
-- - Create an upgrade path from Bronze to Silver
-- =========================================================
