#!/bin/bash

filename=$1


if [[ -n "$filename" ]]; then

echo ""
echo "Please allow some time to scan the log..."
echo ""


#
# create 2 files: 
#     1) collect loading VProbe script in file1
#     2) collect Script unloaded from vmkernel
#
cat $filename | grep -iE "Loading VProbes script" > 1.txt
cat $filename | grep -iE "Script unloaded from vmkernel" > 2.txt


#
#  Populate a list of shortIO and put it in shortIO_logsummary_from_vmkernel.txt
#
#echo "Collecting a list of shortIO load/unload from vmkernel..."
#paste 1.txt 2.txt | (
#let j=1
#while read -r rowFromFile1 rowFromFile2 ; do
#echo "$j: ${rowFromFile1}, ${rowFromFile2}" >> shortIO_logsummary_from_vmkernel.txt
#let j++
#done
#)


#
# get ShortIO load/unload count
#
echo "Get ShortIO load/unload count..."
echo "" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt
echo -e "Loading VProbe script count:" >> shortIO_logsummary_from_vmkernel.txt
cat $filename | grep -c -iE "Loading VProbes script" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt
echo -e "Script unloaded from vmkernel count:" >> shortIO_logsummary_from_vmkernel.txt
cat $filename | grep -c -iE "Script unloaded from vmkernel" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt



#
# search vmkernel to see if there are any ShortIOs issued that is less than 1 second.
#
echo "Searching the list to see if there are any shortIOs that is less than 1 second..."
paste 1.txt 2.txt | ( 
let i=1
let k=0   # a counter keep track on shortIO that is less than 1 sec


echo "" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt
echo "=ShortIO load/unload that is less than 1 second=" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt

while read -r rowFromFile1 rowFromFile2 ; do
#echo "$i: ${rowFromFile1}, ${rowFromFile2}"

#
# read each line then Convert Date/Time into EPOC for both files
#
dateTime1="$(echo ${rowFromFile1} | awk '{print $1}' | sed s/.$//)"
EPOC1="$(date +%s -d"$dateTime1")"

dateTime2="$(echo ${rowFromFile2} | awk '{print $9}' | sed s/.$//)"
EPOC2="$(date +%s -d"$dateTime2")"


#
#  evaulate the time difference 
#  if shortIO is less than 1 seconds, return that output
#
timeValue="$(expr $EPOC2 - $EPOC1)"
if [[ $timeValue -lt 1 ]]; then
   echo "$i: ${rowFromFile1}, ${rowFromFile2}" >> shortIO_logsummary_from_vmkernel.txt
   echo "" >> shortIO_logsummary_from_vmkernel.txt
   let k++ 
fi

let i++
done
echo "" >> shortIO_logsummary_from_vmkernel.txt
echo "ShortIO less than 1sec Total count: $k" >> shortIO_logsummary_from_vmkernel.txt
echo "" >> shortIO_logsummary_from_vmkernel.txt

rm -f 1.txt
rm -f 2.txt
echo "Scan finished..."
echo ""
echo "      shortIO_logsummary_form_vmkernel.txt has been created"
echo ""
) 
else
  echo ""
  echo ""
  echo "	Usage: checkShortIO.sh <filename>"
  echo ""
  echo "               example: sh checkShortIO.sh vmkernel.consolidated.log"
  echo ""
  echo "           Note:  if there are multiple vmkernel logs, such as vmkernel.0.gz,vmkernel.1.gz,..etc " 
  echo "                  ensure to consolidate the logs in a sorted order. "
  echo ""
fi
