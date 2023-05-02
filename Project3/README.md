# Project 3

## 1.A What is our overall conversion rate?
62.46%
```sql
select SUM(case when event_type = 'checkout' and event_type_order = 1 then 1 else 0 end) as num_sessions_with_checkout 
, count(distinct session_guid) as num_sessions
,  cast(round((num_sessions_with_checkout / num_sessions) * 100,2) as decimal(36,2)) as conversion_rate
from dbt_danieloutschoolcom.int_events_ranked
```


## 1.B What is our conversion rate by product?
62.46%
```sql
select SUM(case when event_type = 'checkout' and event_type_order = 1 then 1 else 0 end) as num_sessions_with_checkout 
, count(distinct session_guid) as num_sessions
,  cast(round((num_sessions_with_checkout / num_sessions) * 100,2) as decimal(36,2)) as conversion_rate
from dbt_danieloutschoolcom.int_events_ranked
```


