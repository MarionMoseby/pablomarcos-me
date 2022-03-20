---
title: "GFF feature files and visualization"
author: Pablo Marcos
date: 2021-11-30
math: true
menu:
  sidebar:
    name: Assignment 3
    identifier: finding_insertional_mutagenesis
    parent: retos_progra
    weight: 40
---

<div style="text-align: center">
    <a href="https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%203" target="_parent"><img src="/posts/Imagenes/codeberg-badge.svg" align="center" width="20%"/></a>
</div>

#### Tasks:  for 10% (easy)

1. **Using BioRuby**, examine the sequences of the ~167 Arabidopsis genes from the last assignment by retrieving them from whatever database you wish
2. Loop over every exon feature, and scan it for the CTTCTT sequence
3. Take the coordinates of every CTTCTT sequence and create a new Sequence Feature. Add that new Feature to the EnsEMBL Sequence object.
4. Once you have found and added them all, loop over each one of your CTTCTT features and create a GFF3-formatted file of these features.
5. Output a report showing which genes on your list do NOT have exons with the CTTCTT repeat

#### Tasks:  for 10% (hard)

6. Re-execute your GFF file creation so that the CTTCTT regions are now in the full chromosome coordinates used by EnsEMBL.  Save this as a separate **new** file.
7. Prove that your GFF file is correct by uploading it to ENSEMBL and adding it as a new “track” [to the genome browser of Arabidopsis](http://plants.ensembl.org/info/website/upload/index.html)
8. Along with your code, for this assignment please submit a screenshot of your GFF track for the AT2G46340 gene on the ENSEMBL website to proof that you were successful.

Documentation can be accessed using YarDoc:

* ``` yardoc README.md insertional_mutagenesis.rb ./Clases/Embl_to_GFF3.rb ./Clases/ImportExportModule.rb```
* ``` yard server```

I have knowingly gitignored the html files from the repo to make it more legible, since they can be easily generated.

To run the script, use: ```ruby insertional_mutagenesis.rb  ./SampleData/ArabidopsisSubNetwork_GeneList.txt report_file.gff3```

