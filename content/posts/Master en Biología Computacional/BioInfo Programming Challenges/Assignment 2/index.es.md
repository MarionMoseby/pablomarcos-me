---
title: "Your worst nightmare"
author: Pablo Marcos
date: 2021-11-09
math: true
menu:
  sidebar:
    name: Assignment 2
    identifier: asignment_2_bad_bad_bad
    parent: retos_progra
    weight: 40
---

<div style="text-align: center">
    <a href="https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%202" target="_parent"><img src="/posts/Imagenes/codeberg-badge.svg" align="center" width="20%"/></a>
</div>

</br>

A recent paper executes a meta-analysis of a few thousand published co-expressed gene sets from Arabidopsis.  They break these co-expression sets into ~20 sub-networks of <200 genes each, that they find consistently co-expressed with one another.  Assume that you want to take the next step in their analysis, and see if there is already information linking these predicted sub-sets into known regulatory networks.  One step in this analysis would be to determine if the co-expressed genes are known to bind to one another.

Using the co-expressed gene list from the "Assignment 2" folder:
* Use a combination of any or all of:  dbFetch, Togo REST API, EBI’s PSICQUIC REST API, DDBJ KEGG REST, and/or the Gene Ontology
* Find all protein-protein interaction networks that involve members of that gene list
* Determine which members of the gene list interact with each other.

Documentation can be accessed using YarDoc:

* ``` yardoc README.md find_interactions.rb ./Clases/Annotations.rb ./Clases/Gene.rb ./Clases/InteractionNetwork.rb ./Clases/ImportExportModule.rb```
* ``` yard server```

I have knowingly gitignored the html files from the repo to make it more legible, since they can be easily generated.

To run the script, use: ```ruby find_interactions.rb  ./SampleData/ArabidopsisSubNetwork_GeneList.txt report_file.txt```
