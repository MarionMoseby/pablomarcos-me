---
title: "Using Knowledge Representation to Improve Machine Learning Processes"
author: Pablo Marcos
date: 2021-12-16
math: true
menu:
  sidebar:
    name: Paper
    identifier: knowledge_representation_paper
    parent: knowledge_representation
    weight: 40
---

by Arnáiz, Yaiza and Marcos, Pablo Ignacio

<div style="text-align: center">
    <a href="https://github.com/yaiza612/Link-between-brain-and-machine" target="_parent"><img src="https://img.shields.io/badge/Get%20Source-on%20Github-white?style=for-the-badge&logo=Github&style=flat" align="center" width="20%"/></a>
</div> </br>

## Abstract

Knowledge representation is an area of artificial intelligence whose fundamental goal is to represent knowledge in a way that facilitates the inference of new data. This discipline studies how to think formally - how to use a system of symbols to represent a domain of discourse, along with functions that allow formal reasoning about objects.

In this paper, we will analyze the inner workings of knowledge representation, providing a simplified approach to the discipline and a practical example on how it can be applied to improve a Machine Learning Model. We will also explore how the different knowledge representation systems can be applied to neuroscience and artificial intelligence, in order to better understand how humans learn and how to use this knowledge to improve the design of machine learning algorithms.

## Introduction: Knowledge representation for machines and humans

When we represent knowledge, what we seek is not only to want to explain how the world around us works (be it nature itself or a ML algorithm), but, above all, to be able to make inferences from existing knowledge to derive new data. Therefore, it is necessary to find a balance between systems that are very expressive and easy to understand for humans, such as propositional logic, and others that are less intuitive but make the derivation of new data much easier, such as autoepistemic logic. To understand how these systems work, we will look at machines, which, due to being built by humans, are the ones most in need of this systems to order data.

### Knowledge representation for machines

There are two main types of models for studying how machines acquire knowledge:

• In connectionist models, we assume that knowledge is embedded in networks of relationships between different elements, allowing basic stimuli to be used to give rise to large processing networks. These models are based on the internal behavior of living beings, and give rise to structures such as neural networks, but are less explicable, since, in them, it is not possible to find an association between knowledge and representation.

• In symbolic models, knowledge is represented as a series of declarative sentences, usually based on logic, describing the attributes of a series of "symbols", mental models modifiable by rules that hold cognizable properties. These models are easier to explain, and it is on this type of models that we will deal with in our study.

### Knowledge representation for humans

In view of this, we may then ask ourselves, how do humans learn? In Legenyel et al., it is theorized that humans learn on the basis of symbols, which, in their case, are each of the movements that make up the repertoire of motor memories appropriate for the multitude of tasks we perform. But didn't we say that the connectionist models, and not the symbolic ones, were the ones based on real evolutionary phenomena?

The truth is, in reality, most of the biological systems are hybrid, mixing symbolic representations with connectionist models; the brain is probably one of them.

### The Legenyel experiment

To understand this in more detail, we would like to take a look into a theoretical model that explains how human senses work to produce and store knowledge. As part of a 2019 study, Legenyel et al did precisely this, studying how the sense of sight, a complex set of receptors and neural paths, works to convert complex features into simple, brain-processable pieces of information, which is what in the introduction we called symbols.

Their idea was simple: humans are good at recognizing symbols, but, what about chimeras? (symbols made up by remixing already existing symbols) Can humans easily distinguish those, or, on the contrary, would humans get even more lost when two different things are mixed together? How can we help humans visually remember different patterns?

To solve this question, they showed a group of 20 individuals groups of 6 elements (the train data) that were pairwise related. Then, the test subjects were shown groups of pairs, some “true” pairs as shown in the train data, and some “chimeric”, meaning mixing elements from different groups or different scenes, and asked them to tell whether those groups were familiar or not. In line with previous results, they found that observation of the training scenes helped subjects perform above chance in the visual familiarity test, judging “true pairs” more familiar than “pseudo pairs” despite having seen all the shapes an equal number of times.

To improve learning outcomes, a phisical (haptic) stimuli was provided: when shown the train data, subjects were told to “brea them appart”, being forced to push onto a bimanual robotic interface until it told them to stop. Critically, the force to break any of the groups of 6 elemets depended on their proportion of “true pairs” with those composed only of true pairs being the most difficult to break and those with only chimeras the easiest to tear appart. This improved learning significantly, as it provided humans with another sense to experiment.

## Materials and Methods

### Our experiment: Using ML to classify chimeras

So, by now, it should be clear that humans are really good at distinguishing between objects, and even at guessing how to classify new objects when they emerge. However, machines are notably bad at the same task, with classification of emerging patterns one of the clear challenges of machine learning approaches.

To illustrate this, we have built a simple, yet powerful, machine learning algorithm that classifies some images based on the pattern (circles, triangles or squares) that appear on them. To train and test it, we have built a custom database of shapes, including some chimeras, which, if we follow the ideas exposed on Legenyel, and if machines do indeed learn in a way similar to how humans do, should be the most difficult to analyze.

The source code and the dataset for this work [can be found on GitHub](https://github.com/yaiza612/Link-between-brain-and-machine), and are availaible freely for anyone to reuse or reproduce at will.

### A fourth class: Random Pixels

To improve our model, we have to provide an external input, as Legenyel did with the haptic impulse when separating the components. In our case, we have created a new class of "random pixels", which we hope will help the network to discover that a fourth class exists and be able to better classify chimeras.

This is because we believe that, by teaching the machine that there is a possibility of incomprehensible pixels appearing, it will learn to classify the chimeras as part of this new class of "random pixels", separating them from the different shapes.

### The final comparison: training with chimeras

To compare the results of our model with the best version of itself, we have created a final neural network, which, in this case, we have trained using chimeras as a fourth class; in this way, we expect its accuracy to be the best of all, being able to perfectly classify shapes into circles, squares or triangles.

### Results

As expected, the first neural network, which we trained using shape data but not chimera data, has fairly high accuracy rates in predicting the shape present in simple images (see Figure 1); however, in complex images, those containing a chimera, the program fails, telling us which shape is present in greater proportion but not being able to indicate that what it is seeing is neither one thing nor the other.

<div style="text-align: center">
    <img src="./figure-1.png" alt="Figure 1 - Compared Accuracy" align="center" width="50%" />
    <p>Figure 1: Compared accuracy of different shapes, global accuracy and performance over time for our first neural network, trained using only shape data. Please note how accuracy for shape detection is really high, although it cant detect chimeras,</p>
</div>

This makes sense: as we understand it, this machine would learn by grouping pixels, and deciding with what percentage confidence those pixels belong to one shape or another. The problem with this way of learning is that, given a chimera, the program does not quite understand how it works, since different groups of pixels belong, in different percentages, to different classes, and cannot classify it.

Thus, in order to be able to distinguish chimeras, we created our fourth class of random pixels. We theorized this would help the machine learn better, since it would have a fourth class of “uncomprehensible images” where to put the chimeras; however, contrary to expectations, we have seen that the accuracy not only does not increase, but actually decreases (see Figure 2): it seems that the random pixels only "confuse" the machine, which does not know how to classify them.

<div style="text-align: center">
    <img src="./figure-2.png" alt="Figure 2 - Compared Accuracy" align="center" width="50%" />
    <p>Figure 2: Compared accuracy of different shapes, global accuracy and performance over time for our second neural network, trained using shape data and random pixels. Please note how accuracy for shape detection has decreased with regards to Figure 1, while there are no improvements in chimera detection</p>
</div>

What is more, the machine is not even good at predicting chimeras, so it seems like adding a random pixel category was definetely not a good idea. Therefore, in order to understand what are the best results the machine would be capable of, we decided to create a third neural network, this time training it to know about the existence of the chimeras, and see what happens. Indeed, as we can see in Figure 3, this new neural network is not only better than the second one at classifying simple figures, but, unlike the first one, it is highly efficient at classifying chimeras, although these, due to their more complex nature, are still the least accurate (just like with humans!).

<div style="text-align: center">
    <img src="./figure-3.png" alt="Figure 3 - Compared Accuracy" align="center" width="50%" />
    <p>Figure 3: Compared accuracy of different shapes, global accuracy and performance over time for our third neural network, trained using shape data and chimera data. Please note how accuracy, although it takes a bit to take over, is better than in the second network, and how it can efficiently classify chimeras.</p>
</div>

## Conclusions

Throughout this paper, we have studied how humans learn, using the knowledge learned in class and Legenyel's paper. By creating our own neural networks, we have tried to simulate the learning process "in silico", providing our "virtual brains" with a series of external inputs (in this case, random pixels) to try to increase their recognition efficiency. However, we found that this approach did not work: possibly due to poor stimulus design.

In any case, what our results do agree with Legenyel's experiment is that, given a series of simple shapes, both humans and machines are worse at differentiating chimeras from real shapes, demonstrating that, in the end, machines are not so different from the humans who created them.

This is why knowledge representation remains a topical field, whose applications go beyond the philosophical field, and allow us to make practical decisions that improve decision-making algorithms. Although in this case we have not managed to improve the model, this experiment can serve as an example of how to try to make machine learning algorithms more understandable to humans, allowing interpretable and understandable decisions to be made in a world that will increasingly be governed by this type of algorithm.

## References

[1]: Cho, Y.-R., & Kang, M. (2020). Interpretable machine learning in bioinformatics. Methods, 179, 1-2. https://doi.org/10.1016/j.ymeth.2020.05.024

[2]: Doherty, P., Szalas, A., Skowron, A., & Lukaszewicz, W. (2006). Knowledge representation techniques: A rough set approach. Springer.

[3]:Lengyel, G., Žalalytė, G., Pantelides, A., Ingram, J. N., Fiser, J., Lengyel, M., & Wolpert, D. M. (2019). Unimodal statistical learning produces multimodal object-like representations. ELife, 8, e43942. https://doi.org/10.7554/eLife.43942

[4]: Tanwar, P., Prasad, & Mahendra. (s. f.). Comparative Study of Three Declarative  Knowledge Representation Techniques. nternational Journal on Computer Science and Engineering.

## License

Text is available under the Creative Commons Attribution Share Alike 4.0 License. Figures and source code availaible under the GNU General Public License, versions 3 or later.
