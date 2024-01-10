-- Databricks notebook source
CREATE
OR REPLACE TABLE _persist.default.test LOCATION 's3://databricks-zaxier-persistent-storage/external-location1/test/rastxqv/' TBLPROPERTIES(
  'delta.universalFormat.enabledFormats' = 'iceberg',
  'delta.enableDeletionVectors' = false
) AS
SELECT
  col1 as id
FROM
VALUES
  0,
  1,
  2,
  3,
  4;

-- COMMAND ----------

CREATE
OR REPLACE TABLE _persist.default.nyc_taxi_trips USING DELTA LOCATION 's3://databricks-zaxier-persistent-storage/external-location1/nyctaxi/trips' TBLPROPERTIES(
  'delta.universalFormat.enabledFormats' = 'iceberg',
  'delta.enableDeletionVectors' = false
) AS
SELECT
  *
FROM
  samples.nyctaxi.trips;
