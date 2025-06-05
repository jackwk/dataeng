#!/bin/bash
# Yum update + git
sudo yum update -y
sudo yum groupinstall "Development Tools" -y
sudo yum install python3-devel -y

# Virtual environment
python3 -m venv dbt_duckdb
source dbt_duckdb/bin/activate

# Upgrade pip & install dbt & libraries
python3 -m pip install --upgrade pip
pip install dbt-core dbt-duckdb pandas matplotlib seaborn

# Download & install the DuckDB CLI 
wget https://github.com/duckdb/duckdb/releases/download/v1.2.2/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
chmod +x duckdb

# Move to a directory in your PATH 
sudo mv duckdb /usr/local/bin/
deactivate
