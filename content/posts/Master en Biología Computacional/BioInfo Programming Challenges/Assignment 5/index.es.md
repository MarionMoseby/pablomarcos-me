---
title: "SPARQL Queries"
author: Pablo Marcos
date: 2021-12-30
math: true
menu:
  sidebar:
    name: Assignment 5
    identifier: sparql_queries
    parent: retos_progra
    weight: 40
---
SPARQL is a query language and protocol for searching, adding, modifying or deleting RDF (Resource Description Framework) graph data available on the Internet. Its name is a recursive acronym that stands for SPARQL Protocol and RDF Query Language. Its syntax and functionality is quite simmilar to that of SQL, given that both are designed to query large databases; [the main difference is](https://cambridgesemantics.com/blog/semantic-university/learn-sparql/sparql-vs-sql/) that SQL does this by accessing tables in relational databases, and SPARQL works with a web of Linked Data

For this assignment, we will use SPARQL's Jupyter Notebook Kernel to answer some questions regarding a series of online databases:

<div style="text-align: center">
    <a href="https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%205" target="_parent"><img src="/posts/Imagenes/codeberg-badge.svg" align="center" width="20%"/></a>
</div>

## UniProt SPARQL Endpoint

First, we will use uniprot's SPARQL to learn some things about the UniProt DB. For this, we first have to set up the endpoint to uniprot, and we will set the format to JSON since it is easier to process using Jupyter and will automatically generate some nice tables!

We need to use some [kernel magic instructions](https://github.com/paulovn/sparql-kernel/blob/master/doc/magics.rst) for that! 


```sparql
%endpoint https://sparql.uniprot.org/sparql
%format JSON
```

And, now, we can begin the problem solving!

1. How many protein records are in UniProt? 


```sparql
PREFIX core:<http://purl.uniprot.org/core/> 

SELECT (COUNT(?protein) AS ?Total) # I first tried COUNT(DISTINCT ?protein), but it took ages to run
WHERE{ 
        ?protein a core:Protein .
}
```


<div class="krn-spql"><table><tr class=hdr><th>Total</th></tr><tr class=odd><td class=val>360157660</td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


2. How many Arabidopsis thaliana protein records are there in UniProt?


```sparql
PREFIX core:<http://purl.uniprot.org/core/> 
PREFIX taxon:<http://purl.uniprot.org/taxonomy/>

SELECT (COUNT(DISTINCT ?protein) AS ?Total)
WHERE{ 
        ?protein a core:Protein .            # Select proteins only
        ?protein core:organism taxon:3702 .  # Arabidopsis thaliana has taxa id 3702
}
```


<div class="krn-spql"><table><tr class=hdr><th>Total</th></tr><tr class=odd><td class=val>136782</td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


3. Retrieve pictures of Arabidopsis thaliana from UniProt


```sparql
PREFIX foaf: <http://xmlns.com/foaf/0.1/>     # We use the FOAF vocabulary to learn what an image is
PREFIX core: <http://purl.uniprot.org/core/>
SELECT ?name ?image                             
WHERE {
       ?taxon  foaf:depiction  ?image .       # We select images
       ?taxon  core:scientificName ?name .    # And get their associated names
  FILTER regex(?name, '^Arabidopsis thaliana$', 'i') . #We keep only those exactly named "Arabidopsis thaliana"
}
```


<div class="krn-spql"><table><tr class=hdr><th>name</th>
<th>image</th></tr><tr class=odd><td class=val>Arabidopsis thaliana</td>
<td class=val><a href="https://upload.wikimedia.org/wikipedia/commons/3/39/Arabidopsis.jpg" target="_other">https://upload.wikimedia.org/wikipedia/commons/3/39/Arabidopsis.jpg</a></td></tr><tr class=even><td class=val>Arabidopsis thaliana</td>
<td class=val><a href="https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Arabidopsis_thaliana_inflorescencias.jpg/800px-Arabidopsis_thaliana_inflorescencias.jpg" target="_other">https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Arabidopsis_thaliana_inflorescencias.jpg/800px-Arabidopsis_thaliana_inflorescencias.jpg</a></td></tr></table><div class="tinfo">Total: 2, Shown: 2</div></div>


4. What is the description of the enzyme activity of UniProt Protein Q9SZZ8 


```sparql
PREFIX core:<http://purl.uniprot.org/core/> 
PREFIX uniprot:<http://purl.uniprot.org/uniprot/> 
# Hint: rdfs and label are already prefixed!

SELECT ?description
WHERE {
  uniprot:Q9SZZ8 a core:Protein ;          # We select the uniprot protein #Q9SZZ8
                   core:enzyme ?enzyme .   # Only if it is an enzyme we save the ?enzyme variable
  ?enzyme core:activity ?activity .        # For the enzime, we get its activity
  ?activity rdfs:label ?description        # And for its activity, we get the description label
}
```


<div class="krn-spql"><table><tr class=hdr><th>description</th></tr><tr class=odd><td class=val>Beta-carotene + 4 reduced ferredoxin [iron-sulfur] cluster + 2 H(+) + 2 O(2) = zeaxanthin + 4 oxidized ferredoxin [iron-sulfur] cluster + 2 H(2)O.</td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


5. Retrieve the proteins IDs, and date of submission, for proteins that have been added to UniProt this year


```sparql
PREFIX core:<http://purl.uniprot.org/core/> 

# Without a limit, jupyter will not load the results. A script-query works fine! :p
# Also, I cant place this comment alongside "LIMIT". Dont know why
SELECT ?id ?date
WHERE{
  ?protein a core:Protein .             # Select all instances of protein from uniprot
  ?protein core:mnemonic ?id .          # and from them, retrieve the mnemonic as ?id
  ?protein core:created ?date .         # also, get the time of creation as ?date
  FILTER (contains(STR(?date), "2021")) # We only want those submitted in 2021
} LIMIT 10 
```


<div class="krn-spql"><table><tr class=hdr><th>id</th>
<th>date</th></tr><tr class=odd><td class=val>A0A1H7ADE3_PAEPO</td>
<td class=val>2021-06-02</td></tr><tr class=even><td class=val>A0A1V1AIL4_ACIBA</td>
<td class=val>2021-06-02</td></tr><tr class=odd><td class=val>A0A2Z0L603_ACIBA</td>
<td class=val>2021-06-02</td></tr><tr class=even><td class=val>A0A4J5GG53_STREE</td>
<td class=val>2021-04-07</td></tr><tr class=odd><td class=val>A0A6G8SU52_AERHY</td>
<td class=val>2021-02-10</td></tr><tr class=even><td class=val>A0A6G8SU69_AERHY</td>
<td class=val>2021-02-10</td></tr><tr class=odd><td class=val>A0A7C9JLR7_9BACT</td>
<td class=val>2021-02-10</td></tr><tr class=even><td class=val>A0A7C9JMZ7_9BACT</td>
<td class=val>2021-02-10</td></tr><tr class=odd><td class=val>A0A7C9KUQ4_9RHIZ</td>
<td class=val>2021-02-10</td></tr><tr class=even><td class=val>A0A7D4HP61_NEIMU</td>
<td class=val>2021-02-10</td></tr></table><div class="tinfo">Total: 10, Shown: 10</div></div>


6. How  many species are in the UniProt taxonomy?


```sparql
PREFIX core:<http://purl.uniprot.org/core/> 

SELECT (COUNT(DISTINCT ?taxon) AS ?Total)
WHERE{
  ?taxon a core:Taxon .             # Select all instances of taxon from uniprot
  ?taxon core:rank core:Species     # and from them, all taxons with level = species 
}
```


<div class="krn-spql"><table><tr class=hdr><th>Total</th></tr><tr class=odd><td class=val>2029846</td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


7. How many species have at least one protein record?


```sparql
# This WILL take a long time to execute. Please, pick a coffee, sit back, and enjoy the flight!
PREFIX core: <http://purl.uniprot.org/core/>

SELECT (COUNT(DISTINCT ?species) AS ?Total)
WHERE 
{
    ?protein a core:Protein .           # Select all protein records from uniprot
    ?protein core:organism ?species .   # Select all the species present on those proteins
    ?species a core:Taxon .             # (species are a taxon)
    ?species core:rank core:Species .   # a taxon with level = species
}
```


<div class="krn-spql"><table><tr class=hdr><th>Total</th></tr><tr class=odd><td class=val>1057158</td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


8.  Find the AGI codes and gene names for all Arabidopsis thaliana  proteins that have a protein function annotation description that mentions “pattern formation”


```sparql
# The SKOS (Simple Knowledge Organization System) vocabulary is a common data model for sharing and linking 
#knowledge organization systems via the Semantic Web. We will use it to get description labels
PREFIX skos:<http://www.w3.org/2004/02/skos/core#> 
PREFIX core:<http://purl.uniprot.org/core/> 
PREFIX taxon:<http://purl.uniprot.org/taxonomy/> 

SELECT ?agi_code ?gene_name
WHERE{ 
    ?protein a core:Protein .                              # Select all instances of protein from uniprot
    
    ?protein core:organism taxon:3702 .                    # From those proteins, keep those from arabidopsis only
    ?protein core:annotation ?annotation .
    ?annotation a core:Function_Annotation .               # I mean, their functional annotations!
    ?annotation rdfs:comment ?description .                # And select their description (save for later)
  

    ?protein core:encodedBy ?gene .                        # See which gene encodes the protein
    ?gene core:locusName ?agi_code .                       # and get the AGI codes
    ?gene skos:prefLabel ?gene_name .                      # and the name
    
    # Now that we have everything, we filter our answers by description
    # Could have placed this earlier to improve computer time; it loks cleaner this way though
    FILTER regex( ?description, 'pattern formation','i') .
    
} LIMIT 10
```


<div class="krn-spql"><table><tr class=hdr><th>agi_code</th>
<th>gene_name</th></tr><tr class=odd><td class=val>At3g54220</td>
<td class=val>SCR</td></tr><tr class=even><td class=val>At4g21750</td>
<td class=val>ATML1</td></tr><tr class=odd><td class=val>At1g13980</td>
<td class=val>GN</td></tr><tr class=even><td class=val>At5g40260</td>
<td class=val>SWEET8</td></tr><tr class=odd><td class=val>At1g69670</td>
<td class=val>CUL3B</td></tr><tr class=even><td class=val>At1g63700</td>
<td class=val>YDA</td></tr><tr class=odd><td class=val>At2g46710</td>
<td class=val>ROPGAP3</td></tr><tr class=even><td class=val>At1g26830</td>
<td class=val>CUL3A</td></tr><tr class=odd><td class=val>At3g09090</td>
<td class=val>DEX1</td></tr><tr class=even><td class=val>At4g37650</td>
<td class=val>SHR</td></tr></table><div class="tinfo">Total: 10, Shown: 10</div></div>


## MetaNetX SPARQL Endpoint

MetaNetX.org is an online platform for accessing, analyzing and manipulating genome-scale metabolic networks (GSM) as well as biochemical pathways. To this end, it integrates a great variety of data sources and tools. In this assignment, we would like to find what is the MetaNetX Reaction identifier for the UniProt Protein Q18A79


```sparql
# Of course, we need to reset the endpoint
%endpoint https://rdf.metanetx.org/sparql  
```


<div class="krn-spql"><div class="magic">Endpoint set to: https://rdf.metanetx.org/sparql</div></div>



```sparql
PREFIX meta: <https://rdf.metanetx.org/schema/>
PREFIX uniprot: <http://purl.uniprot.org/uniprot/>

SELECT DISTINCT ?reaction_identifier # This is HUGE. If we dont DISTINCT, we get 128 repetitions!!
WHERE{
    ?peptide meta:peptXref uniprot:Q18A79 . # First, we get all molecules in metanetx that correspond to UNiprot's Q18A79
    ?catalyzes meta:pept ?peptide .         # We extract the peptides from all of those molecules
    ?gpr meta:cata ?catalyzes ;             # Get the reactions catalyzed by said peptide
         meta:reac ?reaction .              # We get the associated reactions
    ?reaction rdfs:label ?reaction_identifier . # And we use rdfs to get the ID label
    
    #Not 100% necessary, but can be used to filter out invalid identifiers
    FILTER regex( ?reaction_identifier, '^mnx*','i') .
}
```


<div class="krn-spql"><table><tr class=hdr><th>reaction_identifier</th></tr><tr class=odd><td class=val>mnxr165934</td></tr><tr class=even><td class=val>mnxr145046c3</td></tr></table><div class="tinfo">Total: 2, Shown: 2</div></div>


## Federated Query

To finish up, we will learn how to do federated queries, i.e. those that implement more than one database, making them talk among themselves. Here, we ask, what is the “mnemonic” Gene ID and the MetaNetX Reaction identifier for the protein that has “Starch synthase” catalytic activity in Clostridium difficile (taxon 272563)?

First, we need to decide the endpoint. Since we are doing a "composite" search, ¿which endpoint should be use? ¿The one from UniProt or the one from Metanext? 

The answer is, **any of those**! The endpoint is just our "point of entry" to the semantic web, and, while it makes it easier to run some "local" queries, with the correct syntax we can navigate all databases!

I will thus use UniProt, since its interface is cuter; but its up to you!


```sparql
%endpoint https://sparql.uniprot.org/sparql
```


<div class="krn-spql"><div class="magic">Endpoint set to: https://sparql.uniprot.org/sparql</div></div>


Now, lets divide the question by parts: first, what is the mnemonic ID of the protein that has “Starch synthase” catalytic activity in Clostridium difficile? We can almost re-use some code from exercise 8:


```sparql
PREFIX core: <http://purl.uniprot.org/core/>
PREFIX taxon: <http://purl.uniprot.org/taxonomy/>

SELECT ?protein
WHERE
{
    ?protein a core:Protein .
    ?protein core:organism taxon:272563 .
    ?protein core:mnemonic ?mnemonic .
    ?protein core:classifiedWith ?goTerm .
    ?goTerm rdfs:label ?activity .
    FILTER regex( ?activity, 'starch synthase','i') .
}
```


<div class="krn-spql"><table><tr class=hdr><th>protein</th></tr><tr class=odd><td class=val><a href="http://purl.uniprot.org/uniprot/Q18A79" target="_other">http://purl.uniprot.org/uniprot/Q18A79</a></td></tr></table><div class="tinfo">Total: 1, Shown: 1</div></div>


But... wait!! I have already seen this before! This is exactly the same protein from exercise 9!! I know how to solve this!


```sparql
%endpoint https://rdf.metanetx.org/sparql  
PREFIX meta: <https://rdf.metanetx.org/schema/>
PREFIX uniprot: <http://purl.uniprot.org/uniprot/>

SELECT DISTINCT ?reaction_identifier 
WHERE{
    ?peptide meta:peptXref uniprot:Q18A79 .
    ?cata meta:pept ?peptide .             
    ?gpr meta:cata ?cata ;                 
         meta:reac ?reaction .              
    ?reaction rdfs:label ?reaction_identifier . 
    FILTER regex( ?reaction_identifier, '^mnx*','i') .
}
```


<div class="krn-spql"><div class="magic">Endpoint set to: https://rdf.metanetx.org/sparql</div></div>



<div class="krn-spql"><table><tr class=hdr><th>reaction_identifier</th></tr><tr class=odd><td class=val>mnxr165934</td></tr><tr class=even><td class=val>mnxr145046c3</td></tr></table><div class="tinfo">Total: 2, Shown: 2</div></div>


Ok, that was great! We can solve the exercise step-by-step. But, ¿can we do it all in one go, without changing endpoints as promised and getting all the results in a neat, simple table! Yes we can! We just need to use some sub-stringing and some binding to get Metanetx to understand what we want from it. It would work like this:


```sparql
# Set endpoint to UniProt (I prefer it)
%endpoint https://sparql.uniprot.org/sparql

# Do some prefixes
PREFIX meta: <https://rdf.metanetx.org/schema/>
PREFIX core: <http://purl.uniprot.org/core/>
PREFIX taxon: <http://purl.uniprot.org/taxonomy/>

#Prepare the selects
SELECT DISTINCT ?mnemonic ?reaction_identifier ?protein
WHERE
{
    # The SERVICE function lets me use servers independently of the enpoint; great!
    service <http://sparql.uniprot.org/sparql> { 
        # Code derived from exercise 8
        ?protein a core:Protein .
        ?protein core:organism taxon:272563 .
        ?protein core:mnemonic ?mnemonic .
        ?protein core:classifiedWith ?goTerm .
        ?goTerm rdfs:label ?activity .
        FILTER regex( ?activity, 'starch synthase','i') .
    }
    
    service <https://rdf.metanetx.org/sparql> {
        # Code derived from exercise 9
        ?peptide meta:peptXref ?protein . # ?protein is already on up:up endpoint! No need to BIND anything haha
        ?catalyzes meta:pept ?peptide .
        ?gpr meta:cata ?catalyzes ;
             meta:reac ?reac .
        ?reac rdfs:label ?reaction_identifier .
        FILTER regex( ?reaction_identifier, '^mnx*','i') .
  }
} 
```


<div class="krn-spql"><div class="magic">Endpoint set to: https://sparql.uniprot.org/sparql</div></div>



<div class="krn-spql"><table><tr class=hdr><th>mnemonic</th>
<th>reaction_identifier</th>
<th>protein</th></tr><tr class=odd><td class=val>GLGA_CLOD6</td>
<td class=val>mnxr165934</td>
<td class=val><a href="http://purl.uniprot.org/uniprot/Q18A79" target="_other">http://purl.uniprot.org/uniprot/Q18A79</a></td></tr><tr class=even><td class=val>GLGA_CLOD6</td>
<td class=val>mnxr145046c3</td>
<td class=val><a href="http://purl.uniprot.org/uniprot/Q18A79" target="_other">http://purl.uniprot.org/uniprot/Q18A79</a></td></tr></table><div class="tinfo">Total: 2, Shown: 2</div></div>


And, ¡that would be it!!
