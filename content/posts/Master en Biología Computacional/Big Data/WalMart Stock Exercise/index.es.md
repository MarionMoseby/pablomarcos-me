---
title: "Walmart Stock Exercise"
author: Pablo Marcos
date: 2021-10-14
math: true
menu:
  sidebar:
    name: Walmart Stock Exercise
    identifier: walmart_stock_exercise
    parent: big_data_master
    weight: 40
---

Create a Jupyter notebook to execute the following tasks, as part of the Big Data engineerig course:

<div style="text-align: center">
    <a href="./Walmart_Stock_Data_Exercise.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div>

#### Start a simple Spark session


```
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

import pandas as pd
```

#### Load the Walmart Stock CSV file, let Spark infer the data types


```
df = spark.read.options(infersSchema="true").csv("/content/walmart_stock.csv")
df.printSchema()
```

    root
     |-- _c0: string (nullable = true)
     |-- _c1: string (nullable = true)
     |-- _c2: string (nullable = true)
     |-- _c3: string (nullable = true)
     |-- _c4: string (nullable = true)
     |-- _c5: string (nullable = true)
     |-- _c6: string (nullable = true)
    


As we can see, Spark is not really good at infering the Schema. Lets manually coerce it:


```
df = spark.read.options(header="true").csv("/content/walmart_stock.csv")
df.printSchema()
```

    root
     |-- Date: string (nullable = true)
     |-- Open: string (nullable = true)
     |-- High: string (nullable = true)
     |-- Low: string (nullable = true)
     |-- Close: string (nullable = true)
     |-- Volume: string (nullable = true)
     |-- Adj Close: string (nullable = true)
    


Good! Now it works (more or less, see point 4)

#### Show the column names


```
df.schema.names
```




    ['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Adj Close']



#### What does the Schema look like?


```
df.printSchema()
```

    root
     |-- Date: string (nullable = true)
     |-- Open: string (nullable = true)
     |-- High: string (nullable = true)
     |-- Low: string (nullable = true)
     |-- Close: string (nullable = true)
     |-- Volume: string (nullable = true)
     |-- Adj Close: string (nullable = true)
    


However, as you can see in Point 5, not all columns are strings: some of them are dates, some are numbers... We will have to fix this later

#### Print out the first 5 rows


```
df.toPandas().head() #If I dont do toPandas(), I only print the first row, and the formatting is worse
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
      <th>Date</th>
      <th>Open</th>
      <th>High</th>
      <th>Low</th>
      <th>Close</th>
      <th>Volume</th>
      <th>Adj Close</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2012-01-03</td>
      <td>59.970001</td>
      <td>61.060001</td>
      <td>59.869999</td>
      <td>60.330002</td>
      <td>12668800</td>
      <td>52.619234999999996</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2012-01-04</td>
      <td>60.209998999999996</td>
      <td>60.349998</td>
      <td>59.470001</td>
      <td>59.709998999999996</td>
      <td>9593300</td>
      <td>52.078475</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2012-01-05</td>
      <td>59.349998</td>
      <td>59.619999</td>
      <td>58.369999</td>
      <td>59.419998</td>
      <td>12768200</td>
      <td>51.825539</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2012-01-06</td>
      <td>59.419998</td>
      <td>59.450001</td>
      <td>58.869999</td>
      <td>59.0</td>
      <td>8069400</td>
      <td>51.45922</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2012-01-09</td>
      <td>59.029999</td>
      <td>59.549999</td>
      <td>58.919998</td>
      <td>59.18</td>
      <td>6679300</td>
      <td>51.616215000000004</td>
    </tr>
  </tbody>
</table>
</div>



#### Use describe() to learn about the DataFrame


```
df.toPandas().describe() #If I do toPandas(), the shown info is cuter and more useful
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
      <th>Date</th>
      <th>Open</th>
      <th>High</th>
      <th>Low</th>
      <th>Close</th>
      <th>Volume</th>
      <th>Adj Close</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>1258</td>
      <td>1258</td>
      <td>1258</td>
      <td>1258</td>
      <td>1258</td>
      <td>1258</td>
      <td>1258</td>
    </tr>
    <tr>
      <th>unique</th>
      <td>1258</td>
      <td>957</td>
      <td>956</td>
      <td>938</td>
      <td>943</td>
      <td>1250</td>
      <td>1184</td>
    </tr>
    <tr>
      <th>top</th>
      <td>2014-09-18</td>
      <td>74.839996</td>
      <td>75.190002</td>
      <td>74.510002</td>
      <td>73.510002</td>
      <td>12653800</td>
      <td>69.701339</td>
    </tr>
    <tr>
      <th>freq</th>
      <td>1</td>
      <td>5</td>
      <td>5</td>
      <td>5</td>
      <td>5</td>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
</div>



#### Format the numbers to show only 2 decimal places


```
#Moving it definitely toPandas() to make it easier to manage the df and set datatypes. 
df2 = df.toPandas().astype({'Date': "string", 'Open': float, 'High': float, 'Low': float, 'Close': float, 'Volume': float, 'Adj Close': float})
pd.options.display.float_format = '{:.2f}'.format
df2.head()
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
      <th>Date</th>
      <th>Open</th>
      <th>High</th>
      <th>Low</th>
      <th>Close</th>
      <th>Volume</th>
      <th>Adj Close</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2012-01-03</td>
      <td>59.97</td>
      <td>61.06</td>
      <td>59.87</td>
      <td>60.33</td>
      <td>12668800.00</td>
      <td>52.62</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2012-01-04</td>
      <td>60.21</td>
      <td>60.35</td>
      <td>59.47</td>
      <td>59.71</td>
      <td>9593300.00</td>
      <td>52.08</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2012-01-05</td>
      <td>59.35</td>
      <td>59.62</td>
      <td>58.37</td>
      <td>59.42</td>
      <td>12768200.00</td>
      <td>51.83</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2012-01-06</td>
      <td>59.42</td>
      <td>59.45</td>
      <td>58.87</td>
      <td>59.00</td>
      <td>8069400.00</td>
      <td>51.46</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2012-01-09</td>
      <td>59.03</td>
      <td>59.55</td>
      <td>58.92</td>
      <td>59.18</td>
      <td>6679300.00</td>
      <td>51.62</td>
    </tr>
  </tbody>
</table>
</div>



#### Create a new DataFrame with a column called  'HV Ratio' that is the ratio of the High Price vs Volume of Stock traded for a day


```
newdf = df2; newdf['HV Ratio'] = newdf['High']/newdf['Volume']
newdf.head()
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
      <th>Date</th>
      <th>Open</th>
      <th>High</th>
      <th>Low</th>
      <th>Close</th>
      <th>Volume</th>
      <th>Adj Close</th>
      <th>HV Ratio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2012-01-03</td>
      <td>59.97</td>
      <td>61.06</td>
      <td>59.87</td>
      <td>60.33</td>
      <td>12668800.00</td>
      <td>52.62</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2012-01-04</td>
      <td>60.21</td>
      <td>60.35</td>
      <td>59.47</td>
      <td>59.71</td>
      <td>9593300.00</td>
      <td>52.08</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2012-01-05</td>
      <td>59.35</td>
      <td>59.62</td>
      <td>58.37</td>
      <td>59.42</td>
      <td>12768200.00</td>
      <td>51.83</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2012-01-06</td>
      <td>59.42</td>
      <td>59.45</td>
      <td>58.87</td>
      <td>59.00</td>
      <td>8069400.00</td>
      <td>51.46</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2012-01-09</td>
      <td>59.03</td>
      <td>59.55</td>
      <td>58.92</td>
      <td>59.18</td>
      <td>6679300.00</td>
      <td>51.62</td>
      <td>0.00</td>
    </tr>
  </tbody>
</table>
</div>



You may think: It makes no sense! How can the HV Ratio be always 0? Dont worry: its just that we asked pandas to only show the first two decimals. If we ask it to show, for example, 10 decimal places:


```
pd.options.display.float_format = '{:.8f}'.format
newdf.head()
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
      <th>Date</th>
      <th>Open</th>
      <th>High</th>
      <th>Low</th>
      <th>Close</th>
      <th>Volume</th>
      <th>Adj Close</th>
      <th>HV Ratio</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2012-01-03</td>
      <td>59.97000100</td>
      <td>61.06000100</td>
      <td>59.86999900</td>
      <td>60.33000200</td>
      <td>12668800.00000000</td>
      <td>52.61923500</td>
      <td>0.00000482</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2012-01-04</td>
      <td>60.20999900</td>
      <td>60.34999800</td>
      <td>59.47000100</td>
      <td>59.70999900</td>
      <td>9593300.00000000</td>
      <td>52.07847500</td>
      <td>0.00000629</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2012-01-05</td>
      <td>59.34999800</td>
      <td>59.61999900</td>
      <td>58.36999900</td>
      <td>59.41999800</td>
      <td>12768200.00000000</td>
      <td>51.82553900</td>
      <td>0.00000467</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2012-01-06</td>
      <td>59.41999800</td>
      <td>59.45000100</td>
      <td>58.86999900</td>
      <td>59.00000000</td>
      <td>8069400.00000000</td>
      <td>51.45922000</td>
      <td>0.00000737</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2012-01-09</td>
      <td>59.02999900</td>
      <td>59.54999900</td>
      <td>58.91999800</td>
      <td>59.18000000</td>
      <td>6679300.00000000</td>
      <td>51.61621500</td>
      <td>0.00000892</td>
    </tr>
  </tbody>
</table>
</div>



#### What day had the Peak High in Price?

This is easy to do with sql:


```
df.createOrReplaceTempView("Wallmart")
spark.sql("SELECT Date FROM Wallmart where High = (SELECT MAX(High) from Wallmart);").show()
```

    +----------+
    |      Date|
    +----------+
    |2015-01-13|
    +----------+
    


#### What is the mean of the Close column


```
spark.sql("SELECT AVG(Close) from Wallmart;").show()
```

    +--------------------------+
    |avg(CAST(Close AS DOUBLE))|
    +--------------------------+
    |         72.38844998012726|
    +--------------------------+
    


#### What is the max and min of the Volume column?


```
spark.sql("SELECT MIN(Volume), MAX(Volume) from Wallmart;").show()
```

    +-----------+-----------+
    |min(Volume)|max(Volume)|
    +-----------+-----------+
    |   10010500|    9994400|
    +-----------+-----------+
    


#### How many days was the Close lower than 60 dollars?


```
spark.sql("SELECT COUNT(Date) from Wallmart WHERE Close < 60;").show()
```

    +-----------+
    |count(Date)|
    +-----------+
    |         81|
    +-----------+
    


#### What percentage of time was the High greater than 80 dollars?


```
spark.sql("SELECT COUNT(Date) from Wallmart WHERE High > 80;").show()
```

    +-----------+
    |count(Date)|
    +-----------+
    |        106|
    +-----------+
    


#### What is the Pearson correlation between High and Volume?

This works better with Pandas:


```
newdf['High'].corr(newdf['Volume'])
```




    -0.3384326061737164



#### What is the max High per year?

For this, we need to set the datatype of the date column as datetime, so that python can work with it; then, we can work with the code:


```
newdf['Date'] = pd.to_datetime(newdf['Date'], format='%Y-%m-%d')
newdf.groupby(newdf['Date'].dt.year)['High'].max()
```




    Date
    2012   77.59999800
    2013   81.37000300
    2014   88.08999600
    2015   90.97000100
    2016   75.19000200
    Name: High, dtype: float64



#### What is the average Close for each calendar month?


```
newdf.groupby(newdf['Date'].dt.month)['Close'].mean()
```




    Date
    1    71.44801958
    2    71.30680444
    3    71.77794378
    4    72.97361901
    5    72.30971689
    6    72.49537742
    7    74.43971944
    8    73.02981855
    9    72.18411785
    10   71.57854545
    11   72.11108931
    12   72.84792478
    Name: Close, dtype: float64


