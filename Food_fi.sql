SELECT COUNT (DISTINCT customer_id)
FROM foodie_fi.subscriptions;

SELECT *
FROM foodie_fi.plans;

SELECT *
FROM foodie_fi.subscriptions;


--To see a brief description about each customer’s onboarding journey.

---To see the unique customers, which is 1000 unique customers
SELECT COUNT(DISTINCT customer_id) AS NO_OF_CUSTOMERS
FROM foodie_fi.subscriptions;

Q1--THE AMOUNT OF CUSTOMERS THAT SUBSCRIBED TO FREE TRIAL SUBSCRIPTION
WITH Tab_1 AS (
	SELECT customer_id, plan_name, p.plan_id, start_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS Category_onboarding
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
)
SELECT *
FROM Tab_1
WHERE Category_onboarding = 1;


Q2---All the customers subscribe to at least one of the plan, Basic, Pro monthly and Pro annual

WITH Tab_1 AS (
	SELECT customer_id, plan_name, p.plan_id, start_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS Category_onboarding
		FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
)
SELECT *
FROM Tab_1
WHERE Category_onboarding = 4;


Q3---What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value?

WITH Tab_1 AS (
	SELECT customer_id, plan_name, p.plan_id, start_date,
	EXTRACT (MONTH FROM start_date)AS Month_start,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS Category_onboarding
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
)
SELECT COUNT (month_start) AS monthly_distribution
FROM Tab_1
WHERE Category_onboarding = 1
GROUP BY customer_id, Tab_1.plan_id
ORDER BY monthly_distribution;



Q4--What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

WITH Tab_1 AS (
	SELECT customer_id, plan_name, p.plan_id, start_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date) AS Category_onboarding
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
)
SELECT *
FROM Tab_1
WHERE Category_onboarding = 2 AND start_date > '2020-12-31';


Q4--What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

WITH tab_2 AS ( SELECT COUNT(customer_id) AS churned_no
FROM (
	SELECT customer_id, plan_name, p.plan_id, start_date, price
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE plan_name = 'churn')
),
tab_3 AS ( 
	SELECT COUNT (DISTINCT customer_id) AS NO_OF_CUSTOMERS
FROM foodie_fi.subscriptions
			)
SELECT ROUND(churned_no::NUMERIC / NO_OF_CUSTOMERS, 1) *100  AS Rounded_churn
FROM tab_2
CROSS JOIN tab_3;


Q5--How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH tab_2 AS ( 
	SELECT COUNT(customer_id) AS churned_no
	FROM (
		SELECT customer_id, plan_name, p.plan_id, start_date, price
		FROM foodie_fi.plans p
		JOIN foodie_fi.subscriptions s
		ON p.plan_id = s.plan_id
		WHERE plan_name = 'churn')
),
tab_3 AS ( 
	SELECT COUNT (DISTINCT customer_id) AS NO_OF_CUSTOMERS
	FROM foodie_fi.subscriptions
			)
SELECT ROUND(churned_no::NUMERIC / NO_OF_CUSTOMERS, 1) *100  AS Rounded_churn
FROM tab_2
CROSS JOIN tab_3;

Q6--What is the number and percentage of customer plans after their initial free trial?

--customer plans after initial free trial= total number of plans - initial free trial

WITH Tab_4 AS 
	(SELECT COUNT (customer_id) AS NO_OF_CUSTOMERS
FROM foodie_fi.subscriptions
),
Tab_5 AS (
	SELECT COUNT(customer_id) AS Trial
	FROM (
	SELECT customer_id, plan_name, p.plan_id, start_date
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE plan_name = 'trial')
		 )
SELECT (NO_OF_CUSTOMERS - Trial) AS customer_plans_atrial
FROM tab_4
CROSS JOIN tab_5;

--percentage after trial

WITH Tab_4 AS 
	(SELECT COUNT (customer_id) AS NO_OF_CUSTOMERS
FROM foodie_fi.subscriptions
),
Tab_5 AS (
	SELECT COUNT(customer_id) AS Trial
	FROM (
	SELECT customer_id, plan_name, p.plan_id, start_date
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE plan_name = 'trial')
		 )
SELECT ROUND((NO_OF_CUSTOMERS - Trial)::NUMERIC/NO_OF_CUSTOMERS, 1)* 100  AS customer_plans_atrial
FROM tab_4
CROSS JOIN tab_5;

Q7--What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
SELECT customer_id, plan_name, p.plan_id, start_date
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE start_date = '2020-12-31';
	

Q8--How many customers have upgraded to an annual plan in 2020?
SELECT COUNT (customer_id) AS no_cus_annualplan
FROM (SELECT customer_id, plan_name, p.plan_id, start_date
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE start_date BETWEEN '2020-01-01' AND '2020-12-31'
	AND p.plan_id = '3');

Q9--How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH Tab_6 AS (SELECT customer_id, plan_name, p.plan_id, start_date AS annual_date
	FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE  p.plan_id = '3'
 ),
J_date AS (SELECT  start_date
			FROM foodie_fi.plans p
	JOIN foodie_fi.subscriptions s
	ON p.plan_id = s.plan_id
	WHERE  p.plan_id = '0'
			 )
SELECT 
    ROUND(AVG(annual_date::DATE - J.start_date::DATE) , 1) AS avg_days_to_subscribe 
FROM 
   Tab_6 
   CROSS JOIN J_date J
   WHERE annual_date IS NOT NULL AND J.start_date IS NOT NULL;


Q10--How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH plan_changes AS (
    SELECT 
        customer_id,
        plan_name,
        start_date,
        LEAD(plan_name) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan,
        LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_change_date
   FROM foodie_fi.plans p
JOIN foodie_fi.subscriptions s
ON p.plan_id = s.plan_id
)
SELECT COUNT(*)
FROM plan_changes
WHERE plan_name = 'pro monthly'
  AND next_plan = 'basic monthly'
  AND next_change_date IS NOT NULL
  AND next_change_date <= start_date + INTERVAL '1 year';

