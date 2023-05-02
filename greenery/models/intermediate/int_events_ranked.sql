{{
    config(materialized = 'table')
}}


with source as (
select *
    , row_number() over (partition by session_guid, event_type order by created_at) event_type_order
from  {{ ref('stg_postgres__events') }}
)

select
    *
from source