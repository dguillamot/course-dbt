SELECT *
FROM {{ ref('mart_product__dim_users') }}
WHERE first_order_created_at < user_created_at 
