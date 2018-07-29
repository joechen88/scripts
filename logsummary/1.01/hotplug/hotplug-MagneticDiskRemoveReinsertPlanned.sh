#!/bin/sh
VERSION=1.01

###############################################################################
#
# Log summary for hotplug MagneticDiskRemoveReinsertPlanned test
#
# Function:
#   Collect a summary for hotplug MagneticDiskRemoveReinsertPlanned test
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
  echo "                                    ====================================================="
  echo "                                          ${green} MagneticDiskRemoveReinserPlanned test ${nc}"
  echo "                                    ====================================================="
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
  cat $filename | grep -iE  'consuming'
  echo ""
  echo ""

  # IP
  echo "${blue}=Host IP address=${nc}"
  cat $filename | grep -iE  'host.py'
  echo ""
  echo ""

  # LED
  echo "${blue}=LED INFO=${nc}"
  cat $filename | grep -iE  'led on host'
  echo ""
  echo ""

  # short summary
  echo "${blue}=Short Summary=${nc}"
  cat $filename | grep -iE 'STARTING TEST: PLANNED:|COMPLETED TEST: PLANNED:'
  echo ""
  echo ""

  # mid summary
  echo "${blue}=Mid summary=${nc}"
  cat $filename | grep -iE -A 1 'please reinsert|Found the user prompt file|Found all the components'
  echo""
  echo""
  printf "${red}Re-sync time: ${nc}"
  GetLineNum1="$(cat $filename | grep -iE -n "Please reinsert" | awk '{print $1}' | cut -d: -f1 | sed -n '1p')"
  GetLineNum2="$(cat $filename | grep -iE -n "Please reinsert" | awk '{print $1}' | cut -d: -f1 | sed -n '2p')"

  ResyncTime11="$(tail -n +${GetLineNum1} $filename | grep -iE "Found the user prompt" | sed '1!d')"
  ResyncTime12="$(tail -n +${GetLineNum1} $filename | grep -iE "Found all the" | sed '1!d')"

  timediff "$ResyncTime11" "$ResyncTime12"  
  echo ""
  echo ""

  #Full re-sync summary
  echo "${blue}=Full Re-sync summary=${nc}" 
  echo ""
  echo "			0 - FIRST		4 - INITIALIZED		8 - RESYNCHING		12 - TRANSIENT" 	
  echo "			1 - NONE		5 - ACTIVE		9 - DEGRADED		13 - LAST "
  echo "			2 - NEED_CONFIG		6 - ABSENT	       10 - RECONFIGURING"
  echo "			3 - INITIALIZE		7 - STALE	       11 - CLEANUP"
  echo ""
  cat $filename | grep -iE -A 1 'Found all the component|expected state degraded|expected state active|waiting for user prompt file|simple component state|found the user prompt|Please be ready to remove|please reinsert' | grep -v 'Enter function named vmObjectQuery'
  echo ""
  echo ""

  # high level summary
  echo "${blue}=High level summary=${nc}"
  cat $filename | grep -iE -A 1 'diskManagementGeneralTest'
  echo ""
  echo ""
 
  # cleanup
  echo "${blue}=Cleanup=${nc}"
  cat $filename | grep -iE 'cleaning|Deleting all'
  cat $filename | grep -iE 'testvpx.py'
  echo ""
  echo ""

  # status
  echo "${blue}=status=${nc}"
  cat $filename | grep -iE 'raid1pass|raid1completed|raid1fail'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hotplug-MagneticDiskRemoveReinsertPlanned.sh <filename>"
  echo ""
  echo "               example: sh hotplug-MagneticDiskRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.MagneticDiskRemoveReinsertPlanned_RAID1.log"
  echo ""
fi
