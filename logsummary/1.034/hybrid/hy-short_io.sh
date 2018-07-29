#!/bin/sh
VERSION=1.034

###############################################################################
# 
# Log summary for hy-short_io
#
# Functions:
#   Collect a summary for hy-short_io test 
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
  echo "                                              ${green} short IO test (8hrs max)${nc}"
  echo "                                    ==========================================="
  echo ""
  echo ""

  # IOcert version
  echo "${blue}=IOcert version=${nc}"
  cat $filename | grep -iE "Test version"
  echo ""
  echo ""

  # Host IP or Host Name
  echo "${blue}=Host=${nc}"
  printf "Host: "
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

  # FIO
  echo "${blue}=FIO (duration 4hr each)=${nc}"
  echo "First FIO thread"
  cat $filename | grep -iE "starting fio runs" | sed '1!d' 
  cat $filename | grep -iE "All VM IO threads are completed" | sed '1!d'
  FIO1start="$(cat $filename | grep -iE "starting fio runs" | sed '1!d' | cut -d, -f1)"
  FIO1end="$(cat $filename | grep -iE "All VM IO threads are completed" | sed '1!d' | cut -d, -f1)"
  printf "${red}First FIO completion time: ${nc}"
  timediff "$FIO1start" "$FIO1end" 
  echo ""
  echo "Second FIO thread"
  cat $filename | grep -iE "starting fio runs" | sed '2!d' 
  cat $filename | grep -iE "All VM IO threads are completed" | sed '2!d' 
  FIO2start="$(cat $filename | grep -iE "starting fio runs" | sed '2!d' | cut -d, -f1)"
  FIO2end="$(cat $filename | grep -iE "All VM IO threads are completed" | sed '2!d' | cut -d, -f1)"
  printf "${red}Second FIO completion time: ${nc}"
  timediff "$FIO2start" "$FIO2end"
  echo ""
  echo ""

  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""

  #status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -iE "vsan.iocert.ctrlr_short_io_c1...............................COMPLETED|vsan.iocert.ctrlr_short_io_c2...............................COMPLETED" 
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-short_io.sh <filename>"
  echo ""
  echo "               example: sh hy-short_io.sh test-vpx.vsan.iocert.ctrlr_short_io_c1.log"
  echo ""
fi





