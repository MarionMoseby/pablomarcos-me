 ---
title: "SoK 2021 - Informe Final "
date: 2021-04-09
menu:
  sidebar:
    name: Informe Final
    identifier: informefinal
    parent: seasonofkde2021es
    weight: 40
---

Para la Season of KDE 2021, decidí trabajar en el sitio web de Okular. Okular es un programa multifacético que uso casi todos los días para mis necesidades de lectura y anotación de PDF, aunque puede hacer mucho más. Desgraciadamente, su sitio web estaba un poco anticuado y no era apto para móviles. Por lo tanto, me propuse reescribir el sitio web de Okular utilizando el framework HUGO, de forma similar a como se hizo con el sitio web principal de kde.org, y manteniendo la coherencia con otras aplicaciones de KDE como [Konsole](https://konsole.kde.org/). Afortunadamente, parte del trabajo ya fue iniciado por Carl Schwan, por lo que sólo tuve que continuar y terminar su trabajo.

### Mentor

* [Carl Schwan](https://invent.kde.org/carlschwan/)

### Enlaces

Repositorios
* [Repo oficial donde se fusionará todo el trabajo](https://invent.kde.org/websites/okular-kde-org/)
* [Repo de trabajo](https://invent.kde.org/carlschwan/okular-kde-org/-/tree/work)

### Trabajo realizado

#### Enero de 2021
No hice mucho en enero, ya que era el mes de los "partiels" (exámenes finales) en INSA y estaba muy ocupado estudiando. Pero, de vuelta a España, [¡había mucha nieve!](https://www.eldiario.es/sociedad/filomena-tine-blanco-espana-imagenes-nevada-historica_3_6738421.html) Lo cual es super bonito :p

#### Febrero de 2021

Empecé por [portar la sección de Anuncios de HTML (RDF) a Markdown](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/e3e8529ff33be74ea4d9ed59406fdef4e5418127), para lo cual escribí un pequeño script. Luego, [configuré el proyecto](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9229e022294accb9b279d87f3d91fb1693251a61) para usar [aether-sass](https://invent.kde.org/websites/aether-sass) (el tema estándar HUGO de KDE) como módulo Go, ya que los submódulos Git eran menos deseables. A continuación, añadí [una sección de preguntas frecuentes](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/62829821d073506f15e46def4d0f1418ec215834), lo cual fue fácil ya que la mayoría de las preguntas habían sido eliminadas en una limpieza reciente. Para ello, utilicé las etiquetas HTML `</details>` y `</summary>`, que no conocía y que me parecen super chulas. Por último, [añadí las nuevas páginas /download y /build-it, así como un nuevo index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/7b85b02878982032487e49058771c9685c39b213), utilizando una mezcla de markdown de HUGO y plantillas html crudo.

#### Marzo de 2021

Una vez añadido el index como una plantilla html sin procesar, ahora necesitaba añadir soporte i18n; [esto se consiguió utilizando la plantilla {{i18n}} de HUGO](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/a042f38d0fe1d781860a0056721e66349393b997), que también utilicé en la tabla de formatos soportados de /applications. A continuación, [añadí la página /contacto](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/0e7989a171c36f2d7d0b32332a43a490a27ccf59), que rediseñé y actualicé para incluir matrix. Modifiqué el índice](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/1795c0da36113ee0219a69d66bfce1595218f94c) para incluir una referencia a la [próxima compatibilidad con la firma de PDF](https://invent.kde.org/graphics/okular/-/merge_requests/296) de Okular (¡qué bien! Puede que finalmente deje de usar [Autofirma](https://github.com/ctt-gob-es/clienteafirma)), [limpié los archivos innecesarios que quedaron de la transición](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9cab0470f744252ecff9ef9721f71de084167dfb), [y añadí una funcionalidad de Búsqueda en el Sitio](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/05ce2a78d2b77d4e4e4e19e64a7e3601856095bf) [que funciona](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/01d76a0403681263c991b55667f038db80323f3c) del lado del cliente y no depende de google, inspirada en (en los mentideros dirán que *copiada de*) [el popular gist de eddieweb](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae).

#### Abril de 2021
Todo el trabajo en el proyecto ya está terminado. Sólo quedan [algunas modificaciones menores](https://invent.kde.org/websites/okular-kde-org/-/merge_requests/4) y escribir este informe del proyecto.

### Balance del proyecto
Creo que los [objetivos fijados al inicio del proyecto](https://season.kde.org/project/46) (haz clic [aquí](https://www.pablomarcos.me/posts/concursos/sok-report-january) si no tienes una cuenta de KDE) se han cumplido en su mayor parte: la nueva web presenta la información de forma clara, bonita y amigable para los móviles, gracias al tema aether-sass. Tiene un sistema de búsqueda independiente de Google, aunque no utiliza lunar.js como se sugirió, y las noticias de desarrollo están ahora en su propia sección, aunque los registros de cambios se dejaron fuera de los mensajes individuales por razones de practicidad. Las capturas de pantalla han sido actualizadas, pero la mayoría han sido eliminadas ya que hemos decidido hacer una página de inicio más sencilla que destaque las características más importantes del programa.

En definitiva, se han mantenido la mayoría de las características de la antigua página web, pero se ha añadido un rediseño más moderno que aumenta la usabilidad y hace el proyecto más atractivo y coherente con la estética de KDE. 

#### Lo que he aprendido

* ¡Las etiquetas HTML `</details>` y `</summary>` existen! Esto ha sido súper útil, pues ya he utilizado ese conocimiento en mi página web personal :p
* Cómo usar HUGO en general, y HUGO i18n en particular
* ¡Que Okular está añadiendo soporte para firmas PDF!
* Cómo manejar HTML, CSS y JavaScript, conocimientos importantes que ya he aplicado en mi próximo proyecto, la web de la [Revista Científica "Pensamiento Matemático"](https://revista.giepm.com/)
* ¡KDE es tan genial como pensaba! 😏

### Blog Posts on KDE Planet

Los enlaces de estos posts del blog están en mi sitio personal, no en KDE Planet, pero puedes comprobar que se agregan a Planet pinchando [aquí](https://invent.kde.org/websites/planet-kde-org/-/commit/fcd89ac67fc2478f9ad456b1384ccae5f1060d51)

* [Post de enero de 2021](https://www.pablomarcos.me/posts/concursos/sok-report-january/)
* [Post de febrero de 2021](https://www.pablomarcos.me/posts/concursos/sok-report-february/)
* [Post de marzo de 2021](https://www.pablomarcos.me/posts/concursos/sok-report-march/)
* [Post de abril de 2021](https://www.pablomarcos.me/posts/concursos/sok-report-april/)

### Screenshots

Aquí puedes encontrar algunos ejemplos del trabajo que he realizado. 

{{< split 3 3 3 3 >}}
{{< figure src="/posts/Imagenes/old-okular-mobile-site.png" alt="Vista móvil de la antigua web de Okular" >}}
Como puedes ver, la antigua web no tenía soporte para móviles
---
{{< figure src="/posts/Imagenes/new-okular-mobile-site.png" alt="Vista móvil del nuevo sitio web de Okular" >}}
Sin embargo, la segunda versión funciona de maravilla en el móvil
---
{{< figure src="/posts/Imagenes/okular-news.png" alt="Vista móvil del nuevo sitio web de Okular para la sección de noticias" >}}
He mejorado la sección de Noticias usando list.html y un script de python
---
{{< figure src="/posts/Imagenes/okular-faq.png" alt="Vista móvil del nuevo sitio web de Okular para la sección de preguntas frecuentes" >}}
Y añadí las FAQ usando `<detalles>` y `<resumen>`.
{{< /split >}}

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-download.png" alt="Sección de descargas de la nueva web de Okular" >}}
La sección de descargas te ayuda a encontrar las opciones de descarga disponibles.
---
{{< figure src="/posts/Imagenes/okular-build-it.jpg" alt="Sección build-it del nuevo sitio web de Okular" >}}
Y la sección Build It muestra cómo construir el programa desde el código fuente
{{< /split >}}

{{< split 4 4 4 >}}
{{< figure src="/posts/Imagenes/okular-contact.png" alt="Sección de contacto de la nueva web de Okular" >}}
Si quieres contactar con los desarrolladores, hay información en la página de contacto
---
{{< figure src="/posts/Imagenes/okular-formats.png" alt="Sección de formatos del nuevo sitio web de Okular" >}}
La página de Formatos Soportados lista las extensiones que Okular puede abrir
---
{{< figure src="/posts/Imagenes/okular-search.png" alt="Sección de búsqueda del nuevo sitio web de Okular" >}}
Se puede buscar usando la barra de navegación, y los resultados se resaltan
{{< /split >}}

Y, por último, la comparación lado a lado: Aquí está el antiguo sitio web [(enlace al Internet Archive)](https://web.archive.org/web/20210312020118/https://okular.kde.org/):
{{< figure src="/posts/Imagenes/old-okular-site.png" alt="Old Okular Website" >}}

Y aquí está [la nueva](https://okular.kde.org):

{{< figure src="/posts/Imagenes/new-okular-site.png" alt="New Okular Website" >}}


### Contacto
Si quieres hacer sugerencias para este proyecto, no dudes en ponerte en contacto conmigo.

KDE Invent :- [Pablo Marcos](https://invent.kde.org/flyingflamingo)

Matrix :- [@pablitouh:matrix.org](https://matrix.to/#/@pablitouh:matrix.org)
