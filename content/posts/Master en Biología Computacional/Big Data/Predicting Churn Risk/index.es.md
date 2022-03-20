---
title: "Predicting Churn Risk"
author: Pablo Marcos
date: 2021-11-01
math: true
menu:
  sidebar:
    name: Predicting Churn Risk
    identifier: predicting_churn_risk
    parent: big_data_master
    weight: 40
---

Your goal is to create a model that can predict whether a customer will churn (0 or 1) based on the features in [this dataset](https://www.kaggle.com/hassanamin/customer-churn). See the slides for more information.

<div style="text-align: center">
    <a href="./Predicting_Churn_Risk.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

#### Initial Steps

First, we need to create the Spark Session


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

Afterwards, we can read the file and inspect it


```python
#Please drop the file in the environment's 'Files' panel
df = spark.read.options(header="true", inferSchema="true").csv("/content/customer_churn.csv")
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
      <th>Names</th>
      <th>Age</th>
      <th>Total_Purchase</th>
      <th>Account_Manager</th>
      <th>Years</th>
      <th>Num_Sites</th>
      <th>Onboard_date</th>
      <th>Location</th>
      <th>Company</th>
      <th>Churn</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
      <td>900</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>None</td>
      <td>41.81666666666667</td>
      <td>10062.82403333334</td>
      <td>0.4811111111111111</td>
      <td>5.27315555555555</td>
      <td>8.587777777777777</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.16666666666666666</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>None</td>
      <td>6.127560416916251</td>
      <td>2408.644531858096</td>
      <td>0.4999208935073339</td>
      <td>1.274449013194616</td>
      <td>1.7648355920350969</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.3728852122772358</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>Aaron King</td>
      <td>22.0</td>
      <td>100.0</td>
      <td>0</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>2006-01-02 04:16:13</td>
      <td>00103 Jeffrey Crest Apt. 205 Padillaville, IA ...</td>
      <td>Abbott-Thompson</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>Zachary Walsh</td>
      <td>65.0</td>
      <td>18026.01</td>
      <td>1</td>
      <td>9.15</td>
      <td>14.0</td>
      <td>2016-12-28 04:07:38</td>
      <td>Unit 9800 Box 2878 DPO AA 75157</td>
      <td>Zuniga, Clark and Shaffer</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



#### Deciding on the features of the Model

```python
#To see which columns we wish to select, we do:
df.printSchema()
```

    root
     |-- Names: string (nullable = true)
     |-- Age: double (nullable = true)
     |-- Total_Purchase: double (nullable = true)
     |-- Account_Manager: integer (nullable = true)
     |-- Years: double (nullable = true)
     |-- Num_Sites: double (nullable = true)
     |-- Onboard_date: string (nullable = true)
     |-- Location: string (nullable = true)
     |-- Company: string (nullable = true)
     |-- Churn: integer (nullable = true)
    

Here, we have to think wether it is work to index some columns: Both company name and location are pretty much unique, so I see no use for indexing them, although it could be interesting (but far too complicated) to index by country, for instance. I could also index the date by year, or add it to the model as datetime variable type, but, since I dont recall how to tell spark to accept a column as datetime (cant get .to_date() to work :/ ) I will leave it out for now.


```python
#And we proceed to select them:
mycols =  df.select(['Churn', 'Age', 'Total_Purchase', 'Years', 'Num_sites'])
#Hint: since 'Account_Manager' is currently selected as random, we dont have to select it :p
final_train = mycols.na.drop()
```

#### Preparing the data

Since this dataset did not provide us with a 'train' and a 'test' sub-database, we need to manually make the divission ourselves. Thus:


```python
(train, test) = final_train.randomSplit([0.7,0.3])
train.describe().show(), test.describe().show()
```

    +-------+-------------------+------------------+------------------+------------------+------------------+
    |summary|              Churn|               Age|    Total_Purchase|             Years|         Num_sites|
    +-------+-------------------+------------------+------------------+------------------+------------------+
    |  count|                604|               604|               604|               604|               604|
    |   mean| 0.1456953642384106|41.764900662251655|10058.752913907281|  5.24854304635762| 8.509933774834437|
    | stddev|0.35309296232693316| 6.293619382523293|2443.5585608960027|1.2693878324304124|1.6725966135800687|
    |    min|                  0|              22.0|             100.0|               1.0|               4.0|
    |    max|                  1|              65.0|          16955.76|              9.15|              13.0|
    +-------+-------------------+------------------+------------------+------------------+------------------+
    
    +-------+-------------------+-----------------+------------------+------------------+-----------------+
    |summary|              Churn|              Age|    Total_Purchase|             Years|        Num_sites|
    +-------+-------------------+-----------------+------------------+------------------+-----------------+
    |  count|                296|              296|               296|               296|              296|
    |   mean|0.20945945945945946| 41.9222972972973|10071.131317567566|5.3233783783783775|8.746621621621621|
    | stddev|0.40761195202746325|5.782853919155999| 2339.838924409756| 1.285407304203774|1.932765316381917|
    |    min|                  0|             27.0|            3263.0|              1.81|              3.0|
    |    max|                  1|             58.0|          18026.01|              8.84|             14.0|
    +-------+-------------------+-----------------+------------------+------------------+-----------------+
    





    (None, None)


#### Creating the model

Since it seems like the divission was correctly made, and like we have enough items both in the train and test dataframes, we can proceed to building the model based on the train data:


```python
from pyspark.ml.feature import (VectorAssembler, OneHotEncoder, VectorIndexer, StringIndexer)
assembler = VectorAssembler(inputCols=['Age', 'Total_Purchase', 'Years', 'Num_sites'],
                            outputCol='features')
```

Interesting to know is that we can use: 


```
from pyspark.ml.feature import (VectorAssembler, OneHotEncoder, VectorIndexer, StringIndexer)

gender_indexer = StringIndexer(inputCol='Sex', outputCol='SexIndex')
gender_encoder = OneHotEncoder(inputCol='SexIndex', outputCol='SexVec')

embarked_indexer = StringIndexer(inputCol='Embarked', outputCol='EmbarkedIndex')
embarked_encoder = OneHotEncoder(inputCol='EmbarkedIndex', outputCol='EmbarkedVec')
```

To index vectors, and then add this to pipeline and assembler:     

```
assembler = VectorAssembler(inputCols=['Pclass','SexVec','Age','SibSp','Parch','Fare','EmbarkedVec'],
                            outputCol='features')

pipeline = Pipeline(stages=[gender_indexer, embarked_indexer, gender_encoder, embarked_encoder, assembler, lr])
```

To work with parameters such as sex or others; however, as I have discussed previously, I will not use this here.


```python
from pyspark.ml.classification import LogisticRegression
lr = LogisticRegression(featuresCol='features', labelCol='Churn')
```


```python
from pyspark.ml import Pipeline
pipeline = Pipeline(stages=[assembler, lr])
```


```python
model = pipeline.fit(train)
```

Once we have developed the model, we curate the test data and use this 


```python
curated_test = test.na.drop()
predictions = model.transform(curated_test)
```

#### Visualizing the results

Lets see the results!


```python
predictions.toPandas()
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
      <th>Churn</th>
      <th>Age</th>
      <th>Total_Purchase</th>
      <th>Years</th>
      <th>Num_sites</th>
      <th>features</th>
      <th>rawPrediction</th>
      <th>probability</th>
      <th>prediction</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>27.0</td>
      <td>8628.80</td>
      <td>5.30</td>
      <td>7.0</td>
      <td>[27.0, 8628.8, 5.3, 7.0]</td>
      <td>[6.675936689418812, -6.675936689418812]</td>
      <td>[0.9987406968746404, 0.001259303125359601]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>28.0</td>
      <td>9090.43</td>
      <td>5.74</td>
      <td>10.0</td>
      <td>[28.0, 9090.43, 5.74, 10.0]</td>
      <td>[2.1718950670750665, -2.1718950670750665]</td>
      <td>[0.8976971350218025, 0.10230286497819752]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>29.0</td>
      <td>9617.59</td>
      <td>5.49</td>
      <td>8.0</td>
      <td>[29.0, 9617.59, 5.49, 8.0]</td>
      <td>[4.976543878227016, -4.976543878227016]</td>
      <td>[0.9931493932780102, 0.006850606721989783]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>29.0</td>
      <td>10203.18</td>
      <td>5.82</td>
      <td>8.0</td>
      <td>[29.0, 10203.18, 5.82, 8.0]</td>
      <td>[4.801549127250805, -4.801549127250805]</td>
      <td>[0.9918499609427239, 0.00815003905727607]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>30.0</td>
      <td>13473.35</td>
      <td>3.84</td>
      <td>10.0</td>
      <td>[30.0, 13473.35, 3.84, 10.0]</td>
      <td>[2.633769753642472, -2.633769753642472]</td>
      <td>[0.9330035738020525, 0.06699642619794755]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>291</th>
      <td>1</td>
      <td>50.0</td>
      <td>14398.89</td>
      <td>5.54</td>
      <td>12.0</td>
      <td>[50.0, 14398.89, 5.54, 12.0]</td>
      <td>[-2.6224366916584323, 2.6224366916584323]</td>
      <td>[0.06770831797659854, 0.9322916820234015]</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>292</th>
      <td>1</td>
      <td>51.0</td>
      <td>8100.43</td>
      <td>4.92</td>
      <td>13.0</td>
      <td>[51.0, 8100.43, 4.92, 13.0]</td>
      <td>[-3.522746635680445, 3.522746635680445]</td>
      <td>[0.02867190349642679, 0.9713280965035732]</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>293</th>
      <td>1</td>
      <td>55.0</td>
      <td>5024.52</td>
      <td>8.11</td>
      <td>9.0</td>
      <td>[55.0, 5024.52, 8.11, 9.0]</td>
      <td>[0.4878396300738217, -0.4878396300738217]</td>
      <td>[0.619597372506964, 0.380402627493036]</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>294</th>
      <td>1</td>
      <td>56.0</td>
      <td>12217.95</td>
      <td>5.79</td>
      <td>11.0</td>
      <td>[56.0, 12217.95, 5.79, 11.0]</td>
      <td>[-1.7215722913002764, 1.7215722913002764]</td>
      <td>[0.15166875344376754, 0.8483312465562325]</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>295</th>
      <td>1</td>
      <td>58.0</td>
      <td>9703.93</td>
      <td>5.16</td>
      <td>11.0</td>
      <td>[58.0, 9703.93, 5.16, 11.0]</td>
      <td>[-1.4845273670253718, 1.4845273670253718]</td>
      <td>[0.18474456093726596, 0.815255439062734]</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
<p>296 rows × 9 columns</p>
</div>

#### Evaluating accuracy

Now that we have made the predictions, lets evaluate the accuracy of our prediction model:   


```python
from pyspark.ml.evaluation import BinaryClassificationEvaluator
evaluator = BinaryClassificationEvaluator(rawPredictionCol='prediction', labelCol='Churn')
acc = evaluator.evaluate(predictions)
acc
```




    0.738833746898263



As we can see, the precition model is not that great, but it works to an extent.As previously discussed, we may be able to improve the model by indexing other parameters.
