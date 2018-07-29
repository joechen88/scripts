#!/bin/sh
VERSION=1.01

###############################################################################
#.
# Log summary for hy-reset test
#
# Functions:
#   Collect a summary for reset test.
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

if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ==========================================="
  echo "                                            ${green} reset test (24hrs max)${nc}"
  echo "                                    ==========================================="
  echo ""
  echo ""

  # IOcert version
  echo "${blue}=IOcert version=${nc}"
  cat $filename | grep -iE "Test version"
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
  echo ""
 

  # IP
  echo "${blue}=IP address=${nc}"
  cat $filename | grep -iE  'got IP'
  echo ""
  echo ""

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
  echo ""
  echo ""

  # busreset, lunreset, targetreset (duration is 12hrs)
  echo "${blue}=Busreset, Lunreset, Targetreset (duration is 12hrs)=${nc}"
  cat $filename | grep -iE  'starting device reset'
  echo "Last busreset, lunreset, and targetrest"
  cat $filename | grep -iE 'Running busreset' | tail -n 1
  cat $filename | grep -iE 'Running lunreset' | tail -n 1
  cat $filename | grep -iE 'Running targetreset' | tail -n 1
  echo ""
  printf "${red}busreset count:${nc} "
  grep -c 'Running busreset' $filename
  printf "${red}lunreset count:${nc} "
  grep -c 'Running lunreset' $filename
  printf "${red}targetreset count:${nc} "
  grep -c 'Running targetreset' $filename
  echo ""
  ResetStartTime="$(cat $filename | grep -iE  'starting device reset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"

  printf "BusReset time: "
  lastBusReset="$(cat $filename | grep -iE 'Running busreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastBusReset"

  printf "LunReset time: "
  lastLunReset="$(cat $filename | grep -iE 'Running lunreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastLunReset"

  printf "TargetReset time: "
  lastTargetReset="$(cat $filename | grep -iE 'Running targetreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastTargetReset"

  echo ""
  echo ""

  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""
  echo ""

  #status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -i 'vsan.iocert.ctrlr_reset.....................................COMPLETED ('
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-reset.sh <filename>"
  echo ""
  echo "               example: sh hy-reset.sh test-vpx.vsan.iocert.ctrlr_reset.log"
  echo ""
fi
