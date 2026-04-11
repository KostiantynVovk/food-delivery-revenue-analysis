/* PART 3: Loyalty Tier Profitability & Revenue Leakage

KEY INSIGHT: 
Over 62% of total revenue loss originates from the Bronze segment. 
Crucially, this leakage persists during 'Clear Sky' conditions, proving 
that the issue isn't operational (weather/cooking) but behavioral. 
Bronze users exhibit the lowest platform commitment.

STRATEGIC RECOMMENDATIONS (from Business Action Plan):
1. Loyalty Boost: Incentive program for Bronze users to complete 3+ orders without cancellation.
2. UX Friction: Implement a "Are you sure?" confirmation for Bronze cancellations in clear weather.
3. Bronze-to-Silver Bridge: "Level Up" challenges to convert volatile users into stable Silver members.
*/

SELECT 
    customer_loyalty_tier AS loyalty_tier,
    CASE 
        WHEN weather_precipitation = 0 THEN 'Clear Sky' 
        ELSE 'Rain/Storm' 
    END AS weather_condition,
    order_status,
    COUNT(order_id) AS total_orders,
    -- Total money per category
    ROUND(SUM(total_amount)::numeric, 2) AS total_revenue,
    -- Average spending per order
    ROUND(AVG(total_amount)::numeric, 2) AS average_order_value,
    -- Delivery fees impact
    ROUND(AVG(delivery_fee)::numeric, 2) AS avg_delivery_fee
FROM food_delivery
GROUP BY 1, 2, 3
ORDER BY 1, 2, order_status DESC;
