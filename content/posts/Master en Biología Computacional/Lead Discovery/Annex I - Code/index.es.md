---
title: "Annex I - Code"
author: Pablo Marcos
date: 2022-01-10
math: true
menu:
  sidebar:
    name: Annex I - Code
    identifier: code_lead_discovery
    parent: lead_discovery
    weight: 40
---

This jupyter notebook shall serve as accompanying material to the paper titled "Using Computational Methods to Discover Novel Drugs for the Treatment of Androgenetic Alopecia", a report for the "Computational Structural Biology for Lead Discovery" subject at UPM's Master in Computational Biology

## Imports

First, we proceed to import the modules we will use:


```python
import json                        # Lets us work with the json format
import requests                    # Allows Python to make web requests
import pandas as pd                # Analysis of tabular data
import numpy as np                 # Numerical library
import matplotlib.pyplot as plt    # Static, animated, and interactive visualizations

import rdkit                       # Cheminformatics and ML package
from rdkit.Chem import MACCSkeys   # MACCS fingerprint calculation
from rdkit.Chem import PandasTools # RDkit interaction with pandas
from rdkit.Chem import rdFingerprintGenerator #Generate fingerprints
from rdkit import Chem             # The chemistry library
from rdkit.Chem import Descriptors, Draw # Molecule descriptors for the Ro5
import rdkit.Chem.AllChem as AllChem # Import all RDKit chemistry modules
```

## Initial Analysis

First, we query the compounds targeting **CHEMBL1856** (3-oxo-5-alpha-steroid 4-dehydrogenase 2, a.k.a. 5-$\alpha$-reductase type II


```python
# Ask for at least 150 compounds
activity_url = "https://www.ebi.ac.uk/chembl/api/data/activity?target_chembl_id_exact=CHEMBL1856&offset=150&limit=150"
# Get results as JSON
activity_request = requests.get(activity_url, headers={"Accept":"application/json"}).json()
# Display as table
activity_table = pd.DataFrame.from_dict(activity_request['activities'])[['molecule_chembl_id',
                                                                         'type', 'standard_value', 'standard_units']]
```

We then process the data by Ki and standarize the values


```python
# Select only those that have Ki
activity_table_filter = activity_table.loc[activity_table['type']=="Ki"].copy().dropna()
# Transform the standard_value column to float to be able to work with it
activity_table_filter['standard_value'] = activity_table_filter['standard_value'].astype("float")
# Order the table by value and display first 5 values
activity_table_filter.sort_values(['standard_value']).head(5)
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
      <th>molecule_chembl_id</th>
      <th>type</th>
      <th>standard_value</th>
      <th>standard_units</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>143</th>
      <td>CHEMBL336532</td>
      <td>Ki</td>
      <td>7.6</td>
      <td>nM</td>
    </tr>
    <tr>
      <th>21</th>
      <td>CHEMBL3350133</td>
      <td>Ki</td>
      <td>44.0</td>
      <td>nM</td>
    </tr>
    <tr>
      <th>140</th>
      <td>CHEMBL340006</td>
      <td>Ki</td>
      <td>46.0</td>
      <td>nM</td>
    </tr>
    <tr>
      <th>25</th>
      <td>CHEMBL3350133</td>
      <td>Ki</td>
      <td>110.0</td>
      <td>nM</td>
    </tr>
    <tr>
      <th>141</th>
      <td>CHEMBL340006</td>
      <td>Ki</td>
      <td>265.0</td>
      <td>nM</td>
    </tr>
  </tbody>
</table>
</div>



We find the best compound to be CHEMBL296415. After [checking CHEMBL](https://www.ebi.ac.uk/chembl/compound_report_card/CHEMBL296415/), we find no information on selectivity; since we want it to be selective, we search for approved, selective drugs:


```python
# Specify approved drugs that target CHEMBL1856
mechanism_url = "https://www.ebi.ac.uk/chembl/api/data/mechanism?target_chembl_id__exact=CHEMBL1856"
# Get data from the URL
mechanism_components = requests.get(mechanism_url, headers={"Accept":"application/json"}).json()
# Format dataframe
mechanism_table = pd.DataFrame.from_dict(mechanism_components['mechanisms'])[['molecule_chembl_id', 'max_phase']]
mechanism_table #And print
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
      <th>molecule_chembl_id</th>
      <th>max_phase</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>CHEMBL710</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>



We find there is only one approved compound, Finasteride (**CHEMBL710**). Our focus will thus be finding drugs similar to Finasteride, but more effective, more selective, and with less side effects.

## Similarity Analysis

We upload FNS's SMILES TO [SwissSimilarity](http://www.swisssimilarity.ch/), select ChEMBL (activity<10µM) as subset and combined as method, run the analysis and save the result as "ScreeningResultsFinasteride.csv".

## Ligand Based Virtual Screening

We subset this data to get only the results most similar to FNS, using a series of metrics (DICE/Tanimoto, MACCS/Morgan) explained in the paper.


```python
# Define Query molecule
smiles = "CC(C)(C)NC(=O)[C@H]1CC[C@H]2[C@@H]3CC[C@H]4NC(=O)C=C[C@]4(C)[C@H]3CC[C@]12C"
Query = rdkit.Chem.MolFromSmiles(smiles)
# And depict it
rdkit.Chem.Draw.MolToImage(Query, includeAtomNumbers=True)
```




![png](output_files/output_16_0.png)




```python
raw_database = pd.read_csv('./ScreeningResultsFinasteride.csv', delimiter=';',
                           names =('ChemblID','Score','Smile'))       # Read the file and add titles
print(f"The initial compounds database has {len(raw_database)} molecules")
PandasTools.AddMoleculeColumnToFrame(raw_database, smilesCol='Smile') # Generate molecule (RoMol) from SMILES
```

    The initial compounds database has 400 molecules


Now, we will build databases for our fingerprints:


```python
# We build databases for the two methods
MACCSDatabase = raw_database.ROMol.apply(MACCSkeys.GenMACCSKeys)
MorganDatabase = rdFingerprintGenerator.GetFPs(raw_database["ROMol"].tolist())

# And prepare the queries:
MorganQuery = rdFingerprintGenerator.GetFPs([Query])[0]
MACCQuery = MACCSkeys.GenMACCSKeys(Query)
```

And we calculate the indices based on those fingerprints:


```python
# We calculate this indices both for the MACCS fingerprints
raw_database["Tanimoto (MACCS)"] = rdkit.DataStructs.BulkTanimotoSimilarity(MACCQuery, MACCSDatabase)
raw_database["Dice (MACCS)"] = rdkit.DataStructs.BulkDiceSimilarity(MACCQuery, MACCSDatabase)
# And for the morgan fingerprint too
raw_database["Tanimoto (Morgan)"] = rdkit.DataStructs.BulkTanimotoSimilarity(MorganQuery, MorganDatabase)
raw_database["Dice (Morgan)"] = rdkit.DataStructs.BulkDiceSimilarity(MorganQuery, MorganDatabase)
```

We can describe the new database:


```python
raw_database.describe()
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
      <th>Score</th>
      <th>Tanimoto (MACCS)</th>
      <th>Dice (MACCS)</th>
      <th>Tanimoto (Morgan)</th>
      <th>Dice (Morgan)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>400.000000</td>
      <td>400.000000</td>
      <td>400.000000</td>
      <td>400.000000</td>
      <td>400.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.055978</td>
      <td>0.482113</td>
      <td>0.640505</td>
      <td>0.157272</td>
      <td>0.258770</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.099914</td>
      <td>0.130162</td>
      <td>0.115564</td>
      <td>0.108950</td>
      <td>0.140409</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.025000</td>
      <td>0.205128</td>
      <td>0.340426</td>
      <td>0.035294</td>
      <td>0.068182</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.027750</td>
      <td>0.388682</td>
      <td>0.559785</td>
      <td>0.093458</td>
      <td>0.170940</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.030000</td>
      <td>0.450806</td>
      <td>0.621456</td>
      <td>0.113636</td>
      <td>0.204082</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.038000</td>
      <td>0.600000</td>
      <td>0.750000</td>
      <td>0.172580</td>
      <td>0.294359</td>
    </tr>
    <tr>
      <th>max</th>
      <td>0.998000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



As we can see, the simmilarity scores are pretty small, but this is to be expected when selecting "Combined - ChEMBL (activity<10µM)" in ENSEMBL, as it takes two methods (electroshape and fingerprint) which are quite different. For our Tanimoto and Dice metrics, we can see that all metrics including MACCS yield way better values than those used with the Morgan fingerprint, and those with Dice show better results than those with Tanimoto. Thus, we use "dice_maccs" as our parameter, and set the cutoff to 0.621456 (with a length of ~200 elements and representing Quartile 2) and save the data.


```python
raw_databasefilter = raw_database.loc[raw_database['Dice (MACCS)'].astype('float') > 0.621456]
raw_databasefilter.drop('ROMol', axis=1).to_csv('./SimilarityAnalysisFinasteride.csv', index=False)
print(f"The DICE(MACCS) filtered database has {len(raw_databasefilter)} molecules")
```

    The DICE(MACCS) filtered database has 200 molecules


## Pharmacophore Based Virtual Screning

We upload "SimilarityAnalysisFinasteride.csv" to Pharmit, and generate the "Finasteride-Similar 5ARIs KQMJ9Y" database. Since PharmIt requires the db format to be ".smi", we make the necessary changes:


```python
pharmit_input = raw_databasefilter['Smile'] + ' ' + raw_databasefilter['ChemblID']
pharmit_input.to_csv('./pharmit_input.smi', index=False, header=False)
```

We use our created pharmacophore (see paper) to filter the database, and download the results as "pharmit_output.sdf"

## ADMET Properties analysis

As a proxy for ADMET properties, we are using Lipinski's rule of five, adding TPSA as an additional method.


```python
def calculate_ro5_properties(smiles): # Define the funtion to validate Ro5
    molecule = Chem.MolFromSmiles(smiles)
    molecular_weight = Descriptors.ExactMolWt(molecule)
    n_hba = Descriptors.NumHAcceptors(molecule)
    n_hbd = Descriptors.NumHDonors(molecule)
    logp = Descriptors.MolLogP(molecule)
    TPSA = Descriptors.TPSA (molecule)
    conditions = [molecular_weight <= 500, n_hba <= 10, n_hbd <= 5, logp <= 5, TPSA < 140]
    ro5_fulfilled = sum(conditions) == 5
    return pd.Series(
        [molecular_weight, n_hba, n_hbd, logp, TPSA, ro5_fulfilled],
        index=["molecular_weight", "n_hba", "n_hbd", "logp", "TPSA", "ro5_fulfilled"],
    )
```

Read the database we will process:


```python
MoleculeDatabase = PandasTools.LoadSDF('./pharmit_output.sdf', embedProps=True, molColName=None, smilesName='smiles')
print(f"The pharmit database has {len(MoleculeDatabase)} molecules")
```

    The pharmit database has 51 molecules


And apply the Rule of Five


```python
# Calculate RO5 properties for all molecules
ro5_properties = MoleculeDatabase["smiles"].apply(calculate_ro5_properties)

# Concat the properties dataframe with the pharmit output dataframe
MoleculeDatabase_Concat = pd.concat([MoleculeDatabase, ro5_properties], axis=1)

#And separate by valid and invalid drugs (~ negates boolean values)
MoleculeDatabase_ro5_fulfilled = MoleculeDatabase_Concat[MoleculeDatabase_Concat["ro5_fulfilled"]]
MoleculeDatabase_ro5_violated = MoleculeDatabase_Concat[~MoleculeDatabase_Concat["ro5_fulfilled"]]
print(f"{len(MoleculeDatabase_ro5_fulfilled)} Ro5-following compounds found")
```

    30 Ro5-following compounds found


We save Ro5-fulfilling compounds for refference:


```python
MoleculeDatabase_ro5_fulfilled.to_csv("MolDB_Ro5.csv", index=False)
```

## Docking using DockThor (Autodock Vina)

For autodock vina, we want to screen the most similar molecules to our pharmacophore to see how these bind to our original targets. We can get the 4 best hits like so:


```python
MoleculeDatabase_ro5_fulfilled.sort_values(['rmsd'], ascending=False).head(4)
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
      <th>rmsd</th>
      <th>ID</th>
      <th>smiles</th>
      <th>molecular_weight</th>
      <th>n_hba</th>
      <th>n_hbd</th>
      <th>logp</th>
      <th>TPSA</th>
      <th>ro5_fulfilled</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>33</th>
      <td>0.60144037</td>
      <td>CHEMBL2397139</td>
      <td>CNC(=O)c1ccc(OC2CCC(NC(=O)NC34CC5CC(CC(C5)C3)C...</td>
      <td>425.267842</td>
      <td>3</td>
      <td>3</td>
      <td>4.00420</td>
      <td>79.46</td>
      <td>True</td>
    </tr>
    <tr>
      <th>23</th>
      <td>0.551425219</td>
      <td>CHEMBL1668930</td>
      <td>CC(=O)N1CCC(NC(=O)NC2CCC(C)(C)CC2)CC1</td>
      <td>295.225977</td>
      <td>2</td>
      <td>2</td>
      <td>2.26530</td>
      <td>61.44</td>
      <td>True</td>
    </tr>
    <tr>
      <th>17</th>
      <td>0.547150791</td>
      <td>CHEMBL2282650</td>
      <td>CC1=C2N(C)CC3C(CCC4(C)C(C(=O)NC(C)(C)C)CCC34)C...</td>
      <td>400.308979</td>
      <td>3</td>
      <td>1</td>
      <td>4.54840</td>
      <td>49.41</td>
      <td>True</td>
    </tr>
    <tr>
      <th>46</th>
      <td>0.510232747</td>
      <td>CHEMBL1631395</td>
      <td>CC(=O)Nc1cc2c3c(c1)n(C/C=C/Cn1cc(C)c(=O)[nH]c1...</td>
      <td>409.175004</td>
      <td>7</td>
      <td>2</td>
      <td>1.12242</td>
      <td>110.89</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>



And we process them using Autodock Vina. Unfortunately, this are not valid molecules (see paper). So, we process the full database to get one in SDF format for DockThor


```python
pd.options.mode.chained_assignment = None # Disable warnings
# Subset only the eseential columns
MoleculeDatabase_ro5_fulfilled.reset_index(inplace=True)
MitDatabase = MoleculeDatabase_ro5_fulfilled[['ID','smiles']]
# We add the molecule column using rdkit
PandasTools.AddMoleculeColumnToFrame(MitDatabase,'smiles','Molecule')
# And add Hidrogens to said molecules
MitDatabase['MoleculeH'] = MitDatabase['Molecule'].apply(Chem.AddHs)
# Compute 3D coordinates
MitDatabase['MoleculeH'].map(AllChem.EmbedMolecule);
```

And we save it:


```python
PandasTools.WriteSDF(MitDatabase, 'Finasteride_Similar_Ro5.sdf',
                     molColName='MoleculeH', properties=list(MitDatabase.columns))
```

We can now read the results and process them:


```python
# Load dataframes
bestranking_typeII = pd.read_csv('./bestranking_typeII.csv', delimiter=';', header=0)
bestranking_typeI  = pd.read_csv('./bestranking_typeI.csv',  delimiter=';', header=0)

# For each database, get the compound ID and select the Name and Score columns
for i, row in bestranking_typeII.iterrows(): bestranking_typeII['Name'][i] = bestranking_typeII['Name'][i].split('_')[-1]
bestranking_typeII = bestranking_typeII[['Name', 'Score']]

# For each database, get the compound ID and select the Name and Score columns
for i, row in bestranking_typeI.iterrows(): bestranking_typeI['Name'][i] = bestranking_typeI['Name'][i].split('_')[-1]
bestranking_typeI = bestranking_typeI[['Name', 'Score']]

# We rename the columns
bestranking_typeII.rename(columns = {'Score':'Score for type II'}, inplace = True)
bestranking_typeI.rename(columns = {'Score':'Score for type I'}, inplace = True)

# Merge the two dataframes
bestranking = pd.merge(bestranking_typeI, bestranking_typeII, how='inner', on = 'Name')

# Add CHEMBLIDs
for i, row in bestranking.iterrows():
    bestranking['Name'][i] = MoleculeDatabase_ro5_fulfilled.iloc[int(row["Name"])]['ID']

# And convert scores to Ki
bestranking["KI for type I"] = np.exp(-bestranking["Score for type I"]/(0.008314*(273+37)))
bestranking["KI for type II"] = np.exp(-bestranking["Score for type II"]/(0.008314*(273+37)))
```

Now, we select only those CHEMBLIDs that are more effective and selective than finasteride:


```python
initial_ki = float(bestranking.loc[bestranking["Name"]=="CHEMBL710"]["KI for type I"])
bestranking.loc[(bestranking["KI for type I"] >= initial_ki) & (bestranking["KI for type II"] <= initial_ki)]
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
      <th>Name</th>
      <th>Score for type I</th>
      <th>Score for type II</th>
      <th>KI for type I</th>
      <th>KI for type II</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>CHEMBL2057291</td>
      <td>-10.082</td>
      <td>-8.657</td>
      <td>49.988102</td>
      <td>28.757235</td>
    </tr>
    <tr>
      <th>2</th>
      <td>CHEMBL1343539</td>
      <td>-9.619</td>
      <td>-8.498</td>
      <td>41.768499</td>
      <td>27.036773</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CHEMBL2282650</td>
      <td>-9.608</td>
      <td>-8.746</td>
      <td>41.590612</td>
      <td>29.767617</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CHEMBL2057296</td>
      <td>-9.581</td>
      <td>-8.565</td>
      <td>41.157187</td>
      <td>27.748830</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CHEMBL76192</td>
      <td>-9.507</td>
      <td>-8.255</td>
      <td>39.992294</td>
      <td>24.604138</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CHEMBL2282653</td>
      <td>-9.351</td>
      <td>-8.616</td>
      <td>37.643461</td>
      <td>28.303388</td>
    </tr>
    <tr>
      <th>7</th>
      <td>CHEMBL1762030</td>
      <td>-9.271</td>
      <td>-8.796</td>
      <td>36.492965</td>
      <td>30.350742</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CHEMBL2282652</td>
      <td>-9.252</td>
      <td>-8.281</td>
      <td>36.224930</td>
      <td>24.853599</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CHEMBL1668930</td>
      <td>-9.204</td>
      <td>-7.939</td>
      <td>35.556526</td>
      <td>21.765096</td>
    </tr>
    <tr>
      <th>10</th>
      <td>CHEMBL1631395</td>
      <td>-9.186</td>
      <td>-8.164</td>
      <td>35.309066</td>
      <td>23.750579</td>
    </tr>
    <tr>
      <th>11</th>
      <td>CHEMBL1825149</td>
      <td>-9.137</td>
      <td>-7.898</td>
      <td>34.644117</td>
      <td>21.421599</td>
    </tr>
    <tr>
      <th>12</th>
      <td>CHEMBL3221237</td>
      <td>-9.109</td>
      <td>-8.250</td>
      <td>34.269783</td>
      <td>24.556452</td>
    </tr>
    <tr>
      <th>13</th>
      <td>CHEMBL1800917</td>
      <td>-9.108</td>
      <td>-8.054</td>
      <td>34.256489</td>
      <td>22.758239</td>
    </tr>
    <tr>
      <th>14</th>
      <td>CHEMBL280155</td>
      <td>-8.991</td>
      <td>-8.473</td>
      <td>32.736163</td>
      <td>26.775786</td>
    </tr>
    <tr>
      <th>15</th>
      <td>CHEMBL2282654</td>
      <td>-8.969</td>
      <td>-8.318</td>
      <td>32.457919</td>
      <td>25.212967</td>
    </tr>
    <tr>
      <th>16</th>
      <td>CHEMBL2057293</td>
      <td>-8.937</td>
      <td>-8.796</td>
      <td>32.057416</td>
      <td>30.350742</td>
    </tr>
    <tr>
      <th>17</th>
      <td>CHEMBL2282779</td>
      <td>-8.909</td>
      <td>-8.314</td>
      <td>31.711032</td>
      <td>25.173867</td>
    </tr>
    <tr>
      <th>18</th>
      <td>CHEMBL1668929</td>
      <td>-8.847</td>
      <td>-8.067</td>
      <td>30.957299</td>
      <td>22.873321</td>
    </tr>
    <tr>
      <th>19</th>
      <td>CHEMBL710</td>
      <td>-8.839</td>
      <td>-8.467</td>
      <td>30.861358</td>
      <td>26.713525</td>
    </tr>
  </tbody>
</table>
</div>



Since there are a lot of compounds, we can select those that are better among equals:


```python
bestranking.loc[(bestranking["KI for type I"] >= (initial_ki + 0.15*initial_ki )) &
                 (bestranking["KI for type II"] <= (initial_ki - 0.15*initial_ki))]
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
      <th>Name</th>
      <th>Score for type I</th>
      <th>Score for type II</th>
      <th>KI for type I</th>
      <th>KI for type II</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>CHEMBL76192</td>
      <td>-9.507</td>
      <td>-8.255</td>
      <td>39.992294</td>
      <td>24.604138</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CHEMBL2282652</td>
      <td>-9.252</td>
      <td>-8.281</td>
      <td>36.224930</td>
      <td>24.853599</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CHEMBL1668930</td>
      <td>-9.204</td>
      <td>-7.939</td>
      <td>35.556526</td>
      <td>21.765096</td>
    </tr>
  </tbody>
</table>
</div>



The discussion can be checked in the paper! :P


## Code and Acknowledgements

The header image for this post is [CC-By-Sa 3.0](http://creativecommons.org/licenses/by-sa/3.0/) by [Alberto Salguero](//commons.wikimedia.org/wiki/User:Alberto_Salguero) on [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Arabidopsis_thaliana_hojas_basales.jpg#/media/Archivo:Arabidopsis_thaliana_hojas_basales.jpg)
