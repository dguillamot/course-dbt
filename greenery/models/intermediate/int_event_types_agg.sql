{{
    config(materialized = 'table')
}}

{{ event_types_agg() }}
