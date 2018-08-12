#!/bin/bash

filename=$1
declare -A timeValueArray   # create an empty array




lunreset() {



echo ""
echo "Please allow some time to scan the log..."
echo ""


#
# create files:
#     1) collect loading VProbe script in file1
#     2) collect Script unloaded from vmkernel
#
cat $filename | grep -iE "Attempt to issue lun reset" > 1.txt
cat $filename | grep -iE "Executed out-of-band lun reset" > 2.txt

#
#  Populate a list of lun and target resets and put it in lun/target-count.txt
#
echo "Collecting a list of lun and target resets from vmkernel..."
#paste 1.txt 2.txt | (
#let j=1
#while read -r rowFromFile1 rowFromFile2 ; do
#echo "$j: ${rowFromFile1}, ${rowFromFile2}" >> lunreset-count.txt
#let j++
#done



#
# get lun/target reset count
#
echo "Get Lun/Target reset count..."
echo "" >> lunreset-count.txt
echo "" >> lunreset-count.txt
echo -e "Attempt to issue lun reset:" >> lunreset-count.txt
cat $filename | grep -c -iE "Attempt to issue lun reset" >> lunreset-count.txt
echo "" >> lunreset-count.txt
echo -e "Executed out-of-band lun reset:" >> lunreset-count.txt
cat $filename | grep -c -iE "Executed out-of-band lun reset" >> lunreset-count.txt
echo "" >> lunreset-count.txt


#
# search vmkernel to see if there are any lun/target resets issued that is less than 1 seconds.
#
printf "Searching the list to see if there are any lun reset that is more than 1 second...\n\n"


echo "" >> lunreset-count.txt
echo "" >> lunreset-count.txt
echo "=Lun reset in second(s)=" >> lunreset-count.txt
echo "" >> lunreset-count.txt
i=0


#
#  read 2 files at the same time line by line
#    1. will first convert into seconds
#    2. timeValue=EPOC2 - EPOC1
#    3. every timeValue will get inserted into timeValueArray
#
while IFS= read -r -u3 File1 && IFS= read -r -u4 File2; do
#
# read each line then Convert Date/Time into EPOCH for both files
#
dateTime1="$(echo ${File1} | awk '{print $1}' | sed s/.$//)"
EPOC1="$(date +%s -d"$dateTime1")"

dateTime2="$(echo ${File2} | awk '{print $1}' | sed s/.$//)"
EPOC2="$(date +%s -d"$dateTime2")"

#
#  evaulate the time difference
#  graph it out
#
timeValue="$(expr $EPOC2 - $EPOC1)"

timeValueArray[$i]="$timeValue"  

##
##  ${#var} - Will calulate the number of character
##
#a[0]="$dateTime1"   
printf "$dateTime1 -- $timeValue \n" >> lunreset-count.txt

let i++

done 3< 1.txt 4< 2.txt

printf "\n\n" >> lunreset-count.txt

printf "== MAP ( Note: 18 resets per row of each hr; read from left to right )==\n" >> lunreset-count.txt
printf "\n" >> lunreset-count.txt

# 
# read timeValueArray to get the graph
#
#
# If value is between 0-9, add a 0 infront to make it , ie 08 
#    zero in front is not needed if value that is bigger than 9
#    
#    generally, 12:15 - 12:30 will give 240 lun reset count and same for target
#     
l=0
trackTime=1
for ((k=0; k<${#timeValueArray[@]};k++))
do
    # first element, will print without -- 
    if [[ $l -eq 0 ]]; then


      if [[ $trackTime -lt 10 && $trackTime -gt 0 ]];
      then
          # trackTime is to represent each hour.
          # if num between 0-9, then add a 0 infront
          echo -n "0$trackTime ->  " >> lunreset-count.txt
      else
          # trackTime is to represent each hour.
          echo -n "$trackTime ->  " >> lunreset-count.txt
      fi

      if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
      then   
            # if num between 0-9, then add a 0 infront
            echo -n "0${timeValueArray[$k]}" >> lunreset-count.txt
      else  
            echo -n "${timeValueArray[$k]}" >> lunreset-count.txt
      fi
       
      let l++
      let trackTime++

    # second+ elements will have --
    # will have 18 row per line
    elif [[ $l -lt 18 ]]; then

      if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
      then  
            # if num between 0-9, then add a 0 infront        
            echo -n "--0${timeValueArray[$k]}" >> lunreset-count.txt
      else 
            echo -n "--${timeValueArray[$k]}" >> lunreset-count.txt
      fi

      let l++

    else
      # after 18 elements, it will make a newline
      printf "\n" >> lunreset-count.txt
      let l=0    # reset back to 1 to start a new line
        
       
    fi

done

printf "\n\n" >> lunreset-count.txt

rm -f 1.txt
rm -f 2.txt
printf "\n\nScan finished..."
echo ""
echo "      lunreset-count.txt has been created"
echo ""

}


targetreset() {

echo ""
echo "Please allow some time to scan the log..."
echo ""


#
# create files:
#     1) collect loading VProbe script in file1
#     2) collect Script unloaded from vmkernel
#
cat $filename | grep -iE "Attempt to issue target reset" > 3.txt
cat $filename | grep -iE "Executed out-of-band target reset" > 4.txt


#
#  Populate a list of lun and target resets and put it in lun/target-count.txt
#
#paste 3.txt 4.txt | (
#let k=1
#while read -r rowFromFile3 rowFromFile4 ; do
#echo "$k: ${rowFromFile3}, ${rowFromFile4}" >> targetreset-count.txt
#let k++
#done
#)



#
# get target reset count
#


echo "" >> targetreset-count.txt
echo "" >> targetreset-count.txt
echo -e "Attempt to issue target reset:" >> targetreset-count.txt
cat $filename | grep -c -iE "Attempt to issue target reset" >> targetreset-count.txt
echo "" >> targetreset-count.txt
echo -e "Executed out-of-band target reset:" >> targetreset-count.txt
cat $filename | grep -c -iE "Executed out-of-band target reset" >> targetreset-count.txt
echo "" >> targetreset-count.txt



#
# search vmkernel to see if there are any lun/target resets issued that is less than 1 seconds.
#
echo "Searching the list to see if there are any lun reset that is more than 1 second..."


echo "" >> targetreset-count.txt
echo "" >> targetreset-count.txt
echo "=Lun reset in second(s)=" >> targetreset-count.txt
echo "" >> targetreset-count.txt
i=0


#
#  read 2 files at the same time line by line
#    1. will first convert into seconds
#    2. timeValue=EPOC2 - EPOC1
#    3. every timeValue will get inserted into timeValueArray
#
while IFS= read -r -u3 File1 && IFS= read -r -u4 File2; do
#
# read each line then Convert Date/Time into EPOCH for both files
#
dateTime1="$(echo ${File1} | awk '{print $1}' | sed s/.$//)"
EPOC1="$(date +%s -d"$dateTime1")"

dateTime2="$(echo ${File2} | awk '{print $1}' | sed s/.$//)"
EPOC2="$(date +%s -d"$dateTime2")"

#
#  evaulate the time difference
#  graph it out
#
timeValue="$(expr $EPOC2 - $EPOC1)"

timeValueArray[$i]="$timeValue"  

##
##  ${#var} - Will calulate the number of character
##
#a[0]="$dateTime1"   
printf "$dateTime1 -- $timeValue \n" >> targetreset-count.txt

let i++

done 3< 3.txt 4< 4.txt

printf "\n\n" >> targetreset-count.txt

printf "== MAP ( Note: 18 resets per row of each hr; read from left to right )==\n" >> targetreset-count.txt
printf "\n" >> targetreset-count.txt

# 
# read timeValueArray to get the graph
#
#
# If value is between 0-9, add a 0 infront to make it , ie 08 
#    zero in front is not needed if value that is bigger than 9
#    
#    generally, 12:15 - 12:30 will give 240 lun reset count and same for target
#     
l=0
trackTime=1

for ((k=0; k<${#timeValueArray[@]};k++))
do
    # first element, will print without -- 
    if [[ $l -eq 0 ]]; then

       if [[ $trackTime -lt 10 && $trackTime -gt 0 ]];
       then
          # trackTime is to represent each hour.
          # if num between 0-9, then add a 0 infront
          echo -n "0$trackTime ->  " >> targetreset-count.txt
       else
          # trackTime is to represent each hour.
          echo -n "$trackTime ->  " >> targetreset-count.txt
       fi

       if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
       then
            echo -n "0${timeValueArray[$k]}" >> targetreset-count.txt
       else 
            echo -n "${timeValueArray[$k]}" >> targetreset-count.txt
       fi
       
       let l++
       let trackTime++

    # second+ elements will have --
    # will have 18 row per line
    elif [[ $l -lt 18 ]]; then
       if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
       then
            echo -n "--0${timeValueArray[$k]}" >> targetreset-count.txt
       else 
            echo -n "--${timeValueArray[$k]}" >> targetreset-count.txt
       fi

       let l++

    else
        printf "\n" >> targetreset-count.txt
        let l=0
       
    fi

done

printf "\n\n" >> targetreset-count.txt

rm -f 3.txt
rm -f 4.txt
printf "\n\nScan finished..."
echo ""
echo "      targetreset-count.txt has been created"
echo ""

}




if [[ -n "$filename" ]]; then
  lunreset "$filename"
  targetreset "$filename"

else
  echo ""
  echo ""
  echo "	Usage: resetCount.sh <filename>"
  echo ""
  echo "               example: sh resetCount.sh vmkernel.consolidated.log"
  echo ""
  echo "           Note:  if there are multiple vmkernel logs, such as vmkernel.0.gz,vmkernel.1.gz,..etc "
  echo "                  ensure to consolidate the logs in a sorted order. "
  echo ""
fi
