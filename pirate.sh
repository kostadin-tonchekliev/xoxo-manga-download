#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
NC='\033[0m'

function spacer { echo '--------------------------' ; }

echo "Manga downloader designed for xoxocomics.com. Make sure to use the all page view!"
echo -e "${Y}Input link:${NC}"
while [[ -z $cur_link ]]
do
	read cur_link
done

if [[ -z $(echo $cur_link | grep '/all') ]]
then
	link="${cur_link}/all"
	echo -e "${R}[-]${NC}Incorrect link"
	echo "The link is for single page viewing, automatically converted to all view"
else
	echo -e "${G}[+]${NC}The link is correct"
	link=$cur_link
fi


filename=$(echo $link | sed 's/\// /g' | awk '{print $4}')
cur_names=$(find . -maxdepth 1 -name "$filename\_.*" | wc -l)
spacer

mkdir tmp
echo "Starting Download..."
results=$(curl -s $link | grep 'data-original=' | cut -d '"' -f5 | cut -d "'" -f2)
num=1
for result in $results
do
	curl -s $result -o tmp/$num.jpeg
	echo -e "${G}[+]${NC} Download of $result succesfull" 
	num=$((num + 1))
done
echo -e "${G}Full download succesfull${NC}"
spacer

echo "Starting cbz file creation"
find tmp -maxdepth 1 -name '*jpeg' -exec zip -q -m ${filename}.cbz {} \;
rm -rf tmp/
echo "Finished, enjoy"
