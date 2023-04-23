# Project 2

### 1. What is our user repeat rate?
79.84%

```sql
WITH orders_per_user_table as (
    SELECT user_guid
    , COUNT(distinct order_guid) as orders_per_user
    FROM dev_db.dbt_danieloutschoolcom.stg_postgres__orders
    GROUP BY user_guid
),

user_order_counts as (
    SELECT orders_per_user
    , COUNT(distinct user_guid) as num_users_with_this_many_orders
    FROM orders_per_user_table
    GROUP BY orders_per_user
)

SELECT SUM(case when orders_per_user >= 2 then num_users_with_this_many_orders else 0 end) as num_repeat_users  
, SUM(case when orders_per_user < 2 then num_users_with_this_many_orders else 0 end) as num_non_repeat_users
, (num_repeat_users / (num_repeat_users + num_non_repeat_users)) * 100 as user_repeat_rate
FROM user_order_counts;
```


### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

* What is the first and last touch attribution for the user (ie did this user come to Greenery via Google organic search? Via paid facebook ad?). And, what does our data show about the repeat rate for users across different attribution channels?

* Was this user's first purchase via promo code or not? What does our data show about repeat rate for users whose first purchase was via promo code or not?

* For their first oder, was the user's delivered at time less than the estimated delivery date, or was it late? What does our data show about the repeat rate for users who had a late delivery on their first order?

* What state is this user from? What does our data show about repeat rate per state (and country)? Are certain states better-suited for our product inventory (ie humid vs dry states, cool vs warm). 

* What website engagement level have we detected for this user? How many page views did they do before (and after) their first purchase? How long were their user sessions before (and after) their first purchase? What does our data show about repeat rates based on this data?

* How many, and what types of items were in the user's first order? For user's who purchase plants, what is the repeat rate for users who also purchased fertilizer with their order vs those who did not also buy fertilizer as part of their first order?

* Was the user's first order a gift?



### Explain the product mart models you added. Why did you organize the models in the way you did?

## 1 - mart_product__fct_page_views

This model exists to explore page view event data. We anticipate using it to answer questions suchs as:

* 
