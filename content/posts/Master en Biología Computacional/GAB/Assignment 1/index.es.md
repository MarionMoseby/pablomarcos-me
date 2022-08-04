---
title: "Assignment 1"
author: Pablo Marcos
date: 2021-10-12
output: pdf_document
menu:
  sidebar:
    name: Assignment 1
    identifier: assignment_1_gab
    parent: gab
    weight: 40
---

## Crop Production
1. What are the main disciplines that helped to increase crop production in the last century and how did they do so?

In the last century, and, specially, after 1960, we have witnessed the unfolding of a **green revolution**, a huge increase in the yield of crops and in food production that has enabled the human race to reduce hunger even when the population to feed keeps growing. This has been possible through the use of new, higher-yelding varieties, controlled irrigation (i.e. drop irrigation, which has made cultivation in the arid land of Israel possible), mechanisation, agrochemicals such as fertilizers and pesticides, and, as of lately, GMOs. This impact crop production in a variety of ways, all with the final goal of increasing yield: they nake the plants stronger and more productive, more resistant to droughts and protected from pests, and make collecting fresh produce easier and cheaper.

## Plant Breeding Goals
2. What and why are the main goals in plant breeding?

Plant breeding is essentially the genetic improvement of plants for the benefit of humans. The objectives pursued are very varied, such as increasing the frequency of favorable alleles (additive effects), increasing the frequency of favourable phenotypes (through dominance and epistatic effects) and increasing adaptation of crops to environments, making yields more stable and predictable and crops better adapted to each region.

In short, the aim of plant breeding is to achieve maximum yields of products while minimising impacts and environmental hazard. This, in itself, is a very human objective: maximising yields while minimising effort will lead to more production, and thus enable us to solve the major challenges of our generation, such as hunger or high food prices and food insecurity due to climate change.

## Plant Breeding Problem
3. To improve protein concentration in i27, you do a round of selection, finding that, last year, individuals had 15.5% mean protein after a intensity of selection of 10%, while, the year before, the population had a protein mean of 12.5% and a standard phenotypic deviation of 1.71.

* If the narrow sense heritability is 0.6, what is the predicted mean of the progeny and genetic gain from this generation?. Show both ways of calculating it.

```{r} 
#Since the mean protein concentration increases from 12.5 to 15.5, 
#the Response can be calculated as follows:
Selection_Differential <- 15.5-12.5
Heritability = 0.6
Response <- Heritability^2 * Selection_Differential #This is what is called "genetic gain"
print(Response)
#Since the average has grown, the new average must be:
NewMean <- 12.5 + Response
print(NewMean)
```

```{r} 
intensity <- 1.755 #For a selection of 10%, if we look at the normal distribution table,
                   #this is what we get
phenotypic_deviation <- 1.71 #What we were provided with
Selection_Differential <- intensity*phenotypic_deviation

Response <- Heritability^2 * Selection_Differential
NewMean <- 12.5 + Response
print(NewMean)
```

As we can see, the two methods yield (approximately) the same results.

* By adding marker assisted selection, you can raise the selection intensity to a value of 4. What would be your expected progeny mean and genetic gain now?

With an intensity of selection of i = 4, the normal distribution table tells us that we are selecting 0.00001 % of the population. Unless we have a very big population, this might mean problems for the survival (i.e. population bottleneck).
    
```{r} 
intensity <- 4 
phenotypic_deviation <- 1.71 #What we were provided with
Selection_Differential <- intensity*phenotypic_deviation

Response <- Heritability^2 * Selection_Differential
NewMean <- 12.5 + Response
print(NewMean)
```

As we can see, the difference with the previous case is pretty great, but scientists must take into account that this might cause an increase in genetic-transmitted diseases and susceptibility to pests, both traits that come with low gene diversity.

* What is the X~selected~ under this greater selection intensity. 

As we saw in the previous point, the X~selected~ is 0.00001 % of the original population.

## Wheat variety
4. Suppose you have a wheat variety with 2 loci and 2 alleles that affect the height trait, A1A2 and B1B2. Having an allele with a 2, adds one unit of measure to the phenotype. Having 1 doesn't add any unit of measure to the phenotype. Please, indicate what are the possible genotypes and the value of the phenotypes from a two loci and 2 alleles example. Represent the information on a mathematical axis, where in the x axis you indicate the phenotypic values and in the y-axis the counts of the phenotypic values.

Given that there are 4 aleles to combinate in groups of 2 (assuming A and B are not mutually exclusive), the combinatory number for 4 elements taken in groups of 2 tells us there are 4 possible combinations: A1B1 A1B2 A2B1 A2B2. For this genotypes, we get 3 possible phenotypes: Height-2, for A2B2; Height-1, for A1B2 and A2B1; and Height-0, for A1B1

If we plot a graph, as specified, to show the implications of this 4 genotypes on the phenotype, we get: 

```{r} 
possible_phenotypes <- c("Height-2","Height-1","Height-0")
phenotype_frequency <- c(1,2,1)
barplot(phenotype_frequency, names.arg=possible_phenotypes, 
        main="Phenotype frequency graph", xlab="Possible Phenotypes", 
        ylab="Phenotype Frequency")

```

Sources used:

* [How to calculate Response to Selection](https://www.youtube.com/watch?v=Xup2gE4XnvI)  -  Nikolay's Genetics Lessons on Youtube
* [Broad sense heritability vs Narrow sense heritability](https://www.youtube.com/watch?v=dSFNb5T2Ml0)  -  Nikolay's Genetics Lessons on Youtube
* [How to find a Selection Differential, Genetic Gain and Heritability](https://www.youtube.com/watch?v=anCPzdNDVIs)  -  Nikolay's Genetics Lessons
* [This interactive normal distribution table](https://www.mathsisfun.com/data/standard-normal-distribution-table.html)
* Class materials
