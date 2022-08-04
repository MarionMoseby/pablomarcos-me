---
title: "Notas de Clase"
author: Pablo Marcos
date: 2021-11-02
math: true
menu:
  sidebar:
    name: Notas de Clase
    identifier: statistics_assignment_0
    parent: estadistica_master
    weight: 40
---

## Introducción

La estadística es, según la RAE, el "Estudio de los datos cuantitativosde la población, de los recursos naturales e industriales, del tráfico o de cualquier otra manifestación de las sociedades humanas." Sin embargo,cabe preguntarnos, ¿de qué sirve todo esto? Tiene sentido buscarpatrones ocultos en los datos, o son estos patrones un mero artefacto denuestra imaginación?

Lo cierto es que, en la naturaleza, la objetividad es una ilusión: los datos simplemente existen, sin más, y somos los seres humanos los que,mediante el análisis matemático de los mismos, podemos conferirles un significado que los convierta en un sistema estructurado de información y conocimiento.

Es así que la estadística es uno de los métodos científicos más fiables de los que disponemos los seres humanos a la hora de buscar significados a conjuntos de datos aparentemente aleatorios, y, por tanto, para tomar decisiones de manera racional y sistemática.

## El pensador racional

En los textos de literatura clásica grecorromana, se genera el concepto de **pensador racional**: se trata del ser humano deseable para los antiguos, capaz de aislar los sentimientos y tomar decisiones usandosolamente la razón, **siguiendo las leyes de la aritmética** para discriminar, con una **perfección maquinal**, cuál es la carta ganadora,**libre** al fin **de influencias externas**. Este es, por cierto, elmismo camino seguido por Descartes en su famoso "*Cogito, ergo sum*",donde llega a demostrar, usando su razón como elemento aislado, su propia existencia.

Además, el pensador debe aprender a distinguir la verdadera racionalidad de la inteligencia: mientras que la segunda se refiere únicamente a los mecanismos mentales que garantizan la supervivencia, usando patronespre-entrenados del cerebro para tomar decisiones de manera rápida, la primera, entrenable mediante la educación, nos permite analizar cuidadosa e individualmente cada problema, buscando la respuesta más adecuada. Dicho de otro modo, en palabras de Sherlock Holmes: "*No hay nada más engañoso que una cosa evidente*"

## Representación de un problema

A la hora de tomar decisiones, existen una serie de **alternativas**,variables dependientes de un **contexto** cambiante que sólo con su debido tiempo revelará cuál era la opción más óptima.

A la vista de la aleatoreidad del tiempo, uno podría caer en una visión nihilista del mundo, y plantearse si, dada la imposibilidad de conocer el futuro (descontando claro, chamanes y pitonisas por igual) es imposible tomar decisiones con sentido. Ante esta terrible perspectiva,aparece el concepto de **consecuencias**, el **retorno potencial de inversión sobre una serie de alternativas y contextos posibles**, que nos puede ayudar a tomar decisiones.

De esta manera, podemos **representar un problema** de distintas maneras: bien como una tabla, donde las filas son las alternativas, las columnas, los posibles escenarios, y la intersección de las mismas, las consecuencias obtenidas; o bien como un árbol, donde cada tronco representa una alternativa, cada rama un escenario, y cada hoja una consecuencia

> **Ver diapositivas 11 y 13 de la Presentación "**[**Lesson 1    (October    5th)**](https://moodle.upm.es/titulaciones/oficiales/mod/resource/view.php?id=270508)**" para ejemplos**

## Toma de decisiones: certeza vs incertidumbre

Ahora que sabemos representar sistemáticamente un problema, nos preguntamos: ¿cómo tomar la decisión acertada? Para ello, existen una serie de criterios estandarizados, que dependen del tipo de problema al que nos enfrentemos:
* *Decisiones bajo certeza*: son aquellas en las que existen **relaciones directas de causa-efecto entre cada acción y sus consecuencias:** por ejemplo, si queremos gestionar recursos productivos, podemos usar métodos tales como la programación lineal(optimización), o las teorias de valores cardinales y ordinales.
* *Decisiones bajo incertidumbre*: aparecen dos nuevos conceptos: el**riesgo**, cuando conocemos las posibilidades de las distintas consecuencias (aunque no sepamos, lógicamente, cual triunfará) y la**incertidumbre **o** incertidumbre estricta,** donde ni siquiera conocemos las probabilidades de las distintas consecuencias. Para esta clase de casos, tenemos los siguientes métodos:
    - *Criterio Maximin-Minmax de Wald o criterio pesimista*: Para cada alternativa se supone el peor escenario, y, dentro de este, se elige la alternativa que conduce a la mejor consecuencia. Su mayor crítica es que, al ser un **método conservador** (supone el peor escenario), podríamos estar renunciando a beneficios enormes que no tengan un riesgo tanto mayor
    - *Criterio Maximax*: Asume el mejor escenario, y, de él, elige la    alternativa que conduce a la mejor consecuencia. No es muy utilizado por su **exagerado optimismo.**
    - *Criterio de Hurwicz*: **Combina los puntos de vista pesimista y optimista**, valorando cada alternativa con una combinación ponderada entre la mejor y la peor
    - *Criterio de Savage o coste-oportunidad*: **Las consecuencias de cada alternativa se comparan con las consecuencias de las demás** bajo el mismo contexto. Se trata, por así decirlo, de encontrar la opción "menos mala", y es muy usado en el ámbito de la economía.
    -*Criterio de \"razón insuficiente\" de Laplace*: **Tiene en cuenta todos los valores**. Como las probabilidades de los contextos son desconocidas, se asigna el mismo valor de probabilidad para todos ellos, eligiendo la alternativa con mayor valor esperado. Si lo modificamos para añadir probabilidades subjetivas, obtenemos la *Modificación Bayesiana*.

Excepto el criterio de Laplace, que es más objetivo, todos los criterios dependen en los sentimientos subjetivos del pensador, y en su nivel de optimismo. Para encontrar un compromiso entre objetividad y el punto de vista del tomador de decisiones, nace la *Teoría de la Utilidad Esperada*, una herramienta común para decisiones bajo incertidumbre y bajo certeza. En esta teoría, las consecuencias se valoran según su preferencia, y los escenarios según las creencias del tomador de decisiones racional, que es el agente objetivo: se genera así una**función de utilidad**,que contiene las posibles consecuencias, y elobjetivo es encontrar una alternativa tal, que maximice la utilidad.

## Toma de decisiones: colectivas vs interactivas

En función del número de participantes, las decisiones se pueden clasificar en:
* *Decisiones no interactivas*: También llamadas *decisiones colectivas*, son aquellas en las que un grupo, en lugar de un sólo individuo, debe tomar la decisión.
    - *Caso ordinal*: En este caso, hay una **cantidad finita de alternativas** X, con un número también finito de agentes que tienen una serie de preferencias sobre el set X. Hay maneras de proceder: una *regla de votación* es una función que asigna una alternativa a cada serie de preferencias, escogiéndose la opción con más votos, sin elaborar un ranking; por otro lado, una *regla de decisiones sociales* hace un ranking de las alternativas según las preferencias de los agentes. Aunque el segundo es el ideal, al asegurar que se obtiene la opción con la que más contenta estaría la mayoría, el primero resulta muchas veces más práctico y realista.
    - *Caso cardinal*: Permite llevar a cabo una **agregación de las funciones de utilidad de la TUE**, con distintos Principios a la hora de seleccionar el valor óptimo: el Liberal (mayoritario), el Social (equilibrado), el de Fraternidad (minoritario) o el Aristocrático (no todas las funciones de utilidad cuentan igual)• *Decisiones no interactivas*: También llamadas decisiones pornegociación, permiten establecer el efecto que las acciones de unindividuo tendrá en el/los otro/s, a diferencia de lo que ocurría en lasdecisiones colectivas, donde las decisiones, si bien influyen en larealidad material de los demás electores, no deben influir en el sentidode su voto.

## Toma de decisiones: multicriterio

Un tomador de decisiones puede querer obtener varias cosas de su elección; por ejemplo, un banquero querrá maximizar el retorno de la inversión, pero también minimizar el tiempo en que esto sucede y el riesgo al que expone su patrimonio. Ante esto, tenemos que decidir qué tipo de estrategias utilizar: eficientes, de compromiso o satisfactorias.

## Conclusiones

La estadística es una de las más potentes herramientas de las que disponemos los seres humanos a la hora de tomar decisiones informadas sobre el mundo. Dejando a un lado los sentimientos, y tomando un enfoque racional, podemos encontrar la solución más óptima a todos los problemas de la vida, usando cualquiera de los métodos anteriormente mencionados en función de nuestras preferencias y nuestra tolerancia al riesgo. Por ejemplo, usando métodos de negociación colectiva, podemos encontrar la manera de resolver problemas tan graves como el cambio climático, la crisis de la democracia o la pobreza, evitando en el camino problemas como la tragedia de los comunes.

La estadística marca así el camino, pero, en el juego de la vida, somos nosotros los que decidimos, y es nuestra responsabilidad usar las conclusiones científicas y racionales como nosotros deseemos; y es aquí donde nuestro juego de valores, y nuestros sentidos, sí que pueden jugar un papel mas allá de la razón, siempre teniendo en cuenta las consecuencias de nuestras acciones.

## Referencias

Algunos recursos que me han interesado, que me han ayudado a entender este tema o que me han parecido de interés:

* *Bayes theorem, the geometry of changing beliefs*.[https://www.youtube.com/watch?](https://www.youtube.com/watch?y=HZGCoVF3YvM)

* *Game Theory: The Science of Decision-Making*. [https://www.youtube.com/watch?v=MHS-htjGgSY](https://www.youtube.com/watch?v=MHS-htjGgSY)

* *La curiosa historia del hombre que NO podía usar sus emociones*: [https://www.youtube.com/watch?v=Y85OfTdWFYI](https://www.youtube.com/watch?v=Y85OfTdWFYI)

* «Politics Podcast». *FiveThirtyEight*,<https://fivethirtyeight.com/tag/politics-podcast/>, concretamente la sección "Good use of polling or bad use of polling"
