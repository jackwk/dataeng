{{ config(materialized='table') }}

SELECT
    id,
    city,
    city_ascii,
    latitude,
    longitude,
    country,
    iso2,
    iso3,
    admin_name,
    capital,
    population,
    -- Additional transformations as needed
    CASE 
        WHEN population > 10000000 THEN 'Megacity'
        WHEN population > 1000000 THEN 'Large City'
        WHEN population > 100000 THEN 'Medium City'
        ELSE 'Small City'
    END AS city_size
FROM {{ ref('stg_cities') }}

