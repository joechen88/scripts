#!/bin/sh
VERSION=1.037

###############################################################################
#
# Log summary for hotplug-diskRemoveReinsertPlanned test
#
# Functions:
#   Collect a summary for diskRemoveReinsertPlanned test
#
###############################################################################

filename=$1




timediff()
{
   calctime.py "$1" "$2"
}


if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ==============================================="
  echo "                                           diskRemoveReinsertPlanned test "
  echo "                                    ==============================================="
  echo ""
  echo ""

  # IOcert version
  echo "=IOcert version="
  cat $filename | grep -iE 'Test version'
  echo ""
  echo ""

  # ESX version
  echo "=ESX version="
  cat traces/*/stats.html |grep -iE "VMware ESXi" | awk '{ print $1,$2,$3,$4 }' | sort | uniq
  echo ""
  echo ""

  # Host IP or Host Name
  echo "=Host="
  printf "Host: "
  cat $filename | grep -iE "hosts reserved" | awk '{print $NF}' | cut -d. -f1-4
  echo ""
  echo""

  # Errors
#  echo "=Errors="
#  cat $filename | grep -A 3 -i "ERROR" 
#  echo ""
#  echo ""
  
  # Traceback
#  echo "=Traceback="
#  sed -n '/Traceback/,/:[0-9][0-9]:[0-9][0-9]/p' $filename
#  echo ""
#  echo ""

  # Disk info
  echo "=Disk Info="
  cat $filename | grep -iE 'consumed   mds:'
  echo ""
  cat $filename | grep -iE 'consumed  ssds:'
  echo ""
  cat $filename | grep -iE  'diskmapping'
  echo ""
  echo ""

  # IP
  echo "=Host IP address="
  cat $filename | grep -iE  'host.py'
  echo ""
  echo ""

  # LED
  echo "=LED INFO="
  cat $filename | grep -iE  'led on host'
  echo ""
  echo ""

  # short summary
  echo "=Short Summary="
  cat $filename | grep -iE 'STARTING TEST: PLANNED:|COMPLETED TEST: PLANNED:'
  echo ""
  echo ""

  # mid summary
  echo "=Mid summary="
  cat $filename | grep -iE -A 1 'please reinsert|Found the user prompt file|Found all the components'
  echo ""
  echo ""
  printf "1st Re-sync time: "
  GetLineNum1="$(cat $filename | grep -iE -n "Please reinsert" | awk '{print $1}' | cut -d: -f1 | sed -n '1p')"
  GetLineNum2="$(cat $filename | grep -iE -n "Please reinsert" | awk '{print $1}' | cut -d: -f1 | sed -n '2p')"
  
  ResyncTime11="$(tail -n +${GetLineNum1} $filename | grep -iE "Found the user prompt" | sed '1!d' | cut -d, -f1)"
  ResyncTime12="$(tail -n +${GetLineNum1} $filename | grep -iE "Found all the" | sed '1!d' | cut -d, -f1)"
  timediff "$ResyncTime11" "$ResyncTime12"
  echo ""
  printf "2nd Re-sync time: "
  ResyncTime21="$(tail -n +${GetLineNum2} $filename | grep -iE "Found the user prompt" | sed '1!d' | cut -d, -f1)"
  ResyncTime22="$(tail -n +${GetLineNum2} $filename | grep -iE "Found all the" | sed '1!d' | cut -d, -f1)"
  timediff "$ResyncTime21" "$ResyncTime22"
  echo ""
  echo ""

  # full re-sync summary
  echo "=Full Re-sync summary=" 
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
  echo "=high level summary="
  cat $filename | grep -iE 'diskManagementGeneralTest'
  echo ""
  echo ""
 
  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE 'cleaning|Deleting all'
  cat $filename | grep -iE 'testvpx.py'
  echo ""
  echo ""

  # status
  echo "=status="
  cat $filename | grep -iE  'raid1pass|raid1completed|raid1fail'
  echo ""
  echo ""

else
  echo ""
  echo "	Usage: hotplug-diskRemoveReinsertPlanned.sh <filename>"
  echo ""
  echo "               example: sh hotplug-diskRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log"
  echo ""
fi
