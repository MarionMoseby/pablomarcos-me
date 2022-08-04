---
title: "Designing a pharmacophore and ensuring ADMET properties"
author: Pablo Marcos
date: 2021-10-15
math: true
menu:
  sidebar:
    name: Assignment 1
    identifier: assig_1_lead_description_problem
    parent: lead_discovery
    weight: 40
---

<div style="text-align: center">
    <a href="./Target Selection and LBVS.ipynb" target="_parent"><img src="/posts/Imagenes/jupyter-badge.svg" align="center" width="20%"/></a>
</div> </br>

For this assignment, I will study Male Pattern Hair Loss, also called baldness or, more technically, alopecia. Although not technically a “disease” (it can be more accurately defined as a normal phenotipic variation) its high prevalence among caucasian men (~40% of men over 40),[^1] the age I am approaching and my family history, I believe this topic could be of great interest for me to investigate.

## Analysis of Molecular Mechanisms

Androgenetic alopecia is a  hereditary condition, in which scalp hair progressively thins, and eventually stops growing, under the influence of DiHidroTestosterone, an hormone derived from Testosterone.[^2] Although common myths persist, it is a poligenic disease: family history may influence the risk of suffering this condition, but does not perfecly predict it.[^3]

The molecular mechanism underlying this is pretty simple: in susceptible patients (those with the indicated genes), the transformation of free Testosterone into DHT by 5α-reductase, an enzyme involved in steroids metabolism, leads to a progressive thinning of the hairs being produced by the folicules, which is called “miniaturization”, until they stop growing at all.[^4] Hair on the scalp is genetically predisposed to be more sensitive to DHT, which is why the traditional “pattern”, with hair on the sides remaining, appears.[^2]

<div style="text-align: center">
    <img src="./reaction.png" alt="sometext" align="center" width="50%" />
    <p>Figure 1. Testosterone is reduced into DHT by 5α-reductase, an enzyme that uses NADPH. CC-By-4.0 by Governa et al. on PeerJ</p>
</div>

## Target selection

Finasteride is a drug developed in 1992 to treat Benign Prostate Hiperplasia, a disease similar to MPHL in that it is caused by excessive levels of DHT.[^5] In 1998, after some studies found that BPH patients presented increased hair growth and an stop in hair loss when taking this drug, and given its strong safety profile, the FDA approved it to treat MPHL too.[^6]

Finasteride works by blocking 5αR, and, more specifically, isoform II of the enzyme, which is expressed mostly in the prostate and in scalp skin[^7] (type I is expressed mostly in the liver and the rest of the skin).[^8] It works through competitive inhibition, binding to 5αR to produce DiHidroFinasteride instead of DHT. Since it eventually dissociates from the Enzyme-Substrate complex, it is not considered a suicide inhibitor.[^9] It has a short half-life of 5-7 hours, and, although more effective drugs with comparative side effects (such as Dutasteride, which is more effective at blocking 5αR) exist, they have not yet been approved to target MPHL (only BPH).[^10]

To sum up: the desired target, the protein whose activity we wish to block, is  5α-Reductase

## Hypothesis for Drug Design

We ideally would like to find a drug that selectively inhibits isoform II of  5αR, while keeping isoform I as untouched as posiible, since DHT remains an important and potent androgen, and its supression can lead to side effects such as decreased libido and sperm levels, erectile dysfunction and even depression.[^11]

Important to know is that 5α-Reductase Inhibitors (5ARIs) have been found to be teratogenic (that is, they cause developmental malformations) so, whatever drug we design, should never be used in minors or in pregnant women.[^12]

## Ligand based-virtual screening

The results can be seen in the accompanying Jupyter Notebook, but they can be summarized as follows:

- After searching for typeII 5α-Reductase typeII on CHEMBL, we get drugs which interact with it and order them in increasing order or IC50 (that is, decreasing order of inhibitory power)
- The best drug is CHEMBL296415, with  IC50 of 0.00086 ug/mL; however, we cannot be sure if it targets typeI 5aR (which will be undesirable) as well as typeI; so, we change the SwissSimilarity target to Finasteride.
- To see if we can improve FNS’s IC50  value (16 nM) we use SwissSimilarity to find similarly shaped molecules, using methods such as MACCS and Morgan Keys and Dice and Tanimoto indexes
- Out of the 400 “similar” molecules provided by Swiss, we pick those with Dice (MACCS) > 0.625, so as to get more than 150 molecules as commissioned, but not too much (it is to be noted that SwissSimilarity scores were really bad, but this is to be expected due to method selection)
- With this, 172 molecules are selected, and exported to SimilarityAnalysis.csv
- In Assignments 2 and 3, we will describe how to perform docking analysis on such molecules, to see whether one has a higher affinity that the original molecule (Finasteride)

For more details, please refer to the full notebook.

## References

[^1]: A. Goren et al., «A preliminary observation: Male pattern hair loss among hospitalized COVID-19 patients in Spain – A potential clue to the role of androgens in COVID-19 severity», J. Cosmet. Dermatol., vol. 19, n.o 7, pp. 1545-1547, 2020, doi: 10.1111/jocd.13443.
[^2]: V. A. Randall, «Molecular Basis of Androgenetic Alopecia», en Aging Hair, R. M. Trüeb y D. J. Tobin, Eds. Berlin, Heidelberg: Springer, 2010, pp. 9-24. doi: 10.1007/978-3-642-02636-2_2.
[^3]: W. C. Chumlea et al., «Family history and risk of hair loss», Dermatol. Basel Switz., vol. 209, n.o 1, pp. 33-39, 2004, doi: 10.1159/000078584.
[^4]: «baldness | dermatology | Britannica». https://www.britannica.com/science/baldness (accedido nov. 13, 2021).
[^5]: Health Products Regulatory Authority of England, «Public Assessment Report for a Medicinal Product for Human Use - Finasteride 1mg film-coated tablets». Accedido: nov. 13, 2021. [^En línea]. Disponible en: https://www.hpra.ie/img/uploaded/swedocuments/Public_AR_PA22753-002-001_20102020172946.pdf
[^6]: P. M. Zito, K. G. Bistas, y K. Syed, «Finasteride», en StatPearls, Treasure Island (FL): StatPearls Publishing, 2021. Accedido: nov. 13, 2021. [^En línea]. Disponible en: http://www.ncbi.nlm.nih.gov/books/NBK513329/
[^7]: F. Azzouni, A. Godoy, Y. Li, y J. Mohler, «The 5 Alpha-Reductase Isozyme Family: A Review of Basic Biology and Their Role in Human Diseases», Adv. Urol., vol. 2012, p. 530121, 2012, doi: 10.1155/2012/530121.
[^8]: W. D. Steers, «5alpha-reductase activity in the prostate», Urology, vol. 58, n.o 6 Suppl 1, pp. 17-24; discussion 24, dic. 2001, doi: 10.1016/s0090-4295(01)01299-7.
[^9]: S. L. Hulin-Curtis, D. Petit, W. D. Figg, A. W. Hsing, y J. K. Reichardt, «Finasteride metabolism and pharmacogenetics: new approaches to personalized prevention of prostate cancer», Future Oncol. Lond. Engl., vol. 6, n.o 12, pp. 1897-1913, dic. 2010, doi: 10.2217/fon.10.149.
[^10]: «FICHA TECNICA DUTASTERIDA CINFA 0,5 MG CAPSULAS BLANDAS EFG». https://cima.aemps.es/cima/dochtml/ft/80595/FT_80595.html (accedido nov. 13, 2021).
[^11]: «Side Effects of 5-Alpha Reductase Inhibitors: A Comprehensive Review - PubMed». https://pubmed.ncbi.nlm.nih.gov/27784557/ (accedido nov. 12, 2021).
[^12]: «PROSPECTO FINASTERIDA SANDOZ 1 mg COMPRIMIDOS RECUBIERTOS CON PELICULA EFG». https://cima.aemps.es/cima/dochtml/p/70567/P_70567.html (accedido nov. 12, 2021).

Header Image by Andrea Piacquadio at Pexels
