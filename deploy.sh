#!/bin/bash

if [ "$1" = --source ] || [ "$1" = -s ]; then
    echo -e "You have decided to push the updated code to your Codeberg Repository." #You will be asked for a commit message later on
else
    echo -e "You have decided to only update the Codeberg Pages live webpage." #No content will be commited to the "main" branch
fi

# ---- First, generate the static HTML pages in a new public directory -----
echo -e "Building Site ..."
if [ -d ./public/ ]; then rm -r ./public/; fi
hugo --minify > /dev/null #sin -D para no publicar drafts
rm -r ./resources/ #I cannot get to gitignore this pesky folder
echo -e "User-agent: *  \nDisallow: /" > ./public/robots.txt #Add the robots.txt file
cp ./LICENSE ./public/LICENSE
echo -e "This branch allows Codeberg Pages to generate a Hugo Static website for my personal blog, [pablomarcos.me](https://www.pablomarcos.me/).
Please check the \`\`\`main\`\`\` branch to check and edit the HUGO config files." > ./public/README.md #Finally, add README
mkdir ./public/🐣 #Future easter egg

# ---- FINALLY. NO FTP, JUST Codeberg-PAGES!!!! -----
echo -e "Replacing old site with the new one ..."
if [ ! -d "/tmp/update-website" ]; then
    mv ./public/ /tmp/update-website #Move the content to the transitory folder
else
    echo -e "[ERROR]: /tmp/update-website folder already exists. Please, remove it or change code so as not to override."
    exit 1
fi

# ---- Sync HTML to Codeberg Pages ----
echo -e "Uploading to Codeberg Pages. Please provide a comment for Git ..."
read commit
git add . > /dev/null
git stash save > /dev/null #Save any existing changes
git checkout pages > /dev/null #Change branch to pages
echo -e "Reverting to last commit before pushing to reduce size increase..."
git reset HEAD~1
rm -r `ls | grep -v ".git"`
mv /tmp/update-website/* ./ #Copy website content
echo -e "www.pablomarcos.me \n
pablomarcos-me.flyingflamingo.codeberg.page \n
pages.pablomarcos-me.flyingflamingo.codeberg.page \n
        " > .domains #Add the .domains file
git add .
git commit -m "$commit" > /dev/null
git push --force
echo -e "Site has been deployed"
if [ -d /tmp/update-website/ ]; then rm -r /tmp/update-website/; fi
git checkout main > /dev/null #Go back to main branch
git stash apply > /dev/null #Get changes back
git submodule update --remote --rebase > /dev/null #Re-download submodules, presumably lost after checkout


# ---- Sync Source Code to Codeberg ----
if [ "$1" = --source ] || [ "$1" = -s ]; then
cd ../pablomarcos.me/
echo -e "Printing git status for you to decide which commit message to make..."
git add .
git status
echo -e "Uploading source code to Codeberg's main branch. Please provide a Git comment ..."
read commit
git commit -m "$commit"
git push
echo -e "Source code has been published"
fi

echo -e "Gracias por contar con MARIPILI, tu asistente virtual para publicar páginas web"
exit 0
