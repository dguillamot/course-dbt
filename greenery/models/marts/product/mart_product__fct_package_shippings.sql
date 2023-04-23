{{
    config(materialized = 'table')
}}

with source as (
    select stg_pg_events.event_guid
    , stg_pg_events.session_guid
    , stg_pg_events.user_guid
    , stg_pg_events.page_url
    , stg_pg_events.created_at
    , stg_pg_products.product_guid 
    , stg_pg_products.name as product_name
    , stg_pg_products.price
    , stg_pg_order_items.order_item_guid as order_item_guid
    , stg_pg_order_items.quantity as order_item_quantity    
    , stg_pg_products.inventory 
    , stg_pg_orders.order_guid
    , stg_pg_orders.promo_guid
    , stg_pg_orders.address_guid
    , stg_pg_orders.created_at as order_created_at
    , stg_pg_orders.order_cost
    , stg_pg_orders.shipping_cost
    , stg_pg_orders.order_total
    , stg_pg_orders.tracking_guid
    , stg_pg_orders.shipping_service
    , stg_pg_orders.estimated_delivery_at
    , stg_pg_orders.delivered_at
    , stg_pg_orders.status as order_status
    , stg_pg_promos.discount as promo_discount
    , stg_pg_promos.status as promo_status
    , stg_pg_addresses.state as order_address_state
    , stg_pg_addresses.zip_code as order_address_zip_code
    , stg_pg_addresses.country as order_address_country
    , stg_pg_users.created_at as user_created_at
    from {{ ref('stg_postgres__events') }} stg_pg_events
    left join {{ ref('stg_postgres__order_items') }} stg_pg_order_items
        on stg_pg_order_items.order_guid = stg_pg_events.order_guid     
    left join {{ ref('stg_postgres__products') }} stg_pg_products
        on stg_pg_products.product_guid = stg_pg_order_items.product_guid 
    left join {{ ref('stg_postgres__orders') }} stg_pg_orders
        on stg_pg_orders.order_guid = stg_pg_order_items.order_guid         
    left join {{ ref('stg_postgres__promos') }} stg_pg_promos
        on stg_pg_promos.promo_guid = stg_pg_orders.promo_guid    
    left join {{ ref('stg_postgres__addresses') }} stg_pg_addresses
        on stg_pg_addresses.address_guid = stg_pg_orders.address_guid              
    left join {{ ref('stg_postgres__users') }} stg_pg_users
        on stg_pg_users.user_guid = stg_pg_events.user_guid                         
    WHERE stg_pg_events.event_type = 'package_shipped'
)

select
    event_guid
    , session_guid
    , user_guid
    , page_url
    , created_at
    , order_guid
    , product_guid
    , product_name
    , price
    , order_item_guid
    , order_item_quantity
    , inventory
    , promo_guid
    , address_guid
    , order_created_at
    , order_cost
    , shipping_cost
    , order_total
    , tracking_guid
    , shipping_service
    , estimated_delivery_at
    , delivered_at
    , order_status
    , promo_discount
    , promo_status
    , order_address_state
    , order_address_zip_code
    , order_address_country
    , user_created_at
from source