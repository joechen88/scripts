#!/bin/sh
VERSION=1.03

###############################################################################
#
# Log summary for hy-combinedLong
#
# Functions:
#   Collect a summary for CombinedLong test.
#
###############################################################################

filename=$1

#color
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
nc=`tput sgr0`   #no color

timediff()
{
   calctime.py "$1" "$2"
}

filename=$1

if [ "$filename" == "test-vpx.vsan.iocert.ctrl_combined_long_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrl_combined_long_c2.log" ]; then

  echo ""
  echo "                                    ======================================================"
  echo "                                                ${green} CombinedLong test (75hrs max)${nc}"
  echo "                                    ======================================================"
  echo ""
  echo ""

  # IOcert version
  echo "${blue}=IOcert version=${nc}"
  cat $filename | grep -iE "Test version"
  echo ""
  echo ""

  # Host IP
  echo "${blue}=Host IP=${nc}"
  printf "Host IP: "
  cat $filename | grep -iE "hosts reserved" | awk '{print $NF}' | cut -d. -f1-4
  echo ""
  echo""

  # Errors
  echo "${blue}=Errors=${nc}"
  cat $filename | grep -A 3 -i "ERROR" 
  echo ""
  echo ""
  
  # Traceback
  echo "${blue}=Traceback=${nc}"
  sed -n '/Traceback/,/:[0-9][0-9]:[0-9][0-9]/p' $filename  
  echo ""
  echo ""

  # Disk info
  echo "${blue}=Disk Info=${nc}"
  cat $filename | grep -iE 'Consuming  MDs:'
  echo ""
  cat $filename | grep -iE 'Consuming SSds:'
  cat $filename | grep -iE  'diskmapping'
  echo ""
  echo ""

  # 2 VMs + VM size
  echo "${blue}=2 VMs + VM size=${nc}"
  cat $filename | grep -iE  'Adding data'
  echo ""
  printf "${red}VM count: ${nc}"
  grep -iEc 'Adding data' $filename
  echo ""
  echo ""

  # IP
  echo "${blue}=IP address=${nc}"
  cat $filename | grep -iE  'got IP'
  echo""
  echo""

  # number of DD
  echo "${blue}=DD info (16)=${nc}"
  cat $filename | grep -iE  'dd if=/dev/zero'
  echo ""
  printf "${red}DD count:${nc} "
  grep -c 'dd if=/dev/zero' $filename
  echo ""
  echo ""

  # Dynamo or IOBlazer
  echo "${blue}=Dynamo or IOBlazer=${nc}"
  cat $filename | grep -iE  'Running dynamo|running ioblazer'
  echo""
  echo""

  # 100r test
  echo "${blue}=100r test (3hr)=${nc}"
  cat $filename | grep -iE  'Starting 100r test|100r test complete|Starting 100r0w test|100r0w test complete'
  StartTime100r="$(cat $filename | grep -iE 'Starting 100r test|Starting 100r0w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime100r="$(cat $filename | grep -iE '100r test complete|100r0w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime100r" "$EndTime100r" 
  echo ""
  echo ""

  # 70r30w 100% Hit rate test
  echo "${blue}=70r30w 100% test (4hrs)=${nc}"
  cat $filename | grep -iE  'Starting 70r30w 100% hit rate|70r30w 100% hit rate test complete|Starting 70r30w test|70r30w test complete'
  StartTime70r30w100="$(cat $filename | grep -iE 'Starting 70r30w 100% hit rate|Starting 70r30w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w100="$(cat $filename | grep -iE '70r30w 100% hit rate test complete|70r30w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w100" "$EndTime70r30w100"
  echo ""
  echo ""

  # 70r30w 99% Hit rate test
  echo "${blue}=70r30w 99% test (4hrs)=${nc}"
  cat $filename | grep -iE  'Starting 70r30w 99% hit rate|70r30w 99% hit rate test complete'
  StartTime70r30w99="$(cat $filename | grep -iE 'Starting 70r30w 99% hit rate' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w99="$(cat $filename | grep -iE '70r30w 99% hit rate test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w99" "$EndTime70r30w99"  
  echo ""
  echo ""

  #
  # 70r30w 95% Hit rate test
  echo "${blue}=70r30w 95% test(4hrs)=${nc}"
  cat $filename | grep -iE  'Starting 70r30w 95% hit rate|70r30w 95% hit rate test complete'
  StartTime70r30w95="$(cat $filename | grep -iE 'Starting 70r30w 95% hit rate' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w95="$(cat $filename | grep -iE '70r30w 95% hit rate test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w95" "$EndTime70r30w95"
  echo ""
  echo ""

  # 100w test
  echo "${blue}=100w test (3 hrs)=${nc}"
  cat $filename | grep -iE  'Starting 100w test|100w test complete|Starting 0r100w test|0r100w test complete'
  StartTime100w="$(cat $filename | grep -iE 'Starting 100w test|Starting 0r100w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime100w="$(cat $filename | grep -iE '100w test complete|0r100w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime100w" "$EndTime100w"
  echo ""
  echo ""


  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""

  # status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -iE 'vsan.iocert.ctrl_combined_long_c1...........................COMPLETED|vsan.iocert.ctrl_combined_long_c2...........................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-combinedlong.sh <filename>"
  echo ""
  echo "               example: sh hy-combinedlong.sh test-vpx.vsan.iocert.ctrl_combined_long_c1.log"
  echo ""
fi





