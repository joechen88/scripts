#!/bin/sh
VERSION=1.0

###############################################################################
#
# Log summary for af-100r0w_long.sh
#
# Functions:
#   Collect a summary for af-100r0w_long test
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

if [ "$filename" == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log" ]; then

  echo ""
  echo "                                    ======================================================"
  echo "                                                ${green}AF af-100r0w_long test (4hrs max)${nc}"
  echo "                                    ======================================================"
  echo ""
  echo ""

  # IOcert version
  echo "${blue}=IOcert version=${nc}"
  cat $filename | grep -iE "Test version"
  echo ""
  echo ""

  # Traceback
  echo "${blue}=Traceback=${nc}"
  cat $filename | grep -iE -A 1 'Traceback'
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

  # 10 VMs + VM size
  echo "${blue}=10 VMs + VM size=${nc}"
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
  echo "${blue}=DD info=${nc}"
  cat $filename | grep -iE  'dd if=/dev/zero'
  echo ""
  printf "${red}Total number of DD:${nc} "
  grep -c 'dd if=/dev/zero' $filename
  echo ""
  echo ""

  # FIO
  echo "${blue}=FIO=${nc}"
  cat $filename | grep -iE  'fio'
  echo""
  
  FIOSTART="$(cat $filename | grep -iE 'Starting FIO runs' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  LASTFIO="$(cat $filename | grep -iE 'Done running FIO' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"

  printf "${red}FIO completion time: ${nc}"
  timediff "$FIOSTART" "$LASTFIO"
  echo""
  echo""

  #100r0w long test
  echo "${blue}=100r test (1 hr)=${nc}"
  cat $filename | grep -iE "Starting test vsan.iocert.ctrlr_100r0w_long_af_|vsan.iocert.ctrlr_100r0w_long_af_c2.........................COMPLETED|vsan.iocert.ctrlr_100r0w_long_af_c1.........................COMPLETED"
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
  cat $filename | grep -iE 'vsan.iocert.ctrlr_0r100w_long_4k_af_c1......................COMPLETED|vsan.iocert.ctrlr_0r100w_long_4k_af_c2......................COMPLETED'
  echo ""
  echo ""


else
  echo ""
  echo "	Usage: af-100r0w_long.sh <filename>"
  echo ""
  echo "               example: sh af-100r0w_long.sh test-vpx.vsan.iocert.ctrl_af-100r0w_long_af_c1.log"
  echo ""
fi





