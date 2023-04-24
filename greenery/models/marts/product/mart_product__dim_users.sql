{{
    config(materialized = 'table')
}}

with source as (
    select stg_pg_users.user_guid
    , stg_pg_users.first_name
    , stg_pg_users.last_name
    , stg_pg_users.email
    , stg_pg_users.phone_number
    , stg_pg_users.created_at as user_created_at 
    , stg_pg_users.updated_at as user_updated_at
    , stg_pg_users.address_guid as user_address_guid
    , int_first_page_views.first_page_view_event_guid as first_page_view_event_guid
    , int_first_page_views.first_page_view_session_guid as first_page_view_session_guid
    , int_first_page_views.first_page_view_page_url as first_page_view_page_url
    , int_first_page_views.first_page_view_created_at as first_page_view_created_at
    , int_first_orders.first_order_order_guid as first_order_order_guid
    , int_first_orders.first_order_promo_guid as first_order_promo_guid
    , int_first_orders.first_order_address_guid as first_order_address_guid
    , int_first_orders.first_order_created_at as first_order_created_at
    , int_first_orders.first_order_order_cost as first_order_order_cost
    , int_first_orders.first_order_shipping_cost as first_order_shipping_cost
    , int_first_orders.first_order_order_total as first_order_order_total
    , int_first_orders.first_order_tracking_guid as first_order_tracking_guid
    , int_first_orders.first_order_shipping_service as first_order_shipping_service
    , int_first_orders.first_order_estimated_delivery_at as first_order_estimated_delivery_at
    , int_first_orders.first_order_delivered_at as first_order_delivered_at
    , int_first_orders.first_order_status as first_order_status
    from {{ ref('stg_postgres__users') }} stg_pg_users
    left join {{ ref('int_user_first_page_views') }} int_first_page_views
        on stg_pg_users.user_guid = int_first_page_views.user_guid 
    left join {{ ref('int_user_first_orders') }} int_first_orders
        on stg_pg_users.user_guid = int_first_orders.user_guid
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
    , first_page_view_event_guid
    , first_page_view_session_guid
    , first_page_view_page_url
    , first_page_view_created_at
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