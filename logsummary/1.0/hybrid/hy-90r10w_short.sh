#!/bin/sh
VERSION=1.0

###############################################################################
#
# Log summary for hy-90r10w short
#
# Functions:
#   Collect a summary for 90r10w short test 
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
  echo "                                         ${green} 90r10w short test (50mins max)${nc}"
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

  # IOBlazer
  echo "${blue}=IOBlazer (duration ~13.33mins)=${nc}"
  cat $filename | grep -i 'Starting IOBlazer'
  cat $filename | grep -iE 'vsan.iocert.ctrl_90r10w_short...............................COMPLETED'
  echo ""
  echo ""

  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""

  #status
  echo "${blue}=Status=${nc}"
  cat $filename | grep -i 'vsan.iocert.ctrl_90r10w_short...............................COMPLETED ('
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-90r10w_short.sh <filename>"
  echo ""
  echo "               example: sh hy-90r10w_short.sh test-vpx.vsan.iocert.ctrl_90r10w_short.log"
  echo ""
fi





