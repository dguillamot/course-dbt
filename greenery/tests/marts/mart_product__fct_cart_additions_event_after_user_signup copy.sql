SELECT *
FROM {{ ref('mart_product__fct_cart_additions') }}
WHERE created_at < user_created_at
