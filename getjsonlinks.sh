#!/bin/bash
# get json links 
# joechen
#


echo ""
printf "Enter AD username: "
read -r username
echo ""
printf "Enter AD password: "
read -s password
echo ""
echo ""


getJsonLinks()
{
count=0
echo "JSON links for $link"
echo ""
while read line
do
        addJsonstats="${line}jsonstats"
        echo "$addJsonstats"
        let count++
done < <(curl -s -u $username:$password -d parmetername=value $link | grep -iE "10.28.208.10|prme-vsanhol-observer-10" |grep -iE "0r100w|100r0w|100w|100r|95hit|99hit|100hit|0r100w_4k|0r100w_64k|70r30w_50gb|70r30w_mdCap|100r0w_long_af" | grep -Eo "(http|https)://[\da-z.\%/?A-Z0-9\D=_-]*")
echo ""
echo "number of results: $count"
echo "-------------------------------------------------------------------------------------"

}

j=1
if [ $# -eq 0 ]; then
   echo "getjsonlinks.sh link1 link2 ... etc"
else 
  for link in "$@"
  do 
     getJsonLinks
  done 
fi
