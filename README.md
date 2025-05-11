# Install plugins for duckdb
dbt init dataeng

cd dataeng

duckdb dataeng.duckdb
INSTALL aws;
LOAD aws;
INSTALL httpfs;
LOAD httpfs;

# Configure dbt profile, models, sources
models/staging/stg_cities.sql
models/sources/sources.yml
dbt_project.yml

# Check if it's working
SELECT * FROM read_csv_auto('s3://dataeng-duckdb-dbt/worldcities.csv', AUTO_DETECT=TRUE) LIMIT 5;
duckdb dataeng.duckdb -c "select * from stg_cities;"
duckdb dataeng.duckdb -c "select distinct(iso2) from stg_cities;"

# other stuff
# Start UI from shell
duckdb -ui

# Start UI from duckdb
CALL start_ui();

# Run single dbt model
dbt run --models marts.dim_cities
