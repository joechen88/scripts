#!/bin/sh
VERSION=1.0

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
  d1="$1"
  d2="$2"
  date1="$(echo $d1 | awk '{print $1}')"
  time1="$(echo $d1 | awk '{print $2}')"
  date2="$(echo $d2 | awk '{print $1}')"
  time2="$(echo $d2 | awk '{print $2}')"

  #validate date format and return a boolean
  d1="$(echo $date1 | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$')"
  d2="$(echo $date2 | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$')"


  if [ $d1 == 1 ] && [ $d2 == 1 ]; then
    datediff ${date1}T${time1} ${date2}T${time2} -f '%dd %Hh %Mm %Ss'
  else
    echo "unable to calculate time"
  fi
}


if [ "$filename" == "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log" ]; then

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
  cat test-vpx.log |grep -i "running ioblazer"  
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
   
  ResetStartTime="$(cat $filename | grep -iE  'starting device reset')"
   
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
