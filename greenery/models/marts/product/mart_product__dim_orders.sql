{{
    config(materialized = 'table')
}}

with source as (
    select order_guid
        , user_guid
        , promo_guid
        , address_guid
        , created_at
        , order_cost
        , shipping_cost
        , order_total
        , tracking_guid
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status
        , row_number() over (partition by user_guid order by created_at) as order_sequence_for_user
    from {{ ref('stg_postgres__orders') }} stg_pg_orders
)

select
    order_guid
        , user_guid
        , promo_guid
        , address_guid
        , created_at
        , order_cost
        , shipping_cost
        , order_total
        , tracking_guid
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status
        , order_sequence_for_user
from source