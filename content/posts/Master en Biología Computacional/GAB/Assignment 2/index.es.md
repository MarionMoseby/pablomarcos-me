---
title: "Assignment 2"
author: Pablo Marcos
date: 2021-10-21
math: true
menu:
  sidebar:
    name: Assignment 2
    identifier: assignment_2_gab
    parent: gab
    weight: 40
---

## Fundamental concepts

### Blending Inheritance
1.  What implications from Blending Inheritance were dismissed by Mendel?

Before Mendel, people used to think that, given that both parents contribute fluids to their offspring, the descendant's traits would be a mixture of the two individual's characteristcs: a "common middle ground", a central point probably influenced by Aristotle's theory of balance. 

Thus, blending inheritance proponents assumed that half the variation is removed each generation, and that this variation had to be somehow replenished by mutation. Mendel's main innovation was to show that, in fact, the offspring does not always represent the middle ground of the parents: some phenotypes are recessive, and may be hidden if a more dominant genotype appears. 


### Test Crossing
2. Indicate crosses and phenotypes you would make to get the genotype of a dominant phenotype

This case, which is common to see in genetics, is called **retrocrossing** or **test-crossing**: to see the genotype of a dominant phenotype, we cross said dominant phenoptype with a recessive, homozygotic parent: if the offspring is 100% dominant, we can conclude the parent is homozygotic dominant; however, if the offspring is 50% dominant and 50% recessive, we can conclude the parent was heterozygotic, meaning with a dominant phenotype, but carrier of both an allele that, by itself, would produce a dominant phenotype, and one which would produce a recessive phenotype.

This, of course, only works under "normal" (i.e. trully mendelian) conditions: if there are epystatic phenotypes, or if any other non-mendelian form of heritance is involved, this method would need to be altered.

Another option, specifically for self-polinating organisms such as some plants, is **selfing**: we cross the individeual with itself, and analyse the results.

### Breeding Values
3. Calculate the breeding values and rank for next generation cycle four genotypes with yield value of A=1200Kg/ha, B=5500kg/ha, C=900kg/ha and D=3600Kg/ha, given that heritability was 0.3, the mean of the yield values was 3500 kg/ha and that there were 2000 different wheat genotypes implied

```{r} 
#Given that the Estimated Breeding Value = Heritability * P

BreedingValueA <- 0.3*(1200)
BreedingValueB <- 0.3*(5500)
BreedingValueC <- 0.3*(900)
BreedingValueD <- 0.3*(3600)

paste(BreedingValueA, BreedingValueB, BreedingValueC, BreedingValueD)

```
Since the Breeding Values can be used as an estimator for the genetic potential of an individual, we rank the individuals in decreasing order of BVs, taking into account that we want to **increase** yield. 

Thus: B > D > > > > A > C

### Heritability
4. We have processed 20 phenotypes of soybeans over 3 environments and 3 repetitions, finding out that the correlation between the breeding value and the character is 0.25, that the additive genetic variance is 4, and that the environmental variance is 36. Please, calculate heritability and find out if the trait is highly heritable or not. Would you select for oil content at the beginning or end of the breeding process?

```{r}
Variance_e <- 36
Variance_a <- 4
replicates <- 20
environments <- 3

heritability <- Variance_a/((Variance_a)+(Variance_a/replicates*environments))
heritability 
```
We can thus infer that the heritability (narrow sense) is around .869; that is, this trait is highlty heritable. As such, we could select for oil content at the beginning of the process, keeping the parents which have higher yields and re-crossing them to maximize it; unlike with a low-heritability trait, there is no problem of trait-loss due to possible changes in environmental conditions

\
\
  
## Linear Algebra Exercises

1. Create the following vectors:

* (1,2,3,...,19,20)
```{r} 
seq(from = 1, to = 20, by = 1) 
```

* (20,19,18,17,16,..,1)
```{r} 
rev(1:20)
```

* (1,2,3,...,19,20,19,18,...,2,1)
```{r} 
assign("vector3", c(1:19, 20:1) )
vector3
```

* (4,6,3) and assign it to the name tmp.
```{r} 
tmp <- c(4,6,3)
tmp
```

* Look at the help of function rep and make the following vector. (4,6,3,4,6,3,4,6,3) where there are 10 occurences of 4
```{r} 
help(rep)
rep(tmp, 10)
```
*  Use the function ‘paste’ to create the following character vectors of length 10.
```{r} 
# (“SNP 1”, “SNP 2”, “SNP 3”,...,“SNP 10”)
paste("SNP", 1:10)
```

```{r} 
#(“SNP1”, “SNP2”, “SNP3”,...,“SNP10”)
paste("SNP", 1:10, sep="")
```

* Look at the function sample and create to random integers with replacement from 1 to 500 with length 100 and store it in a object call xvect and yvect.
```{r} 
xvect = sample(1:500, 100, replace=TRUE)
yvect = sample(1:500, 100, replace=TRUE)
```

* Pick out the values in xvect that are greater than 300. What are the index positions of xvect which are greater than 300?.
```{r} 
xvect_300 <- xvect[xvect>300]
which_xvect_300 <- which(xvect > 300)
```

* What are the values in yvect which correspond to the values in xvect which are > 300 (at the same index postions).
```{r} 
yvect_xvect_300 <- yvect[xvect>300]
```

* Pick out the elements in xvect at index positions 1,4,7,10,13.
```{r} 
xvect[c(1,4,7,10,13)]
```

* Sort yvect in decreasing order. Check the sort function in R.
```{r} 
yvect_sorted <- sort(yvect, decreasing=TRUE)
```

* Sort the numbers in the vector xvect in the order of increasing values in yvect. Look at the help file for order function in r.
```{r} 
xvect_sorted <- xvect[order(yvect, decreasing=TRUE)]
```

\newpage

## Exercises with Matrices

1. Enter matrix A in R and then replace the third column of A by the sum of the second and third columns.
```{r} 
A = rbind(c(1,1,3), c(5,2,6), c(-2,-1, -3))
A[,3] = A[,2]+A[,3]
A
```
2. Create the B matrix and calculate B^T B using R. Check the crossprod function in R.
```{r} 
vector4 = c(10, -10, 10)
B = matrix(rep(vector4,15), nrow=15, byrow=T)
crossprod = crossprod(t(B))
```

3. Create a 6 × 10 matrix of random integers chosen from 1, 2,. . . , 10 by executing the following two lines of code, and learn each of the functions
```{r} 
set.seed(75)
aMat <- matrix( sample(10, size=60, replace=T), nr=6)
aMat
```
a) Find the number of entries in each row which are greater than 4.
```{r} 
#This gives a table: each column is a row with occurences count
rowSums(aMat > 4)
```
b) Which rows contain exactly two occurances of the number 7.
```{r} 
which(rowSums(aMat == 7) == 2)
```

4. Put the following system of linear equations in matrix notation
To put a system in matrix notation, we generate two separate matrixes: the "unknowns" matrix and the "values" matrix, which, when multiplied together, gives us back the system of equations. 
```{r eval=FALSE, include=FALSE}
#This code generates the matrixes in R
values <- rbind(1:5,c(2,1,2,3,4), c(3,2,1,2,3), c(4,3,2,1,2))
unknowns <- cbind( c("x1", "x2", "x3", "x4", "x5"))
equals_to <- cbind(c(7,-1,-3,7))
```


Since R doesnt let me print matrixes together in a cute way, lets see how this looks using LaTeX
$$ \begin{bmatrix}
1 & 2 & 3 & 4 & 5 \\
2 & 1 & 2 & 3 & 4 \\
3 & 2 & 1 & 2 & 3 \\
4 & 3 & 2 & 1 & 2 
\end{bmatrix}
\cdot
\begin{bmatrix}
x_{1}\\
x_{2}\\
x_{3}\\
x_{4}\\
x_{5}
\end{bmatrix}
=
\begin{bmatrix}
7\\
-1\\
-3\\
7
\end{bmatrix}$$
