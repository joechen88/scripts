#!/bin/sh
VERSION=1.034

###############################################################################
# 
# Log summary for af-10r90w short
#
# Functions:
#   Collect a summary for 10r90w short test 
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


if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ===========================================" 
  echo "                                         ${green} 10r90w short test (50mins max)${nc}"
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

  # number of DD
  echo "${blue}=DD info (10)=${nc}"
  cat $filename | grep -iE  'dd if=/dev/zero'
  echo ""
  printf "${red}DD count: ${nc}"
  grep -c 'dd if=/dev/zero' $filename
  echo ""
  echo ""

  # IOBlazer or FIO
  echo "${blue}=IOBlazer or FIO (duration ~22.22mins)=${nc}"
  cat $filename | grep -iE 'Starting IOBlazer|Starting FIO runs'
  cat $filename | grep -iE 'vsan.iocert.ctrl_10r90w_short...............................COMPLETED'
  echo ""
  echo ""

  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""

  #status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -i 'vsan.iocert.ctrl_10r90w_short...............................COMPLETED ('
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: af-10r90w_short.sh <filename>"
  echo ""
  echo "               example: sh af-10r90w_short.sh test-vpx.vsan.iocert.ctrl_10r90w_short.log"
  echo ""
fi





