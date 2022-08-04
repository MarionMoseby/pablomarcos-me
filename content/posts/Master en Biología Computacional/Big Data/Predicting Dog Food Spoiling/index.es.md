---
title: "Predicting Dog Food Spoiling"
author: Pablo Marcos
date: 2021-10-14
math: true
menu:
  sidebar:
    name: Dog Food Spoiling
    identifier: predicting_dogfood_spoiling
    parent: big_data_master
    weight: 40
---

We have been contracted by a dog food company that uses an additive with 4 different chemicals (A, B, C and D) and a filler to preserve their food. The scientists have detected a problem: some batches of their dog food spoil much faster than expected. Since they haven't updated their machinery, the levels of preservatives can vary a lot, so your job as a consultant is to use Machine Learning to detect which chemical is most responsible for the spoilage.

<div style="text-align: center">
    <a href="./Predicting_Dog_Food_Spoiling.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

## Initial data Analysis

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
#Please drop the file in the environments 'Files' panel
df = spark.read.options(header="true", inferSchema="true").csv("/content/dog_food.csv")
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>Spoiled</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>490</td>
      <td>490</td>
      <td>490</td>
      <td>490</td>
      <td>490</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>5.53469387755102</td>
      <td>5.504081632653061</td>
      <td>9.126530612244897</td>
      <td>5.579591836734694</td>
      <td>0.2857142857142857</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>2.9515204234399057</td>
      <td>2.8537966089662063</td>
      <td>2.0555451971054275</td>
      <td>2.8548369309982857</td>
      <td>0.45221563164613465</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>1</td>
      <td>1</td>
      <td>5.0</td>
      <td>1</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>10</td>
      <td>10</td>
      <td>14.0</td>
      <td>10</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
</div>

## Deciding on the Model's Method

The idea for this assignment is to use Tree Methods to find underlying patterns in data, preventing the model from making undue assumptions about the data itself and letting it speak by itself. In any case, and as with the previous models, we must first assemble a Vector with a "features" and a "label" tag so that it can be processed by Spark. For more commented code, please see other assignments:


```python
from pyspark.ml.feature import VectorAssembler, Imputer
assembler = VectorAssembler(inputCols= [e for e in df.columns if e not in ('Spoiled')]  , outputCol='features', handleInvalid='skip')
output = assembler.transform(df)
imputer = Imputer(inputCols=['Spoiled'], outputCols=['label'], strategy='mean')
imputer_model = imputer.fit(output)
output = imputer_model.transform(output)
```

As always, we divide the data into a train and a test set, so that we can test the metrics and see if everything went OK. 


```python
train, test = output.randomSplit([0.7, 0.3])
```

We are using three different tree methods, which come bundled with spark:

* [Decission Tree Classifier](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.DecisionTreeClassifier.html): It uses a decision tree (as a predictive model) to go from observations about an item (represented in the branches) to conclusions about the item's target value (represented in the leaves).
* [Random Forest Classifier](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.RandomForestClassifier.html):  For classification tasks, the output of the random forest is the class selected by most trees. For regression tasks, the mean or average prediction of the individual trees is returned. Random decision forests correct for decision trees' habit of overfitting to their training set.
* [Gradient Boosted Trees](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.GBTClassifier.html): It gives a prediction model in the form of an ensemble of weak prediction models, which are typically decision trees. When a decision tree is the weak learner, the resulting algorithm is called gradient-boosted trees; it usually outperforms random forest.

We will use the three methods to find if their results match, and to pick the most accurate of the three.


```python
#Fist, we alias the methods to make them easier to call
from pyspark.ml.classification import (RandomForestClassifier, GBTClassifier, DecisionTreeClassifier)
dtc = DecisionTreeClassifier()
rfc = RandomForestClassifier(numTrees = 100)
gbt = GBTClassifier()
```


```python
#We fit the three models
dtc_model = dtc.fit(train)
rfc_model = rfc.fit(train)
gbt_model = gbt.fit(train)
```


```python
#And get their predictions
dtc_preds = dtc_model.transform(test)
rfc_preds = rfc_model.transform(test)
gbt_preds = gbt_model.transform(test)
```
## Analyzing the data

To evaluate the models, we import ``` MulticlassClassificationEvaluator ```, which will give us an accuracy metric

```python
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
evaluator = MulticlassClassificationEvaluator(metricName='accuracy')
```

And we display it


```python
print(f'DTC: {evaluator.evaluate(dtc_preds)} \t Features Importance: {dtc_model.featureImportances}') 
print(f'RFC: {evaluator.evaluate(rfc_preds)}  Features Importance: {rfc_model.featureImportances}')
print(f'GBT: {evaluator.evaluate(gbt_preds)} \t Features Importance: {gbt_model.featureImportances}')
```

    DTC: 0.959731543624161 	 Features Importance: (4,[0,1,2,3],[0.010142105007278246,0.0016897828403142857,0.96352393472086,0.024644177431547582])
    RFC: 0.9664429530201343  Features Importance: (4,[0,1,2,3],[0.025437259862519997,0.024627784289245877,0.9287766018080698,0.021158354040164428])
    GBT: 0.959731543624161 	 Features Importance: (4,[0,1,2,3],[0.008071973502739728,0.03292367928105117,0.9086511641861458,0.05035318303006327])


As we can see, all methods have a quite similar (and quite high!) accuracy score, with the three of them coinciding in atttributing the 3rd column (**Preservative C**) an outsize influence (> 90%) on dog food spoilage. 

Thus, we can conclude that it is **Preservative C** which is the most responsible for Dog Food Spoilage, and we can recommend for it to stop being used.
