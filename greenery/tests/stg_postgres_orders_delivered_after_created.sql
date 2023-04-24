SELECT *
FROM {{ ref('stg_postgres__orders') }}
WHERE delivered_at < created_at 
