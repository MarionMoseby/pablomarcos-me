---
title: "Hack Data"
author: Pablo Marcos
date: 2021-10-14
math: true
menu:
  sidebar:
    name: Hack Data
    identifier: big_data_master_hack_data
    parent: big_data_master
    weight: 40
---

A technology start-up in California has recently been hacked, and their forensic engineers have grabbed valuable information, including information like session time,locations, wpm typing speed, etc, to identify the hackers. Your goal is to use SparkML to do this.

<div style="text-align: center">
    <a href="./Hack_Data.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

#### Initial Steps

First, we need to create the Spark Session


```python
#In collab, we need to install everything:
!apt-get install openjdk-8-jdk-headless -qq > /dev/null
!wget -q https://mirrors.sonic.net/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
!tar xzf spark-3.1.2-bin-hadoop3.2.tgz
!pip install -q findspark


import os
os.environ["JAVA_HOME"] = "/usr/lib/jvm/java-8-openjdk-amd64"
os.environ["SPARK_HOME"] = "/content/spark-3.1.2-bin-hadoop3.2"


import findspark
findspark.init()
from pyspark.sql import SparkSession
spark = SparkSession.builder.master("local[*]").getOrCreate()

#In a native Jupyter notebook, we would simply do:
#from pyspark.sql import SparkSession
#spark = SparkSession.builder.appName('seedfinder').getOrCreate()
```

Afterwards, we can read the file and inspect it


```python
#Please drop the file in the environments 'Files' panel
df = spark.read.options(header="true", inferSchema="true").csv("/content/hack_data.csv")
df.describe().toPandas()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>summary</th>
      <th>Session_Connection_Time</th>
      <th>Bytes Transferred</th>
      <th>Kali_Trace_Used</th>
      <th>Servers_Corrupted</th>
      <th>Pages_Corrupted</th>
      <th>Location</th>
      <th>WPM_Typing_Speed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>30.008982035928145</td>
      <td>607.2452694610777</td>
      <td>0.5119760479041916</td>
      <td>5.258502994011977</td>
      <td>10.838323353293413</td>
      <td>None</td>
      <td>57.342395209580864</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>14.088200614636158</td>
      <td>286.33593163576757</td>
      <td>0.5006065264451406</td>
      <td>2.30190693339697</td>
      <td>3.06352633036022</td>
      <td>None</td>
      <td>13.41106336843464</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>1.0</td>
      <td>10.0</td>
      <td>0</td>
      <td>1.0</td>
      <td>6.0</td>
      <td>Afghanistan</td>
      <td>40.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>60.0</td>
      <td>1330.5</td>
      <td>1</td>
      <td>10.0</td>
      <td>15.0</td>
      <td>Zimbabwe</td>
      <td>75.0</td>
    </tr>
  </tbody>
</table>
</div>

#### Deciding on the features of the Model

The idea for this assignment is to use clustering methods to see if we can find which attacks belong to which hacker: essentially, we want to create n number of groups of attacks, where n is the number of involved hackers. We are also told that hackers like to equally divide work; so, for example, if we have (as we do) 335 attacks and 3 hackers, each would do 110 attacks; if, however, we only had 2 hackers, each would only do 165 attacks, and so on. I will use K-means clustering, which is not surprising, given its the only one we have been told how to use 😋.

We were told the "Location" feature is not really important due to VPN use, but I think including it might be interesting nonetheless, if not for the final result, just to learn a bit! So, here I use the StringIndexer to convert it to string format:


```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer

#Bonus! Change this code to index multiple columns at once!
indexers = [StringIndexer(inputCol=column, outputCol=column+"_index").fit(df) for column in list(["Location"]) ]


pipeline = Pipeline(stages=indexers)
df_indexed = pipeline.fit(df).transform(df)
df_indexed.describe().toPandas()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>summary</th>
      <th>Session_Connection_Time</th>
      <th>Bytes Transferred</th>
      <th>Kali_Trace_Used</th>
      <th>Servers_Corrupted</th>
      <th>Pages_Corrupted</th>
      <th>Location</th>
      <th>WPM_Typing_Speed</th>
      <th>Location_index</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
      <td>334</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>30.008982035928145</td>
      <td>607.2452694610777</td>
      <td>0.5119760479041916</td>
      <td>5.258502994011977</td>
      <td>10.838323353293413</td>
      <td>None</td>
      <td>57.342395209580864</td>
      <td>64.99700598802396</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>14.088200614636158</td>
      <td>286.33593163576757</td>
      <td>0.5006065264451406</td>
      <td>2.30190693339697</td>
      <td>3.06352633036022</td>
      <td>None</td>
      <td>13.41106336843464</td>
      <td>50.98975334284259</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>1.0</td>
      <td>10.0</td>
      <td>0</td>
      <td>1.0</td>
      <td>6.0</td>
      <td>Afghanistan</td>
      <td>40.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>60.0</td>
      <td>1330.5</td>
      <td>1</td>
      <td>10.0</td>
      <td>15.0</td>
      <td>Zimbabwe</td>
      <td>75.0</td>
      <td>180.0</td>
    </tr>
  </tbody>
</table>
</div>



Now, we can use the VectorAssembler to define our "features" column:


```python
from pyspark.ml.feature import VectorAssembler
#By using a list comprehension we can define inputcols as the exclusion of some columns from df_indexed
assembler = VectorAssembler(inputCols= [e for e in df_indexed.columns if e not in ('Location')]  , outputCol='features', 
                            handleInvalid='skip')
output = assembler.transform(df_indexed)
```

Another interesting thing to do is "standarization". In essence, this adjusts all values to follow a "common scale", so that they are easier to compare and process. Thus:


```python
from pyspark.ml.feature import StandardScaler
scaler = StandardScaler(inputCol='features', outputCol='scaled_features')
scalar_model = scaler.fit(output)
scaled_data = scalar_model.transform(output)
scaled_data.select('scaled_features').head()
```




    Row(scaled_features=DenseVector([0.5679, 1.3658, 1.9976, 1.2859, 2.2849, 5.3963, 1.7258]))


#### Deciphering the number of hackers

Now starts the difficult, more think-about-it part! We already know that we might have 2 OR 3 [harkers](https://www.youtube.com/watch?v=H3edGTP7GVY), so, we are going to try to do it first with 3, then with 2, and compare which gets the best clustering score!


```python
from pyspark.ml.clustering import KMeans #Import the module
```

First, we define and apply the models:


```python
kmeans3 = KMeans(featuresCol='scaled_features', k=3)
model3 = kmeans3.fit(scaled_data)
kmeans2 = KMeans(featuresCol='scaled_features', k=2)
model2 = kmeans2.fit(scaled_data)
```

#### Getting the results

And then, we get the results:


```python
results3 = model3.transform(scaled_data)
results2 = model2.transform(scaled_data)
```

We could also visualize the results; this has been abbreviated for efficiency


```python
#results3.select('prediction').show()
#results2.select('prediction').show()
```

Thats it! We have the results! Now, lets see how good the classification is: if all the attacks classify neatly in two groups, then, the two-hacker-theory would be validated; else, if we need a group more to explain all the attacks better, the three-hacker-thesis would be king! Lets see how this works:


```python
from pyspark.ml.evaluation import ClusteringEvaluator
```

Lets generate the evaluations:


```python
ClusteringEvaluator().evaluate(results2)
```




    0.6555369436993117




```python
ClusteringEvaluator().evaluate(results3)
```




    0.3008773897853434



As we can see, ¡the two-hacker-theorem gets way, way better evaluation scores! This means that the underlying patterns in the data fit two-group classification way, way better than three-group classification! (ClusteringEvaluator uses the [silhouette method](https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.ml.evaluation.ClusteringEvaluator.html), for which closeness to 1 signals closeness between the clusters and the clustering center. This centers can be shown using model.clusterCenters() )

To sum up: there are, definetely, **two and only two hackers here**

And interesting to-do would be to show the characteristic's % on each cluster, to see if we can unmask the criminals.
