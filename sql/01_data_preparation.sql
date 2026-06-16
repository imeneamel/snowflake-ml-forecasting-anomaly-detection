-- Create database and schema

CREATE OR REPLACE DATABASE quickstart;
CREATE OR REPLACE SCHEMA ml_functions;

USE DATABASE quickstart;
USE SCHEMA ml_functions;

-- Create warehouse

CREATE OR REPLACE WAREHOUSE quickstart_wh;
USE WAREHOUSE quickstart_wh;

-- Create CSV format

CREATE OR REPLACE FILE FORMAT csv_ff
TYPE = CSV
SKIP_HEADER = 1;

-- Create stage

CREATE OR REPLACE STAGE s3load
URL='s3://sfquickstarts/frostbyte_tastybytes/mlpf_quickstart/'
FILE_FORMAT = csv_ff;

-- Create sales table

CREATE OR REPLACE TABLE tasty_byte_sales(
    DATE DATE,
    PRIMARY_CITY STRING,
    MENU_ITEM_NAME STRING,
    TOTAL_SOLD NUMBER
);

-- Load data

COPY INTO tasty_byte_sales
FROM @s3load/ml_functions_quickstart.csv;