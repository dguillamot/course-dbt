# Project 3

## 1.A What is our overall conversion rate?
62.46%
```sql
select SUM(case when event_type = 'checkout' and event_type_order = 1 then 1 else 0 end) as num_sessions_with_checkout 
, count(distinct session_guid) as num_sessions
,  cast(round((num_sessions_with_checkout / num_sessions) * 100,2) as decimal(36,2)) as conversion_rate
from dbt_danieloutschoolcom.int_events_ranked
```


## 1.B What is our conversion rate by product?
PRODUCT NAME	CONVERSION_RATE
String of pearls	60.94
Arrow Head	        55.56
Cactus	            54.55
ZZ Plant	        53.97
Bamboo	53.73
Rubber Plant	51.85
Monstera	51.02
Calathea Makoyana	50.94
Fiddle Leaf Fig	50
Majesty Palm	49.25
Aloe Vera	49.23
Devil's Ivy	48.89
Philodendron	48.39
Jade Plant	47.83
Pilea Peperomioides	47.46
Spider Plant	47.46
Dragon Tree	46.77
Money Tree	46.43
Orchid	45.33
Bird of Paradise	45
Ficus	42.65
Birds Nest Fern	42.31
Pink Anthurium	41.89
Boston Fern	41.27
Alocasia Polly	41.18
Peace Lily	40.91
Ponytail Palm	40
Snake Plant	39.73
Angel Wings Begonia	39.34
Pothos	34.43
```sql
with product_session_views as
(
    select product_guid
    , count(distinct session_guid) as num_sessions_with_product_page_view
    from dbt_danieloutschoolcom.int_events_ranked
    where event_type = 'page_view'
    -- and event_type_order = 1
    and product_guid is not null
    group by product_guid
    order by product_guid
), product_purchases as (
    select product_guid
    , count(distinct session_guid) as num_sessions_with_product_order
    from dbt_danieloutschoolcom.mart_product__dim_order_items
    group by product_guid
)
select product_session_views.product_guid
, stg_postgres__products.name
, product_session_views.num_sessions_with_product_page_view
, product_purchases.num_sessions_with_product_order
, cast(round(((product_purchases.num_sessions_with_product_order * 100) / product_session_views.num_sessions_with_product_page_view),2) as decimal(36,2)) as conversion_rate
from product_session_views
left join product_purchases
    on product_session_views.product_guid = product_purchases.product_guid
left join stg_postgres__products
    on product_session_views.product_guid = stg_postgres__products.product_guid
order by conversion_rate desc

```

