SELECT
    city,
    city_ascii,
    CAST(lat AS DOUBLE) AS latitude,
    CAST(lng AS DOUBLE) AS longitude,
    country,
    iso2,
    iso3,
    admin_name,
    capital,
    CAST(population AS BIGINT) AS population,
    id
FROM read_csv('s3://dataeng-duckdb-dbt/worldcities.csv', AUTO_DETECT=TRUE)
