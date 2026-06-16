-- Create view for Lobster Mac & Cheese

CREATE OR REPLACE VIEW lobster_sales AS
SELECT
    timestamp,
    total_sold
FROM vancouver_sales
WHERE menu_item_name = 'Lobster Mac & Cheese';

-- Train forecast model

CREATE OR REPLACE FORECAST lobstermac_forecast(
    INPUT_DATA => SYSTEM$REFERENCE('VIEW','lobster_sales'),
    TIMESTAMP_COLNAME => 'TIMESTAMP',
    TARGET_COLNAME => 'TOTAL_SOLD'
);

-- Generate predictions

CALL lobstermac_forecast!FORECAST(
    FORECASTING_PERIODS => 10
);