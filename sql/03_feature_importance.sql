-- Create holiday view

CREATE OR REPLACE VIEW canadian_holidays AS
SELECT
    date,
    holiday_name,
    is_financial
FROM frostbyte_cs_public.PUBLIC_DATA_FREE.public_holiday_calendar
WHERE ISO_ALPHA2 = 'CA';

-- Training dataset with holidays

CREATE OR REPLACE VIEW allitems_vancouver AS
SELECT
    vs.timestamp,
    vs.menu_item_name,
    vs.total_sold,
    ch.holiday_name
FROM vancouver_sales vs
LEFT JOIN canadian_holidays ch
    ON vs.timestamp = ch.date;

-- Train multiseries forecast

CREATE OR REPLACE FORECAST vancouver_forecast(
    INPUT_DATA => SYSTEM$REFERENCE('VIEW','allitems_vancouver'),
    SERIES_COLNAME => 'MENU_ITEM_NAME',
    TIMESTAMP_COLNAME => 'TIMESTAMP',
    TARGET_COLNAME => 'TOTAL_SOLD'
);

-- Feature importance

CALL vancouver_forecast!EXPLAIN_FEATURE_IMPORTANCE();