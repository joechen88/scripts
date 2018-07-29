#!/bin/sh
VERSION=1.038

###############################################################################
#
# Log summary for af-data-integrity-af.sh
#
# Functions:
#   Collect a summary for af-data-integrity-af test.
#
###############################################################################

filename=$1



timediff()
{
   calctime.py "$1" "$2"
}


if [[ -n "$filename" ]]; then

  echo ""
  echo "                                    ========================================================="
  echo "                                                AF data-integrity test (20hrs max)"
  echo "                                    ========================================================="
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
 

  # 40 VMs + VM size
  echo "=40 VMs + VM size="
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
  echo "=FIO (duration 12hrs)="
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
  echo ""

  # Data Integrity test (12hrs)
  echo "=Data Integrity test (12 hrs)="
  cat $filename | grep -iE "Starting VM IO phase|vsan.iocert.ctrlr_data_integrity_af_c1......................COMPLETED|vsan.iocert.ctrlr_data_integrity_af_c2......................COMPLETED"
  echo ""

  SPLITIOSTART="$(cat $filename | grep -iE 'Starting VM IO phase' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  SPLITIOEND="$(cat $filename | grep -iE 'vsan.iocert.ctrlr_data_integrity_af_c1......................COMPLETED|vsan.iocert.ctrlr_data_integrity_af_c2......................COMPLETED' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  printf "Data Integrity completion time: "
  timediff "$SPLITIOSTART" "$SPLITIOEND"
  echo""
  echo""
  echo ""


  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""
  echo ""

  # status
  echo "=Status="
  cat $filename | grep -iE 'vsan.iocert.ctrlr_data_integrity_af_c1......................COMPLETED|vsan.iocert.ctrlr_data_integrity_af_c2......................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: af-data-integrity.sh <filename>"
  echo ""
  echo "               example: sh af-data-integrity.sh vsan.iocert.ctrlr_data_integrity_af_c1"
  echo ""
fi





