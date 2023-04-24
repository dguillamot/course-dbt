{{
    config(materialized = 'table')
}}


WITH first_page_views as (
    SELECT e.user_guid
        , min(e.created_at) as first_page_view_created_at
    FROM stg_postgres__events e
    GROUP BY e.user_guid
), first_page_views_full as (
    SELECT *
    FROM stg_postgres__events e2
    WHERE e2.created_at IN (
        SELECT fpv.first_page_view_created_at FROM first_page_views fpv
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
    , user_first_page_views.event_guid as first_page_view_event_guid
    , user_first_page_views.session_guid as first_page_view_session_guid
    , user_first_page_views.page_url as first_page_view_page_url
    , user_first_page_views.created_at as first_page_view_created_at
    from {{ ref('stg_postgres__users') }} stg_pg_users
    left join first_page_views_full user_first_page_views
        on user_first_page_views.user_guid = stg_pg_users.user_guid  
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
from source