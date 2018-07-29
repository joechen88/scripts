#!/bin/sh
VERSION=1.031

###############################################################################
#.
# Log summary for af-reset test
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


if [ -n "$filename" ]; then

  echo ""
  echo "                                    ============================================"
  echo "                                            ${green}AF reset test (24hrs max)${nc}"
  echo "                                    ============================================"
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
  cat $filename | grep -iE 'consumed   mds:'
  echo ""
  cat $filename | grep -iE 'consumed  ssds:'
  echo ""
  cat $filename | grep -iE  'diskmapping'
  echo ""
  echo ""

  # 40 VMs + VM size
  echo "${blue}=40 VMs + VM size=${nc}"
  cat $filename | grep -iE  'Adding data'
  echo ""
  printf "${red}VM count: ${nc}"
  grep -iEc 'Adding data' $filename
  echo ""
  echo ""
 
  # IP
  echo "${blue}=IP address=${nc}"
  cat $filename | grep -iE  'got IP'
  echo ""
  echo ""

  # number of DD
  echo "${blue}=DD info=${nc}"
  cat $filename | grep -i 'init'
  cat $filename | grep -iE  'dd if=/dev/zero'
  echo ""
  printf "${red}DD count:${nc} "
  grep -c 'dd if=/dev/zero' $filename
  echo ""
  echo ""

  # IOBlazer
  echo "${blue}=IOBlazer=${nc}"
  cat $filename |grep -i "running ioblazer"  
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
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""
  echo ""

  # status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -iE 'vsan.iocert.ctrlr_reset_af_c1...............................COMPLETED|vsan.iocert.ctrlr_reset_af_c2...............................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: af-reset.sh <filename>"
  echo ""
  echo "               example: sh af-reset.sh test-vpx.vsan.iocert.ctrlr_reset.log"
  echo ""
fi
