---
title: "SoK 2021 - Informe de Febrero"
date: 2021-02-25
menu:
  sidebar:
    name: SoK 2021 Febrero
    identifier: sokfebruaryes
    parent: seasonofkde2021es
    weight: 40
---

Empecé el mes [portando la sección de Anuncios de HTML a Markdown](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/e3e8529ff33be74ea4d9ed59406fdef4e5418127), para lo cual escribí un pequeño script en python que analiza todo el contenido de [este archivo news.rdf](https://invent.kde.org/carlschwan/okular-kde-org/-/blob/b22f5e0e420cfddd406139eb814d02b82eeec95b/news.rdf), heredado del antiguo sitio, y crea varios archivos de posts en markdown que serán procesados por las plantillas 'list.html' y 'single.html' del tema aether-sass para convertirlas en la nueva sección.

<details>
<summary>Para ver el script de python al completo, pincha aquí</summary>
{{< highlight python >}}
import re
text_file = open("./news.rdf", "r")
data = text_file.read()
titles = re.findall('<title>(.*)</title>', data)
dates = re.findall('<date>(.*)</date>', data)
fullstories = re.findall('<fullstory>(.*)</fullstory>', data)

i=0; mes=0; dia =0
for i in range(len(dates)):
    año = dates[i].split(' ')[2]
    day = dates[i].split(' ')[1].replace(',','')
    if day == '1': dia = '01' 
    elif day == '2': dia = '02' 
    elif day == '3': dia = '03' 
    elif day == '4': dia = '04' 
    elif day == '5': dia = '05' 
    elif day == '6': dia = '06' 
    elif day == '7': dia = '07' 
    elif day == '8': dia = '08' 
    elif day == '9': dia = '09' 
    else: dia = day
    month = dates[i].split(' ')[0]
    if month == 'January': mes = '01' 
    elif month == 'February': mes = '02' 
    elif month == 'March': mes = '03'
    elif month == 'April': mes = '04'
    elif month == 'May': mes = '05'
    elif month == 'June': mes = '06'
    elif month == 'July': mes = '07'
    elif month == 'August': mes = '08'
    elif month == 'September': mes = '09'
    elif month == 'October': mes = '10'
    elif month == 'November': mes = '11'
    elif month == 'December': mes = '12'
    elif month == 'December': mes = '12'
    elif month == 'Jul': mes = '07'
    elif month == 'Apr': mes = '04'
    elif month == 'Jan': mes = '01'
    elif month == 'Nov': mes = '11'
    elif month == 'Aug': mes = '08'
    fecha = str(año)+'-'+str(mes)+'-'+str(dia)
    filetoopen = str(titles[i].replace(',','').replace(' ','_')+'.md')
    f = open(filetoopen, "a")
    f.write('---\ndate: '+fecha+'\ntitle: '+titles[i]+'\n---\n'+fullstories[i])
    #f.close()
{{< /highlight >}}
</details>


Luego, [configuré el proyecto](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9229e022294accb9b279d87f3d91fb1693251a61) para usar el ya mencionado [aether-sass](https://invent.kde.org/websites/aether-sass) (el tema estándar de KDE para HUGO) como módulo Go, ya que los submódulos Git son menos deseables. A continuación, añadí [una sección de preguntas frecuentes](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/62829821d073506f15e46def4d0f1418ec215834), lo cual fue fácil ya que la mayoría de las preguntas habían sido eliminadas en una limpieza reciente. Para ello, utilicé las etiquetas HTML `</details>` y `</summary>`, que no conocía y que me parecen super chulas. ¡Esta fue, también, la primera vez que experimenté cómo funciona una plantilla de HUGO! ¡Yay!

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-news.png" alt="Vista móvil de la nueva web de Okular para la sección de noticias" >}}
He mejorado la sección de Noticias usando list.html, de HUGO, y un script de python
---
{{< figure src="/posts/Imagenes/okular-faq.png" alt="Vista móvil del nuevo sitio web de Okular para la sección de preguntas frecuentes" >}}
Y he añadido las preguntas frecuentes usando `<detalles>` y `<resumen>`.
{{< /split >}}

Por último, [añadí las nuevas páginas /download y /build-it, así como un nuevo index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/7b85b02878982032487e49058771c9685c39b213), utilizando una mezcla de markdown de HUGO y plantillas de html. Puedes ver algunas capturas de pantalla a continuación:

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-download.png" alt="Sección de descargas de la nueva web de Okular" >}}
La sección de descargas te ayuda a encontrar las opciones de descarga disponibles.
---
{{< figure src="/posts/Imagenes/okular-build-it.jpg" alt="Sección build-it del nuevo sitio web de Okular" >}}
Y la sección Build It muestra cómo construir el programa desde el código fuente
{{< /split >}}


<style>
details {
    border: 1px solid #5850ec;
    border-radius: 10px;
    padding: .5rem .5rem 0;
}

summary {
    margin: -.5rem -.5rem 0;
    padding: .5rem;
}

summary:hover {
    font-weight: bold;
}

details[open] {
    padding: .5rem;
}

details[open] summary {
    border-bottom: 1px solid #aaa;
    margin-bottom: .5rem;
    font-weight: bold;
}
</style>
