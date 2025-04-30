SELECT
    country,
    iso2,
    iso3,
    COUNT(*) AS city_count,
    SUM(population) AS total_population,
    AVG(population) AS avg_population,
    SUM(CASE WHEN city_size = 'Megacity' THEN 1 ELSE 0 END) AS megacity_count,
    SUM(CASE WHEN city_size = 'Large City' THEN 1 ELSE 0 END) AS large_city_count,
    SUM(CASE WHEN city_size = 'Medium City' THEN 1 ELSE 0 END) AS medium_city_count,
    SUM(CASE WHEN city_size = 'Small City' THEN 1 ELSE 0 END) AS small_city_count,
    MAX(population) AS max_city_population,
    -- Optionally, get the name of the largest city
    MAX_BY(city, population) AS largest_city
FROM {{ ref('dim_cities') }}
GROUP BY country, iso2, iso3
