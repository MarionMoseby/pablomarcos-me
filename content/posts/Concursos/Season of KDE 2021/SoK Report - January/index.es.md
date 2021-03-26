---
title: "SoK 2021 January Report"
date: 2021-01-30
menu:
  sidebar:
    name: SoK 2021 January
    identifier: sokjanuary
    parent: seasonofkde2021
    weight: 40
---

I havent done much this January, as it was the "partiels" (final exams) month at INSA and I was really caught up studying. I did, however, find time to write the project application, which I have attached below for reference, and I spent what little time I was able to devote to SoK learning how to properly use HUGO and which templates I had to edit to get a given, desired result. 

---

### Project Application: New Website for Okular
Okular is a multifaceted program that I use almost every day for my PDF reading and annotating needs, although it can do much more. Sadly, its website is a bit outdated and not mobile friendly. I thus propose to rewrite the Okular website using the HUGO framework, in a similar way as was done with the kde.org main website, keeping consistency with other KDE applications such as [Konsole](https://konsole.kde.org/). Fortunately, some work was already initiated by Carl Schwan, so I would only need to continue and finish his work.

#### Project Goals

The updated Okular webpage should be beautiful, present the information in a clear way, and be easy to use. Some desired features are:
* Mobile-friendliness
* In-page search that is independent from google, i.e. using Lunar Search
* Updated screenshot section (the screenshots look outdated to me, but maybe its just that they were taken on a different platform)
* A more blog-like interface for the development news, maybe keeping the changelogs inside the Okular webpage

Also, features already present in the current webpage, such as multilanguage support, should be preserved.

#### Implementation

As previously stated, work was already initiated by [Carl Schwan](https://invent.kde.org/carlschwan/okular-kde-org/-/tree/hugo). The project uses the HUGO framework and some python scripts for i18n. Feedback from the Okular devs would be gathered throughout the process to ensure the new website accommodates their needs. Regarding the documentation, I believe that a basic description of how to make the site work would suffice, since HUGO is ultimately producing simple HTML/CSS/JS.

#### Timeline

* Jan 13th: Start of work according to the KDE website
* Jan 15th - Jan 24thth: Familiarization with the platform and learning its inner workings. I am leaving lots of time here in case this ends up being more difficult than I believe, but possibly it could be done in a shorter time
* Jan 24th - Jan 31st: Last week of the semester at INSA, I will probably have presentations and work to do
* Feb 1st - Feb 12th: Coding time
* Feb 13th - Feb 21st: Vacations in France, if possible due to coronavirus I might go on vacation, so it would be difficult to code now
* Feb 22nd - March 28th: Coding time
* March 29th - April 4th: Work should be done by now, time to write a report on how everything went
* April 5th - April 9th: Last week before vacations in France, so it is possible that I will have work to do at uni
* April 9th: End of work according to the KDE website

#### About Me

I am a computational biotechnology student at UPMadrid currently doing an ERASMUS at INSA Lyon. I love open source, and use Kubuntu -hence, KDE- as my operating system of choice, and I would like to give back to the community by contributing something back. Although I mostly work with python (especially the BioPython package), I have previously used HUGO to make my personal website, [pablomarcos.me](https://www.pablomarcos.me), where more personal information and my full CV can be found. I have also worked on another project with a user facing UI: [Who's that Function](https://flyingflamingo.itch.io/whos-that-function), an interactive game that teaches first grade students the properties of functions, as part of a teacher-student collaboration scholarship; although it is not super related.

I am completely comfortable working remotely, as I already did so for the aforementioned game due to COVID-19 restrictions, and, although English is not my native language, I can write and speak it fluently. I can also speak Spanish, my mother tongue, and French.

---

P.S.: Also, back in Spain, [there was a lot of snow!](https://www.eldiario.es/sociedad/filomena-tine-blanco-espana-imagenes-nevada-historica_3_6738421.html) Which is super nice :p although some people (my mother included) were trapped in their jobs. In case you are curious, here is a photo of Alcalá Street in Madrid, covered with snow due to the storm Borrasca Filomena. <a href="https://commons.wikimedia.org/wiki/File:Borrasca_Filomena_Calle_de_Alcal%C3%A1.jpg">Javier Pérez Montes</a>, <a href="https://creativecommons.org/licenses/by-sa/4.0">CC BY-SA 4.0</a>, via Wikimedia Commons

{{< figure src="/posts/Imagenes/filomena-madrid.jpg" alt="Alcalá Street in Madrid, covered with snow due to the storm Borrasca Filomena" >}}
