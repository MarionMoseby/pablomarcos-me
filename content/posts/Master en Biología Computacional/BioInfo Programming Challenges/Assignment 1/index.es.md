---
title: "Creating Objects"
author: Pablo Marcos
date: 2021-10-19
math: true
menu:
  sidebar:
    name: Assignment 1
    identifier: asignment_1_retos_ruby
    parent: retos_progra
    weight: 40
---

<div style="text-align: center">
    <a href="https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%201" target="_parent"><img src="/posts/Imagenes/codeberg-badge.svg" align="center" width="20%"/></a>
</div>

Your task is to use Object-oriented programming to achieve two things:

1) "Simulate" planting 7 grams of seeds from each of the records in the seed stock genebank; then, you should update the genebank information to show the new quantity of seeds that remain after a planting. The new state of the genebank should be printed to a new file, using exactly the same format as the original file seed_stock_data.tsv. If the amount of seed is reduced to zero or less than zero, then a friendly warning message should appear on the screen. The amount of seed left in the gene bank is, of course, not LESS than zero guiño


2) Process the information in cross_data.tsv and determine which genes are genetically-linked. To achieve this, you will have to do a Chi-square test on the F2 cross data. If you discover genes that are linked, this information should be added as a property of each of the genes (they are both linked to each other).

To run the script, use: ```ruby process_database.rb  ./SampleData/gene_information.tsv  ./SampleData/seed_stock_data.tsv ./SampleData/cross_data.tsv  new_stock_file.tsv```
