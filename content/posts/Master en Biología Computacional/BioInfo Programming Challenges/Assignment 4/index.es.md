---
title: "Finding Orthologues in Arabidopsis Thaliana"
author: Pablo Marcos
date: 2021-12-07
math: true
menu:
  sidebar:
    name: Assignment 4
    identifier: finding_orthologues
    parent: retos_progra
    weight: 40
---

The idea for this assignment is find the orthologue pairs between species Arabidopsis and S. pombe using BioRuby to do BLAST and parse the BLAST-generated reports. We will use use "reciprocal best BLAST", scanning for Protein A of Species A in the whole proteome of Species B, and then BLAST the top hit against all proteins in Species A. If the top hits match, the protein is a good Orthologue candidate.

To decide on "sensible" BLAST parameters, we have done a bit of online reading, and cited the papers or websites that provided the information. Also, we have writen a few sentences describing how we would continue to analyze the putative orthologues we just discovered, to prove that they really are orthologues. We WILL NOT write the code - just describe in words what that code would do.

<div style="text-align: center">
    <a href="https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%204" target="_parent"><img src="/posts/Imagenes/codeberg-badge.svg" align="center" width="20%"/></a>
</div>

Documentation can be accessed using YarDoc:

* ``` yardoc README.md blast_orthologues.rb ./Clases/Embl_to_GFF3.rb ./Clases/ImportExportModule.rb ./Clases/BlastCmdEnhanced.rb```
* ``` yard server```

I have knowingly gitignored the html files from the repo to make it more legible, since they can be easily generated.

To run the script, use: ```ruby blast_orthologues.rb  ./SampleData/target_genome.fa ./SampleData/protein.fa report_file.txt```

## Design choices

### BLAST parameters

* For the **e-value** (measures similarity beyond randomness), I choose 0.000001 as my cutoff, following the advice given by *Ward and Moreno-Hagelsieb* and standard practice.
* This paper, *Ward and Moreno-Hagelsieb* also suggest that we add a **Smith-Waterman final alignment** (-F “m S” -s T) to our BLASTP options; however, this would mean changing the code, rendering ```BlastCmdEnhanced..makeblast_besthits()``` useless and greatly increasing computing time, which is already quire high (around 7 hrs). So, we will just keep a soft filter (-F “m S”), which masks low information segments only during the search phase, reducing the values of masking to increase the accuracy scores of the alignment.
*  In normal, command-line, bash BLAST, there are more detailed formatting options: ```"blastp -query {0} -subject {1} -evalue {2} -outfmt '6 qseqid qseq sseqid sseq qcovs pident evalue' > {3}"```, which can be used to filter for **coverage and identity**, as well as for e-value; unfortunately, BioRuby does seems to be **really bad** at managing this, so I have been forced to design the following backstop solution:
    * For **coverage**, which is the percent of the query length that is included in the aligned segments, bioruby only returns absolute values (in total nucleotides), and calls it "overlap" (in violation of existing naming conventions and for no reason at all), so I decided to divide it by the total length of the sequence and multiplying by 100 to get the percentage value, which PAPER A suggest should be of more than 50%. This makes sense: we dont want a sequence with a really good e-value (i.e. really good alignment) but with, for instance only 10 nucleotides known out of a total length of 1000.
    * For **identity**, [bioruby is supposed to provide](http://bioruby.org/rdoc/Bio/Blast/Report/Hit.html) a ```percent_identity()``` method; however, whenever I have called it in the program it refused to work, always returning 0 when ```identity()``` did return non-zero values. Thus, I had to get the percentage value myself, once again by dividing by ```.query_len``` and multiplying by 100. According to *Ostlund et al*, this is usually higher than 60% for eukaryotes, but I decided to go with a value of 30% as [it seems to be more commonplace](https://www.researchgate.net/post/Minimum-Nucleotide-Percent-Identity-for-Homologous-Orthologous-Sequences); after all, if the genes are orthologues, we would expect at least some of the bases to be identical, although others might have changed due to neutral evolution and mutations.
* This large amount of conditions greatly reduces the amount of positives, from 2400 with e-value only to... actually 0!! After doing some tests, I have found that this is due mainly to identity, so I have deactivated that parameter (setting the treshold to 0). This is not that big of a deal: identity should be smaller the closer two samples are in time, but orthologues can be far, far away! With the new treshold, I get way less matches (1800), but, given the high coverage, we can be **pretty sure** they are good putative orthologues.
* Some problems might arise if two or more FASTA sequences with non-unique headers are provided as either query or target. Fortunately, none of the files provided here exhibited this problem (and they shouldn't! its malpractice on the user's end to provide with non-standard files, let alone non-unique FASTA headers!)

### File input

I have decided against allowing tar.gz or any compressed files as an input; I believe file decompression is better left to the OS and the user, which I have thus forced to use fasta files.

### Guessing BLAST type

Some internet solutions suggested creating a function for automatically guessing the BLAST types. It would go along the following lines:

    ```
    def self.guess_blast_type(query, target)
        if self.guess_fastatype(target) =='dna' and self.guess_fastatype(query) =='dna'
            return 'blastn'
        elsif self.guess_fastatype(target) =='prot' and self.guess_fastatype(query) =='prot'
            return 'blastp'
        elsif self.guess_fastatype(target) =='prot' and self.guess_fastatype(query) =='dna'
            return 'blastx'
        elsif self.guess_fastatype(target) =='dna' and self.guess_fastatype(query) =='prot'
            return 'tblastn'
        elsif self.guess_fastatype(target) =='dna' and self.guess_fastatype(query) =='dna'
            return 'tblastx'
        else
            abort("[ERROR]: Something went wrong when trying to detect BLAST type")
        end
    end
    ```

However, as you can see, there is a conflict between **tblastx** and **blastn**: they both use DNA fastas as source type, and choosing between them depends essentially on the desires of the user running the program. Thus, I have decided against including such function in my code: I could ignore **tblastx** and create a function only useful for this assignment, but, given that the idea, as I see it, is to create as general and as useful and reusable classes as possible, I believe it is better to ask the user to do this manually.

## What to do next? (Bonus 1%)

To confirm whether the list of putative orthologues found in report.txt is, in fact, made up of real orthologues or not, *Trachana et al.* suggest that we use the genome of a third species, ideally related both to *A. Thaliana* and *S. pombe* (our target and query organisms) to perform a Cluster of Orthologous Genes, a clustering method based on the results of our Best Reciprocal BLASTs. By selecting only as valid those clusters of orthologues with hits for the three species, we would be a little more sure that we are dealing with genuinely orthologous genes

Another option would be to use the mentioned third specied to generate a phylogenetic tree usign alignment algorithms such as ClustalW, and infering orthology from speciation events; this is not only less computationally efficient than the clustering algorithms presented in the last paragraph, but, as *Bapteste et al.* suggest, it is not even a failproof way of showing gene-to-gene relation.

## Bibliography

- Bapteste, E., et al. «Do orthologous gene phylogenies really support tree-thinking?» BMC Evolutionary Biology, vol. 5, mayo de 2005, p. 33. PubMed Central, https://doi.org/10.1186/1471-2148-5-33.

- Moreno-Hagelsieb, G., y K. Latimer. «Choosing BLAST Options for Better Detection of Orthologs as Reciprocal Best Hits». Bioinformatics, vol. 24, n.º 3, febrero de 2008, pp. 319-24. DOI.org (Crossref), https://doi.org/10.1093/bioinformatics/btm585.

- On the definition of sequence identity. (s. f.). Recuperado 20 de diciembre de 2021, de https://lh3.github.io/2018/11/25/on-the-definition-of-sequence-identity

- Ostlund, G., Schmitt, T., Forslund, K., Kostler, T., Messina, D. N., Roopra, S., Frings, O., & Sonnhammer, E. L. L. (2010). InParanoid 7: New algorithms and tools for eukaryotic orthology analysis. Nucleic Acids Research, 38(Database), D196-D203. https://doi.org/10.1093/nar/gkp931

- Smith, E. (s. f.). Library guides: Ncbi bioinformatics resources: an introduction: blast: compare & identify sequences. Recuperado 20 de diciembre de 2021, de https://guides.lib.berkeley.edu/ncbi/blast

- Trachana, Kalliopi, et al. «Orthology prediction methods: A quality assessment using curated protein families». Bioessays, vol. 33, n.º 10, octubre de 2011, pp. 769-80. PubMed Central, https://doi.org/10.1002/bies.201100062.

- Ward, Natalie, y Gabriel Moreno-Hagelsieb. «Quickly Finding Orthologs as Reciprocal Best Hits with BLAT, LAST, and UBLAST: How Much Do We Miss?» PLOS ONE, vol. 9, n.º 7, julio de 2014, p. e101850. PLoS Journals, https://doi.org/10.1371/journal.pone.0101850.

- Yuan, Y. P., et al. «Towards Detection of Orthologues in Sequence Databases». Bioinformatics (Oxford, England), vol. 14, n.º 3, 1998, pp. 285-89. PubMed, https://doi.org/10.1093/bioinformatics/14.3.285.

- Zhou, Y., y L. F. Landweber. «BLASTO: A Tool for Searching Orthologous Groups». Nucleic Acids Research, vol. 35, n.º Web Server, mayo de 2007, pp. W678-82. DOI.org (Crossref), https://doi.org/10.1093/nar/gkm278.

## Code and Acknowledgements

Source code for the assignment can be found [here](https://codeberg.org/FlyingFlamingo/assignment-answers/src/branch/main/Assignment%204)

The header image for this post is [CC-By-Sa 3.0](http://creativecommons.org/licenses/by-sa/3.0/) by [Alberto Salguero](//commons.wikimedia.org/wiki/User:Alberto_Salguero) on [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Arabidopsis_thaliana_hojas_basales.jpg#/media/Archivo:Arabidopsis_thaliana_hojas_basales.jpg)

---

This document can easily be converted to PDF format using pandoc:

``` pandoc --pdf-engine=xelatex README.md -o README.pdf ```
