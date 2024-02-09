from databricks.connect import DatabricksSession
from databricks.sdk.core import Config


config = Config(
    profile = "DEFAULT",
    cluster_id = "1129-041055-o6fv9zvr"
)


spark = DatabricksSession.builder.getOrCreate()

df = spark.read.table("samples.nyctaxi.trips")
df.show(5)