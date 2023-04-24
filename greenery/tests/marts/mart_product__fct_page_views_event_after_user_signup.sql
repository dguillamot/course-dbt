SELECT *
FROM {{ ref('mart_product__fct_page_views') }}
WHERE created_at < user_created_at
