#!/bin/sh
VERSION=1.038

###############################################################################
#
# Log summary for af-100r0w_long.sh
#
# Functions:
#   Collect a summary for af-100r0w_long test
#
###############################################################################

filename=$1



timediff()
{
   calctime.py "$1" "$2"
}

if [ "$filename" == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log" ]; then

  echo ""
  echo "                                    ======================================================"
  echo "                                                AF af-100r0w_long test (4hrs max)"
  echo "                                    ======================================================"
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
  cat $filename | grep -iE -A 1 'Traceback'
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

  # FIO
  echo "=FIO="
  cat $filename | grep -iE  'fio'
  echo""
  
  FIOSTART="$(cat $filename | grep -iE 'Starting FIO runs' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  LASTFIO="$(cat $filename | grep -iE 'Done running FIO' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"

  printf "FIO completion time: "
  timediff "$FIOSTART" "$LASTFIO"
  echo""
  echo""

  #100r0w long test
  echo "=100r test (1 hr)="
  cat $filename | grep -iE "Starting test vsan.iocert.ctrlr_100r0w_long_af_|vsan.iocert.ctrlr_100r0w_long_af_c2.........................COMPLETED|vsan.iocert.ctrlr_100r0w_long_af_c1.........................COMPLETED"
  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""
  echo ""

  # status
  echo "=Status="
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

