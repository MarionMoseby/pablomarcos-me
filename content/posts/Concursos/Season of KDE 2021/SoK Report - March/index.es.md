---
title: "SoK 2021 - Informe de Marzo"
date: 2021-03-26 19:40:00 +0600
menu:
  sidebar:
    name: SoK 2021 Marzo
    identifier: sokmarzo
    parent: seasonofkde2021es
    weight: 40
---

En el post de febrero, expliqué como he reordenado el material que había en el MVP de Carl Schwan para el index, que ahora explica las principales características de Okular. Una vez hecho esto, me dediqué a añadir soporte para i18n, ya que puede ser difícil para los traductores trabajar con una plantilla de html crudo. Para ello, [he usado la plantilla {{i18n}} de HUGO](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/a042f38d0fe1d781860a0056721e66349393b997), que especifica las partes traducibles usando `{{ i18n "Section.variable" }}` en cada una de las cadenas a traducir, y luego mapeando los valores en un archivo yaml:

<details>
<summary>/i18n/es.yaml</summary>
{{< highlight yaml >}}
#Nombre de la sección traducible.
Section.variable:
    other: "Traducción al inglés de 'variable'"
Section.othervariable::
    other: "Traducción al inglés para 'othervariable'"
Section.yetanothervariable::
    other: "Traducción al inglés para 'yetanothervariable'"
{{< /highlight >}}
</details>

También he utilizado esto para traducir la tabla de formatos soportados en /applications. El resultado final se puede ver aquí:

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/new-okular-site.png" alt="Nuevo sitio web de okular" >}}
La página de inicio, con soporte para i18n
---
{{< figure src="/posts/Imagenes/okular-formats.png" alt="Sección de formatos del nuevo sitio web de Okular" >}}
Y la lista de formatos de archivo que Okular puede abrir
{{< /split >}}

A continuación, [añadí la página de /contacto](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/0e7989a171c36f2d7d0b32332a43a490a27ccf59), que rediseñé y actualicé para incluir la posibilidad de usar matrix. [También modifiqué el index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/1795c0da36113ee0219a69d66bfce1595218f94c) para incluir una referencia a la [próxima funcionalidad de firma de PDFs](https://invent.kde.org/graphics/okular/-/merge_requests/296) de Okular (¡UwU! A ver si me sirve de reemplazo para [Autofirma](https://github.com/ctt-gob-es/clienteafirma)), y [limpié los archivos innecesarios que quedaban de la transición](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9cab0470f744252ecff9ef9721f71de084167dfb) desde la web anterior.

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-contact.png" alt="Nueva sección de contacto de la web de Okular" >}}
Si quieres contactar con los desarrolladores, hay información en la página de contacto
---
{{< figure src="/posts/Imagenes/okular-esign.png" alt="Nueva función de firma de PDFs de Okular" >}}
También puedes firmar tus propios pdfs así como ver y verificar otras firmas.
{{< /split >}}

También quería añadir [un sistema de búsqueda del lado del cliente](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/05ce2a78d2b77d4e4e4e19e64a7e3601856095bf), ya que el que existía era realmente un botón que redirigía la consulta una búsqueda de Google. Me inspiré en (en los mentideros dirán que *me copié de*) [el popular gist de eddieweb](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae), que no sólo no requiere instalar paquetes adicionales, sino que además resalta las coincidencias usando JSON y Fuse.js. Ha sido fácil de añadir, ¡pero sigo estando orgulloso! 🤩 Es bonito ayudar a hacer la web menos dependiente de google 😊 

Puedes ver cómo queda aquí:

{{< figure src="/posts/Imagenes/okular-search.png" alt="Sección de búsqueda de la nueva web de Okular" >}}
Puedes buscar usando la barra de navegación, y los resultados están resaltados

Sí, ha sido un mes con mucho trabajo, pero, ¡por fin está todo listo! 🥳
