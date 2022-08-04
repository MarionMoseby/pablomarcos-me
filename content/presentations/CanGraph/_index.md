---
title: CanGraph
description: a python utility to study and analyse cancer-associated metabolites using knowledge graphs
outputs: Reveal
reveal_hugo:
  custom_theme: /reveal-themes/colorful-shapes/styles.css
  margin: 0.2
  width: 1200
  height: 675
  slide_number: true
  highlight_theme: color-brewer
  transition: slide
  transition_speed: medium
  templates:
    hotpink:
      class: hotpink
      background: '#FF4081'

---

{{< slide background-image="/reveal-themes/colorful-shapes/presentation.png" >}}

</br></br>

# CanGraph

##### a python utility to study and analyse cancer-associated metabolites using knowledge graphs

~ by [Pablo Ignacio Marcos López](https://www.pablomarcos.me/)

</br></br>

<div style="display: flex" class="row">
  <div style="flex: 50%" class="column ">
    <img style="margin-right: 30%;" data-src="IARC Logo.png" width="45%">
  </div>
  <div style="flex: 50%" class="column ">
    <small style="vertical-align: middle">July 11, 2022</small>
  </div>
</div>

---

{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

<h3 style="text-align:left"> Introduction</h3>

* Cancer is one of the leading causes of death, with 19 M diagnoses and 10 M deaths each year

* A modest part of this work is carried out at IARC, where we try to identify cancer-related metabolites to include them in IARC's reputed **Monographs**; but this is costly and complicated

* To solve this, **metabolomics**, the global analysis of small molecule metabolites, is being increasingly used

---


{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_2.png" >}}

<h3 style="text-align:left"> Objectives </h3>

<p style="text-align:left"> Given the need to automate interaction with bast metabolomics data, and harnessing the power of machines, we want to: </p>

* Create a python program that extracts Knowledge sub-Graphs from a series of existing DataBases (*like google*, but for metabolomics!)

* Automate the analysis of the resulting graphs

* Eventually, offer the program as SaaS using the Agency's HPC system and a web-interface

---

{{% section %}}
{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

To do this, we will use

## Five DataBases and Five Search Parameters...

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

## Five DataBases


<div class="r-stack">
  <img class="fragment" src="hmdb.png" width="30%">
  <img class="fragment" src="drugbank.png" width="30%">
  <img class="fragment" src="smpdb.png" width="30%">
  <img class="fragment" src="exposome-explorer.jpg" width="30%">
  <img class="fragment" src="wikidata.png" width="30%"">
</div>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_2.png" >}}

##### which complement each other...

![](comparison-table.png)

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

## and Five Search Parameters...

</br></br>
<div style="display: flex" class="row">
  <div style="flex: 50%" class="column fragment">
    HMDB ID
  </div>
  <div style="flex: 50%" class="column fragment">
    CHEBI ID
  </div>
</div>
</br>
<div style="display: flex" class="row">
  <div style="flex: 50%" class="column fragment">
    Name
  </div>
  <div style="flex: 50%" class="column fragment">
    InChI and InChIKey
  </div>
</div>

{{% /section %}}

---

{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

that are related thanks to:

## The Database Management System

<img class="fragment" data-src="neo4j.png" width="30%">

---

{{% section %}}
{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

and unified under

## a common schema

---

{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_2.png" >}}

* To arrive to this, we merged the five schemas of the five databases we use by **carefully investigating each of the node types and their properties**, removing duplicates and condensing information

* The idea is to minimize the number of fields while maximizing the information contained on each, leading to **as little information loss** as possible

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

This way, we can reduce the number of nodes from 70 to 29, and the number of relations, from 98 to 35

<img class="" data-src="figure_1a.png" width="50%">
<img class="fragment" data-src="figure_1b.png" width="50%">


{{% /section %}}

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

The workflow would be:

![](flowchart-full.jpg)

---

{{% section %}}
{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

## Seeing the outputs...

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}
![](figure_2.png)
</br></br>
<small>Schema of CanGraph’s output</small>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png"  >}}
![](figure_3a.png)
</br></br>
<small>A Publication node and some related Drugs, Metabolites and Proteins</small>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}
![](figure_3b.png)
</br></br>
<small>All the Pathways a Metabolite is a part of</small>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}
![](figure_3c.png)
</br></br>
<small>All the Diseases related to a Protein</small>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}
![](figure_3d.png)
</br></br>
<small>Some Proteins and their Sequences</small>

{{% /section %}}

---

{{% section %}}
{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

... and understanding them

![](figure_4.png)
</br></br>
<small>Categories (search terms) used for data import and databases from which the data comes</small>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

<div>
<div style="float:left;">
<img data-src="figure_4a.png" width="75%">
</div>
<div style="float:rigth; text-align:left">
</br></br>

The most used criterion is structural similarity, which makes sense, since it doesn't require an exact match

ChEBI is the less used one due to problems with the way it was supplied

Lots of exact InChI matches

</div>
</div>

---

{{< slide background-image="/reveal-themes/colorful-shapes/quote_or_image.png" >}}

<div>
<div style="float:left;">
<img data-src="figure_4b.png" width="75%">
</div>
<div style="float:rigth; text-align:left">
</br></br>

The most used database is WikiData, since its the most general

HMDB has a high relevance, since HMDB was one of the search queries

SMPDB is the least used, but also the smallest DB

</div>
</div>

{{% /section %}}

---

{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

</br></br>

<h3 style="text-align:left"> Potential Improvements</h3>

* The processing time is **still too high** (60 h + per metabolite). Since the publication was written, we have reduced this to 6 h

* Neo4J's python driver is **really unstable**

* The networks need to be post-processed

</br>

{{% fragment %}} Potential solution: Use the HPC system  {{% /fragment %}}

---

{{< slide background-image="/reveal-themes/colorful-shapes/content_slide_1.png" >}}

<h3 style="text-align:left"> Conclussions</h3>

* We were able to develop a software that acts as a *search engine* on existing databases, pulling metabolic sub-networks that will help IARC **determine potential cancer associations**.

* We would like to provide the software as SaaS, to present the graphs in a more attractive and informative way

* Running the program on IARC's HPC system **might help reduce** the main roadblocks we have encountered


---

{{< slide background-image="/reveal-themes/colorful-shapes/last_slide.png" >}}

</br></br></br></br>

# Thank you!

<small>Bibliography and additional information can be found in the [original TFM document]()</small>

[↩️](#) Back to the beggining

</br></br></br></br>

<img style="position: absolute; right: 0px; bottom: 0px;" data-src="creativecommons.png" width="20%">
