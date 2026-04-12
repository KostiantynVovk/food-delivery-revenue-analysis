/*
PROJECT: Food Delivery Revenue Analysis
SECTION: Marketing Efficiency & Discount Paradox

BUSINESS QUESTION:
Do discounts reduce cancellations in the Bronze segment, or do they attract more unstable customer behavior?

WHY IT MATTERS:
Discounts are supposed to improve conversion and retention.
If certain promotions increase cancellation risk instead, marketing budget is being used inefficiently.

DATA USED:
- customer_loyalty_tier
- discount_code
- discount_type
- order_status
- order_id

LOGIC:
1. Compare cancellation rates for Bronze users with vs without discounts
2. Break down cancellation rates by discount type
3. Identify which promotional mechanics reduce or worsen churn risk

KEY FINDING:
Bronze users with discounts show a higher cancellation rate (8.93%) than Bronze users without discounts (7.70%).

Among discount types, free_delivery performs worst (11.14% cancellation rate),
while fixed_amount performs best (7.20%).

BUSINESS IMPACT:
The current discount strategy does not improve loyalty in the Bronze segment.
Some promotions attract low-commitment users who are more likely to cancel.

BUSINESS ACTION:
Reallocate marketing budget away from broad discounting and toward more controlled retention incentives.

- Reduce use of free_delivery promotions for Bronze users
- Prioritize fixed_amount discounts over percentage or delivery-based offers
- Test post-order recovery vouchers instead of upfront discounting
*/

-- =========================================================
-- STEP 1: Cancellation rate with vs without discount
-- PURPOSE: Check whether discounts improve or worsen order completion in the Bronze segment
-- =========================================================

select
	customer_loyalty_tier,
	case
		when discount_code is null
		or discount_code = '' then 'No Discount'
		else 'With Discount'
	end as promo_status,
	COUNT(*) as total_orders,
	ROUND(
        AVG(case when order_status = 'cancelled' then 1 else 0 end) * 100.0,
        2
    ) as cancel_rate
from
	food_delivery
where
	customer_loyalty_tier = 'Bronze'
group by
	1, 2;


-- -------------------------
-- FINDING:
-- -------------------------
-- Bronze users with discounts cancel more often (8.93%)
-- than Bronze users without discounts (7.70%).
-- This suggests that discounts are not improving commitment in this segment.


-- =========================================================
-- STEP 2: Cancellation rate by discount type
-- PURPOSE: Identify which promotion mechanics perform best or worst
-- =========================================================

select
	discount_type,
	COUNT(*) as total_orders,
	ROUND(
        AVG(case when order_status = 'cancelled' then 1 else 0 end) * 100.0,
        2
    ) as cancel_rate
from
	food_delivery
where
	customer_loyalty_tier = 'Bronze'
	and discount_type is not null
group by
	1
order by
	cancel_rate asc;


-- =========================================================
-- -------------------------
-- FINDING:
-- -------------------------
-- fixed_amount discounts show the lowest cancellation rate (7.20%),
-- while free_delivery performs worst (11.14%).
-- Percentage discounts also underperform relative to fixed_amount offers.
-- =========================================================

-- =========================================================
-- -------------------------
-- FINAL INSIGHT:
-- -------------------------
-- Discounts do not automatically improve retention in the Bronze segment.
-- In this case, some promotions appear to attract more price-sensitive
-- and low-commitment users, increasing cancellation risk instead of reducing it.
-- =========================================================

-- =========================================================
-- -------------------------
-- BUSINESS ACTION:
-- -------------------------
-- Replace broad discounting with more selective retention design:
-- - reduce free_delivery campaigns for Bronze users
-- - prioritize fixed_amount offers
-- - test recovery vouchers after delayed but completed orders
-- - evaluate promotions based on completion quality, not just order volume
-- =========================================================
