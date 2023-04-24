# Project 2

## 1. What is our user repeat rate?
79.84%

### Query using new dim_orders model and order_sequence_for_user column (Week 2)
```
with num_orders_per_user as (
    select user_guid
    , max(order_sequence_for_user) as num_orders_for_user
    from dbt_danieloutschoolcom.mart_product__dim_orders 
    group by user_guid
)
select sum(case when nopu.num_orders_for_user = 1 then 1 else 0 end) as num_single_purchase_users 
, sum(case when nopu.num_orders_for_user > 1 then 1 else 0 end) as num_multiple_purchase_users
, num_multiple_purchase_users / (num_multiple_purchase_users + num_single_purchase_users) * 100
from num_orders_per_user nopu
```

### Query using models from Week 1
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

## 1 - int_user_first_page_views

This model exists as an intermediate model to combine a user's first page view information with the rest of the user's data. We anticipate using it to answer questions such as:

* What is the expected LTV (Lifetime Value) for users whose first page view was a product page vs a search listings page vs the homepage (combined with mart_product__fct_checkouts)

* How often are users landing on homepage vs search listings page vs product page?

* Do users landing on homepage, search listings page or product page have a higher conversion rate (checkout event)? (combine with mart_product__fct_checkouts)



## 2 - int_user_first_orders

This model exists as an intermediate model to combine a user's first order information with the rest of the user's data. We anticipate using it to answer questions such as:

* What is the expected LTV (Lifetime Value) for users whose first purchase is less than $50, greater than $50, greater than $100 (combined with mart_product__fct_checkouts)

* How often are promo codes used for a user's first purchase, versus follow-on purchases (combined with mart_product__fct_checkouts)

* For re-activation and resurrection campaigns, what type of products work well as a user's first purchase, to upsell them onto a second purchase?



## 3 - mart_product__dim_users

This model represents our users and includes the data from stg_postgres__users as well as information on each user's first page view and first order if it exists. We anticipate using it to answer questions such as:

* (segmentation) How many users come to the site first via the homepage, search listings or product page?

* (funnel) How many users have had an order shipped within the first 30 days of them signing up?

* (cohort) What is the value of the first order for all users who signed up in November 2022 vs December 2022 vs January 2023?



## 3 - mart_product__dim_orders

This model represents our orders and adds a field order_sequence_for_user which represents if this was the user's first, second, third etc purchase. We anticipate using it to answer questions such as:

* (segmentation) How many users had their first purchase in January, 2023?

* (segmentation) How many users had a follow-on (2nd, 3rd, 4th, etc) purchase in January, 2023?

* (funnel) On average, how long does it take from a user's first purchase to their second purchase?

* (cohort) What % of users who signed up in November, 2022 made a follow-on (2nd, 3rd, 4th) purcahse 3 months later, in February 2023? (combine with mart_product__dim_users)

* (segmentation) Who are our most frequent purchasers? (order_sequence_for_user > 5) and what do their late-cycle orders look like?



## 5 - mart_product__fct_page_views

This model exists to explore page view event data. We anticipate using it to answer questions such as:

* (segmentation) Which products get the most/least page views

* (cohort analysis) Are users who signed up in November doing more page views than users who signed up in October?



## 6 - mart_product__fct_cart_additions

This model exists to explore cart addition event data. We anticipate using it to answer questions such as:

* (segmentation) Which products get added into carts the most

* (cohort analysis) For the last 6 months, which are the top 10 products that were added into carts the most?

* (funnel analysis) Which products have the highest page_view to cart_addition ratio (using mart_product__fct_page_views in combination with mart_product__fct_cart_additions)



## 7 - mart_product__fct_checkouts

This model exists to explore checkout events. We've joined order_items and orders and product and addresses and users tables in order to be able to analyze checkouts across various dimensions. This model can answer questions such as:

* (segmentation) Which of our products are generating the most/least checkouts?
** How does this different from state to state and country to country using the shipping destination?

* (funnel) when combined with fct_cart_additions, which products are seeing a high checkour rate after being added to a cart?
** NOTE - we will create a separate fct_product_funnel table to do this kind of analysis as well which will combine add_to_cart, checkout, and package_shipped events

* (funnel) What is the rate of page_views to checkout for each product? For each state? 

* (segmentation) Which of our promotional campaigns are generating the most page views?

* (cohort) What % of users who signed up in January, did at least 1 checkout every month during their first 3 months? 
** compare that to users who signed up in December 2022, Nov 2022 etc etc



## 8 - mart_product__fct_package_shippings

This model exists to explore shipping events. We've joined order_items and orders and product and addresses and users tables in order to be able to analyze shippings across various dimensions. This model can answer questions such as:

* (segmentation) Which shipping service has the best shipping costs and speed per zip code?

* (segmentation) Which shipping service has the best shipping speed (and success delivering within expected_delivery_at) per zip code?

* (funnel) How long does it take for a product to go from add_to_cart, through checkout and package_shipped all the way to order_status delivered
** NOTE - we will create a separate fct_product_funnel table to do this kind of analysis as well which will combine add_to_cart, checkout, and package_shipped events

* (funnel) What is the rate of page_views to checkout for each product? For each state? 

* (cohort) Which shipping service are Nov, Dec, January users choosing to select at checkout over time?






## dbt docs DAG image

<img width="1549" alt="Screenshot 2023-04-23 at 11 51 02 PM" src="https://user-images.githubusercontent.com/12869509/233910473-7e47d64b-5e92-4a17-915e-f8ef924e2e24.png">




## Testing Quality and Monitoring

### Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would run a freshness test, checking that every day there is new data being loaded into the data warehouse. I would set up dbt CI/CD to also run tests whenever changes are made to our dbt repo. Any errors would be set up to fire a slack alert in #data-team-alerts as well as #data-pulse slack channels (if they exist).



## Inventory Snapshot
The following products had updated inventory between week 1 and week 2: 

Pothos, Philodendron, Monstera, String of pearls


```
SELECT product_id, name, inventory
FROM dbt_danieloutschoolcom.inventory_snapshot
WHERE dbt_valid_to is not NULL
GROUP BY product_id, name, inventory
;
```
