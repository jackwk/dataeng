# Yum update
sudo yum update -y
sudo yum install git -y

# Create a virtual environment
python3 -m venv dbt_duckdb

# Activate the virtual environment
source dbt_duckdb/bin/activate

# Upgrade pip & install everything
python3 -m pip install --upgrade pip
pip install dbt-core dbt-duckdb pandas matplotlib seaborn

# verify installation 
python3 -c "import duckdb; print(duckdb.__version__)"
dbt --help

# Download & install the DuckDB CLI 
wget https://github.com/duckdb/duckdb/releases/download/v1.2.2/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
chmod +x duckdb

# Move to a directory in your PATH (optional) - This allows you to run 'duckdb' from anywhere
sudo mv duckdb /usr/local/bin/

# Install plugins for duckdb
dbt init dataeng

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

# other stuff
# Start UI from shell
duckdb -ui

# Start UI from duckdb
CALL start_ui();

# Next steps

