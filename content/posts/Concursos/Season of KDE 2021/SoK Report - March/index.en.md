---
title: "SoK 2021 March Report"
date: 2021-03-26
menu:
  sidebar:
    name: SoK 2021 March
    identifier: sokmarch
    parent: seasonofkde2021
    weight: 40
---

In the february post, I mentioned how I ordered the material that was on Carl Schwan's MVP for the Index page, explaining Okular's main features. Now that that was set, I had to add support for i18n, as it can be difficult for translators to work with a raw html template. [This was achieved by using the {{i18n}} HUGO template](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/a042f38d0fe1d781860a0056721e66349393b997), which specifies the translatable parts by using `{{ i18n "Section.variable" }}` in each of the strings to translate, and then mapping the values into a yaml file such as:

<details>
<summary>/i18n/en.yaml</summary>
{{< highlight yaml >}}
#Name of the translatable section
Section.variable:
    other: "English translation for variable"
Section.othervariable:
    other: "English translation for othervariable"
Section.yetanothervariable:
    other: "English translation for yetanothervariable"
{{< /highlight >}}
</details>

I also used this to translate the table of supported formats in /applications. The final result can be seen here:

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/new-okular-site.png" alt="New Okular Website" >}}
A cool homepage with i18 support
---
{{< figure src="/posts/Imagenes/okular-formats.png" alt="New Okular Website's formats section" >}}
And the list of file formats Okular can open
{{< /split >}}

Next, [I added the /contact page](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/0e7989a171c36f2d7d0b32332a43a490a27ccf59), which I redesigned and updated to include matrix. [I modified the index](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/1795c0da36113ee0219a69d66bfce1595218f94c) to include a refference to Okular's [upcoming PDF signing support](https://invent.kde.org/graphics/okular/-/merge_requests/296) (¡so neat! I might finally stop using [Autofirma](https://github.com/ctt-gob-es/clienteafirma)), and [cleaned up unnecesary files that were left from the transition](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/9cab0470f744252ecff9ef9721f71de084167dfb)

{{< split 6 6 >}}
{{< figure src="/posts/Imagenes/okular-contact.png" alt="New Okular Website's contact section" >}}
If you want to contact the developers, there is info on the contact page
---
{{< figure src="/posts/Imagenes/okular-esign.png" alt="Okular's new eSign feature" >}}
You will be able to sign your own pdfs as well as view and verify other signatures.
{{< /split >}}

I also wanted to add client-side [Site Search](https://invent.kde.org/carlschwan/okular-kde-org/-/commit/05ce2a78d2b77d4e4e4e19e64a7e3601856095bf), as the one that existed was really just a button that redirected the search query to a google search. I was inspired by (some might even say *copied*) [eddieweb's popular gist](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae), which not only does not require to install additional packages, but also highlights the matches, using JSON and Fuse.js. It was easy to add, but I am still proud! 🤩 It's nice to help the web transition away from google 😊 You can see how that looks like here:

{{< figure src="/posts/Imagenes/okular-search.png" alt="New Okular Website's search section" >}}
You can search using the navbar, and results are highlighted

So, it was a month with lots of work, but the site is finally ready! 🥳

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
