{{
    config(materialized = 'table')
}}

with source as (
    select stg_pg_orders_items.order_item_guid
    , stg_pg_orders_items.order_guid
    , stg_pg_orders_items.product_guid
    , stg_pg_events.session_guid as session_guid
    , stg_pg_orders_items.quantity
    from {{ ref('stg_postgres__order_items') }} stg_pg_orders_items
    left join {{ ref('stg_postgres__events') }} stg_pg_events
        on stg_pg_orders_items.order_guid = stg_pg_events.order_guid 
)

select
    *
from source