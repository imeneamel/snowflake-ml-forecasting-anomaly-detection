-- Training dataset

CREATE OR REPLACE VIEW vancouver_anomaly_training_set AS
SELECT *
FROM vancouver_sales
WHERE timestamp <
(
    SELECT MAX(timestamp)
    FROM vancouver_sales
) - INTERVAL '1 MONTH';

-- Analysis dataset

CREATE OR REPLACE VIEW vancouver_anomaly_analysis_set AS
SELECT *
FROM vancouver_sales
WHERE timestamp >
(
    SELECT MAX(timestamp)
    FROM vancouver_anomaly_training_set
);

-- Train anomaly detection model

CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION
vancouver_anomaly_model(
    INPUT_DATA => SYSTEM$REFERENCE('VIEW','vancouver_anomaly_training_set'),
    SERIES_COLNAME => 'MENU_ITEM_NAME',
    TIMESTAMP_COLNAME => 'TIMESTAMP',
    TARGET_COLNAME => 'TOTAL_SOLD',
    LABEL_COLNAME => ''
);

-- Detect anomalies

CALL vancouver_anomaly_model!DETECT_ANOMALIES(
    INPUT_DATA => SYSTEM$REFERENCE('VIEW','vancouver_anomaly_analysis_set'),
    SERIES_COLNAME => 'MENU_ITEM_NAME',
    TIMESTAMP_COLNAME => 'TIMESTAMP',
    TARGET_COLNAME => 'TOTAL_SOLD',
    CONFIG_OBJECT => {'prediction_interval':0.95}
);