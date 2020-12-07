#!/bin/bash    

# ---- First, generate the static HTML pages in a new public directory -----
echo -e "Building Site ..."
rm -r ./public/
hugo -D > /dev/null
echo -e "User-agent: *  \nDisallow: /" > ./public/robots.txt #Add the robots.txt file
echo -e "www.pablomarcos.me" > ./public/CNAME #And also the CNAME
mkdir ./public/🐣 #Future easter egg

# ---- FINALLY. NO FTP, JUST GH-PAGES!!!! -----
echo -e "Replacing old site with the new one ..."
if [ -d "../gh-pages" ]; then
    cd ../gh-pages
    rm -rf `ls | grep -v "README.md\|LICENSE"` 
    #With -f, rm does not complain about missing files
    mv ../pablomarcos.me/public/* ../gh-pages #Move the content to the gh-pages repo
else
    echo -e "[ERROR]: Could not find gh-pages repository"
    exit 1
fi

# ---- Sync HTML to Github ----
echo -e "Uploading to GitHub Pages. Please provide a comment for Git ..."
read commit
git add .
git commit -m "$commit"
git push
echo -e "Site has being deployed"

# ---- Sync Source Code to Codeberg ----
cd ../pablomarcos.me/
echo -e "Uploading source code to Codeberg. Please provide a Git comment ..."
read commit
git add .
git commit -m "$commit"
git push
echo -e "Source code has been published"


echo -e "Gracias por contar con MARIPILI, tu asistente virtual para publicar páginas web"
exit 0
