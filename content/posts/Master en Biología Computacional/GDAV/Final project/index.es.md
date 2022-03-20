---
title: GDAV Final Project
date: 2022-01-20
author: Pablo Marcos
menu:
  sidebar:
    name:   Final Project
    identifier: final_project
    parent: gdav
    weight: 80
geometry: margin=2.5cm
bibliography: Bibliography.bib
csl: vancouver-superscript-brackets-only-year.csl
header-includes:
    - # Allow multicol by replacing \begin with \Begin
    - \usepackage{multicol}
    - \newcommand{\hideFromPandoc}[1]{#1}
         \hideFromPandoc{
             \let\Begin\begin
             \let\End\end
         }
    - # Make code cells wrap text
    - \usepackage{fvextra}
    - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
---

The following is a list of the commands used for the Final Project of the "Genomic Data Analysis and Visualization" subject, from UPM's Master in Computational Biology.

# Project Description

Our lab has identified an hot spring in Iceland, which, in the spring, undergoes events of high temperature (~90 ºC), producing algae blooms. Our intention is to study this blooms, performing an in-depth genomic and
metagenomic exploration of this singular ecosystem.

# Metagenomics

##  Most abundant organisms and relative abundance

As a first step, we run a shotgun metagenomic sequencing of the prokaryotic microbiome in two of kind of samples, obtained at different times: one sample taken during the high temperature episodes, and another right after them, when the temperature is back to normal and there is a bloom of algae. We extracted the DNA present in each sample, performing an Illumina sequencing which results can be accessed in GDAV's server:

```{.bash}

# First, we connect to the server:
ssh pablo.marcos.lopez@138.4.139.16

# We can list the contents of the final-project folder, where Illumina results are:
ls ~/final_project/

# We found two files:

    # Forward and reverse reads from the high temperature sample
    ./metagenomics-hotspring-hightemp.1.fq.gz
    ./metagenomics-hotspring-hightemp.2.fq.gz

    # And Forward and reverse reads from the normal temperature sample
    ./metagenomics-hotspring-normaltemp.1.fq.gz
    ./metagenomics-hotspring-normaltemp.2.fq.gz

```

First, we used the [mOTUs tool](https://motu-tool.org/tutorial.html)[^milanese_microbial_2019] to perform a taxonomic profiling of your samples, using config files to ensure that both forward and reverse strands are processed:

```{.bash}

# First, we create a results folder to store them:
mkdir  ~/Results/
mkdir  ~/Results/Metagenomics/

# Navigate to the local files folder
cd  ~/final_project/

# Run the motus analysis for the High Temperature Samples:
motus profile -f metagenomics-hotspring-hightemp.1.fq.gz -r metagenomics-hotspring-hightemp.2.fq.gz  \
              -o ~/Results/Metagenomics/high_temperatures.motu

# And for the Low Temperature Samples, too:
motus profile -f metagenomics-hotspring-normaltemp.1.fq.gz  -r metagenomics-hotspring-normaltemp.2.fq.gz   \
              -o ~/Results/Metagenomics/normal_temperatures.motu

```

To analyze the results, we can use [mOTUs' official guide](https://github.com/motu-tool/mOTUs/wiki/Explain-the-resulting-profile); one of the first warnings we get is that ``` The length of the first 2500 reads is 151. It is suggested to quality control the reads before profiling```; this might mean that Illumina's sequencing was not of a good quality. Now, we would like to see what is the most abundant organism in high-temperature, and what is its relative abundance.

```{.python}

# For this, we can first inspect the file:
nano ~/Results/Metagenomics/high_temperatures.motu

# We see that it has a header and some columns. We can first read the file removing said column in python:
import pandas as pd # Do the necessary imports
high_heat = pd.read_csv("~/Results/Metagenomics/high_temperatures.motu", skiprows=2, header = 0, sep = "\t")

# And print only those organisms that are present:
high_heat.sort_values(by="unnamed sample", ascending = False).query('`unnamed sample` > 0')

```

As we can see if we run the code above, the most abundant organism is *Aquifex aeolicus* [ref_mOTU_v25_10705], with a relative abundance of **0.846838**. That is, well, ¡huge! and comparable to none of the other values, which are all smaller than 0.15.

###  Aquifex aeolicus: an in-depth analysis

This organism, *Aquifex aeolicus*, is a known species [^deckert_complete_1998-1], an extreme heat-loving bacterium that is known for feeding on gases and inorganic chemicals. Its genome has previously been sequenced in whole, and it consists on 1,512 open-reading frames,[^noauthor_aquifex_nodate]  [^noauthor_aquifex_nodate-1] which have been decoded as part of a Nature article,[^deckert_complete_1998-1] which may be consulted in NCBI.[^deckert_complete_1998]  [^deckert_complete_1998] In general lines, is a chemolithoautotrophic, Gram-negative, motile, hyperthermophilic bacterium. It is the best detailed species of the genus aeolicus, named after it and because the genus was discovered in submarine volcanic vents near the Aeolian Islands, located north of Sicily.[^gupta_molecular_2013] Like the other species of its genus, it is rod-shaped and about 4 μm in length and 0.5 in radius.[^deckert_complete_1998]

Its preferred growth conditions are between 85 and 95 ºC and with a pH between 7 and 9,[^guiral_microbe_nodate] and, although it requires oxygen to grow, it prefers microaerophilic conditions, such as those found in our pond as the temperature rises. Regarding its genome, as we have seen, it is completely sequenced, and there is reason to believe that it is one of the oldest species of bacteria, since it has many genes in common with both filamentous and archaea (more than 16% of the genome).[^reysenbach_phylogenetic_1994]

## Other abundant species

To find which are the most abundant species in the "normal temperature scenario, and how they compare with the ones in the high-temp scenario, we can run the following code:

```{.python}

import pandas as pd # Do the necessary imports

# First, we can generate the normal temperature database.
normal_temp = pd.read_csv("~/Results/Metagenomics/normal_temperatures.motu", skiprows=2, header = 0, sep = "\t"
                         ).sort_values(by="unnamed sample", ascending = False).query('`unnamed sample` > 0')

normal_temp_filtered = normal_temp.query('`unnamed sample` > 0.01') # Here, we filter only for those with abundance > 0.01 (1%)
normal_temp # If you are using IPython, display like this. If not, print()

# We can recreate the previous database
higher_temp = pd.read_csv("~/Results/Metagenomics/high_temperatures.motu", skiprows=2, header = 0, sep = "\t"
                         ).sort_values(by="unnamed sample", ascending = False).query('`unnamed sample` > 0')

# Finally, we get the comparison:
higher_temp.merge(normal_temp_filtered,how="outer", on="#consensus_taxonomy"
                 ).rename(columns = {"#consensus_taxonomy":"Species","unnamed sample_x":"High Temp. Abundance", "unnamed sample_y":"Normal Temp. Abundace"}
                 ).fillna(0)

```

As we can see in the code output, it most abundant species is *Methanococcus maripaludis* [ref_mOTU_v25_01426], with a relative abundance of 4.8%. Aquifex aeolicus [ref_mOTU_v25_10705] has a relative abiundance of 2.1%, and the rest of the unknown species, -1, have a relative abundace of 1.1%. As we can see, these three groups do not sum up to 100%, which indicates us that, at a normal temperature, there is a much bigger amount of diversity, which reduces tremendously when temperature grows; thus, this periods of high temperature act as a "bottleneck" on the population. This is because, at high temperatures, only *Aquifex aeolicus* and *Methanococcus maripaludis* remain at a significant relative level: with 84.68 and 13.17% of the bacterial population, respectively; the rest of the bacteria represent a measly 1.1% of the individuals.

Here, we can introduce an interesting concept: **$\alpha$-diversity**, also known as **species richness**, which is the diversity within a particular area or ecosystem, usually expressed by the number of species therein present.[^noauthor_7_2018] This can be calculated using the following code:

```{.python}

# Apply the same code as in the old chunk and do:
print(f"The a-diversity for the Higher-Temperature scenario is {len(higher_temp)}")
print(f"The a-diversity for the Normal-Temperature scenario is {len(normal_temp)}")

```

Since the $\alpha$-diversity for the Normal-Temperature scenario is 230, whereas the Normal-Temperature scenario has only 16 species, we can conclude that, without a doubt, it is the Normal-Temperature scenario that presents a higher level of species richness.

An interesting detail, however, can be noted: there is no algae diversity here. This can be checked using the following code:

```{.bash}

# First, we generate the mOTUs databases:
motus profile -f metagenomics-hotspring-hightemp.1.fq.gz -r metagenomics-hotspring-hightemp.2.fq.gz  \
              -o ~/Results/Metagenomics/kingdoms_high.motu -k kingdom

motus profile -f metagenomics-hotspring-normaltemp.1.fq.gz  -r metagenomics-hotspring-normaltemp.2.fq.gz   \
              -o ~/Results/Metagenomics/kingdoms_normal.motu -k kingdom

# And then, we read them:
tail -n+4 ~/Results/Metagenomics/kingdoms_high.motu | cat
tail -n+4 ~/Results/Metagenomics/kingdoms_normal.motu | cat

```

As one can see, on both cases, no Eukaryot was detected, with around 90% of the individuals in both cases being bacteria and the resting 9% being archea, with 1% being unclassified individuals (it is interesting to note that, in the High temperature sample, the Archaea proportion grows from 6% to 13% - this makes sense! Archaeas are more extremophilic than most bacteria!). Since algae are part of the Eukaryota kingdom, this means that no algae were detected. This makes sense, due to two things:

* On the first hand, when we decided to do our first shotgun analysis, we picked *only prokaryotic samples*, which means that, of course, no algae where selected.
* Moreover, mOTUs works by identifying species based on their 16S ribosomic RNA sequences,[^milanese_microbial_2019] which means that it will **never** be able to detect algae, Eukaryotic beings wich lack a rRNA 16S component, *even if* they were present in our shotgun analysis .

In all, we can conclude that the normal temperature is the one with the most biodiversity, with a 20-fold increase in species counts telling us that, definitely, most bacterial species are bad at surviving at super high (~90 ºC) temperatures. That both *A. aeolicus*'s and Archaea's relative abundance rises dramatically when the heat is turned on also tells us a lot about their hyperthermophilicity: they are the only ones able to prosper in such a terrible environment, with the rest of the microorganisms probably facing bottleneck speciation events.

#  Genome Analysis

## Sample Analysis

Having found an organism that is relatively abundant in high-temperature conditions, we would like to further characterize it, sequencing its whole genome and performing an RNAseq analysis of samples from both cultures at  both high and normal temperature conditions, with two replicates each. After performing quality checks, and picking only high quality reads, we get 8 files, 2 replicates for 2 organisms in 2 different conditions. We can find out the number of reads in the following way:

```{.python}

import os # First, we uncompress the databases; we need to import os to do that
from Bio import SeqIO # We will also import SeqIO for later

# We create the output directory
os.system("mkdir ~/Results/Genome_Analysis/")

# And uncompress the files
os.chdir(os.path.expanduser("~/final_project/RNAseq"))
os.system('for f in *.gz ; do gunzip -c "$f" > ~/Results/Genome_Analysis/"${f%.*}" ; done')

# We can now check the number of reads:
for file in os.listdir(os.path.expanduser("~/Results/Genome_Analysis")):
    records = list(SeqIO.parse(os.path.join(os.path.expanduser("~/Results/Genome_Analysis"),file), "fastq"))
    print(f"Total reads for {file}: {len(records)}")

```

We find that all the high-temperature samples have the same number of reads (318693), as do all the normal-temperature ones (288742). These samples are paired-end reads, since we have two files, one forward and one reverse, for each read. This can be further confirmed by looking at the files themselves:

```{.bash}

head -n 4 ~/Results/Genome_Analysis/normal02.r1.fq
head -n 4 ~/Results/Genome_Analysis/normal02.r2.fq

```

### Reads Analysis

By printing the first 4 lines (which correspond to the most abundant organism, AQUIFEX_00001_47, we can see that they follow Illumina's FastQ format [^noauthor_fastq_nodate], where each individual has, at the end of their identifier, a 1 or a 2, depending on whether they are read from the forward or reverse strand. [^noauthor_bioinformatics_nodate]. To find out whether the sequences are all the same length or not, we can use the following code, which builds on our previous program, and was derived from StackOverflow:[^noauthor_python_nodate]

```{.python}

import os; from Bio import SeqIO; import statistics as stats

for file in os.listdir(os.path.expanduser("~/Results/Genome_Analysis")):
    sizes = [len(rec) for rec in SeqIO.parse(os.path.join(os.path.expanduser("~/Results/Genome_Analysis"),file), "fastq")]
    if len(set(sizes)) <= 1: print(f"All sequences in file: {file} have an equal length of {sizes[0]}")
    else: print(f"For file: {file}, the average size was {stats.mean(sizes)}, with a maximum of {max(sizes)} and a minimum of {min(sizes)}")

```

As we can see, all of the files have the same length, 100 base pairs. In Illumina paired-end sequencing, our reads are always presented 5' -> 3', with both strands being sequenced in opposite directions in order to keep said direction; this means that one of the files (R1) will be forward-oriented, while the other will be reverse-oriented.[^noauthor_orientation_nodate]

### Additional Comments

Some additional comments can be made on our reads:

```{.python}

import os; from Bio import SeqIO; import collections; import statistics as stats

for file in os.listdir(os.path.expanduser("~/Results/Genome_Analysis")):
    all_qualities = []; all_sequences = []
    for record in SeqIO.parse(os.path.join(os.path.expanduser("~/Results/Genome_Analysis"),file), "fastq"):
        all_qualities += record.letter_annotations['phred_quality']
        all_sequences += list(str(record.seq).strip("\n"))
    relative_seqs = [(each, all_sequences.count(each) / len(all_sequences)) for each in set(all_sequences)]
    relative_qual = [(each, all_qualities.count(each) / len(all_qualities)) for each in set(all_qualities)]
    print(f"For file: {file}, the average quality was {stats.mean(all_qualities)}, and each base had a frequency of:\n{relative_seqs}\n")

```

As we can see, the average quality for our reads is 40, which is the maximum available in Illumina, and which, in the FastQs produced by this programme, is represented by an I.[^noauthor_quality_nodate] We can also observe that all bases have a more or less equal chance of appearing, with A/T being slightly more likely to appear in the genome than G/C (55.7% vs 44.3%, respectively), across temperatures and samples. This has surprised me, since, when I coded the solution, I expected to find a bigger proportion of G/C base pairs in high-temperature samples, as it is known G/C has a higher resistance to temperature than A/T due to having three hydrogen bonds, instead of two.[^noauthor_molecular_nodate]

# Read Mapping

### Alignment workflow

After checking our reads, we would like to perform several downstream analyses, including variant calling and expression analysis. First, we will map out current reads to the existing genome using bwa, a Burrows-Wheeler Aligner program which efficiently aligns short sequencing reads against a large reference sequence such as the human genome, allowing mismatches and gaps.[^li_fast_2009] After doing this, we performed the alignment itself using MEM, a more modern algorithm that has the best performance among those offered by BWA.[^noauthor_bwa1_nodate] We can use the following piece of code:

```{.bash}

# To be able to work with our files, we copy them to a file with write permission:
mkdir ~/Results/Read_Mapping/
cp ~/final_project/genome.fasta ~/Results/Read_Mapping/genome.fasta

# We begin by creating an index of the reference genome
bwa index ~/Results/Read_Mapping/genome.fasta

# We create the alignments. Here, we are not using -t since we *intentionally* want to use **all possible threads**
bwa mem ~/Results/Read_Mapping/genome.fasta  ~/Results/Genome_Analysis/hightemp01.r1.fq ~/Results/Genome_Analysis/hightemp01.r2.fq > ~/Results/Read_Mapping/hightemp01.sam 2> ~/Results/Read_Mapping/hightemp01.err
bwa mem ~/Results/Read_Mapping/genome.fasta  ~/Results/Genome_Analysis/hightemp02.r1.fq ~/Results/Genome_Analysis/hightemp02.r2.fq > ~/Results/Read_Mapping/hightemp02.sam 2> ~/Results/Read_Mapping/hightemp02.err
bwa mem ~/Results/Read_Mapping/genome.fasta  ~/Results/Genome_Analysis/normal01.r1.fq ~/Results/Genome_Analysis/normal01.r2.fq > ~/Results/Read_Mapping/normaltemp01.sam 2> ~/Results/Read_Mapping/normaltemp01.err
bwa mem ~/Results/Read_Mapping/genome.fasta  ~/Results/Genome_Analysis/normal02.r1.fq ~/Results/Genome_Analysis/normal02.r2.fq > ~/Results/Read_Mapping/normaltemp02.sam 2> ~/Results/Read_Mapping/normaltemp02.err

```

### Samtools analysis and number of mappings

Having the alignment done, we can analyze it using samtools, a suite of programs for interacting with high-throughput sequencing data.[^noauthor_samtools_nodate] For this, we will first generate some binary files as input for the program, obtaining some stats using the ```flagstat``` module. This module essentially counts the number of flags for alignments for each FLAG type,[^noauthor_samtools-flagstat_nodate] telling us whether they passed Quality Control or not, and helping us run find out their numbers in general. If we run the following code:

```{.bash}

conda activate samtools # Activate the samtools-containing environment

cd ~/Results/Read_Mapping/ # Go to the results folder, which makes it easier to process stuff

# Generate BAM files, the binary versions of SAM files
for file in *.sam; do samtools view -h -b "$file" > "${file%.sam}.bam"; done

# And we generate stats for them using samtools
for file in *.bam
do
    echo " #### FLAGSTAT REPORT FOR $file #### "
    samtools flagstat $file
    echo -e "\n"
    echo "               *****                  "
    echo -e "\n"
done > flagstats_report.txt

conda deactivate

# We can consult the results of the flagstat command easily using grep:
cat flagstats_report.txt | grep -e "REPORT" -e "QC-passed" -e "read1" -e "read2"

```

We get the following output:

```{.md}
 #### FLAGSTAT REPORT FOR hightemp01.bam ####
637890 + 0 in total (QC-passed reads + QC-failed reads)
318693 + 0 read1
318693 + 0 read2
 #### FLAGSTAT REPORT FOR hightemp02.bam ####
637950 + 0 in total (QC-passed reads + QC-failed reads)
318693 + 0 read1
318693 + 0 read2
 #### FLAGSTAT REPORT FOR normaltemp01.bam ####
577503 + 0 in total (QC-passed reads + QC-failed reads)
288742 + 0 read1
288742 + 0 read2
 #### FLAGSTAT REPORT FOR normaltemp02.bam ####
577498 + 0 in total (QC-passed reads + QC-failed reads)
288742 + 0 read1
288742 + 0 read2
```

as we can see, there are always the same number of reads for read1 and read2, and the number of QC-passed reads ~= read1 + read2. We can also note that there are absolutely 0 QC-failed reads; this makes sense, since we have already specified in the last section that our reads are really, really high-quality. The number of records would thus be the number of QC-passed reads for each file, while the number of reads would be either read1 or read2, depending if we are talking about the forward or reverse reads. If read1 and read2 do not exactly equal the full number of records, this is because some of them were "supplementary", that is, they couldn't be paired in sequencing.

We can compare this numbers with the original samples:

```{.python}

import os; from Bio import SeqIO

# We can now check the number of reads:
for file in os.listdir(os.path.expanduser("~/Results/Genome_Analysis")):
    records = list(SeqIO.parse(os.path.join(os.path.expanduser("~/Results/Genome_Analysis"),file), "fastq"))
    print(f"Total reads for {file}: {len(records)}")

```

Which outputs:

```
Total reads for hightemp02.r1.fq: 318693
Total reads for normal02.r2.fq: 288742
Total reads for normal01.r1.fq: 288742
Total reads for hightemp02.r2.fq: 318693
Total reads for hightemp01.r2.fq: 318693
Total reads for hightemp01.r1.fq: 318693
Total reads for normal02.r1.fq: 288742
Total reads for normal01.r2.fq: 288742
```

As we can see, the numbers we get are absolutely equal, which is, of course, coherent with our previous statements. One might then ask, however: what are those "supplementary" alignments? According to the samtools documentation,[^the_sambam_format_specification_working_group_sequence_2021] these represent "chimeric alignments", which are a set of linear alignments that do not have large overlaps, with one of them, decided at random, considered to be "representative", with the rest being "supplementary" to it.

With respect to Copy number variation, by definition this requires the occurrence of repeated genome sections; however, as we have not found duplicates in either the readings or the mappings, it is difficult to believe that this type of analysis is possible in our data.

# Variant Calling

## Variant Calling workflow
To find out whether a given variant is responsible for the huge uptick in *Aquifex aeolicus* [ref_mOTU_v25_10705] when temperature peaks, we will perform a variant calling analysis. First, we will sort the samtools bam files, since we want to use all of the samples. Then, we will merge all the mappings into a single file, transfering the headers to avoid information loss, and, finally, proceed with the variant calling itself, which uses ```bcftools mpileup``` and ```bcftools call```, but not  ```--ploidy 1```, which does not work in out server (this will make the program assume all samples are diploid). We can also repeat the process with the files individually, so as to be sure no artefacts were introduced by the merge:

```{.bash}

cd ~/Results/Read_Mapping/ # Go to input dir to make things easier
mkdir ~/Results/Variant_Calling/ # Create output dir

conda activate samtools

# First, we generate the sorted samtools binary files
for file in *.bam; do samtools sort -@ 1 $file > "${HOME}/Results/Variant_Calling/${file%.bam}.sorted.bam"; done

cd ~/Results/Variant_Calling/

# Merge all samtools files into one. We chose normal01.sorted.bam for the headers, but anyone is good, really:
samtools merge -h normaltemp01.sorted.bam merged.bam  normaltemp01.sorted.bam normaltemp02.sorted.bam hightemp01.sorted.bam hightemp02.sorted.bam

# We neeed to have the reference genome indexed
samtools faidx ~/Results/Read_Mapping/genome.fasta

conda activate bcftools

# Now,for the variant calling itself. Once again, I want to use **all threads**
bcftools mpileup -f ~/Results/Read_Mapping/genome.fasta merged.bam > merged.vcf
bcftools call -mv -Ob -o variant_calling_merged.bcf merged.vcf

# We repeat everything separately
bcftools mpileup -f ~/Results/Read_Mapping/genome.fasta normaltemp01.sorted.bam normaltemp02.sorted.bam hightemp01.sorted.bam hightemp02.sorted.bam > separate.vcf
bcftools call -mv -Ob -o variant_calling_separate.vcf separate.vcf

conda deactivate

```

## Number of variants

With regards to the number of expected variants, I dont necessarily expect to find any, since the genome we are comparing the samples against is derived from the samples themselves, and *Aquifex aeolicus*'s emergence in high-temperature scenarios can be attributed simply to said bacteria being a hyperthermophile; however, some might be found, due to heterocigosis and intra-population variation in general. We can find out by running this code on the "separated" file, since we belive it will introduce less errors than the additional step of merging:

```{.bash}

# Find all the variants
bcftools stats separate.vcf | grep -P "ST\t|SN\t|IDD\t" | grep -vP ":\t0"

# And asses their quality (must be > 100)
bcftools view variant_calling_separate.vcf | tail -4 | awk -F "\t" '$6 > 100 {print $0}'

# To find out Depth of Coverage, since bcftools is terrible at formatting, we print and do manual search in column 8
bcftools view variant_calling_separate.vcf | tail -4

```

As we can see, none there are only 3 variants detected, all of them being Single Nucleotide Polimorphisms, or SNPs; two of them are T>A substitutions, while one of them is a C>A change. No insertions or deletions (code IDD) were found. Of this variants, we can find out, by running the code above, that all have a quality higher than 100: 127 for the T>As, and a swooping 931 for the C>A. We can also find out their depth of coverage using the code above; in this case, we have only one with DP > 100, the C>A SNP, which has DP = 694.

## Separated vs Merged: finding the best workflow for our use case

We have re-runned the analysis for the merged file, and the results can be observed here:

| Type | Change | Quality (Separated) | Quality (Merged) | Depth of Coverage (Separated) | Depth of Coverage (Merged) |  Position |
|:----:|:------:|:-------------------:|:----------------:|:-----------------------------:|:--------------------------:|----------:|
|  SNP |   C>A  |         931         |        183       |              694              |             249            |  1265109  |
|  SNP |   T>A  |         127         |       36.41      |               30              |             12             |  1265734  |
|  SNP |   T>A  |         127         |       36.41      |               19              |             10             |  1265735  |

As we can see, in both cases we find the same number of variants (3), and of the same type (SNPs), with the only difference being the quality and depth parameters. Since the separated file shows greater quality and depth of coverage than the merged one, and since the improvement in computational time by merging the files is neglegible, I believe using the separated method is advisable, bringing more quality to out analysis.

## Best-Quality mutation

The position on the best-quality mutation (C>A, the one with the highest quality and coverage values overall), which was extracted from the stats file and shown in the table, is 1265109. We can correlate this on the original genome's gff file, using the code below; we will find that the affected gene is nifA, the gene for the nitrogen fixation protein A. This SNP could affect the gene in some different ways: if it is in the non-coding part of the gene (think, for example, in an intron), it will most likely have no effect at all, except if it appears in a Ribosome-binding site, or a promoter or repressor binding site, in which case it might affect basal expression of the protein. Whereas if it is in the coding part, two things could happen: either it is a synonymous mutation, which will produce the same aminoacid as the non-mutated version (this is specially common if the aminoacid is the third of a triplet); or, it might be non-synonymous, which might, and might not, create problems for the affected protein.

```{.bash}

cp ~/final_project/genome.gff ~/Results/Variant_Calling/genome.gff
cd ~/Results/Variant_Calling/
cat genome.gff | awk -F "\t" '{ if ((1265109 <= $5 ) && (1265109 >= $4 )) print $0 }'

```
## Integrative Genomics Viewer

Finally, we would like to re-generate the files, in this case, the different temperatures separately. This way, we can be sure if our variants are related to temperature or not, and we can compare the differential expression in different climates. Then, we will download the files to our local computer, and load them on the Integrative Genomics Viewer, an interactive program for such purposes.[^noauthor_igv_nodate]

```{.bash}

cd ~/Results/Variant_Calling/; conda activate samtools

# Merge files by temperature:
samtools merge -h hightemp01.sorted.bam merged_hightemp.bam hightemp01.sorted.bam hightemp02.sorted.bam
samtools merge -h normaltemp01.sorted.bam merged_normtemp.bam normaltemp01.sorted.bam normaltemp02.sorted.bam

conda deactivate

#### To do on the user's local machine ####

# Download appropriate files
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/Read_Mapping/genome.fasta "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/IGV/Reference_genome.fasta"
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/Variant_Calling/merged_normtemp.bam "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/IGV/merge_normtemp.bam"
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/Variant_Calling/merged_hightemp.bam "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/IGV/merge_hightemp.bam"

# On IGV:
# Genomes → Create .genome file → Introduce Reference_genome.fasta
# Tools → Run igvtools... → Index → Select merge_normtemp.bam
# Tools → Run igvtools... → Index → Select merge_hightemp.bam
# File → Load from file → merge_normtemp.bam
# File → Load from file → merge_hightemp.bam

```

![Screenshot of variant at position 1265109, as shown in IGV.](./IGV/IGV_Screenshot.png)

This is coherent with our previous analysis, which showed a C>A SNP.

# Differential expression analysis

## Workflow

Since we have the expression patterns for different temperature conditions, we can perform a differential expression analysis to try if we can find additional info about which genes are involved and in which way. To do this, first we need to index the sorted files using samtools (otherwise ```htseq-count``` will not work), and, then, we use ```htseq-count``` to count the number of reads within each feature.[^noauthor_htseq-count_nodate] We can then join the files by feature, and find out how they correlate:

```{.bash}

mkdir cd ~/Results/DEA/; cd ~/Results/Variant_Calling/ # Create directories

# Index files using samtools
conda activate samtools; for file in *.sorted.bam; do samtools index $file; done; conda deactivate

# Generate counts files
for file in *.sorted.bam; do htseq-count -i locus_tag -t CDS $file genome.gff > "${HOME}/Results/DEA/${file%.sorted.bam}.counts"; done

# Join all counts files under a common header and in the appropriate dir
cd ~/Results/DEA/; echo -e "Gene_ID NormTemp_R NormTemp_R2 HighTemp_R1 HighTemp_R2" > all.counts
join  normaltemp01.counts normaltemp02.counts | join - hightemp01.counts | join - hightemp02.counts >> all.counts
sed -i 's/ /\t/g' all.counts # Make the file a tsv

```

Now that we have generated the counts for each read and each feature, we can use DESeq2, an R package, to generate the Differential Expression Analysis:

```{.R}

library(DESeq2) # Load the package

counts = read.table("all.counts", header=T, row.names=1) # Load the counts table
colnames = c("Normal","Normal","High","High") # And rename the column header

my.design <- data.frame(row.names = colnames( counts ),
                        group = c("Normal","Normal","High","High")
                        ) # Create the experiment

my.design$group2 <- as.factor(paste(my.design$Time,sep="_")) # And change column type to fit DSeq2

# Create DSeq Data set and add metadata to it
dds <- DESeqDataSetFromMatrix(countData = counts, colData = my.design, design = ~ group + group:group)
dds <- DESeq(dds); resultsNames(dds)

# Create the results dataframe and omit NA's
res <- results(dds, contrast=c("group","High","Normal")); res = na.omit (res)

# Plot a histogram
hist(res$padj, breaks=100, col="darkorange1", border="darkorange4", main="")

# Find out which are significant and save the result
significant <- res[res$padj<0.01,];  write.csv(significant, "./significant_results.csv")

# And draw the MA plot
plotMA(res)

```

To be able to comment on them, we rsync the plots and extract the images:

```{.bash}

# On out local computer, we can do:
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/DEA/Rplots.pdf "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/DEA/Rplots.pdf"
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/DEA/significant_results.csv "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/DEA/significant_results.csv"
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/DEA/annotated_genes.csv "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/DEA/annotated_genes.csv"
rsync -avuL --progress pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/Functional_Analysis "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/"
pdftk ./DEA/Rplots.pdf cat 1 output "./DEA/Histogram.pdf"
Pdftk ./DEA/Rplots.pdf cat 2 output "./DEA/MA_Plot.pdf"

```

And, we can show them here:

## p-adjacency histogram

![Histogram for the DEA using DSeq](./DEA/Histogram.pdf)

As we can see, the majority of the genes have a p-adjacency value of 1, which means that their expression is not significative; however, just a small number of genes on the right, have a differential expression of 0, which means that they have a significative differential expression. The fact that we get a strictly bimodal distribution is suspicious, as it does not seem realistic that all genes are distributed perfectly either in 0 or in 1; and, although it makes sense for our further analysis (as the p-values are not uniform), it would be worth investigating in more detail what is happening in the background.[^noauthor_high-throughput_nodate]  [^noauthor_how_nodate]


## Differentially-expressed genes (annotated)

The genes that show a statistically significant differential expression are:

|               | baseMean  |log2FoldChange | lfcSE | stat   | pvalue           | padj           |
|---------------|-----------|---------------|-------|--------|------------------|----------------|
| AQUIFEX_01423 | 10,026.5  | 5.06          | 0.046 | 111.21 | 0.00000000000000 | 0.000000000000 |
| AQUIFEX_01754 | 124.9     | -10.41        | 1.454 | -7.16  | 0.00000000000079 | 0.000000000203 |
| AQUIFEX_01759 | 3,034.9   | 4.89          | 0.080 | 60.89  | 0.00000000000000 | 0.000000000000 |
| AQUIFEX_01760 | 159.3     | -10.76        | 1.451 | -7.41  | 0.00000000000012 | 0.000000000037 |
| AQUIFEX_01761 | 2,790.9   | 5.09          | 0.088 | 57.72  | 0.00000000000000 | 0.000000000000 |
| __no_feature  | 300,054.4 | 0.14          | 0.003 | 43.65  | 0.00000000000000 | 0.000000000000 |

These can be annotated with the help of our ```.gff``` file:

```{.python}

import pandas as pd
df = pd.read_csv("../Variant_Calling/genome.gff", skiprows=2, header=None, sep = "\t")
source = pd.read_csv("significant_results.csv", header=0)
new_df = pd.DataFrame(columns=["ID", "Name", "Description", "log2FoldChange","padj", "pvalue"])
pd.options.display.max_colwidth = 1000
for element in source['Unnamed: 0']:
    minidf = df[df[8].str.contains(element)]
    description_vect = minidf[8].to_string().split(";")
    if (len(description_vect) > 0):
        name = product = "-"
        for each in description_vect:
            if "Name" in each: name = each.split("=")[1]
            if "product" in each: product = each.split("=")[1]
        values = source[source['Unnamed: 0']==element][["log2FoldChange","pvalue", "padj"]]
        row = ([element, name, product] + values.values.tolist()[0])
        new_df.loc[len(new_df)] = row
new_df.to_csv("./annotated_genes.csv", header=True, index=False)

```

Which outputs:

| ID            | Name  | Description                             | log2FoldChange    | pvalue            | padj           |
|---------------|-------|-----------------------------------------|-------------------|-------------------|----------------|
| AQUIFEX_01423 | nifA  | Nif-specific regulatory protein         | 5.06529           | 0                 | 0              |
| AQUIFEX_01754 | -     | hypothetical protein                    | -10.410           | 0.000000000000799 | 0.000000000203 |
| AQUIFEX_01759 | nifB  | FeMo cofactor biosynthesis NifB         | 4.89894           | 0                 | 0              |
| AQUIFEX_01760 | -     | hypothetical protein                    | -10.761           | 0.000000000000121 | 0.000000000037 |
| AQUIFEX_01761 | nifH1 | Nitrogenase iron protein 1              | 5.09307           | 0                 | 0              |
| __no_feature  | -     | -                                       | 0.14319           | 0                 | 0              |


## MA Plot

The MA plot is an auto-generated plot that is part of the DSeq2 package. In it, genes which meet the adjusted p-value treshold set in our script (0.01) are colored in blue and depicted as triangles, whether those that dont are colored in grey. We can also see a blue dot, which represents the "__no_feature" row.[^noauthor_analyzing_nodate] In all, we can conclude that there are 5 differentially expressed genes in our dataset: the three that present a "name" in the previous table (AQUIFEX_01423, AQUIFEX_01759 and AQUIFEX_01761) are over expressed under high-heat conditions, while the two that dont (AQUIFEX_01754 and AQUIFEX_01760) are under expressed.

![MA plot for the DEA using DSeq](./DEA/MA_Plot.pdf)

Since the null hypothesis in the DSeq package is that there is no differential expression across samples, and given that we have found the p-values to be pretty low (<<<0.01), we can conclude that there is, in fact, differential expression for genes AQUIFEX_01423, AQUIFEX_01759, AQUIFEX_01761, AQUIFEX_01754 and AQUIFEX_01760

# Functional analysis

Having found that some genes over express themselves in high-temperature conditions, we would like to see how this genes work, exactly. To do this, we will extract the sequences from the assembled ```proteome.faa``` and search for them using some known, high-quality databases, such as PFAM, PHMMER,eggNOG, KEGG, NCBI Blast, NCBI Taxonomy, STRING-DB, Uniprot, Ensembl or SMART. Thus:

```{.python}

import os, shutil
from Bio import SeqIO
os.mkdir(os.path.expanduser("~/Results/Functional_Analysis/"))
os.chdir(os.path.expanduser("~/Results/Functional_Analysis/"))
shutil.copy(os.path.expanduser("~/final_project/proteome.faa"), os.path.expanduser("~/Results/Functional_Analysis/proteome.faa"))

records = SeqIO.parse(os.path.expanduser("~/Results/Functional_Analysis/proteome.faa"), "fasta")
SeqIO.write((seq for seq in records if seq.id in ["AQUIFEX_01423","AQUIFEX_01759","AQUIFEX_01761"]), "./overexpressed_seqs.fasta", "fasta")

```

## Overexpressed genes' function

To better understand the meaning of these sequences, the first step is to perform a BLAST analysis to see what they correspond to, and if the data we have in the gff file are correct. As we are interested in performing a functional analysis, we have decided to perform a **blastp**, a similarity analysis directly between the protein sequences, as we estimate that these will be better detailed than the genome as a whole if we were to perform, for example, a tblastn.

* For *AQUIFEX_01423*, we found that there is a 100% match with *sigma-54-dependent Fis family transcriptional regulator* of both *Aquifex aeolicus* and *Aquifex sp.*. As it is a perfect match, and one with 100% coverage and e-value of 0, we can be sure that it is this gene. If we search for its Gene Ontolog in uniprot (accession WP_010881164) we obtain that it is in charge of ATP and DNA binding, regulating transcription; this is confirmed by Kegg, who indicates that it is a transcriptional regulator of the NifA subfamily, also related to ATPase AAA+.[^noauthor_ntrc2_nodate]

* For *AQUIFEX_01759*, blastp gives 97% confidence to *FeMo cofactor biosynthesis protein NifB*, and 96% to *radical SAM protein*, both from *Methanococcus maripaludis*. If we check these proteins in uniprot and kegg, we see that, indeed, the two diagnoses are coincident, since it is a cofactor of the maturase NifB related to the apical meristem asembler protein.[^noauthor_nifB_nodate]

* Finally, for *AQUIFEX_01761*, we have a 100% coverage match with nitrogenase iron protein from several organisms, but mostly *Methanococcus maripaludis*. It is possible that this nitrogenase is highly conserved among several organisms, and that is why it is at the same time in *Methanococcus maripaludis* and, presumably, in *Aquifex aeolicus*, since the file we are analysing comes from it. Uniprot suggests that it is part of a 2-subunit complex responsible for N2-binding at the molecular level. Kegg adds that it could also be involved in energy metabolism, xenobiotic degradation and chloroalkane and chloroalkene degradation.[^noauthor_nifH_nodate]

## Overexpressed genes' known domains

Regarding the presence of known domains, we can explore them using PFAM:[^mistry_pfam:_2021]

* For *AQUIFEX_01423*, we found two domains: GAF, a general domain found, among others, in cGMP-specific phosphodiesterases, adenylyl cyclases and FhlA; and Sigma_54_activat, an interaction domain between core RNA polymerase and ATP, allowing signal transduction. Finally, it contains HTH-8, a regulatory domain.

* For *AQUIFEX_01759* we find a single domain, radical sam, a superfamily of enzymes that use a [4Fe-4S]+ cluster to reductively cleave S-adenosyl-L-methionine to generate a radical.

* For *AQUIFEX_01761*, we also found a single domain, Fer4_NifH, a family which includes the bacterial nitrogenase iron protein NifH, chloroplast encoded chlL , and archaeal Ni-sirohydrochlorin a,c-diamide reductive cyclase complex component.

## Functional relations

As we can see, all the overexpressed genes belong to the Nif family, which encodes proteins responsible for the fixation of atmospheric nitrogen to ammonium under conditions of low dissolved N2. Thus, when there is a lack of nutrients, NifA, *AQUIFEX_01423*, is responsible for activating the fixation, depetrolling the rest of the genes through NifC (*AQUIFEX_01759*), which, as we know, is a transcriptional regulator. The enzyme responsible for this is nitrogenase, and precisely one of its cofactors is encoded by one of the overexpressed genes (*AQUIFEX_01761*), so it is to be expected that its production will also increase.

Thus, we seem to have found a regulatory network of interrelated genes that is activated in response to high temperatures. This might make sense since gases dissolved in water become less soluble with increasing temperature,[^noauthor_dissolved_nodate] generating conditions of low O2 and N2 concentration that activate our system. This conclussion is supported by existing literature on how nitrogenase works.[^buren_biosynthesis_2020]

## Algae Bloom

It is likely that this system we have just described is related to the algal blooms observed in the hot spring after the high-temperature episodes, since DEA indicates that, after these episodes, the expression of genes involved in our regulatory system increases, favouring the development of *Aquifex aeolicus*, which begins to fix nitrogen. By the time the high-temperature episodes are over, the lake in which *Aquifex* grows will be full of nitrogen, which serves as the perfect natural fertiliser for uncontrolled algal growth.

# Phylogenetic analysis

## Closest ortholog of each overexpressed gene

We can find the closest ortholog of each overexpressed gene by doing a BLAST analysis and looking at the first find from a different species:

```{.bash}

mkdir ~/Results/Phylo; cd ~/Results/Phylo
makeblastdb -dbtype prot -in ~/final_project/all_reference_proteomes.faa -out blast_db
for file in ~/Results/Functional_Analysis/*.fa; do blastp -query "$file" -db blast_db -evalue 0.001 -outfmt "6" -out "$(basename -- $file .fa)_result.tsv"; done

```

* For AQUIFEX_01423, the closesr orthologue is tr|A0A497XW95|A0A497XW95_9AQUI, a protein from the  Hydrogenivirga caldilitoris species
* For AQUIFEX_01759, the closesr orthologue is tr|Q6LZH0|Q6LZH0_METMP, a protein from the  Methanococcus maripaludis species
* For AQUIFEX_01761, the closesr orthologue is sp|P0CW57|NIFH_METMP, a protein from the  Methanococcus maripaludis species

This orthology analysis supports our previous functional annotations: for  AQUIFEX_ 01423, we get  A0A497XW95_9AQUI, which is involved in ATP binding and DNA regulation, as expected; for AQUIFEX_01759,  Q6LZH0_METMP is involved in Fe-Mo cofactor biosynthesis; and, for  AQUIFEX_01761, the closesr orthologue, NIFH_METMP, is part of the nitrogenase iron protein, just as expected. The only difference being, of course, that they are from other species. Since only AQUIFEX_01423 produced an autohit (that is, a hit from A. aeolicus), we can assure that neither AQUIFEX_01759 nor AQUIFEX_01761 are present on NCBI's public database.

With regards to each gene's origins, for  AQUIFEX_01423, it seems as if it is simply a A.aeolicus native gene, so its origin would be evolution. However, for both AQUIFEX_01759 and AQUIFEX_01761, it seems like they appeared via vertical or horizontal transfer from  Methanococcus maripaludis. Since Methanococcus maripaludis was actually the most abundant species in high-heat condition, it seems like horizontal gene transfer happened at some point in time, helping A.aeolicus adapt to such hostile conditions, and therefore compete with the original   Methanococcus maripaludis.

## Phylogenetic tree analysis

Finally, we can perform a phylogenetic analysis, by using ete3 and SeqIO, to generate some trees:

```{.python}

import os; import pandas as pd;
from Bio import SeqIO
from ete3 import Tree


for file in os.listdir("./"):
    if file.endswith(".tsv"):
        df = pd.read_csv(file, sep="\t", header = None)
        records = SeqIO.parse(os.path.expanduser("~/final_project/all_reference_proteomes.faa"), "fasta")
        SeqIO.write((seq for seq in records if seq.id in list(df[1])), f"{file.split('.')[0]}.fa", "fasta")

        f = open(f"{file.split('.')[0]}.fa", "a")
        original_seq = open(f"../Functional_Analysis/{file.split('_result')[0]}.fa")
        f.write(original_seq.read())

os.system('for file in *_result.fa; do mafft $file > "$(basename -- $file .fa).aligned"; done')
os.system('for file in *.aligned; do iqtree -s $file -m LG; done')

for file in os.listdir("./"):
    if file.endswith(".treefile"):
        t = Tree(file)
        t.set_outgroup(t.get_midpoint_outgroup())
        f = open(f"{file.split('.')[0]}_final.tree", "w")
        f.write(t.write())


```

We then proceed to download the files:

```{.bash}

rsync --include="*_final.tree" --exclude="*.*" -arv pablo.marcos.lopez@138.4.139.16:/home/pablo.marcos.lopez/Results/Phylo "$HOME/Documentos/Trabajos del cole/UNI/Master/GDAV/Entrega Final Parte 1/"

```

Which can be seen here:

![Phylogenetic tree for AQUIFEX_01423](./Phylo/AQUIFEX_01423_result_final.tree.pdf)
![Phylogenetic tree for AQUIFEX_01759](./Phylo/AQUIFEX_01759_result_final.tree.pdf)
![Phylogenetic tree for AQUIFEX_01761](./Phylo/AQUIFEX_01761_result_final.tree.pdf)

# Conclussions

Through a detailed and multifaceted analysis of the genome of the species present in our variable temperature environment, we can establish a clear account of what is going on: most of the time we will find a pond at room temperature, perfect for a large number of organisms and therefore presenting high alpha-biodiversity. However, periodically, we will find "ultra-high temperature" phenomena, in which such brutal changes occur (both in the temperature itself and in the concentration of dissolved gases in the water) that lead to bottleneck phenomena where only a few individuals of each species survive, unless they are adapted to high temperatures, as is the case of Methanococcus maripaludis. In one of these events, which usually lead to speciation, some bacterium of the species Aquifex aeolicus must have acquired, perhaps by lateral transfer, the genes that allow M. maripaludis to fix nitrogen from the air, thus gaining the competitive advantage that it previously had exclusively, and which allows it to survive in these conditions, since, although Aquifex aeolicus is already resistant to high temperatures, it might not have been so resistant to the low concentration of dissolved gases that these entail until the mutation occured.

Then, when temperatures return to normal, gas concentration returns to normal, and alpha-biodiversity returns to its default values (since they had dropped during the bottleneck), thanks to the few individuals that survived the event, perhaps through sporulation or simple luck.  However, due to the ability of both M. maripaludis and A. aeolicus (acquired) to fix nitrogen, the water will be full of this nutrient, providing the perfect fertiliser for a temporary algal bloom, at least until all dissolved nitrogen is depleted.

Thanks to our analyses, we have been able to determine that the genes involved in this nitrogen fixation would be NifA, NifB and NifH, such that NifA is responsible for recruiting, by phosphorylating the necessary sites in the DNA, the FeMo cofactor (NifB) necessary to synthesise extra nitrogenase (NifH) and thus proceed with the fixation.

After our computational analysis, it is now up to future researchers to confirm the effect of the mutations (SNPs) detected in the aforementioned genes on nitrogen assimilation by A. aeolichus, in order to confirm, by in vivo analysis, our theories developed in silico.


# References

[^milanese_microbial_2019]:  Milanese A, Mende DR, Paoli L, Salazar G, Ruscheweyh H-J, Cuenca M, et al. Microbial abundance, activity and population genomic profiling with mOTUs2. Nat Commun 2019;10(1):1014.
[^deckert_complete_1998-1]:  Deckert G, Warren PV, Gaasterland T, Young WG, Lenox AL, Graham DE, et al. The complete genome of the hyperthermophilic bacterium Aquifex aeolicus. Nature 1998;392(6674):353–8.
[^noauthor_aquifex_nodate]:  Aquifex aeolicus VF5, complete sequence - Nucleotide - NCBI [Internet]. [cited 2022 Jan 31];Available from: https://www.ncbi.nlm.nih.gov/nuccore/NC_000918.1
[^noauthor_aquifex_nodate-1]:  Aquifex aeolicus VF5 plasmid ece1, complete sequence - Nucleotide - NCBI [Internet]. [cited 2022 Jan 31];Available from: https://www.ncbi.nlm.nih.gov/nuccore/NC_001880.1
[^deckert_complete_1998]:  Deckert G, Warren PV, Gaasterland T, Young WG, Lenox AL, Graham DE, et al. The complete genome of the hyperthermophilic bacterium Aquifex aeolicus. Nature 1998;392(6674):353–8.
[^gupta_molecular_2013]:  Gupta RS, Lali R. Molecular signatures for the phylum Aquificae and its different clades: proposal for division of the phylum Aquificae into the emended order Aquificales, containing the families Aquificaceae and Hydrogenothermaceae, and a new order Desulfurobacteriales ord. nov., containing the family Desulfurobacteriaceae. Antonie van Leeuwenhoek 2013;104(3):349–68.
[^guiral_microbe_nodate]:  Guiral M, Giudici-Orticoni M-T 2021. Microbe Profile: Aquifex aeolicus: an extreme heat-loving bacterium that feeds on gases and inorganic chemicals. Microbiology 167(1):001010.
[^reysenbach_phylogenetic_1994]:  Reysenbach AL, Wickham GS, Pace NR. Phylogenetic analysis of the hyperthermophilic pink filament community in Octopus Spring, Yellowstone National Park. Appl Environ Microbiol 1994;60(6):2113–9.
[^noauthor_7_2018]:  7: Alpha, Beta, and Gamma Diversity [Internet]. Biology LibreTexts2018 [cited 2022 Jan 31];Available from: https://bio.libretexts.org/Bookshelves/Ecology/Biodiversity_(Bynum)/7%3A_Alpha_Beta_and_Gamma_Diversity
[^noauthor_fastq_nodate]: FASTQ files explained [Internet]. [cited 2022 Jan 31];Available from: https://emea.support.illumina.com/bulletins/2016/04/fastq-files-explained.html
[^noauthor_bioinformatics_nodate]: bioinformatics - How to check if a fastq file has single or paired end reads [Internet]. Biology Stack Exchange [cited 2022 Jan 31];Available from: https://biology.stackexchange.com/questions/15502/how-to-check-if-a-fastq-file-has-single-or-paired-end-reads
[^noauthor_python_nodate]: python - Parsing fasta file with biopython to count number sequence reads belonging to each ID [Internet]. Stack Overflow [cited 2022 Jan 31]; Available from: https://stackoverflow.com/questions/31540845/parsing-fasta-file-with-biopython-to-count-number-sequence-reads-belonging-to-ea
[^noauthor_orientation_nodate]: Orientation in paired-end sequencing? [Internet]. [cited 2022 Jan 31];Available from: https://www.biostars.org/p/103773/
[^noauthor_quality_nodate]: Quality Score Encoding [Internet]. [cited 2022 Jan 31];Available from: https://support.illumina.com/help/BaseSpace_OLH_009008/Content/Source/Informatics/BS/QualityScoreEncoding_swBS.htm
[^noauthor_molecular_nodate]: Wu H, Zhang Z, Hu S, Yu J. On the molecular mechanism of GC content variation among eubacterial genomes. Biology Direct 2012;7(1):2.
[^li_fast_2009]: Fast and accurate short read alignment with Burrows–Wheeler transform | Bioinformatics | Oxford Academic [Internet]. [cited 2022 Jan 31];Available from: https://academic.oup.com/bioinformatics/article/25/14/1754/225615
[^noauthor_bwa1_nodate]: Burrow-Wheeler Alignment tool Source Code [Internet]. [cited 2022 Jan 31];Available from: http://bio-bwa.sourceforge.net/bwa.shtml
[^noauthor_samtools_nodate]: Samtools [Internet]. [cited 2022 Jan 31];Available from: http://www.htslib.org/
[^noauthor_samtools-flagstat_nodate]: samtools-flagstat manual page [Internet]. [cited 2022 Jan 31];Available from: http://www.htslib.org/doc/samtools-flagstat.html
[^the_sambam_format_specification_working_group_sequence_2021]: The SAM/BAM Format Specification Working Group. Sequence Alignment/Map Format Specification [Internet]. Github; 2021. Available from: https://samtools.github.io/hts-specs/SAMv1.pdf
[^noauthor_igv_nodate]: IGV: Integrative Genomics Viewer [Internet]. [cited 2022 Jan 31];Available from: https://igv.org/
[^noauthor_how_nodate]: How to interpret a p-value histogram – Variance Explained [Internet]. [cited 2022 Jan 31];Available from: http://varianceexplained.org/statistics/interpreting-pvalue-histogram/
[^noauthor_high-throughput_nodate]: p-Value Histograms: Inference and Diagnostics [Internet]. [cited 2022 Jan 31];Available from: https://www.mdpi.com/2571-5135/7/3/23
[^noauthor_analyzing_nodate]: Analyzing RNA-seq data with DESeq2 [Internet]. [cited 2022 Jan 31];Available from: http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#ma-plot
[^noauthor_ntrc2_nodate]: ntrC2 - Transcriptional regulator (NtrC family) - Aquifex aeolicus (strain VF5) - ntrC2 gene & protein [Internet]. [cited 2022 Jan 31];Available from: https://www.uniprot.org/uniprot/O67661
[^noauthor_nifB_nodate]: nifB - FeMo cofactor biosynthesis protein NifB - Methanococcus maripaludis - nifB gene & protein [Internet]. [cited 2022 Jan 31];Available from: https://www.uniprot.org/uniprot/A0A2L1C8R9
[^noauthor_nifH_nodate]: nifH - Nitrogenase iron protein - Methanococcus maripaludis (strain S2 / LL) - nifH gene & protein [Internet]. [cited 2022 Jan 31];Available from: https://www.uniprot.org/uniprot/P0CW57
[^mistry_pfam:_2021]: Mistry J, Chuguransky S, Williams L, Qureshi M, Salazar GA, Sonnhammer ELL, et al. Pfam: The protein families database in 2021. Nucleic Acids Research 2021;49(D1):D412–9.
[^noauthor_dissolved_nodate]: Dissolved Gas Concentration in Water | ScienceDirect [Internet]. [cited 2022 Jan 31];Available from: https://www.sciencedirect.com/book/9780124159167/dissolved-gas-concentration-in-water
[^buren_biosynthesis_2020]: Burén S, Jiménez-Vicente E, Echavarri-Erasun C, Rubio LM. Biosynthesis of Nitrogenase Cofactors. Chem Rev 2020;120(12):4921–68.

<!-----

This document can easily be converted to PDF format using pandoc:

``` pandoc --pdf-engine=xelatex --highlight-style tango --biblio Bibliography.bib "Report.md" -o "Report.pdf" ```-->

