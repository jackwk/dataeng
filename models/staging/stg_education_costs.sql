select
    country,
    city,
    university,
    program,
    level,
    duration_years::numeric as duration_years,
    tuition_usd::numeric as tuition_usd,
    living_cost_index::numeric as living_cost_index,
    rent_usd::numeric as rent_usd,
    visa_fee_usd::numeric as visa_fee_usd,
    insurance_usd::numeric as insurance_usd,
    exchange_rate::numeric as exchange_rate
from read_csv('s3://dataeng-duckdb-dbt/International_Education_Costs.csv', AUTO_DETECT=TRUE)

