-- ============================================================
--  04_Clinic_Queries.sql
--  Clinic Management System — Query Solutions (Q1 to Q5)
--  Replace the year value (2021) as needed for different years.
-- ============================================================


-- ------------------------------------------------------------
-- Q1. Find the revenue we got from each sales channel 
--     in a given year
-- ------------------------------------------------------------
-- Logic: Filter clinic_sales by year, GROUP BY sales_channel,
--        SUM the amount per channel.
-- ------------------------------------------------------------

SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Q2. Find the top 10 most valuable customers for a given year
-- ------------------------------------------------------------
-- Logic: Filter clinic_sales by year, GROUP BY customer uid,
--        SUM their total spend, ORDER BY DESC, LIMIT 10.
-- ------------------------------------------------------------

SELECT
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spend
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spend DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q3. Find month-wise revenue, expense, profit, and status 
--     (profitable / not-profitable) for a given year
-- ------------------------------------------------------------
-- Logic: Aggregate revenue per month from clinic_sales.
--        Aggregate expenses per month from expenses table.
--        LEFT JOIN both on month so months with no expenses 
--        still appear. Compute profit = revenue - expense.
--        Use CASE to label status.
-- ------------------------------------------------------------

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)  AS month_no,
        SUM(amount)      AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)  AS month_no,
        SUM(amount)      AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT
    r.month_no,
    r.total_revenue,
    COALESCE(e.total_expense, 0)                              AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0))          AS profit,
    CASE
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) > 0
            THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                                        AS status
FROM monthly_revenue r
LEFT JOIN monthly_expense e ON r.month_no = e.month_no
ORDER BY r.month_no;


-- ------------------------------------------------------------
-- Q4. For each city, find the most profitable clinic 
--     for a given month
-- ------------------------------------------------------------
-- Logic: Compute per-clinic revenue and expenses for the month.
--        Calculate profit per clinic.
--        Use RANK() partitioned by city, ordered by profit DESC.
--        Return only rank = 1 (most profitable per city).
-- ------------------------------------------------------------

-- Set the target month and year here:
-- month = 6 (June), year = 2021

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime)  = 2021
      AND MONTH(datetime) = 6
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime)  = 2021
      AND MONTH(datetime) = 6
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(r.revenue, 0)                          AS revenue,
        COALESCE(e.expense, 0)                          AS expense,
        (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON cl.cid = r.cid
    LEFT JOIN clinic_expense e ON cl.cid = e.cid
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS profit_rank
    FROM clinic_profit
)
SELECT
    city,
    cid,
    clinic_name,
    revenue,
    expense,
    profit
FROM ranked
WHERE profit_rank = 1
ORDER BY city;


-- ------------------------------------------------------------
-- Q5. For each state, find the second least profitable clinic 
--     for a given month
-- ------------------------------------------------------------
-- Logic: Same profit computation as Q4.
--        Use DENSE_RANK() partitioned by state, ordered by 
--        profit ASC (ascending = least profitable first).
--        Filter for rank = 2 (second least profitable).
-- ------------------------------------------------------------

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime)  = 2021
      AND MONTH(datetime) = 6
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime)  = 2021
      AND MONTH(datetime) = 6
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(r.revenue, 0)                               AS revenue,
        COALESCE(e.expense, 0)                               AS expense,
        (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0))   AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON cl.cid = r.cid
    LEFT JOIN clinic_expense e ON cl.cid = e.cid
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS profit_rank
    FROM clinic_profit
)
SELECT
    state,
    cid,
    clinic_name,
    city,
    revenue,
    expense,
    profit
FROM ranked
WHERE profit_rank = 2
ORDER BY state;
