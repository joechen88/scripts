#!/bin/bash
#
#  resetCount will capture each reset then calulate how long it takes
#
#  version 1.0
#

typeOfReset=$1
filename=$2
declare -a timeValueArray   # create an empty array for timeValue

lunreset() {

echo ""
echo "Please allow some time to scan the log..."
echo ""

#
# create files:
#     1) collect Attempt to issue lun reset
#     2) collect Executed out-of-band lun
#
cat $filename | grep -iE "Attempt to issue lun reset" > 1.txt

# in case if there's a retry during lun reset; remove duplicates
cat $filename | grep -iE "Executed out-of-band lun reset" | gtac | uniq -s 50 | gtac > 2.txt

# used for reoccurence
cat $filename | grep -iE "Executed out-of-band lun reset" > 2-tmp.txt


#
#  Populate a list of lun and target resets and put it in lun/target-count.txt
#
# get lun/target reset count
#
echo ""
echo ""
echo -e "Attempt to issue lun reset:"
lunIssueCount=$(cat $filename | grep -c -iE "Attempt to issue lun reset")
echo $lunIssueCount
echo ""
echo -e "Executed out-of-band lun reset:"
executedLunCount=$(cat $filename | grep -c -iE "Executed out-of-band lun reset")
echo $executedLunCount
echo ""


#check reoccurence lun reset
printf "\n\n"
echo "= Re-occurrence reset such as retries ="
echo ""
cat 2-tmp.txt | uniq -s 50 -d
echo ""



#
# search vmkernel to see if there are any lun/target resets issued that is less than 1 seconds.
#
printf "\n\n"
echo "= Lun reset in second(s)/millisecond(s) ="
echo ""
echo "Beginning time of each lunReset -- duration"
echo ""

i=0  # index to iterate timeValueArray

#
#  read 2 files at the same time line by line
#    1. will first convert into seconds
#    2. timeValue=EPOC2 - EPOC1
#    3. every timeValue will get inserted into timeValueArray
#
while IFS= read -r -u3 File1 && IFS= read -r -u4 File2; do
#
# read each line then Convert Date/Time into EPOCH for both files
#    .%3N will provide milliseconds
#

#currentDrive1="$(echo ${File1} | grep -iE "Attempt to issue lun reset" | awk '{print $12}' | sed 's/.$//')"
#currentDrive1="$(echo ${File1} | grep -iE "Attempt to issue lun reset")"
dateTime1="$(echo ${File1} | awk '{print $1}' | sed s/.$//)"
EPOC1="$(gdate +%s.%3N -d"$dateTime1")"


#currentDrive2="$(echo ${File2} | grep -iE "executed out-of-band lun" | awk '{print $9}')"
#currentDrive2="$(echo ${File2} | grep -iE "executed out-of-band lun")"
dateTime2="$(echo ${File2} | awk '{print $1}' | sed s/.$//)"
EPOC2="$(gdate +%s.%3N -d"$dateTime2")"

#printf "$currentDrive1 \n"
#printf "$currentDrive2 \n"

#
#  evaulate the time difference
#  graph it out
#  bash does not support floating-point arithmetic so need to use an external utility like bc.
#
timeValue=$(expr $EPOC2-$EPOC1 | bc)

timeValueArray[$i]="$timeValue"

printf "$dateTime1 -- $timeValue \n"

let i++

done 3< 1.txt 4< 2.txt

printf "\n\n"

if [[ $lunIssueCount -eq $executedLunCount ]]; then
     numPerRow=$(($lunIssueCount / 12))
elif [[ $lunIssueCount -lt $executedLunCount ]]; then
     #if lunIssue count is not the same as executed out-of-band count, take the
     #smallest value and divide that by 12 for each hour
     numPerRow=$(($lunIssueCount / 12))
else
     numPerRow=$(($executedLunCount / 12))
fi

printf "== MAP ( Note: X resets per row in each hr; read from left to right; ie 5.001 => 5sec , .001 in milliseconds )==\n"
printf "\n"

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
          echo -n "0$trackTime ->  "
      else
          # trackTime is to represent each hour.
          echo -n "$trackTime ->  "
      fi

     echo -n "${timeValueArray[$k]}"

     let l++
     let trackTime++

    # second+ elements will have --
    # will have X elements per line
elif [[ $l -lt $numPerRow ]]; then
     echo -n "--${timeValueArray[$k]}"
     let l++
    else
      # after X elements, it will make a newline
      printf "\n"
      let l=0    # reset back to 0 to start a new line
      let k=k-1

    fi

done

    printf "\n\n"

rm -f 1.txt
rm -f 2.txt
rm -f 2-tmp.txt

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

# in case if there's a retry during lun reset; remove duplicates
cat $filename | grep -iE "Executed out-of-band target reset" | gtac | uniq -s 50 | gtac > 4.txt

# used for reoccurence
cat $filename | grep -iE "Executed out-of-band target reset" > 4-tmp.txt

#
# get target reset count
#

echo ""
echo ""
echo -e "Attempt to issue target reset:"
targetIssueCount=$(cat $filename | grep -c -iE "Attempt to issue target reset")
echo $targetIssueCount
echo ""
echo -e "Executed out-of-band target reset:"
executedTargetCount=$(cat $filename | grep -c -iE "Executed out-of-band target reset")
echo $executedTargetCount
echo ""

#check reoccurence target reset
printf "\n\n"
echo "= Re-occurrence target reset such as retries ="
echo ""
cat 4-tmp.txt | uniq -s 50 -d
echo ""


#
# search vmkernel to see if there are any lun/target resets issued that is less than 1 seconds.
#
printf "\n\n"
echo "= Target reset in second(s)/millisecond(s) ="
echo ""
echo "Beginning time of each TargetReset -- duration"
echo ""

i=0  # index to for timeValueArray

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
#  put in a map
#
timeValue=$(expr $EPOC2-$EPOC1 | bc)

timeValueArray[$i]="$timeValue"

printf "$dateTime1 -- $timeValue \n"

let i++

done 3< 3.txt 4< 4.txt

printf "\n\n"

if [[ $targetIssueCount -eq $executedTargetCount ]]; then
     numPerRow=$(($targetIssueCount / 12))
 elif [[ $targetIssueCount -lt $executedTargetCount ]]; then
      #if lunIssue count is not the same as executed out-of-band count, take the
      #smallest value and divide that by 12 for each hour
      numPerRow=$(($targetIssueCount/ 12))
 else
      numPerRow=$(($executedTargetCount / 12))
 fi

printf "== MAP ( Note: X resets per row in each hr; read from left to right; ie 5.001 => 5sec , .001 in milliseconds )==\n"

printf "\n"

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
          echo -n "0$trackTime ->  "
       else
          # trackTime is to represent each hour.
          echo -n "$trackTime ->  "
       fi

       echo -n "${timeValueArray[$k]}"

       let l++
       let trackTime++

    # second+ elements will have --
    # will have X row per line
     elif [[ $l -lt numPerRow ]]; then
         echo -n "--${timeValueArray[$k]}"
         let l++
    else
        printf "\n"
        let l=0
        let k=k-1

    fi

done

printf "\n\n"

rm -f 3.txt
rm -f 4.txt
rm -f 4-tmp.txt
}

if [[ -n "$filename" ]]; then

     if [[ $typeOfReset == "lunreset" ]];then
          lunreset "$filename"
     fi

     if [[ $typeOfReset == "targetreset" ]]; then
          targetreset "$filename"
     fi
else
  echo ""
  echo ""
  echo "	Usage: resetCount.sh <filename>"
  echo ""
  echo "               example: sh resetCount.sh <type-of-reset>  <vmkernel.consolidated.log>"
  echo ""
  echo "                            type-of-reset:  targetreset"
  echo "                                            lunreset"
  echo ""
  echo "           Note:  if there are multiple vmkernel logs, such as vmkernel.0.gz,vmkernel.1.gz,..etc "
  echo "                  ensure to consolidate the logs in a sorted order. "
  echo ""
fi
