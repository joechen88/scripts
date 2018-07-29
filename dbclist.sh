#!/bin/bash

getList() {

dbclist=(/dbc/*/)

for dir in "${dbclist[@]}"; do 
  #printf "%s \n" $dir
  

  # Get list in Palo Alto ...  
  if [[ $dir == "/dbc/pa-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt) 
  fi
 

  # Get list in Santa Clara
  if [[ $dir == "/dbc/sc-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi


  # Get list in vmc
  if [[ $dir == "/dbc/vmc-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi


  # Get list in w3
  if [[ $dir == "/dbc/w3-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi

  
  # Get list in pek2
  if [[ $dir == "/dbc/pek2-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi


  # Get list in sof4
  if [[ $dir == "/dbc/sof4-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi


  # Get list in blr
  if [[ $dir == "/dbc/blr-dbc"* ]]; then
     fileName=$(echo "${dir}" | cut -f3 -d'/')
     dbcdir=$(find ${dir} -maxdepth 1 -type d -ls | awk '{print $11}' > $fileName.txt)
  fi

done | tac

}

getDate() {

lastUpdated=$(/bin/date)
echo -e "Last updated:   $lastUpdated \n" > date.txt

}

combine() {
cat date.txt blr-dbc* pa-dbc* pek2-dbc* sc-dbc* sof4-* vmc-dbc* w3-dbc* > dbclist.txt

}



lastMod() {

username=$1
echo $username
tmp_findString=$(grep $username dbclist.txt | tr -d '\r')
eval tmp_findString=($tmp_findString)
echo ${#tmp_findString[@]}

for i in ${tmp_findString[@]}
do
  findString=$i

  #
  # second part, get stat, combine findString w/ getStat
  #

  currentDir=$(pwd)
  echo $currentDir
  
  # change directory into the users's direcotry and Run stat against the user's directory
  cd $i
  getStat=$(stat * | grep Modify | sort -k2 | tail -1)

  # To preserve all contiguous whitespaces you have to set the IFS, go gap variable
  IFS='%'
  gap="                   "
  IFS=''

  combine="$i $gap $getStat"

  # go back to the original location
  cd $currentDir
  sed -i "s|$findString|$combine|g" dbclist.txt 
  echo ""

done
}



echo "Scanning DBC dir ... "
echo ""

#getList
getDate
combine
lastMod joechen
lastMod cuongn
lastMod akothari
lastMod mtrinh
lastMod dabucejo
lastMod dross
lastMod cgowda
lastMod ljeffrey
lastMod jbabaria
lastMod aankur
lastMod arunkumarms
