---
title: "GDAV Single Cell - Ex 2"
author: "Pablo Marcos"
date: 2022-02-01
menu:
  sidebar:
    name: Exercise 2
    identifier: single_cell_exercise_2
    parent: single_cell
    weight: 100
---

We have been given a file, 'TableS5.csv', which contains the data for a series of assays on gene expression with multiple samples. Our goal is to perform a Principal Component Analysis across the samples, to try and find out if we can relate said gene expresion profiles to a series of known biomarkers.

```{r setup-chunk, include=FALSE}
# Set up images
knitr::opts_chunk$set(dev = "png", dpi = 1000,  echo = FALSE,
                      out.width = "450px", cache = TRUE)
#install.packages("matlib")
library(matlib) # First, we import the needed libraries
```

## Data Visualization

The first idea is to do a simple data visualization, to see which genes among our data have more variable expression profiles, and thus are more likely to influence the number of PCs and the quality of our analysis. We can use the ```boxplot()``` function for that:

```{r, echo=FALSE, results='hide',fig.keep='all'}
# Of course, first we have to read the data
table <- read.csv("./TableS5.csv", row.names = 1, header = TRUE)

png(file="ex2_boxplots.png",res=300, width = 5200, height = 2000, units = "px")
par(mfrow=c(1,1))
boxplot(table, main="Boxplot for gene expression profiles",
        cex.main = 3, cex.lab = 2) # After that, we can generate a quick boxplot
dev.off()
```

{{< img src="./unnamed-chunk-2-1.png" width=60%  align="center">}}

As we can see, most of the genes have a very similar basal level of expression, and very low, close to 0, which is the reason why the boxes in our box plots (representing the values between Q1 and Q3) look so small and stuck to the bottom of the image. In addition, we can see that most of the genes have a large number of outliers, represented by circles that stack up to look like columns, and that, in almost all cases, do not exceed the 5000 barrier. However, for both **E30** and **S18**, we observe a large number of outliers, which is precisely what we wanted to find with this representation: these are the genes that will be of most interest to us, as they are the ones that most modify the response of the system.

## Analyzing transcriptome differences for all cell types

Here, we would like to calculate how many PCs are optimal for our PCA analysis, and to try and see any relationships among the gene expression values seen in the boxplots and the PCA loadings representation of each component. For this, we will first standarize the data, to get it to have a mean of 0 and a variance of 1, and then plot the variance graph:

```{r, echo=FALSE, results='hide',fig.keep='all'}
# Standarize data. Scale = FALSE means it will just substract the mean
S<-scale(table,center=TRUE,scale=FALSE);
# We will make the matrix diagonalizable so that later code will work
C <-cov(S); det(C); E<-eigen(C)

# Round some stuff
round(inv(E$vectors)%*%C%*%E$vectors,digits=2)
round(E$values,digits=2)

# We first calculate the weights, loadings and scores:
weight<-((E$values/sum(E$values))*100)
loadings<-E$vectors; round(loadings,digits=3);
S<-scale(table,center=TRUE,scale=FALSE); Scores<-S%*%loadings

# And then plot them:
png(file="ex2_pca1_plots.png",res=300, width = 5200, height = 5200, units = "px")
par(mfrow=c(2,2), oma=c(0,0,2,0))
plot(loadings, main="Loadings plot for Full data", xlim=c(-0.6,-0.1),
     xlab = "Component 1", ylab = "Component 2", cex.main = 3, cex.lab = 2)
text(loadings,labels=colnames(table),pos=c(2,2,2,4,4,2))
plot(Scores, main="Scores plot for Full data: C1 vs C2",
     xlab = "Component 1", ylab = "Component 2", cex.main = 3, cex.lab = 2)
plot(Scores[,3], Scores[,4], main="Scores plot for Full data: C3 vs C4",
     xlab = "Component 3", ylab = "Component 4", cex.main = 3, cex.lab = 2)
plot(weight, type="s", main="Weights plot for Full data", cex.main = 3, cex.lab = 2,
     ylab="Percentage of variance", xlab="PCA component")
dev.off()
```

{{< img src="./ex2_pca1_plots.png" width=60%  align="center">}}

As we can see, components 1-3 seem to explain most of the variance on our dataset. with the percentage of variance dropping significantly after PC4. This is equivalent to the more traditional "elbow plot", in which we find an elbow after which adding additional PCs has little to no effect on variance. Seen the resultsof the above plot, we will keep 4 PCs for our analysis. With regards to the loadings plot, what we find is that, once again, there seem to be two clear outliers (maybe related to **E30** and **S18**?), with two semi outliers which might actually be PC3 and PC4. The loadings seem to correlate with the scores, which is good; in both graphs, there is a cluster of uninteresting genes close to 0, with some outliers to the left bringing the scores to the left too, and adding variance that may be of interest.

## Finding biomarkers for Stem Cells

Having decided on the number of Principal Components for our PCA analysis, we can proceed with the analysis itself. Since we want to find biomarkers that occur specifically in Stem Cells, and we know the genes that are differentially expressed there present the **WOX5** domain, we will select for the PCA analysis only those rows that surpass a treshold of 1 for said gene, and that dont surpass it for any of the other genes. Thus:

```{r, echo=FALSE, results='hide',fig.keep='all'}
# First, we subset the data to find only those markers with differential expression
stem_cells <- subset(table, WOX5 >= 1 & (APL < 1 & CO2 < 1 & COBL9 < 1 & COR < 1
                                         & E30 < 1 & GL2 < 1 & PET111 < 1 & S17 < 1
                                         & S18 < 1 & S32 < 1 & S4 < 1 & SCR < 1 
                                         & WER < 1 & WOL < 1) )

# We can show the markers' names:
rownames(stem_cells)

# And heatmap their values:
png(file="ex2_heatmap1.png",res=300, width = 5200, height = 5200, units = "px")
heatmap(as.matrix(stem_cells, scale="column"), main="Heatmap for Stem Cell data", )
dev.off()
# We scale along columns to account for relative value of markers
```

{{< img src="./unnamed-chunk-4-1.png" width=60%  align="center">}}

As shown by the plotted heatmap, the markers we have selected are, in fact, highly selective towards **WOX5** (and thus stem cells), ignoring most of the rest of the tissues. We can now proceed with a PCA analysis of this data:

## PCA of stem-cell markers

We begin by doing what we already did for the full table:

```{r, echo=FALSE, results='hide',fig.keep='all'}
Stem_Scaled<-scale(stem_cells,center=TRUE,scale=FALSE);
Stem_Cov <-cov(Stem_Scaled); det(Stem_Cov); Stem_Eigens<-eigen(Stem_Cov)
round(inv(Stem_Eigens$vectors)%*%Stem_Cov%*%Stem_Eigens$vectors,digits=2)
round(Stem_Eigens$values,digits=2)

Stem_weights<-((Stem_Eigens$values/sum(Stem_Eigens$values))*100)
Stem_loadings<-Stem_Eigens$vectors; round(Stem_loadings,digits=3);
Stem_Scaled<-scale(stem_cells,center=TRUE,scale=FALSE)
Stem_Scores<-Stem_Scaled%*%Stem_loadings

png(file="ex2_pca2_plots.png",res=300, width = 5200, height = 3000, units = "px")
par(mfrow=c(1,3), oma=c(0,0,2,0))
plot(Stem_loadings, main="Loadings plot for Stem Cell data",
     xlab = "Component 1", ylab = "Component 2", cex.main = 3, cex.lab = 2)
text(Stem_loadings,labels=colnames(table),pos=c(2,2,2,4,4,2))
plot(Stem_weights, type="s", main="Weights plot for Stem Cell data",
     ylab="Percentage of variance", xlab="PCA component", cex.main = 3, cex.lab = 2)
plot(Stem_Scores, main="Scores plot for Stem Cell data",
     xlab = "Component 1", ylab = "Component 2", cex.main = 3, cex.lab = 2)
dev.off()
```

![](./ex2_pca2_plots.png)

Unlike what happened before, we can see that 2 PCs suffice to explain most of the variance of the data. This makes sense: we only have ~450 rows, down from ~63000 before! With regards to the loadings, we see much fewer outliers, to the left of the graph, and, while some do exist, forcing the scores a bit in their direction, the real spread occurs along the vertical axis, especially for scores: that is, Component 2 records a much wider diversity than Component 1. That a single component explains so much variance makes a lot of sense: on the one hand, because it is inherent to PCA processes to reduce as much as possible the dimensions we work with; and, on the other hand, because we ourselves have manually reduced those dimensions by selecting a variable of special interest, the overexpression of WOX5. It is therefore possible that PC1 is telling us just that, the inordinate importance of variance in WOX5 expression in understanding our data.

## Comparing the graphs and identifying biomarkers

Finally, we can compare the results obtained for stem cells and for normal cells and see what happens. For instance, we can check PC1 vs PC2, and PC3 vs PC4, and see how they correlate in both experiments:

```{r, echo=FALSE, results='hide',fig.keep='all'}
# We can do this for scores
png(file="ex2_compare_scores.png",res=300, width = 3000, height = 3000, units = "px")
par(mfrow=c(2,2), oma=c(0,0,2,0))
plot(Stem_Scores, xlab = "Component 1", ylab = "Component 2",
     main="Scores for Stem Cell data")
plot(Stem_Scores[,3], Stem_Scores[,4], xlab = "Component 3", ylab = "Component 4",
     main="Scores for Stem Cell data")
plot(Scores, xlab = "Component 1", ylab = "Component 2",
     main="Scores for Full data")
plot(Scores[,3], Scores[,4], xlab = "Component 3", ylab = "Component 4",
     main="Scores for Full data")
dev.off()

# For loadings
png(file="ex2_compare_loadings.png",res=300, width = 3000, height = 3000, units = "px")
par(mfrow=c(2,2), oma=c(0,0,2,0))
plot(Stem_loadings, xlab = "Component 1", ylab = "Component 2",
     main="Loadings for Stem Cell data", xlim = c(-1.2,0.3))
text(Stem_loadings,labels=colnames(table),pos=c(2,2,2,4,4,2))
plot(Stem_loadings[,3], Stem_loadings[,4], xlab = "Component 3", ylab = "Component 4",
     main="Loadings for Stem Cell data", xlim = c(-0.6,0.3))
text(Stem_loadings[,3], Stem_loadings[,4],,labels=colnames(table),pos=c(2,2,2,4,4,2))
plot(loadings, xlab = "Component 1", ylab = "Component 2",
     main="Loadings for Full data", xlim = c(-0.6,-0.1))
text(loadings,labels=colnames(table),pos=c(2,2,2,4,4,2))
plot(loadings[,3], loadings[,4], xlab = "Component 3", ylab = "Component 4",
     main="Loadings for Full data", xlim = c(-0.45,0.1))
text(loadings[,3], loadings[,4], labels=colnames(table),pos=c(2,2,2,4,4,2))
dev.off()
```

{{< split 6 6 >}}
![](./ex2_compare_scores.png)
---
![](./ex2_compare_loadings.png)
{{< /split >}}

To interpret these graphs, we have to know that, to differentiate biomarkers, the key is the points that are separated from the rest, "marking" a differential expression. For example, in the PC1 vs PC2 loadings, we find that WOX5 is very clearly separated from the rest of the loadings in the Stem cell data graph, being located at the top left; as this does not happen in the full data, we can see that it is indeed a biomarker of this expression. We can also see that S18 and E30 tend to be located separately from the others in most loadings: this makes sense, as they are the genes with the highest differential expression, and therefore those for which it would be easiest to find biomarkers. To do this, we go to the Scores graph, where, if we see a point that corresponds to the loadings in terms of its separation from the rest, we can conclude that the marker it represents is specific to that gene (although we cannot know exactly which one because we have omitted the labels to avoid further blurring the image). This happens, apart from WOX5, for S18 and E30, which are the ones for which we can find biomarkers; not surprisingly, it was precisely S18 and E30 which were overexpressed in our original data, which is, indeed, why we can find biomarkers for them.
