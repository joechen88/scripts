#!/bin/bash
#
#  resetCount will capture each reset then calulate how long it takes
#    for mac, you will need to install gdate as date from os x is not from GNU date
#       brew install coreutils  -> will give you gdate
#

filename=$1
declare -a timeValueArray   # create an empty array




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
lunIssueCount=$(cat $filename | grep -c -iE "Attempt to issue lun reset")
echo $lunIssueCount >> lunreset-count.txt
echo "" >> lunreset-count.txt
echo -e "Executed out-of-band lun reset:" >> lunreset-count.txt
executedLunCount=$(cat $filename | grep -c -iE "Executed out-of-band lun reset")
echo $executedLunCount >> lunreset-count.txt
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
EPOC1="$(gdate +%s.%3N -d"$dateTime1")"

dateTime2="$(echo ${File2} | awk '{print $1}' | sed s/.$//)"
EPOC2="$(gdate +%s.%3N -d"$dateTime2")"

#
#  evaulate the time difference
#  graph it out
#  bash does not support floating-point arithmetic so need to use an external utility like bc.
#
timeValue=$(expr $EPOC2-$EPOC1 | bc)

timeValueArray[$i]="$timeValue"

##
##  ${#var} - Will calulate the number of character
##
#a[0]="$dateTime1"
printf "$dateTime1 -- $timeValue \n" >> lunreset-count.txt

let i++

done 3< 1.txt 4< 2.txt

printf "\n\n" >> lunreset-count.txt

if [[ $lunIssueCount -eq $executedLunCount ]]; then
     numPerRow=$(($lunIssueCount / 12))
elif [[ $lunIssueCount -lt $executedLunCount ]]; then
     #if lunIssue count is not the same as executed out-of-band count, take the
     #smallest value and divide that by 12 for each hour
     numPerRow=$(($lunIssueCount / 12))
else
     numPerRow=$(($executedLunCount / 12))
fi

printf "== MAP ( Note: X resets per row in each hr; read from left to right; ie 5.001 =>5sec , 001 in milliseconds )==\n" >> lunreset-count.txt
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

#      if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
#      then
            # if num between 0-9, then add a 0 infront
#            echo -n "0${timeValueArray[$k]}" >> lunreset-count.txt
#      else
            echo -n "${timeValueArray[$k]}" >> lunreset-count.txt
#      fi

      let l++
      let trackTime++

    # second+ elements will have --
    # will have 20 row per line
elif [[ $l -lt $numPerRow ]]; then

#      if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
#      then
            # if num between 0-9, then add a 0 infront
#            echo -n "--0${timeValueArray[$k]}" >> lunreset-count.txt
#      else
            echo -n "--${timeValueArray[$k]}" >> lunreset-count.txt
#      fi

      let l++

    else
      # after 20 elements, it will make a newline
      printf "\n" >> lunreset-count.txt
      let l=0    # reset back to 1 to start a new line
      let k=k-1

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
targetIssueCount=$(cat $filename | grep -c -iE "Attempt to issue target reset")
echo $targetIssueCount >> targetreset-count.txt
echo "" >> targetreset-count.txt
echo -e "Executed out-of-band target reset:" >> targetreset-count.txt
executedTargetCount=$(cat $filename | grep -c -iE "Executed out-of-band target reset")
echo $executedTargetCount >> targetreset-count.txt
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
EPOC1="$(gdate +%s.%3N -d"$dateTime1")"

dateTime2="$(echo ${File2} | awk '{print $1}' | sed s/.$//)"
EPOC2="$(gdate +%s.%3N -d"$dateTime2")"

#
#  evaulate the time difference
#  graph it out
#
timeValue=$(expr $EPOC2-$EPOC1 | bc)

timeValueArray[$i]="$timeValue"

##
##  ${#var} - Will calulate the number of character
##
#a[0]="$dateTime1"
printf "$dateTime1 -- $timeValue \n" >> targetreset-count.txt

let i++

done 3< 3.txt 4< 4.txt

printf "\n\n" >> targetreset-count.txt

if [[ $targetIssueCount -eq $executedTargetCount ]]; then
     numPerRow=$(($targetIssueCount / 12))
 elif [[ $targetIssueCount -lt $executedTargetCount ]]; then
      #if lunIssue count is not the same as executed out-of-band count, take the
      #smallest value and divide that by 12 for each hour
      numPerRow=$(($targetIssueCount/ 12))
 else
      numPerRow=$(($executedTargetCount / 12))
 fi

printf "== MAP ( Note: X resets per row in each hr; read from left to right; ie 5.001 =>5sec , 001 in milliseconds )==\n" >> targetreset-count.txt

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

#       if [[ ${timeValueArray[$k]} -lt 10 && ${timeValueArray[$k]} -gt 0 ]];
#       then
#            echo -n "0${timeValueArray[$k]}" >> targetreset-count.txt
#       else
            echo -n "${timeValueArray[$k]}" >> targetreset-count.txt
#       fi

       let l++
       let trackTime++

    # second+ elements will have --
    # will have X row per line
    elif [[ $l -lt numPerRow ]]; then
#       if [[ ${timeValueArray[$k]} -lt 10.0 && ${timeValueArray[$k]} -gt 0 ]];
#       then
#            echo -n "--0${timeValueArray[$k]}" >> targetreset-count.txt
#       else
            echo -n "--${timeValueArray[$k]}" >> targetreset-count.txt
#       fi

       let l++

    else
        printf "\n" >> targetreset-count.txt
        let l=0
        let k=k-1

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
