/* PART 4: Marketing Efficiency & Discount Paradox

INSIGHT:
Contrary to initial assumptions, the Bronze segment with active discounts shows 
a HIGHER cancellation rate (8.93%) compared to those without discounts (7.70%).

HYPOTHESIS:
Discount-driven customers in the Bronze tier exhibit lower platform loyalty 
and are more likely to cancel orders during operational friction (e.g., bad weather).

RECOMMENDATION:
1. Re-evaluate discount distribution for the Bronze tier. 
2. Shift marketing budget from "upfront" discounts to "recovery" vouchers 
   (giving discounts AFTER a successful but delayed delivery) to build long-term loyalty.
*/

-- Comparison of cancellation rates within the Bronze segment
SELECT 
    customer_loyalty_tier,
    CASE 
        WHEN discount_code IS NULL OR discount_code = '' THEN 'No Discount' 
        ELSE 'With Discount' 
    END as promo_status,
    COUNT(*) as total_orders,
    ROUND(AVG(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0, 2) as cancel_rate
FROM food_delivery
WHERE customer_loyalty_tier = 'Bronze'
GROUP BY 1, 2;

-- Breakdown by Discount Type to see if specific promos perform better
SELECT
    discount_type,
    COUNT(*) as total_orders,
    ROUND(AVG(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) * 100.0, 2) as cancel_rate
FROM food_delivery
WHERE customer_loyalty_tier = 'Bronze' AND discount_type IS NOT NULL
GROUP BY 1
ORDER BY cancel_rate ASC;
