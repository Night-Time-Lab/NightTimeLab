from pyspark.sql import SparkSession
from pyspark import SparkContext

# Create Spark Context
sc = SparkContext()
# Create the RDD
data = sc.parallelize(["1","2","3","4","5","6","7","8","9","10"])

print("Output : " + str(data.collect()))

scriptPath = "java Square"
pipeRDD = data.pipe(scriptPath)

print("Output : " + str(pipeRDD.collect()))