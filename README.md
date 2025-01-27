About the data

Foodie-Fi is a subscription-based streaming platform focused exclusively on food-related content. Launched in 2020, the company offers multiple subscription plans designed to cater to different user needs, including free trials, monthly options, annual subscriptions, and cancellations. The case study presents an opportunity to analyze customer journeys, subscription trends, and revenue streams using two key tables:

Plans Table
This table outlines the details of each subscription plan:

plan_id: A unique identifier for each plan.
plan_name: The name of the subscription plan (e.g., "Trial", "Basic Monthly", "Pro Monthly", "Pro Annual", "churn" ).
price: The associated cost of the plan.


Subscriptions Table
This table records customer activity and includes:

customer_id: A unique identifier for each customer.
plan_id: The subscription plan the customer selected, linked to the Plans table.
start_date: The date the customer began a specific plan.


DATA
Source of the data:
The source of this data was gotten originally from DannyMa's SQL challenge. Source www.datawithdanny.com



Challenges that this particular project solve  is to help understand customer behavior during the onboarding process, including transitions from free trials to paid plans.

Relevants questions asked are:

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?