{{
    config(materialized = 'table')
}}


WITH first_orders as (
    SELECT o.user_guid
        , min(o.created_at) as first_order_created_at
    FROM stg_postgres__orders o
    GROUP BY o.user_guid
), first_orders_full as (
    SELECT *
    FROM stg_postgres__orders o2
    WHERE o2.created_at IN (
        SELECT fo.first_order_created_at FROM first_orders fo
    )
), source as (
    select stg_pg_users.user_guid
    , stg_pg_users.first_name
    , stg_pg_users.last_name
    , stg_pg_users.email
    , stg_pg_users.phone_number
    , stg_pg_users.created_at as user_created_at
    , stg_pg_users.updated_at as user_updated_at
    , stg_pg_users.address_guid as user_address_guid 
    , user_first_orders.order_guid as first_order_order_guid
    , user_first_orders.promo_guid as first_order_promo_guid
    , user_first_orders.address_guid as first_order_address_guid
    , user_first_orders.created_at as first_order_created_at
    , user_first_orders.order_cost as first_order_order_cost
    , user_first_orders.shipping_cost as first_order_shipping_cost
    , user_first_orders.order_total as first_order_order_total
    , user_first_orders.tracking_guid as first_order_tracking_guid
    , user_first_orders.shipping_service as first_order_shipping_service
    , user_first_orders.estimated_delivery_at as first_order_estimated_delivery_at
    , user_first_orders.delivered_at as first_order_delivered_at
    , user_first_orders.status as first_order_status
    from {{ ref('stg_postgres__users') }} stg_pg_users
    left join first_orders_full user_first_orders
        on user_first_orders.user_guid = stg_pg_users.user_guid  
)

select
    user_guid
    , first_name
    , last_name
    , email
    , phone_number
    , user_created_at
    , user_updated_at
    , user_address_guid 
    , first_order_order_guid
    , first_order_promo_guid
    , first_order_address_guid
    , first_order_created_at
    , first_order_order_cost
    , first_order_shipping_cost
    , first_order_order_total
    , first_order_tracking_guid
    , first_order_shipping_service
    , first_order_estimated_delivery_at
    , first_order_delivered_at
    , first_order_status
from source