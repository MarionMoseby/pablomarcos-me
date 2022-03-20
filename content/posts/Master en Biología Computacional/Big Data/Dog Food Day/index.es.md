---
title: "Extra Point: Auto Insurance"
author: Pablo Marcos
date: 2021-10-14
math: true
menu:
  sidebar:
    name: Extra Point
    identifier: extra_point_auto_insurance
    parent: big_data_master
    weight: 40
---

Nothing ruins the thrill of buying a brand new car more quickly than seeing your new insurance bill. The sting’s even more painful when you know you’re a good driver. It doesn’t seem fair that you have to pay so much if you’ve been cautious on the road for years.

Inaccuracies in car insurance company’s claim predictions raise the cost of insurance for good drivers and reduce the price for bad ones. But Kaymo ™ wants to stop that!

[In this competition](https://www.kaggle.com/c/caiis-dogfood-day-2020/overview), you’re challenged to build a model that predicts the probability that a driver will initiate an auto insurance claim. While Kaymo ™ has used machine learning for the past 10 years, they’re looking to the CAIIS machine learning community to explore new, more powerful methods. A more accurate prediction will allow them to further tailor their prices, and hopefully make auto insurance coverage more accessible to more drivers.

<div style="text-align: center">
    <a href="./Extra_Point_Auto_Insurance.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

## Initial data Analysis

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
df = spark.read.options(header="true", inferSchema="true").csv("/content/train.csv")
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
      <th>id</th>
      <th>cat_0</th>
      <th>cat_1</th>
      <th>cat_2</th>
      <th>cat_3</th>
      <th>cat_4</th>
      <th>cat_5</th>
      <th>cat_6</th>
      <th>cat_7</th>
      <th>cat_8</th>
      <th>cat_9</th>
      <th>cat_10</th>
      <th>cat_11</th>
      <th>cat_12</th>
      <th>cat_13</th>
      <th>cat_14</th>
      <th>cat_15</th>
      <th>cat_16</th>
      <th>cat_17</th>
      <th>cat_18</th>
      <th>cont_0</th>
      <th>cont_1</th>
      <th>cont_2</th>
      <th>cont_3</th>
      <th>cont_4</th>
      <th>cont_5</th>
      <th>cont_6</th>
      <th>cont_7</th>
      <th>cont_8</th>
      <th>cont_9</th>
      <th>cont_10</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>3387.4498278406295</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.5051998947729144</td>
      <td>0.49388336368386704</td>
      <td>0.5189480562752655</td>
      <td>0.4735777650650935</td>
      <td>0.5086566082134892</td>
      <td>0.5060181089955016</td>
      <td>0.49226472593286386</td>
      <td>0.5006876416744185</td>
      <td>0.49040640920734324</td>
      <td>0.4745391464905265</td>
      <td>0.5064674250670175</td>
      <td>0.18081180811808117</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>1935.5367394936904</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.20419268191081688</td>
      <td>0.2109889750767605</td>
      <td>0.2140486431630643</td>
      <td>0.21460470991003147</td>
      <td>0.22718105831759158</td>
      <td>0.2395814912115326</td>
      <td>0.21021050608421313</td>
      <td>0.20111985652217018</td>
      <td>0.18048630841199265</td>
      <td>0.1951590751556047</td>
      <td>0.20200775006813254</td>
      <td>0.384909527996416</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>0</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>AA</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>-0.005136936996862684</td>
      <td>0.10745448158938073</td>
      <td>0.11502362274662108</td>
      <td>0.006599651524877015</td>
      <td>0.17695526722535196</td>
      <td>-0.006380447747513784</td>
      <td>0.021270552792613227</td>
      <td>0.1223397138826129</td>
      <td>0.0889069927983469</td>
      <td>0.22995944353840855</td>
      <td>0.1278528100161272</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>6757</td>
      <td>B</td>
      <td>O</td>
      <td>U</td>
      <td>N</td>
      <td>T</td>
      <td>ZZ</td>
      <td>Y</td>
      <td>Y</td>
      <td>Y</td>
      <td>X</td>
      <td>Y</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>0.9953078039956524</td>
      <td>0.9896946695363368</td>
      <td>0.9917094757670126</td>
      <td>0.92705434460466</td>
      <td>0.8511866390241221</td>
      <td>0.8423372084057961</td>
      <td>0.957624056103622</td>
      <td>1.0044606397161469</td>
      <td>1.0414219123188158</td>
      <td>0.9895323265306966</td>
      <td>0.9925120037993798</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



As we can see, we have a database with 8 categotical variables, 11 continuous variables and a target value, which, in this training data, is provided so that we can train the algorithm. In this database, each row represents a given insurance policy, and target represents whether the policy resulted in a claim (1) or not (0). We want to predict whether a given insurance policy lead to claims, to remove that policies from the market and minimize the chance for costly, non-desirable claims.

Before proceeding with any approach, we first have to index the categorical variables! This is because pyspark and machine learning algorithms in general dont work well with strings: they need a mathematical value to work with. This has its own problems, specially since the numbers are not random and are orderable, but its the best we have.


```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import StringIndexer

#Bonus! Change this code to index multiple columns at once!
#And! With a list comprehension I can specify all the cat_ things from 1 to 18 :p
indexers = [StringIndexer(inputCol=column, outputCol=column+"_index").fit(df) for column in [f'cat_{x}' for x in range(19)] ]


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
      <th>id</th>
      <th>cat_0</th>
      <th>cat_1</th>
      <th>cat_2</th>
      <th>cat_3</th>
      <th>cat_4</th>
      <th>cat_5</th>
      <th>cat_6</th>
      <th>cat_7</th>
      <th>cat_8</th>
      <th>cat_9</th>
      <th>cat_10</th>
      <th>cat_11</th>
      <th>cat_12</th>
      <th>cat_13</th>
      <th>cat_14</th>
      <th>cat_15</th>
      <th>cat_16</th>
      <th>cat_17</th>
      <th>cat_18</th>
      <th>cont_0</th>
      <th>cont_1</th>
      <th>cont_2</th>
      <th>cont_3</th>
      <th>cont_4</th>
      <th>cont_5</th>
      <th>cont_6</th>
      <th>cont_7</th>
      <th>cont_8</th>
      <th>cont_9</th>
      <th>cont_10</th>
      <th>target</th>
      <th>cat_0_index</th>
      <th>cat_1_index</th>
      <th>cat_2_index</th>
      <th>cat_3_index</th>
      <th>cat_4_index</th>
      <th>cat_5_index</th>
      <th>cat_6_index</th>
      <th>cat_7_index</th>
      <th>cat_8_index</th>
      <th>cat_9_index</th>
      <th>cat_10_index</th>
      <th>cat_11_index</th>
      <th>cat_12_index</th>
      <th>cat_13_index</th>
      <th>cat_14_index</th>
      <th>cat_15_index</th>
      <th>cat_16_index</th>
      <th>cat_17_index</th>
      <th>cat_18_index</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4065</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
      <td>4066</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>3387.4498278406295</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.5051998947729144</td>
      <td>0.49388336368386704</td>
      <td>0.5189480562752655</td>
      <td>0.4735777650650935</td>
      <td>0.5086566082134892</td>
      <td>0.5060181089955016</td>
      <td>0.49226472593286386</td>
      <td>0.5006876416744185</td>
      <td>0.49040640920734324</td>
      <td>0.4745391464905265</td>
      <td>0.5064674250670175</td>
      <td>0.18081180811808117</td>
      <td>0.24913920314805707</td>
      <td>2.9648303000491882</td>
      <td>1.5393507132316773</td>
      <td>0.6000983767830792</td>
      <td>1.3145597638957207</td>
      <td>0.7845548450565667</td>
      <td>0.7137235612395475</td>
      <td>8.324643384161337</td>
      <td>8.775454992621741</td>
      <td>0.9473684210526315</td>
      <td>19.2073290703394</td>
      <td>0.1352680767338908</td>
      <td>0.14240039350713232</td>
      <td>0.02336448598130841</td>
      <td>0.46532218396458436</td>
      <td>0.34948352188883425</td>
      <td>0.3462862764387605</td>
      <td>0.2825873093949828</td>
      <td>0.2147073290703394</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>1935.5367394936904</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.20419268191081688</td>
      <td>0.2109889750767605</td>
      <td>0.2140486431630643</td>
      <td>0.21460470991003147</td>
      <td>0.22718105831759158</td>
      <td>0.2395814912115326</td>
      <td>0.21021050608421313</td>
      <td>0.20111985652217018</td>
      <td>0.18048630841199265</td>
      <td>0.1951590751556047</td>
      <td>0.20200775006813254</td>
      <td>0.384909527996416</td>
      <td>0.4325677750396001</td>
      <td>3.2452054039576987</td>
      <td>2.4425605042547827</td>
      <td>1.1474084345954927</td>
      <td>1.7807690795360278</td>
      <td>4.2299020498829245</td>
      <td>1.380123728813704</td>
      <td>9.875877537204804</td>
      <td>9.154892230985055</td>
      <td>1.8179599316104342</td>
      <td>30.361885464393367</td>
      <td>0.342051749318574</td>
      <td>0.3495033102516255</td>
      <td>0.15107680233781368</td>
      <td>0.4988573482064128</td>
      <td>0.565594945313189</td>
      <td>0.5695057140802395</td>
      <td>0.6398622202372004</td>
      <td>0.5579704263968471</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>0</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>AA</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>-0.005136936996862684</td>
      <td>0.10745448158938073</td>
      <td>0.11502362274662108</td>
      <td>0.006599651524877015</td>
      <td>0.17695526722535196</td>
      <td>-0.006380447747513784</td>
      <td>0.021270552792613227</td>
      <td>0.1223397138826129</td>
      <td>0.0889069927983469</td>
      <td>0.22995944353840855</td>
      <td>0.1278528100161272</td>
      <td>0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>6757</td>
      <td>B</td>
      <td>O</td>
      <td>U</td>
      <td>N</td>
      <td>T</td>
      <td>ZZ</td>
      <td>Y</td>
      <td>Y</td>
      <td>Y</td>
      <td>X</td>
      <td>Y</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>0.9953078039956524</td>
      <td>0.9896946695363368</td>
      <td>0.9917094757670126</td>
      <td>0.92705434460466</td>
      <td>0.8511866390241221</td>
      <td>0.8423372084057961</td>
      <td>0.957624056103622</td>
      <td>1.0044606397161469</td>
      <td>1.0414219123188158</td>
      <td>0.9895323265306966</td>
      <td>0.9925120037993798</td>
      <td>1</td>
      <td>1.0</td>
      <td>14.0</td>
      <td>16.0</td>
      <td>12.0</td>
      <td>18.0</td>
      <td>56.0</td>
      <td>14.0</td>
      <td>50.0</td>
      <td>53.0</td>
      <td>16.0</td>
      <td>184.0</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>3.0</td>
      <td>3.0</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>



We now remove all the non-indexed (useless and repeated) columns from the original dataframe:


```python
df_indexed = df_indexed.select([c for c in df_indexed.columns if c not in [f'cat_{x}' for x in range(19)]]) #Uses the same list comprehension as before!
#Note that I am keeping the ID. Since it is a unique identifyer, it would do nothing to help with prediction, but it doesnt harm either
```

Now, we have the indexed dataframe! We can proceed to do some exploratory analysis, to see what is the correlation between some of this parameters and the column of interest (target). For this, I'd usually plot the scatter matrix using pandas, but I have tried here and I have found that there are so many datapoints that the graph that appears is useless. Thus, I will plot a heatmap which tells me which variables are correlated to which 


```python
#This is useless! Too much data!
#import pandas as pd
#pd.plotting.scatter_matrix(df.toPandas(), figsize=(10, 10));
```


```python
import seaborn as sns
import matplotlib.pyplot as plt
plt.figure(figsize=(10,9)) #Make the plot easier on the eyes
sns.heatmap(df_indexed.toPandas().corr())
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7f2b4ee3e050>




![png](Extra_Point_Dogfood_Day_ipnyb_files/Extra_Point_Dogfood_Day_ipnyb_13_1.png)


As we can see, there is no clear correlation between any of the variables and the target parameter! This seems like a clear cut case for big data analysis, where we could try and see if each small correlation from each characteristic gets to add up and give us a good prediction after all!

## Supervised approach

One of the ways we can try and predict the outcome is through supervised learning. Here, we take a train data set, show the computer how to predict an outcome from this data, and then give it some data to make some predictions on it. 

Here, we are using three different methods, which come bundled with spark:


* [Decission Tree Classifier](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.DecisionTreeClassifier.html): It uses a decision tree (as a predictive model) to go from observations about an item (represented in the branches) to conclusions about the item's target value (represented in the leaves).
* [Random Forest Classifier](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.RandomForestClassifier.html):  For classification tasks, the output of the random forest is the class selected by most trees. For regression tasks, the mean or average prediction of the individual trees is returned. Random decision forests correct for decision trees' habit of overfitting to their training set.
* [Gradient Boosted Trees](https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.classification.GBTClassifier.html): It gives a prediction model in the form of an ensemble of weak prediction models, which are typically decision trees. When a decision tree is the weak learner, the resulting algorithm is called gradient-boosted trees; it usually outperforms random forest.

We will use the three methods to find if their results match, and to pick the most accurate of the three.

First, we must first assemble a Vector with a "features" and a "label" tag so that it can be processed by Spark.


```python
from pyspark.ml.feature import VectorAssembler, Imputer
assembler = VectorAssembler(inputCols= [e for e in df_indexed.columns if e not in ('target')]  , outputCol='features', handleInvalid='skip')
output = assembler.transform(df_indexed)
imputer = Imputer(inputCols=['target'], outputCols=['label'], strategy='mean')
imputer_model = imputer.fit(output)
output = imputer_model.transform(output)
```

Now that we have this set up, we can proceed to create the models:


```python
#Fist, we alias the methods to make them easier to call
from pyspark.ml.classification import (RandomForestClassifier, GBTClassifier, DecisionTreeClassifier)
dtc = DecisionTreeClassifier(maxBins=185) #Decision Trees require maxBins to be at least as large as the number of values in each categorical feature
rfc = RandomForestClassifier(numTrees = 100, maxBins=185)
gbt = GBTClassifier(maxBins=185)
```


```python
#We fit the three models
dtc_model = dtc.fit(output)
rfc_model = rfc.fit(output)
gbt_model = gbt.fit(output)
```

Now, we would like to get this model's predictions for our test data. First, we need to read the data:


```python
#Please drop the file in the environments 'Files' panel
test_df = spark.read.options(header="true", inferSchema="true").csv("/content/test.csv")
test_df.describe().toPandas()
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
      <th>id</th>
      <th>cat_0</th>
      <th>cat_1</th>
      <th>cat_2</th>
      <th>cat_3</th>
      <th>cat_4</th>
      <th>cat_5</th>
      <th>cat_6</th>
      <th>cat_7</th>
      <th>cat_8</th>
      <th>cat_9</th>
      <th>cat_10</th>
      <th>cat_11</th>
      <th>cat_12</th>
      <th>cat_13</th>
      <th>cat_14</th>
      <th>cat_15</th>
      <th>cat_16</th>
      <th>cat_17</th>
      <th>cat_18</th>
      <th>cont_0</th>
      <th>cont_1</th>
      <th>cont_2</th>
      <th>cont_3</th>
      <th>cont_4</th>
      <th>cont_5</th>
      <th>cont_6</th>
      <th>cont_7</th>
      <th>cont_8</th>
      <th>cont_9</th>
      <th>cont_10</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>count</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36737</td>
      <td>36736</td>
      <td>36736</td>
      <td>36736</td>
      <td>36736</td>
      <td>36736</td>
      <td>36736</td>
    </tr>
    <tr>
      <th>1</th>
      <td>mean</td>
      <td>45565.33519340175</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.5063036234343945</td>
      <td>0.49467192032599405</td>
      <td>0.5173822226393028</td>
      <td>0.4762916314739485</td>
      <td>0.5033223270949208</td>
      <td>0.5020626194199714</td>
      <td>0.48730612112892824</td>
      <td>0.5028144336472354</td>
      <td>0.48923176796866097</td>
      <td>0.4712561312748483</td>
      <td>0.5094019115515299</td>
    </tr>
    <tr>
      <th>2</th>
      <td>stddev</td>
      <td>26266.780527766103</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>None</td>
      <td>0.20801235880562077</td>
      <td>0.21322934164723154</td>
      <td>0.2147802721260591</td>
      <td>0.21726160996894317</td>
      <td>0.22729116824926243</td>
      <td>0.24097697602925358</td>
      <td>0.2117830227977653</td>
      <td>0.20422624901247177</td>
      <td>0.1791202966152642</td>
      <td>0.19567532832917978</td>
      <td>0.20527800336854235</td>
    </tr>
    <tr>
      <th>3</th>
      <td>min</td>
      <td>3</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>AA</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>A</td>
      <td>-0.04726740437268828</td>
      <td>0.09905764069525842</td>
      <td>0.10521322746692256</td>
      <td>-0.038177828728809315</td>
      <td>0.17373018292252934</td>
      <td>-0.03583375784982512</td>
      <td>0.02298451094980952</td>
      <td>0.09708227671225958</td>
      <td>0.0280130873460242</td>
      <td>0.22021805352799687</td>
      <td>0.15451327463463016</td>
    </tr>
    <tr>
      <th>4</th>
      <td>max</td>
      <td>91243</td>
      <td>B</td>
      <td>O</td>
      <td>U</td>
      <td>N</td>
      <td>T</td>
      <td>ZZ</td>
      <td>Y</td>
      <td>Y</td>
      <td>Y</td>
      <td>X</td>
      <td>Y</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>B</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>D</td>
      <td>0.9945586232209024</td>
      <td>1.001207364106895</td>
      <td>1.0105190260692984</td>
      <td>0.9440372658550216</td>
      <td>0.8541243700209937</td>
      <td>0.8455319358435773</td>
      <td>0.9646352575880386</td>
      <td>1.0274581708548551</td>
      <td>1.0434670315747987</td>
      <td>0.9992554391006276</td>
      <td>1.0066065913617064</td>
    </tr>
  </tbody>
</table>
</div>



We have to process it in the same way we processed the test data for it to work!


```python
indexers = [StringIndexer(inputCol=column, outputCol=column+"_index").fit(test_df) for column in [f'cat_{x}' for x in range(19)] ]
pipeline = Pipeline(stages=indexers)
test_df_indexed = pipeline.fit(test_df).transform(test_df)
test_df_indexed.describe().toPandas()
test_df_indexed = df_indexed.select([c for c in df_indexed.columns if c not in [f'cat_{x}' for x in range(19)]]) 
```


```python
assembler = VectorAssembler(inputCols= [e for e in test_df_indexed.columns if e not in ('target')]  , outputCol='features', handleInvalid='skip')
test_output = assembler.transform(test_df_indexed)
imputer = Imputer(inputCols=['target'], outputCols=['label'], strategy='mean')
imputer_model = imputer.fit(test_output)
test_output = imputer_model.transform(test_output)
```

And now, we can predict the results!


```python
#And get their predictions
dtc_preds = dtc_model.transform(test_output)
rfc_preds = rfc_model.transform(test_output)
gbt_preds = gbt_model.transform(test_output)
```

To see how this all went, we can use ``` MulticlassClassificationEvaluator ```, which will give us an accuracy metric



```python
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
#We alias the method
evaluator = MulticlassClassificationEvaluator(metricName='accuracy')
```

And we display the results!


```python
print(f'DTC: {evaluator.evaluate(dtc_preds)} \n Features Importance: {dtc_model.featureImportances}\n\n') 
print(f'RFC: {evaluator.evaluate(rfc_preds)} \n Features Importance: {rfc_model.featureImportances}\n\n')
print(f'GBT: {evaluator.evaluate(gbt_preds)} \n Features Importance: {gbt_model.featureImportances}\n\n')
```

    DTC: 0.8346863468634687 
     Features Importance: (31,[2,3,4,6,7,12,13,15,19,20,22,28],[0.014701613420158115,0.043912393310141254,0.01632263297559012,0.023272955254936112,0.008767295495164232,0.07339838005021362,0.026900352099027025,0.0010919366626692384,0.11149836670131266,0.05104627569585904,0.31490514161563943,0.31418265671928924])
    
    
    RFC: 0.8191881918819188 
     Features Importance: (31,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],[0.007222725777778714,0.013272624708238185,0.06572063427606169,0.07383599205924346,0.016249034815029796,0.015671208937598453,0.013942792952495857,0.012265185023691075,0.022093613183070106,0.03017036047394847,0.02111126567214282,0.007573440666722141,0.03675523871622703,0.05340791474285819,0.018744859020368907,0.01438979707997024,0.014423643530970557,0.006122722273276428,0.0032687974851870532,0.040250295497554885,0.05959542094667576,0.010453230392129118,0.16357534034178262,0.002108188884061558,0.0018874200854626776,0.00033413253805777044,0.004749384890559298,0.08373181729146607,0.1565634402260749,0.005186828755947708,0.02532264875534833])
    
    
    GBT: 0.9035670356703567 
     Features Importance: (31,[0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,28,29,30],[0.019554090543858874,0.005057591508728023,0.004343430810202281,0.00926816409691567,0.020932768384980305,0.00785722449857247,0.010564110036515958,0.003058478492707305,0.017320953448943837,0.024428612308636587,0.010505062823265568,0.02208616336937158,0.05280964313333698,0.004004845413782193,0.005113000839952551,0.008379441440475512,0.022397774964668365,0.0033914933949762242,0.21514282579871444,0.15888697801622456,0.04162650837187161,0.26367570868275864,0.0013931935084589204,0.04507176479283232,0.013432437835222032,0.004494546034221436,0.005203187449805732])
    
    


Coherent with our heatmap (although this does not always work out this way) no feature has much importance than the rest (also because there are lots of features). The method that got a better result according to out metric is GBT, so that is what we will use for our submission:


```python
gbt_preds.toPandas()[['id', 'prediction']].to_csv('/content/predictions.csv')
```
