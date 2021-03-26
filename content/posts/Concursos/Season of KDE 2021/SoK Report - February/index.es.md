---
title: "SoK 2021 February Report"
date: 2021-02-25
menu:
  sidebar:
    name: SoK 2021 February
    identifier: sokfebruary
    parent: seasonofkde2021
    weight: 40
---

I started the month by [porting the Anouncements section from Raw HTML to Markdown](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/e3e8529ff33be74ea4d9ed59406fdef4e5418127), for which I wrote a small python script that parses all the content in [this news.rdf file](https://invent.kde.org/carlschwan/okular-kde-org/-/blob/b22f5e0e420cfddd406139eb814d02b82eeec95b/news.rdf), inherited from the old site, and creates several markdown post files that will be processed by the list and single templates of the aether-sass theme into the new section.

<details>
<summary>To see the full python script, click here</summary>
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


Then, I [configured the project](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9229e022294accb9b279d87f3d91fb1693251a61) to use the aforementioned [aether-sass](https://invent.kde.org/websites/aether-sass) (KDE's HUGO standard theme) as a Go module, as Git submodules are less desirable. Next, I added [a FAQ section](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/62829821d073506f15e46def4d0f1418ec215834), which was easy since most questions had been removed from the FAQ in a recent cleanup. For this, I used the `</details>` and `</summary>` HTML labels, which I didnt know about and which seem super cool to me. This was, also, the first time I experienced how a HUGO template works! Yay!

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-news.png" alt="New Okular Website's mobile view for the News Section" >}}
I improved the News section using HUGO's list.html and a python script
---
{{< figure src="/posts/Imagenes/okular-faq.png" alt="New Okular Website's mobile view for the FAQ section" >}}
And added the FAQ using `<details>` and `<summary>`
{{< /split >}}

Finally, [I added the new  /download and /build-it pages, as well as a new index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/7b85b02878982032487e49058771c9685c39b213), using a mixture of HUGO markdown and raw html templates. You can see some screenshots below:

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-download.png" alt="New Okular Website's download section" >}}
The download section helps you find the availaible download options.
---
{{< figure src="/posts/Imagenes/okular-build-it.jpg" alt="New Okular Website's build-it section" >}}
And the Build It section shows how to build from source
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
