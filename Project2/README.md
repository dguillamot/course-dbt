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

* (segmentation) Which products get the most/least page views

* (cohort analysis) Are users who signed up in November doing more page views than users who signed up in October?



## 2 - mart_product__fct_cart_additions

This model exists to explore cart addition event data. We anticipate using it to answer questions suchs as:

* (segmentation) Which products get added into carts the most

* (cohort analysis) For the last 6 months, which are the top 10 products that were added into carts the most?

* (funnel analysis) Which products have the highest page_view to cart_addition ratio (using mart_product__fct_page_views in combination with mart_product__fct_cart_additions)



## 3 - mart_product__fct_checkouts

This model exists to explore checkout events. We've joined order_items and orders and product and addresses and users tables in order to be able to analyze checkouts across various dimensions. This model can answer questions such as:

* (segmentation) Which of our products are generating the most/least checkouts?
** How does this different from state to state and country to country using the shipping destination?

* (funnel) when combined with fct_cart_additions, which products are seeing a high checkour rate after being added to a cart?
** NOTE - we will create a separate fct_product_funnel table to do this kind of analysis as well which will combine add_to_cart, checkout, and package_shipped events

* (funnel) What is the rate of page_views to checkout for each product? For each state? 

* (segmentation) Which of our promotional campaigns are generating the most page views?

* (cohort) What % of users who signed up in January, did at least 1 checkout every month during their first 3 months? 
** compare that to users who signed up in December 2022, Nov 2022 etc etc



## 4 - mart_product__fct_package_shippings

This model exists to explore shipping events. We've joined order_items and orders and product and addresses and users tables in order to be able to analyze shippings across various dimensions. This model can answer questions such as:

* (segmentation) Which shipping service has the best shipping costs and speed per zip code?

* (segmentation) Which shipping service has the best shipping speed (and success delivering within expected_delivery_at) per zip code?

* (funnel) How long does it take for a product to go from add_to_cart, through checkout and package_shipped all the way to order_status delivered
** NOTE - we will create a separate fct_product_funnel table to do this kind of analysis as well which will combine add_to_cart, checkout, and package_shipped events

* (funnel) What is the rate of page_views to checkout for each product? For each state? 

* (cohort) Which shipping service are Nov, Dec, January users choosing to select at checkout over time?






### dbt docs DAG image

<img width="902" alt="Screenshot 2023-04-23 at 5 47 29 PM" src="https://user-images.githubusercontent.com/12869509/233873025-decab3e3-11a4-48e2-9663-b2c66d4fb37d.png">





