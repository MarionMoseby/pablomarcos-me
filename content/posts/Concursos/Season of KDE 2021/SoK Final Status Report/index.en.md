---
title: "SoK Final Status Report"
date: 2021-04-09
menu:
  sidebar:
    name: Status Report
    identifier: statusreport
    parent: seasonofkde2021
    weight: 40
---

For the Season of KDE 2021, I decided to work on Okular's website. Okular is a multifaceted program that I use almost every day for my PDF reading and annotating needs, although it can do much more. Sadly, its website was a bit outdated and not mobile friendly. I thus proposed to rewrite the Okular website using the HUGO framework, in a similar way as was done with the kde.org main website, and keeping consistency with other KDE applications such as [Konsole](https://konsole.kde.org/). Fortunately, some work was already initiated by Carl Schwan, so I only needed to continue and finish his work.

### Mentors 

* [Carl Schwan](https://invent.kde.org/carlschwan/)

### Links

Repositories
* [Official  Repo where all work will be merged](https://invent.kde.org/websites/okular-kde-org/)
* [Working Repo](https://invent.kde.org/carlschwan/okular-kde-org/-/tree/work)

### Work Done

#### January 2021
I didnt do much in January, as it was the "partiels" (final exams) month at INSA and I was really caught up studying. But, back in Spain, [there was a lot of snow!](https://www.eldiario.es/sociedad/filomena-tine-blanco-espana-imagenes-nevada-historica_3_6738421.html) Which is super nice :p

#### February 2021

I started by [porting the Anouncements section from Raw HTML to Markdown](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/e3e8529ff33be74ea4d9ed59406fdef4e5418127), for which I wrote a small script. Then, I [configured the project](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9229e022294accb9b279d87f3d91fb1693251a61) to use [aether-sass](https://invent.kde.org/websites/aether-sass) (KDE's HUGO standard theme) as a Go module, as Git submodules were less desirable. Next, I added [a FAQ section](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/62829821d073506f15e46def4d0f1418ec215834), which was easy since most questions had been removed from the FAQ in a recent cleanup. For this, I used the `</details>` and `</summary>` HTML labels, which I didnt know about and which seem super cool to me. Finally, [I added the new  /download and /build-it pages, as well as a new index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/7b85b02878982032487e49058771c9685c39b213), using a mixture of HUGO markdown and raw html templates.

#### March 2021

Having added the index page as a raw html template, now I needed to add i18n support; [this was achieved by using the {{i18n}} HUGO template](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/a042f38d0fe1d781860a0056721e66349393b997), which I also used in the /applications table of supported formats. Next, [I added the /contact page](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/0e7989a171c36f2d7d0b32332a43a490a27ccf59), which I redesigned and updated to include matrix. [I modified the index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/1795c0da36113ee0219a69d66bfce1595218f94c) to include a refference to Okular's [upcoming PDF signing support](https://invent.kde.org/graphics/okular/-/merge_requests/296) (¡so neat! I might finally stop using [Autofirma](https://github.com/ctt-gob-es/clienteafirma)), [cleaned up unnecesary files that were left from the transition](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9cab0470f744252ecff9ef9721f71de084167dfb), [and added a Site Search](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/05ce2a78d2b77d4e4e4e19e64a7e3601856095bf) functionality [that works](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/01d76a0403681263c991b55667f038db80323f3c) client-side and does not depend on google, insipired by (some might even say ''copied'' ''from'' / en los mentideros dirán que ''copiado de'') [eddieweb's popular gist](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae).

#### April 2021
All work on the project was finished. All that is left is some minor modifications and writing this project report.

### Balance of the Project
I believe that the [goals set at the start of the project](https://season.kde.org/project/46) (click [here](https://www.pablomarcos.me/posts/concursos/sok-report-january) if you dont have a KDE account) have been mostly fulfilled: the project does in fact present the information in a clear and beautiful, mobile-friendly way, thanks to the aether-sass theme. It has a google-independent in-page search, although it does not use lunar.js as was suggested, and the development news are now in its own section, although the changelogs were left outside of the individual posts for practical reasons. The screenshots and other have been updated, but most of them have been removed as we have decided for a simpler homepage which highlights the most important features of the program.

In all, most features in the old webpage have been kept, while adding a more modern redesign which increases usability and makes the project more attractive and coherent with the KDE aesthetic. 

#### What I've learnt

* The HTML labels `</details>` and `</summary>` exist! This has been super useful, as I have already used that knowledge in my personal webpage :p
* How to use HUGO in general, and HUGO i18n in particular
* That Okular is adding PDF Signatures support!
* How to wirte HTML, CSS and JavaScript, important knowledge that I have already applied in my next project, the website for the [Mathematics Journal "Pensamiento Matemático"](https://revista.giepm.com/)
* KDE is as cool as I thought! 😏

### Blog Posts on KDE Planet

The links for this blog posts are on my personal site, not on KDE Planet, but you can check they aggregate to Planet by clicking [here](https://invent.kde.org/websites/planet-kde-org/-/commit/fcd89ac67fc2478f9ad456b1384ccae5f1060d51)

* [Post for January 2021](https://www.pablomarcos.me/posts/concursos/sok-report-january/)
* [Post for February 2021](https://www.pablomarcos.me/posts/concursos/sok-report-february/)
* [Post for March 2021](https://www.pablomarcos.me/posts/concursos/sok-report-march/)
* [Post for April 2021](https://www.pablomarcos.me/posts/concursos/sok-report-april/)

### Screenshots

Here you can find some examples of the work I have done. 

{{< split 3 3 3 3 >}}
{{< figure src="/posts/Imagenes/old-okular-mobile-site.png" alt="Old Okular Website's mobile view" >}}
As you can see, the old website had no mobile support
---
{{< figure src="/posts/Imagenes/new-okular-mobile-site.png" alt="New Okular Website's mobile view" >}}
However, the second version works beautifully on mobile
---
{{< figure src="/posts/Imagenes/okular-news.png" alt="New Okular Website's mobile view for the News Section" >}}
I improved the News section using HUGO's list.html and a python script
---
{{< figure src="/posts/Imagenes/okular-faq.png" alt="New Okular Website's mobile view for the FAQ section" >}}
And added the FAQ using `<details>` and `<summary>`
{{< /split >}}

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-download.png" alt="New Okular Website's download section" >}}
The download section helps you find the availaible download options.
---
{{< figure src="/posts/Imagenes/okular-build-it.jpg" alt="New Okular Website's build-it section" >}}
And the Build It section shows how to build from source
{{< /split >}}

{{< split 4 4 4 >}}
{{< figure src="/posts/Imagenes/okular-contact.png" alt="New Okular Website's contact section" >}}
If you want to contact the developers, there is info on the contact page
---
{{< figure src="/posts/Imagenes/okular-formats.png" alt="New Okular Website's formats section" >}}
The Supported Formats page lists the extensions Okular can open
---
{{< figure src="/posts/Imagenes/okular-search.png" alt="New Okular Website's search section" >}}
You can search using the navbar, and results are highlighted
{{< /split >}}

And, finally, the side by side comparison: Here is the old website [(internet archive link)](https://web.archive.org/web/20210312020118/https://okular.kde.org/):
{{< figure src="/posts/Imagenes/old-okular-site.png" alt="Old Okular Website" >}}

And here is the new one:

{{< figure src="/posts/Imagenes/new-okular-site.png" alt="New Okular Website" >}}


### Contact
If you want to make suggestions for this project, please do not hesitate to contact me.

KDE Invent :- [Pablo Marcos](https://invent.kde.org/flyingflamingo)

Matrix :- [@pablitouh:matrix.org](https://matrix.to/#/@pablitouh:matrix.org)
