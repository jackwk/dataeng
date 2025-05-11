{{ config(materialized='table') }}

WITH city_data AS (
    SELECT
        city,
        country,
        population,
        city_size,
        latitude,
        longitude
    FROM {{ ref('dim_cities') }}
),

country_stats AS (
    SELECT
        country,
        total_population,
        avg_population,
        city_count
    FROM {{ ref('fct_country_city_stats') }}
),

education_data AS (
    SELECT
        country,
        city,
        university,
        program,
        level,
        duration_years,
        tuition_usd,
        living_cost_index,
        rent_usd,
        visa_fee_usd,
        insurance_usd,
        exchange_rate
    FROM {{ ref('stg_education_costs') }}
)

SELECT
    e.country,
    e.city,
    e.university,
    e.program,
    e.level,
    e.duration_years,
    
    -- City demographics
    c.population AS city_population,
    c.city_size,
    c.latitude,
    c.longitude,
    
    -- Country statistics
    cs.total_population AS country_population,
    cs.city_count,
    
    -- Education costs
    e.tuition_usd,
    e.rent_usd,
    e.living_cost_index,
    e.visa_fee_usd,
    e.insurance_usd,
    
    -- Derived metrics
    (e.tuition_usd * e.duration_years) AS total_tuition_cost,
    (e.rent_usd * 12 * e.duration_years) AS total_rent_cost,
    (e.insurance_usd * e.duration_years) AS total_insurance_cost,
    e.visa_fee_usd AS total_visa_cost,
    
    -- Total program cost
    (e.tuition_usd * e.duration_years) + 
    (e.rent_usd * 12 * e.duration_years) + 
    (e.insurance_usd * e.duration_years) + 
    e.visa_fee_usd AS total_program_cost,
    
    -- Cost per year
    ((e.tuition_usd * e.duration_years) + 
    (e.rent_usd * 12 * e.duration_years) + 
    (e.insurance_usd * e.duration_years) + 
    e.visa_fee_usd) / e.duration_years AS annual_cost,
    
    -- Affordability index (lower is more affordable)
    -- Normalized against living cost index
    ((e.tuition_usd + (e.rent_usd * 12) + e.insurance_usd) / 
    NULLIF(c.population / 1000000, 0)) * (e.living_cost_index / 100) AS affordability_index,
    
    -- Value rating (higher is better value)
    CASE 
        WHEN e.level = 'Master' AND e.program = 'Computer Science' THEN 
            (100 / NULLIF(((e.tuition_usd * e.duration_years) / 10000) * (e.living_cost_index / 75), 0)) * 
            CASE 
                WHEN c.city_size = 'Megacity' THEN 1.2
                WHEN c.city_size = 'Large City' THEN 1.1
                WHEN c.city_size = 'Medium City' THEN 1.0
                ELSE 0.9
            END
        WHEN e.level = 'Master' THEN 
            (90 / NULLIF(((e.tuition_usd * e.duration_years) / 10000) * (e.living_cost_index / 75), 0)) * 
            CASE 
                WHEN c.city_size = 'Megacity' THEN 1.2
                WHEN c.city_size = 'Large City' THEN 1.1
                WHEN c.city_size = 'Medium City' THEN 1.0
                ELSE 0.9
            END
        ELSE 
            (80 / NULLIF(((e.tuition_usd * e.duration_years) / 10000) * (e.living_cost_index / 75), 0)) * 
            CASE 
                WHEN c.city_size = 'Megacity' THEN 1.2
                WHEN c.city_size = 'Large City' THEN 1.1
                WHEN c.city_size = 'Medium City' THEN 1.0
                ELSE 0.9
            END
    END AS value_rating,
    
    -- Local currency tuition (using exchange rate)
    (e.tuition_usd / e.exchange_rate) AS tuition_local_currency,
    
    -- Cost relative to city size (lower is better)
    (e.tuition_usd / NULLIF(LOG(c.population), 0)) AS cost_to_population_ratio
    
FROM education_data e
LEFT JOIN city_data c
    ON LOWER(e.city) = LOWER(c.city) AND LOWER(e.country) = LOWER(c.country)
LEFT JOIN country_stats cs
    ON LOWER(e.country) = LOWER(cs.country)
