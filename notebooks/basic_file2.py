# Databricks notebook source
df = spark.read.table("samples.nyctaxi.trips")
df.show(5)