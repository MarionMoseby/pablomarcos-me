---
title: "SoK 2021 - Informe de Enero"
date: 2021-01-30
menu:
  sidebar:
    name: SoK 2021 Enero
    identifier: sokenero
    parent: seasonofkde2021es
    weight: 40
---

No he hecho mucho este mes de enero, ya que ha sido el mes de los "parciales" (exámenes finales) en el INSA, y he estado muy liado estudiando. Sin embargo, encontré tiempo para escribir la solicitud, que he adjuntado a continuación como referencia, y pasé el poco tiempo que pude dedicar a la SoK aprendiendo a utilizar correctamente HUGO y qué plantillas tenía que editar para obtener un resultado determinado. 

---

### Solicitud: Nuevo sitio web para Okular

Okular es un programa multifacético que uso casi a diario para mis necesidades de lectura y anotación de PDFs, aunque puede hacer mucho más. Lamentablemente, su página web está un poco anticuada y no es mobile-friendly. Por lo tanto, propongo reescribir el sitio web de Okular utilizando HUGO, de forma similar a como se hizo con el sitio web principal de kde.org, y manteniendo la coherencia con otras aplicaciones de KDE como [Konsole](https://konsole.kde.org/). Afortunadamente, parte del trabajo ya fue iniciado por Carl Schwan, por lo que sólo tendría que continuar y terminar su trabajo.

#### Objetivos del proyecto

La página web actualizada de Okular debe ser bonita, presentar la información de forma clara y ser fácil de usar. Algunas características deseadas son:
* Facilidad de uso en móviles
* Búsqueda en la página independiente de Google, por ejemplo, utilizando Lunar Search
* Actualización de la sección de capturas de pantalla (las capturas de pantalla me parecen anticuadas, pero tal vez es por que se tomaron en una plataforma diferente, como windows)
* Una interfaz más parecida a un blog para las noticias de desarrollo, tal vez manteniendo los registros de cambios dentro de la página web de Okular.

Además, las características ya presentes en la página web actual, como el soporte multilingüe, deben ser preservadas.

#### Implementación

Como se ha dicho anteriormente, el trabajo ya fue iniciado por [Carl Schwan](https://invent.kde.org/carlschwan/okular-kde-org/-/tree/hugo). El proyecto utiliza el framework HUGO y algunos scripts de python para la i18n. A lo largo del proceso se recogerán los comentarios de los desarrolladores de Okular para garantizar que el nuevo sitio web se adapte a sus necesidades. En cuanto a la documentación, creo que una descripción básica de cómo hacer funcionar el sitio sería suficiente, ya que HUGO está produciendo, en última instancia, HTML, CSS y JS crudo.

#### Calendario

* 13 Ene: Inicio del trabajo según la web de KDE
* 15 Ene - 24 Ene: Familiarización con la plataforma y aprendizaje de su funcionamiento interno. Dejo mucho tiempo aquí por si esto acaba siendo más difícil de lo que creo, pero posiblemente se pueda hacer en menos tiempo
* 24 de enero - 31 de enero: Última semana del semestre en INSA, probablemente tendré presentaciones y trabajo que hacer
* 1 de febrero - 12 de febrero: Tiempo de programar
* 13 de febrero - 21 de febrero: Vacaciones en Francia, si es posible debido al coronavirus podría ir de vacaciones, por lo que sería difícil programar ahora
* 22 de febrero - 28 de marzo: Tiempo de programar
* 29 de marzo - 4 de abril: El trabajo ya debería estar hecho, es hora de escribir un informe sobre cómo ha ido todo
* 5 de abril - 9 de abril: Última semana antes de las vacaciones en Francia, así que es posible que tenga trabajo que hacer en la uni
* 9 de abril: Fin del trabajo según la página web de KDE

#### Sobre mí

Soy un estudiante de biotecnología computacional de la UPMadrid que actualmente está haciendo un ERASMUS en el INSA de Lyon. Me encanta el código abierto, y uso Kubuntu -por lo tanto, KDE- como mi sistema operativo de elección, y me gustaría devolver a la comunidad aportando algo a cambio. Aunque trabajo principalmente con python (especialmente el paquete BioPython), he utilizado anteriormente HUGO para hacer mi sitio web personal, [pablomarcos.me](https://www.pablomarcos.me), donde se puede encontrar más información personal y mi CV completo. También he trabajado en otro proyecto con una UI orientada al usuario: [Who's that Function](https://flyingflamingo.itch.io/whos-that-function), un juego interactivo que enseña a los alumnos de primer grado las propiedades de las funciones, como parte de una beca de colaboración entre profesores y alumnos; aunque no está súper relacionado.

Me siento completamente cómodo trabajando a distancia, como ya lo hice para el juego antes mencionado debido a las restricciones de COVID-19, y, aunque el inglés no es mi lengua materna, puedo escribirlo y hablarlo con fluidez. También puedo hablar español, mi lengua materna, y francés.

---

P.D.: Además, en España, [¡había mucha nieve!](https://www.eldiario.es/sociedad/filomena-tine-blanco-espana-imagenes-nevada-historica_3_6738421.html) Lo cual es super bonito :p aunque algunas personas (mi madre incluida) acabaron atrapadas en sus trabajos. Por si tenéis curiosidad, aquí tenéis una foto de la calle Alcalá de Madrid, cubierta de nieve por el temporal Borrasca Filomena. <a href="https://commons.wikimedia.org/wiki/File:Borrasca_Filomena_Calle_de_Alcal%C3%A1.jpg">Javier Pérez Montes</a>, <a href="https://creativecommons.org/licenses/by-sa/4.0">CC BY-SA 4.0</a>, vía Wikimedia Commons

{{< figure src="/posts/Imagenes/filomena-madrid.jpg" alt="La calle Alcalá de Madrid, cubierta de nieve por el temporal Borrasca Filomena" >}}
