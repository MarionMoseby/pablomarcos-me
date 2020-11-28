#!/bin/bash    

#First, generate the static HTML pages in a new public directory
rm -r ./public/
hugo -D

#Add the robots.txt file to the public directory
echo -e "User-agent: *  \nDisallow: /" > ./public/robots.txt
mkdir ./public/🐣 #Future easter egg

#OVH does not like me to ftp, so I have to zip and unpack myself... unnerving I know
rm www.zip
zip -r www.zip ./public/

#And upload the new www zip directory in lieu of the old one
lftp -e "rm -r ./www/; put www.zip; bye" ftp.cluster029.hosting.ovh.net
#PS: This only works if you have stored your credentials on ~/.netrc like:
#machine ftp.yourhost.com login your_username password your_password

echo -e "Waiting for the user to unpack the zip. Click any key to continue..."
read nothing
lftp -e "rm www.zip" ftp.cluster029.hosting.ovh.net

#Now, remove the www zip...
rm -r ./www

#And sync the git repository
git add .
echo -e "Type a comment for Git..."
read commit
git commit -m "$1"
git push

echo -e "Site has being deployed"
