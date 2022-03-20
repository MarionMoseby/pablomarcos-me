---
title: "Pneumonia identification from X-Ray Imagery"
author: Pablo Marcos
date: 2022-02-11
math: true
menu:
  sidebar:
    name: ReadMe
    identifier: big_data_master_final_readme
    parent: big_data_master_final
    weight: 40
---

*by Yaiza ARNAIZ ALCACER and Pablo Ignacio MARCOS LOPEZ*

## Abstract

Pneumonia is a serious illness characterised by a severe cough with phlegm, fever, chills and shortness of breath, which is caused by inflammation of the alveoli in one or both lungs. Despite advances in the diagnosis and treatment of lung infections, pneumonia is the sixth leading cause of death in adults in the United States, with more than six million cases of acute pneumonia each year, one million of which require hospitalisation.

The simplest way to determine the extent and location of the infection, so that it can be treated more efficiently, is by taking chest X-rays; however, at present, analysis of these X-rays is limited to what humans are capable of, with the time delays and enormous costs that this entails.

The aim of this paper is to present a complete model of thoracic X-ray image analysis, which we have developed by stacking two different Machine Leaning models, so that future scientists can build on it to hopefully improve the waiting time and economic efficiency of this class of tests.

The present model has an accuracy of 68.26 %. Nevertheless, it is designed to handle big data and uses state of the art techniques presented in *Anunay Gupta et al.*[^1]. The approach uses several networks pretrained on ImageNet and stacks their learned representations. It is up to future researchers (possibly for those with more resources) to improve the stacking process. As further experiment (not done yet in this field) we want to implement a voting system among the networks, which could help with accuracy.

## Introduction

### Description of the illness

Pneumonia is a disease characterised by infection and inflammation of the air sacs of one (unilateral) or two (bilateral) of the lungs, and especially of the alveoli. These are small "clusters" located at the end of each bronchus whose function is to allow oxygen to enter our blood; however, during pneumonia, part of them may end up filling with fluid or pus, preventing air from entering.

The spectrum of germs responsible for pneumopathies is broad, and new pathogens are constantly being identified: it may be caused by bacteria, but it is also possible that a virus, such as influenza or COVID-19, is responsible for the infection. Despite advances in the diagnosis and treatment of lung infections, pneumonia remains a major cause of morbidity and mortality in adults, representing the sixth leading cause of death in the United States, with more than six million cases each year, more than one million of which require hospitalisation.

**Symptoms**

Signs and symptoms of pneumonia vary from mild to severe, depending on factors such as the type of germ causing the infection, age and general health. Mild signs and symptoms are often similar to those of a cold or flu, but last longer. These may include:

* Chest pain when breathing or coughing.
* Nausea, vomiting or diarrhoea.
* Difficulty breathing
* Coughing, which may produce phlegm
* Fatigue
Fever, sweating and/or chills * Lower than normal body temperature
* In adults aged 65 years and older it may also cause confusion or changes in mental awareness and a lower than normal body temperature (the latter is common in people with a weakened immune system).

Newborns and infants may sometimes show no signs of infection, but may also vomit, have fever and cough, appear restless or tired and lack energy, or have difficulty breathing and eating.

#### Risk factors

* Children under 2 years of age or younger
* People 65 years of age or older
* Being hospitalised, especially if you are on a ventilator
* Tingling
Chronic diseases such as asthma or heart disease * Weakened or suppressed immune system
* Weakened or suppressed immune system

#### Diagnosis

The most common methods are:

* Blood tests to confirm an infection and try to identify the type of organism that has caused the pneumonia.
* Chest x-ray to determine the extent and location of the infection.
* Pulse oximetry to measure the level of oxygen in the blood.
* Sputum test to obtain a sample of fluid from the lungs.
* In case of a more serious condition, a CT scan or pleural fluid culture may also be performed.

As can be seen, the most common methods of diagnosis are based on clinical data, appropriate microbiological tests and chest X-rays, which can quickly demonstrate parenchymal abnormalities. Radiography is an important element in the initial evaluation of any patient with suspected pneumopathy, but diagnosis remains a challenge, as pneumopathies with identical clinical and radiological signs may have different germs as their origin.

The most common treatments include antibiotics to treat bacterial pneumonia, cough medicines and fever reducers, but the prognosis is poor: 2.63% of infected patients eventually die, a rate even higher than measles or HIV in their worst years, but lower than other monsters such as Ebola. It is because of this that proper and early diagnosis is essential, to prevent the disease from progressing further and further complicating patient survival.

### Current state of the art for classification of X Ray Images

As we have seen, the inference of medical diagnoses from X-ray images is an essential feature in the diagnosis of pneumonia. However, during the CoViD-19 pandemic in which we live, the number of doctors available (either due to contagion or confinement) has radically decreased, while demand has increased due to coronavirus-derived pneumonia cases, creating a bottleneck that needs an urgent solution.

Thus, the potential of Deep Learning models of X-ray images has been investigated for some years now to hopefully find a model with sufficient accuracy, recall and precision for the detection of COVID-19 induced pneumonia using chest radiography without human supervision. In the paper "InstaCovNet-19: A deep learning classification model for the detection of COVID-19 patients using Chest X-ray"[^1], *Gupta et al* present a model that, precisely, is able to achieve greater than 99% accuracy (much higher than human) by stacking pre-existing networks called Iception, NASnet, Xception, MobileNetV2 and ResNet, all of which are image classification models.

![A diagram showing how integrated stacking works, and, more precisely, how it worked in the InstaCovNet-19 paper. Own work - now uploaded to Wikimedia Commons :p](./integrated-stacking.png)

Our original idea was to study the performance of this model (InstaCovNet-19), but, since its code is not available, and knowing, thanks to this paper, that stacking neural networks significantly improves its results, we have decided to **design our own model using (py)Spark and integrated stacking**.

## Matherials and Methods

### Dataset Description

To train, test and validate our models, we have used a dataset of validated OCT images and chest X-rays as described and analysed in "Deep learning-based classification and referral of treatable human diseases", available on Mendeley Data under CC-By-Sa 4.0 licence.[^2]

This dataset consists of a group of chest X-ray images (anterior-posterior) selected from retrospective cohorts of paediatric patients aged one to five years from the *Guangzhou Women and Children's Medical Center* in Guangzhou (China), selecting for quality control all poor quality or unreadable scans. The diagnostic images were graded by two medical experts before being cleared for AI system training and, in order to account for any grading errors, the evaluation set was also reviewed by a third expert. All radiographs were performed as part of the patients' routine clinical care.[^3]

The images are divided into a training set and a separate patient test set. Images are labelled as (disease)-(random patient ID)-(image number for each patient) and divided into 4 directories: CNV, DME, DRUSEN and NORMAL.
The images are labelled as (disease)-(random patient ID)-(image number for each patient) and divided into 3 folders: Training and Test, which are part of the original dataset; and Validation, which separates 16 images for purposes of checking the validity of the model. Each of these three folders contains the subfolders "normal" and "Pneumonia", to compare between positive and negative patients.

![On the right, infiltrated lung, suggesting a possible pneumonia. On the right, a normal lung. Both images are CC-By-Sa 4.0 by CNX OpenStax via Wikimedia Commons](./pulmones.png)

### Workflow

Different approaches can be taken in this respect, so we decided to look at the state of the art for inspiration.[^1] Our original idea was to study the performance of the InstaCovNet-19 model, but, since its code is not available, and knowing, thanks to this paper, that stacking neural networks significantly improves classification results, we have decided to **design our own model using (py)Spark and integrated stacking**.

However, after performing said stacking, we encounter a RAM problem: neither the 12 gb of Google Collab Free, nor those available in its Pro version, are enough to run the code, for which, it seems, the authors of the respective paper must have had a lot of resources. Thus, it is not possible to define exactly the same neural network as in our reference paper, as the session is squashed due to the ram limit, but we have nonetheless defined the code and found that, until the limit is reached, it works without problems (it can be consulted in the Annex). However, and since with our current resources this code will not run, we will define a new neural network, one that only stacks two sub-networks, but that Google Collab can handle.

We found that the stacking works well and that we can concatenate the models if the last layer of both have the same shape. That means that we need to look at every last layer of each network and feed its learned representation through a small amount of layers. The networks themselves can be improved even further using industry-standard best practices for transfer learning.[^4]

For the data itself, we will do the following preprocessing:

* CenterCrop - Resizes the image to 224 x 224
* RandomFlip - Randomly flips 50% of the image horizontally
* ColorJitter- Randomly adjusts the brigthness of 50% of the images
* Normalize - Normalizes the images

And then feed it to pytorch (a ML library initially developed at Facebook) using Orca from Analytics Zoo and pySpark for distributed running.

## Results and discussion

The accuracy (~68.3%) is lower than expected, considering that our experiment stacks 2 different networks. As we can see in the annex, the loss is very small, but the accuracy is still quite low. This is strange, since the loss usually indicates how well the model learns. Nevertheless, a low loss does not mean better accuracy because the model could be learning in an unexpecting way. A possible explanation for low loss with a low accuracy is called high variance.

We can conclude that scaling an integrated neural network like that of *Anunay Gupta et al.*[^1] is extremely complicated, since 5 neural networks are used in total, some larger than others and all with a very different last layer. For example, inception_v3 is a really good model for X-ray image classification, as you can read in previous work with transfer learning. However, it is a very large model and stacking this model with another one requires a lot of ram memory in training that we do not have now.

With this in mind, taking inceptio_V3 and doing transfer learning could be a good option, but such an experiment would not be original or fun, as it has already been tried and tested by many previous works.

As a further experiment, we could use transfer learning of different good models in image classification, but without stacking them together, and then implement a voting system.

## References

[^1]: A. Gupta, Anjum, S. Gupta, y R. Katarya, «InstaCovNet-19: A deep learning classification model for the detection of COVID-19 patients using Chest X-ray», Applied Soft Computing, vol. 99, p. 106859, feb. 2021, doi: 10.1016/j.asoc.2020.106859. [Online]. Disponible en: https://www.sciencedirect.com/science/article/pii/S1568494620307973. [Accessed: February 11th, 2022]

[^2]: D. Kermany, K. Zhang, y M. Goldbaum, «Labeled Optical Coherence Tomography (OCT) and Chest X-Ray Images for Classification», vol. 2, ene. 2018, doi: 10.17632/rscbjbr9sj.2. [Online]. Disponible en: https://data.mendeley.com/datasets/rscbjbr9sj/2. [Accessed: February 11th, 2022]

[^3]: D. S. Kermany et al., «Identifying Medical Diagnoses and Treatable Diseases by Image-Based Deep Learning», Cell, vol. 172, n.º 5, pp. 1122-1131.e9, feb. 2018, doi: 10.1016/j.cell.2018.02.010. [Online]. Disponible en: https://www.cell.com/cell/abstract/S0092-8674(18)30154-5. [Accessed: February 11th, 2022]

[^4]: F. Zhuang et al., «A Comprehensive Survey on Transfer Learning», arXiv:1911.02685 [cs, stat], jun. 2020 [Online]. Disponible en: http://arxiv.org/abs/1911.02685. [Accessed: February 11th, 2022]
