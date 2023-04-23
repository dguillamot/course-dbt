{{
    config(materialized = 'table')
}}

with source as (
    select stg_pg_order_items.order_item_guid as order_item_guid
    , stg_pg_order_items.order_guid as order_guid
    , stg_pg_order_items.product_guid as product_guid
    , stg_pg_order_items.quantity as quantity
    from {{ ref('stg_postgres__order_items') }} stg_pg_order_items
    left join {{ ref('stg_postgres__products') }} stg_pg_products
        on stg_pg_order_items.product_guid = stg_pg_products.product_guid                         
    left join {{ ref('stg_postgres__orders') }} stg_pg_orders
        on stg_pg_order_items.order_guid = stg_pg_orders.order_guid         
)

select
    order_item_guid
    , order_guid
    , product_guid
    , quantity
from source