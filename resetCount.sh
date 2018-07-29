#!/bin/bash

filename=$1


if [[ -n "$filename" ]]; then

echo ""
echo "Please allow some time to scan the log..."
echo ""


#
# create 4 files:
#     1) collect loading VProbe script in file1
#     2) collect Script unloaded from vmkernel
#
cat $filename | grep -iE "Attempt to issue lun reset" > 1.txt
cat $filename | grep -iE "Executed out-of-band lun reset" > 2.txt



#
#  Populate a list of lun and target resets and put it in reset-count-output.txt
#
echo "Collecting a list of lun and target resets from vmkernel..."
paste 1.txt 2.txt | (
let j=1
while read -r rowFromFile1 rowFromFile2 ; do
echo "$j: ${rowFromFile1}, ${rowFromFile2}" >> reset-count-output.txt
let j++
done
)


#
# get lun/target reset count
#
echo "Get Lun/Target reset count..."
echo "" >> reset-count-output.txt
echo "" >> reset-count-output.txt
echo -e "Attempt to issue lun reset:" >> reset-count-output.txt
cat $filename | grep -c -iE "Attempt to issue lun reset" >> reset-count-output.txt
echo "" >> reset-count-output.txt
echo -e "Executed out-of-band lun reset:" >> reset-count-output.txt
cat $filename | grep -c -iE "Executed out-of-band lun reset" >> reset-count-output.txt
echo "" >> reset-count-output.txt


#
# search vmkernel to see if there are any lun/target resets issued that is less than 1 seconds.
#
echo "Searching the list to see if there are any lun reset that is more than 1 seconds..."
paste 1.txt 2.txt | (
let i=1
let k=0   # a counter keep track on lunreset that is less than 1 sec


echo "" >> reset-count-output.txt
echo "" >> reset-count-output.txt
echo "=Lun reset took  more than 1 second=" >> reset-count-output.txt
echo "" >> reset-count-output.txt

while read -r rowFromFile1 rowFromFile2 ; do
#echo "$i: ${rowFromFile1}, ${rowFromFile2}"

#
# read each line then Convert Date/Time into EPOCH for both files
#
dateTime1="$(echo ${rowFromFile1} | awk '{print $1}' | sed s/.$//)"
EPOC1="$(date +%s -d"$dateTime1")"

dateTime2="$(echo ${rowFromFile2} | awk '{print $21}' | sed s/.$//)"
EPOC2="$(date +%s -d"$dateTime2")"

#
#  evaulate the time difference
#  if reset took more than 1 second, return that output
#
timeValue="$(expr $EPOC2 - $EPOC1)"
if [[ $timeValue -gt 1 ]]; then
   echo "$i: ${rowFromFile1}, ${rowFromFile2}" >> reset-count-output.txt
   echo "" >> reset-count-output.txt
   let k++
fi

let i++
done

rm -f 1.txt
rm -f 2.txt
echo "Scan finished..."
echo ""
echo "      reset-count-output.txt has been created"
echo ""
)
else
  echo ""
  echo ""
  echo "	Usage: reset-count.sh <filename>"
  echo ""
  echo "               example: sh reset-count.sh vmkernel.consolidated.log"
  echo ""
  echo "           Note:  if there are multiple vmkernel logs, such as vmkernel.0.gz,vmkernel.1.gz,..etc "
  echo "                  ensure to consolidate the logs in a sorted order. "
  echo ""
fi
