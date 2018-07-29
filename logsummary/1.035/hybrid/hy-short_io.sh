#!/bin/sh
VERSION=1.035

###############################################################################
# 
# Log summary for hy-short_io
#
# Functions:
#   Collect a summary for hy-short_io test 
#
###############################################################################

filename=$1



timediff()
{
   calctime.py "$1" "$2"
}


if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ===========================================" 
  echo "                                               short IO test (8hrs max)"
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
  
  # FIO
  echo "=FIO (duration 4hr each)="
  echo "First FIO thread"
  cat $filename | grep -iE "starting fio runs" | sed '1!d' 
  cat $filename | grep -iE "All VM IO threads are completed" | sed '1!d'
  FIO1start="$(cat $filename | grep -iE "starting fio runs" | sed '1!d' | cut -d, -f1)"
  FIO1end="$(cat $filename | grep -iE "All VM IO threads are completed" | sed '1!d' | cut -d, -f1)"
  printf "First FIO completion time: "
  timediff "$FIO1start" "$FIO1end" 
  echo ""
  echo "Second FIO thread"
  cat $filename | grep -iE "starting fio runs" | sed '2!d' 
  cat $filename | grep -iE "All VM IO threads are completed" | sed '2!d' 
  FIO2start="$(cat $filename | grep -iE "starting fio runs" | sed '2!d' | cut -d, -f1)"
  FIO2end="$(cat $filename | grep -iE "All VM IO threads are completed" | sed '2!d' | cut -d, -f1)"
  printf "Second FIO completion time: "
  timediff "$FIO2start" "$FIO2end"
  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleanup up any VSAN config'
  echo ""

  #status
  echo "=Status="
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





