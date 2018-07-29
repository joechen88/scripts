#!/bin/sh
VERSION=1.036

###############################################################################
# 
# Log summary for hy-100r0w
#
# Functions:
#   Collect a summary for 100r0w test 
#
###############################################################################

filename=$1

timediff()
{
   python calctime.py "$1" "$2"
}


if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ===========================================" 
  echo "                                          100r0w short test (50mins max)"
  echo "                                    ==========================================="
  echo ""
  echo ""
 
  # IOcert version
  echo "=IOcert version="
  cat $filename | grep -iE "Test version"
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
  echo "=Errors="
  cat $filename | grep -A 3 -i "ERROR" 
  echo ""
  echo ""
  
  # Traceback
  echo "=Traceback="
  sed -n '/Traceback/,/:[0-9][0-9]:[0-9][0-9]/p' $filename  
  echo ""
  echo ""

  # Disk info
  echo "=Disk Info="
  cat $filename | grep -iE 'consumed   mds:'
  echo ""
  cat $filename | grep -iE 'consumed  ssds:'
  echo ""
  cat $filename | grep -iE  'diskmapping'
  echo ""
  echo ""

  # 10 VMs + VM size
  echo "=10 VMs + VM size="
  cat $filename | grep -iE  'Adding data'
  echo ""
  printf "VM count: "
  grep -iEc 'Adding data' $filename
  echo ""
  echo ""

  # IP
  echo "=IP address="
  cat $filename | grep -iE  'got IP'
  echo ""
  printf "IP count: "
  grep -iEc 'got IP' $filename
  echo ""
  echo ""

  # Deploying VMs start time
  echo "=Deploying VMs time="
  cat $filename | grep -iE  "Deploying VMs"
  echo ""
  echo ""

  # ALL VMs Deployed time
  echo "=All VMs deployed time="
  cat $filename | grep -iE  "All VMs deployed"
  echo ""
  echo ""

  # number of DD
  echo "=DD info="
  cat $filename | grep -iE  'running dd'
  echo ""
  echo ""

  # WB usuage
  echo "=WB Usage="
  cat $filename | grep -iE  'WB usage at'
  echo ""
  echo ""


  # IOBlazer or FIO
  echo "=IOBlazer or FIO (duration ~22.22mins)="
  cat $filename | grep -iE 'Starting IOBlazer|Starting FIO runs'
  cat $filename | grep -iE 'vsan.iocert.ctrl_100r0w_short...............................COMPLETED'
  StartTimeIOBlazerOrFIO="$(cat $filename | grep -iE 'Starting IOBlazer|Starting FIO runs' | sed '1,1!d' | cut -d, -f1)"
  EndTimeIOBlazerOrFIO="$(cat $filename | grep -iE 'vsan.iocert.ctrl_100r0w_short...............................COMPLETED' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTimeIOBlazerOrFIO" "$EndTimeIOBlazerOrFIO"
  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""

  #status
  echo "=Status="
  cat $filename | grep -i 'vsan.iocert.ctrl_100r0w_short...............................COMPLETED ('
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-100r0w.sh <filename>"
  echo ""
  echo "               example: sh hy-100r0w.sh test-vpx.vsan.iocert.ctrl_100r0w_short.log"
  echo ""
fi





