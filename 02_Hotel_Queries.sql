-- ============================================================
--  02_Hotel_Queries.sql
--  Hotel Management System — Query Solutions (Q1 to Q5)
-- ============================================================


-- ------------------------------------------------------------
-- Q1. For every user in the system, get the user_id and 
--     last booked room_no
-- ------------------------------------------------------------
-- Logic: Join users with bookings, group by user_id, pick 
--        the booking with MAX(booking_date) per user.
-- ------------------------------------------------------------

SELECT
    u.user_id,
    u.name,
    b.room_no AS last_booked_room
FROM users u
JOIN bookings b
    ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);


-- ------------------------------------------------------------
-- Q2. Get booking_id and total billing amount of every 
--     booking created in November, 2021
-- ------------------------------------------------------------
-- Logic: Filter bookings by Nov 2021, join with 
--        booking_commercials and items, multiply 
--        item_quantity × item_rate to get line total, 
--        then SUM per booking.
-- ------------------------------------------------------------

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i                ON bc.item_id   = i.item_id
WHERE YEAR(b.booking_date)  = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;


-- ------------------------------------------------------------
-- Q3. Get bill_id and bill amount of all bills raised in 
--     October, 2021 having bill amount > 1000
-- ------------------------------------------------------------
-- Logic: Filter booking_commercials by Oct 2021 on bill_date,
--        join items for rate, SUM per bill_id,
--        then use HAVING to keep only bills > 1000.
-- ------------------------------------------------------------

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- ------------------------------------------------------------
-- Q4. Determine the most ordered and least ordered item 
--     of each month of year 2021
-- ------------------------------------------------------------
-- Logic: Aggregate total quantity ordered per item per month.
--        Use RANK() window function to rank items by quantity
--        DESC (for most) and ASC (for least) within each month.
--        Then filter for rank = 1 in both directions.
-- ------------------------------------------------------------

WITH monthly_item_totals AS (
    SELECT
        MONTH(bc.bill_date)    AS order_month,
        i.item_name,
        SUM(bc.item_quantity)  AS total_quantity
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_quantity,
        RANK() OVER (PARTITION BY order_month ORDER BY total_quantity DESC) AS rank_most,
        RANK() OVER (PARTITION BY order_month ORDER BY total_quantity ASC)  AS rank_least
    FROM monthly_item_totals
)
SELECT
    order_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
WHERE rank_most = 1 OR rank_least = 1
GROUP BY order_month
ORDER BY order_month;


-- ------------------------------------------------------------
-- Q5. Find the customers with the second highest bill value 
--     of each month of year 2021
-- ------------------------------------------------------------
-- Logic: Calculate total bill per user per month.
--        Use DENSE_RANK() (so ties don't skip rank 2) to rank
--        users by bill amount DESC within each month.
--        Filter for rank = 2.
-- ------------------------------------------------------------

WITH user_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)                  AS bill_month,
        b.user_id,
        u.name,
        SUM(bc.item_quantity * i.item_rate)  AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN users u    ON b.user_id     = u.user_id
    JOIN items i    ON bc.item_id    = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, u.name
),
ranked AS (
    SELECT
        bill_month,
        user_id,
        name,
        total_bill,
        DENSE_RANK() OVER (
            PARTITION BY bill_month
            ORDER BY total_bill DESC
        ) AS bill_rank
    FROM user_monthly_bill
)
SELECT
    bill_month,
    user_id,
    name,
    total_bill AS second_highest_bill
FROM ranked
WHERE bill_rank = 2
ORDER BY bill_month;
