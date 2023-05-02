{{
    config(materialized = 'table')
}}

with source as (
    select stg_pg_events.event_guid
    , stg_pg_events.session_guid
    , stg_pg_events.user_guid
    , stg_pg_events.page_url
    , stg_pg_events.event_type
    , stg_pg_events.created_at
    , stg_pg_products.product_guid 
    , stg_pg_products.name as product_name
    , stg_pg_products.price
    , stg_pg_products.inventory 
    , stg_pg_users.created_at as user_created_at
    from {{ ref('stg_postgres__events') }} stg_pg_events
    left join {{ ref('stg_postgres__products') }} stg_pg_products
        on stg_pg_products.product_guid = stg_pg_events.product_guid 
    left join {{ ref('stg_postgres__users') }} stg_pg_users
        on stg_pg_users.user_guid = stg_pg_events.user_guid                         
)

select
    event_guid
    , session_guid
    , user_guid
    , page_url
    , event_type
    , created_at
    , product_guid
    , product_name
    , price
    , inventory
    , user_created_at
from source