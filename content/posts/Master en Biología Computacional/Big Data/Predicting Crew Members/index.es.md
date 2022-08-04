---
title: "Predicting Crew Members"
author: Pablo Marcos
date: 2021-10-26
math: true
menu:
  sidebar:
    name: Predicting Crew Members
    identifier: predicting_crew_members
    parent: big_data_master
    weight: 40
---

Your job is to create a regression model that will help predict how many crew members will be needed for future ships. In other words, use the features you think will be useful to predict the value in the Crew column.

<div style="text-align: center">
    <a href="./Predicting_Crew_Members.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

#### Create the Spark Session

```python
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
```

#### Read the file and inspect it


```python
#Please drop the file in the environments 'Files' panel
df = spark.read.options(header="true", inferSchema="true").csv("/content/cruise_ship_info.csv")
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
      <th>Ship_name</th>
      <th>Cruise_line</th>
      <th>Age</th>
      <th>Tonnage</th>
      <th>passengers</th>
      <th>length</th>
      <th>cabins</th>
      <th>passenger_density</th>
      <th>crew</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>Infinity</td>
      <td>None</td>
      <td>15.689873417721518</td>
      <td>71.28467088607599</td>
      <td>18.45740506329114</td>
      <td>8.130632911392404</td>
      <td>8.830000000000005</td>
      <td>39.90094936708861</td>
      <td>7.794177215189873</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>None</td>
      <td>None</td>
      <td>7.615691058751413</td>
      <td>37.229540025907866</td>
      <td>9.677094775143416</td>
      <td>1.793473548054825</td>
      <td>4.4714172221480615</td>
      <td>8.63921711391542</td>
      <td>3.503486564627034</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>Adventure</td>
      <td>Azamara</td>
      <td>4</td>
      <td>2.329</td>
      <td>0.66</td>
      <td>2.79</td>
      <td>0.33</td>
      <td>17.7</td>
      <td>0.59</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>Zuiderdam</td>
      <td>Windstar</td>
      <td>48</td>
      <td>220.0</td>
      <td>54.0</td>
      <td>11.82</td>
      <td>27.0</td>
      <td>71.43</td>
      <td>21.0</td>
    </tr>
  </tbody>
</table>
</div>

#### Indexing non-numeric parameters

Here, we can see that Cruise_line, which we were told is an important parameter, is an string variable. This is a problem! ML algorithms work better with numbers, as it is unclear how to process a string. ¿The solution? We can index the Cruise_line!

Source: [Stack Overflow](https://stackoverflow.com/questions/36942233/apply-stringindexer-to-several-columns-in-a-pyspark-dataframe)


```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer

#Bonus! Change this code to index multiple columns at once!
indexers = [StringIndexer(inputCol=column, outputCol=column+"_index").fit(df) for column in list(["Cruise_line"]) ]


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
      <th>Ship_name</th>
      <th>Cruise_line</th>
      <th>Age</th>
      <th>Tonnage</th>
      <th>passengers</th>
      <th>length</th>
      <th>cabins</th>
      <th>passenger_density</th>
      <th>crew</th>
      <th>Cruise_line_index</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
      <td>158</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>Infinity</td>
      <td>None</td>
      <td>15.689873417721518</td>
      <td>71.28467088607599</td>
      <td>18.45740506329114</td>
      <td>8.130632911392404</td>
      <td>8.830000000000005</td>
      <td>39.90094936708861</td>
      <td>7.794177215189873</td>
      <td>5.063291139240507</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>None</td>
      <td>None</td>
      <td>7.615691058751413</td>
      <td>37.229540025907866</td>
      <td>9.677094775143416</td>
      <td>1.793473548054825</td>
      <td>4.4714172221480615</td>
      <td>8.63921711391542</td>
      <td>3.503486564627034</td>
      <td>4.758744608182735</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>Adventure</td>
      <td>Azamara</td>
      <td>4</td>
      <td>2.329</td>
      <td>0.66</td>
      <td>2.79</td>
      <td>0.33</td>
      <td>17.7</td>
      <td>0.59</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>Zuiderdam</td>
      <td>Windstar</td>
      <td>48</td>
      <td>220.0</td>
      <td>54.0</td>
      <td>11.82</td>
      <td>27.0</td>
      <td>71.43</td>
      <td>21.0</td>
      <td>19.0</td>
    </tr>
  </tbody>
</table>
</div>

#### Plotting a scatter matrix

Of course, the mean and stdev values for Cruise_line_index are pointless, since they just represent the Cruise Operator Company; BUT! they help us understand the data, since we can now use pandas to do a quick check among numeric variables, and see if they are related or not (source: [TowardsDataScience](https://towardsdatascience.com/building-a-linear-regression-with-pyspark-and-mllib-d065c3ba246a))


```python
import pandas as pd
#Fun but interesting fact: if you add ";" at the end of your command, you dont get matplotlib axes warnings! Yuhuuu!
pd.plotting.scatter_matrix(df_indexed.toPandas(), figsize=(10, 10));
```


![png](Consulting_Project_Predicting_Crew_Members_files/Consulting_Project_Predicting_Crew_Members_8_0.png)


We can see that there are some variables which show very good correlation between them, such as passenger number and number of cabins; this makes sense, and can be used as "intuitive proof" that we are doing something correctly. 

With regard to our parameter of interest, crew, we see that it seems to be most closely relate to tonnage and number of cabins, another common sense, intuitive deduction, since bigger ships need more crew to manage them and to guide the customers. 

Crusise_line index doesnt seem to be very related to crew, but this could be an artifact caused by the ordering of the data in decreasing order of Cruse_line_index in the graph; with numeric correlation, a similar problem could arise, since, for potential correlation, we would expect the highest index (19) to have highest values. I will thus continue using the parameter on the model, as I was asked, and see what happens :p

#### Generating a ML Model

Now that we have done an initial exploratory analysis on the data, lets try to generate a ML model using pyspark that tells us which characteristics here are most important:


```python
from pyspark.ml.feature import VectorAssembler
#By using a list comprehension we can define inputcols as the exclusion of some columns from df_indexed
assembler = VectorAssembler(inputCols= [e for e in df_indexed.columns if e not in ('Ship_name', 'Cruise_line', 'crew')]  , outputCol='features', 
                            handleInvalid='skip')
output = assembler.transform(df_indexed)
```


```python
from pyspark.ml.feature import Imputer
imputer = Imputer(inputCols=['crew'], outputCols=['label'], strategy='mean')
imputer_model = imputer.fit(output)
output = imputer_model.transform(output)
```

Just to be sure everything went correctly in our pipeline, lets show the output dataframe:


```python
output.show()
```

    +-----------+-----------+---+------------------+----------+------+------+-----------------+----+-----------------+--------------------+-----+
    |  Ship_name|Cruise_line|Age|           Tonnage|passengers|length|cabins|passenger_density|crew|Cruise_line_index|            features|label|
    +-----------+-----------+---+------------------+----------+------+------+-----------------+----+-----------------+--------------------+-----+
    |    Journey|    Azamara|  6|30.276999999999997|      6.94|  5.94|  3.55|            42.64|3.55|             16.0|[6.0,30.276999999...| 3.55|
    |      Quest|    Azamara|  6|30.276999999999997|      6.94|  5.94|  3.55|            42.64|3.55|             16.0|[6.0,30.276999999...| 3.55|
    |Celebration|   Carnival| 26|            47.262|     14.86|  7.22|  7.43|             31.8| 6.7|              1.0|[26.0,47.262,14.8...|  6.7|
    |   Conquest|   Carnival| 11|             110.0|     29.74|  9.53| 14.88|            36.99|19.1|              1.0|[11.0,110.0,29.74...| 19.1|
    |    Destiny|   Carnival| 17|           101.353|     26.42|  8.92| 13.21|            38.36|10.0|              1.0|[17.0,101.353,26....| 10.0|
    |    Ecstasy|   Carnival| 22|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[22.0,70.367,20.5...|  9.2|
    |    Elation|   Carnival| 15|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[15.0,70.367,20.5...|  9.2|
    |    Fantasy|   Carnival| 23|            70.367|     20.56|  8.55| 10.22|            34.23| 9.2|              1.0|[23.0,70.367,20.5...|  9.2|
    |Fascination|   Carnival| 19|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[19.0,70.367,20.5...|  9.2|
    |    Freedom|   Carnival|  6|110.23899999999999|      37.0|  9.51| 14.87|            29.79|11.5|              1.0|[6.0,110.23899999...| 11.5|
    |      Glory|   Carnival| 10|             110.0|     29.74|  9.51| 14.87|            36.99|11.6|              1.0|[10.0,110.0,29.74...| 11.6|
    |    Holiday|   Carnival| 28|            46.052|     14.52|  7.27|  7.26|            31.72| 6.6|              1.0|[28.0,46.052,14.5...|  6.6|
    |Imagination|   Carnival| 18|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[18.0,70.367,20.5...|  9.2|
    |Inspiration|   Carnival| 17|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[17.0,70.367,20.5...|  9.2|
    |     Legend|   Carnival| 11|              86.0|     21.24|  9.63| 10.62|            40.49| 9.3|              1.0|[11.0,86.0,21.24,...|  9.3|
    |   Liberty*|   Carnival|  8|             110.0|     29.74|  9.51| 14.87|            36.99|11.6|              1.0|[8.0,110.0,29.74,...| 11.6|
    |    Miracle|   Carnival|  9|              88.5|     21.24|  9.63| 10.62|            41.67|10.3|              1.0|[9.0,88.5,21.24,9...| 10.3|
    |   Paradise|   Carnival| 15|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[15.0,70.367,20.5...|  9.2|
    |      Pride|   Carnival| 12|              88.5|     21.24|  9.63| 11.62|            41.67| 9.3|              1.0|[12.0,88.5,21.24,...|  9.3|
    |  Sensation|   Carnival| 20|            70.367|     20.52|  8.55|  10.2|            34.29| 9.2|              1.0|[20.0,70.367,20.5...|  9.2|
    +-----------+-----------+---+------------------+----------+------+------+-----------------+----+-----------------+--------------------+-----+
    only showing top 20 rows
    


Nice! As we can see, we have all our expected columns (the ones in the matrix except those in the list comprehension), and two new ones: features, which is what Spark will use for its ML approach, and label, which is populated with the crew values and will help us predict it.


```python
#Lets select the data we want to use:
final_data = output.select(['features', 'label'])
```

We can now divide the data in two: a training dataset and a test dataset, which will be used to validate the conclussions of our trained data. For the process to work, sampling has to be random, so that no undue influence is exerted through data selection (say, if we picked the first 20 values); and, the data has to be divided somehow: here, we create an 65/35 split because I felt like 70/30 left too few individuals in the test data category


```python
train_data, test_data = final_data.randomSplit([0.65, 0.35])
```


```python
final_data.describe().show(), train_data.describe().show(), test_data.describe().show()
```

    +-------+-----------------+
    |summary|            label|
    +-------+-----------------+
    |  count|              158|
    |   mean|7.794177215189873|
    | stddev|3.503486564627034|
    |    min|             0.59|
    |    max|             21.0|
    +-------+-----------------+
    
    +-------+------------------+
    |summary|             label|
    +-------+------------------+
    |  count|               104|
    |   mean| 7.825096153846162|
    | stddev|3.4947555702107467|
    |    min|               0.6|
    |    max|              21.0|
    +-------+------------------+
    
    +-------+------------------+
    |summary|             label|
    +-------+------------------+
    |  count|                54|
    |   mean|  7.73462962962963|
    | stddev|3.5523607420094137|
    |    min|              0.59|
    |    max|              13.6|
    +-------+------------------+
    





    (None, None, None)




```python
#We import the ML Linear Regression module and stablish the label
from pyspark.ml.regression import LinearRegression
lr = LinearRegression(labelCol='label')
```


```python
lr_model = lr.fit(train_data)
```


```python
test_results = lr_model.evaluate(test_data)
```

#### Cheking the results of the model

```python
#The residuals for an observation is the difference between the observation (the y-value) and the fitted line.
test_results.residuals.show()
#And the root Mean Squared Error is a meassure of accuracy
test_results.rootMeanSquaredError
```

    +--------------------+
    |           residuals|
    +--------------------+
    | -1.3259944983423733|
    | -0.8514434688157184|
    | 0.25203246173775007|
    | -0.5786778245997795|
    | 0.17444151538670027|
    | -1.3832902288430144|
    | -0.8158551082693961|
    | -0.4427713845911221|
    |  0.3604712596502839|
    | -0.6603995683195034|
    |-0.25945919107257787|
    |  0.3813308210539432|
    | -0.7477823634981888|
    |  0.6855294216709122|
    | -0.6200715933698913|
    | -0.7413835788890388|
    | -0.6541795737066902|
    |  0.9199379275910768|
    |  0.9199379275910768|
    | -0.4181630087049122|
    +--------------------+
    only showing top 20 rows
    





    0.6939264035154783



Well... it seems like we dont get reeeealy good values. Lets check the R² just in case...


```python
test_results.r2
```




    0.9611214023707688



Woah! That's a big R² !I guess our results were not so bad after all!!

Lets see the predictions then!

```python
lr_model.transform(test_data).show()
```

    +--------------------+-----+------------------+
    |            features|label|        prediction|
    +--------------------+-----+------------------+
    |[5.0,86.0,21.04,9...|  8.0| 9.325994498342373|
    |[6.0,30.276999999...| 3.55| 4.401443468815718|
    |[6.0,110.23899999...| 11.5| 11.24796753826225|
    |[6.0,112.0,38.0,9...| 10.9| 11.47867782459978|
    |[6.0,113.0,37.82,...| 12.0|  11.8255584846133|
    |[7.0,89.6,25.5,9....| 9.87|11.253290228843014|
    |[7.0,116.0,31.0,9...| 12.0|12.815855108269396|
    |[7.0,158.0,43.7,1...| 13.6|14.042771384591122|
    |[8.0,77.499,19.5,...|  9.0| 8.639528740349716|
    |[8.0,110.0,29.74,...| 11.6|12.260399568319503|
    |[9.0,59.058,17.0,...|  7.4| 7.659459191072578|
    |[9.0,81.0,21.44,9...| 10.0| 9.618669178946057|
    |[9.0,85.0,19.68,9...| 8.69| 9.437782363498188|
    |[9.0,88.5,21.24,9...| 10.3| 9.614470578329088|
    |[9.0,90.09,25.01,...| 8.69|  9.31007159336989|
    |[9.0,105.0,27.2,8...|10.68|11.421383578889039|
    |[9.0,110.0,29.74,...| 11.6| 12.25417957370669|
    |[9.0,113.0,26.74,...|12.38|11.460062072408924|
    |[9.0,113.0,26.74,...|12.38|11.460062072408924|
    |[10.0,81.76899999...| 8.42| 8.838163008704912|
    +--------------------+-----+------------------+
    only showing top 20 rows
    

#### Trying to improve the model

Thats it! We have a LR, ML model that accurately (0.96) predicts the number of crew members in a Cruise ship. However, ¿could we do better? If we look back at the scatter matrix, we see that some values related better to crew than others. By excluding them, could we increase the models accuracy?


```python
pd.plotting.scatter_matrix(df_indexed.toPandas(), figsize=(10, 10));
```


![png](Consulting_Project_Predicting_Crew_Members_files/Consulting_Project_Predicting_Crew_Members_29_0.png)


Lets try to remove passenger_density, Age and Cruise_line_index (even though yes, we were told this was an important parameter for the company) and see what happens:


```python
assembler = VectorAssembler(inputCols= [e for e in df_indexed.columns if e not in ('Ship_name', 'Cruise_line', 
                                                                                   'crew', 'passenger_density', 'Age', 'Cruise_line_index')]  , outputCol='features', 
                            handleInvalid='skip')
output = assembler.transform(df_indexed)
```


```python
imputer = Imputer(inputCols=['crew'], outputCols=['label'], strategy='mean')
imputer_model = imputer.fit(output)
output = imputer_model.transform(output)
```


```python
final_data = output.select(['features', 'label'])
```


```python
train_data, test_data = final_data.randomSplit([0.65, 0.35])
```


```python
lr = LinearRegression(labelCol='label')
lr_model = lr.fit(train_data)
test_results = lr_model.evaluate(test_data)
```


```python
test_results.residuals.show(), test_results.rootMeanSquaredError, test_results.r2
```

    +--------------------+
    |           residuals|
    +--------------------+
    | -0.8231610867408612|
    | -0.2639915612753747|
    | -0.1339915612753746|
    | -0.1943057005996871|
    |-0.22359048492732336|
    |-0.41929365405413854|
    | 0.01972284792550294|
    |-0.05123127867500...|
    | 0.08804027838669004|
    |-0.09625319517634523|
    | -0.2464422157023174|
    |  0.6476692405794164|
    | 0.11971319676579384|
    |  1.2077329156434358|
    |  0.2875155279976793|
    | -1.0783646108913167|
    | -0.1617301231003614|
    | -0.1617301231003614|
    | -0.6314669369748263|
    |-0.44057575750874367|
    +--------------------+
    only showing top 20 rows
    





    (None, 0.9260213023938995, 0.9148216903559475)



Wow!  When we do this supposed "optimisation" of the model, we can see that, while the R² is not so different (0.91 vs 0.96, an **acceptable** decrease), the RMSD grows **massively** (from 0.69 to 0.92). And, given that **an smaller RMSD is better** this change in the model can be deemed unacceptable: all the characteristics **together** predict crew members better that when taking some of them out.

A PCA approach could help us define which parameters are the most important for the model in a more 'mathematic' way, but, for the time being, we will keep the first model: an R² of 0.96 is good enough, I believe.
