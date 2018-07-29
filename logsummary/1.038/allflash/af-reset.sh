#!/bin/sh
VERSION=1.038

###############################################################################
#.
# Log summary for af-reset test
#
# Functions:
#   Collect a summary for reset test.
#
###############################################################################

filename=$1




timediff()
{
   calctime.py "$1" "$2"
}


if [ -n "$filename" ]; then

  echo ""
  echo "                                    ============================================"
  echo "                                            AF reset test (24hrs max)"
  echo "                                    ============================================"
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

  # FIO error
  echo "=FIO Errors="
  cat fio/*/* | grep -B2 -A2 -iE "error="
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

  # DiskHealth
  echo "=DiskHealth Time (duration is 12hrs)="
  cat $filename | grep -iE 'DiskHealthCheckThread: Starting CheckDiskHealth|DiskHealthCheckThread: CheckDiskHealth thread completed'
  echo ""
  DiskHealthThreadStartTime="$(cat $filename | grep -iE 'DiskHealthCheckThread: Starting CheckDiskHealth'  | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  DiskHealthThreadEndTime="$(cat $filename | grep -iE 'DiskHealthCheckThread: CheckDiskHealth thread completed'  | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  printf "Disk Health Check Thread total time: "
  timediff "$DiskHealthThreadStartTime" "$DiskHealthThreadEndTime"
  echo ""
  echo ""

  # FIO time
  echo "=VMIOThread Time (duration is 12hrs)="
  cat $filename | grep -iE 'VMIOThread: Starting IO On all vms|VMIOThread: VM IO Thread completed'
  echo ""

  VMIOThreadStartTime="$(cat $filename | grep -iE 'VMIOThread: Starting IO On all vms'  | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  VMIOThreadEndTime="$(cat $filename | grep -iE 'VMIOThread: VM IO Thread completed'  | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  printf "VMIO Thread total time: "
  timediff "$VMIOThreadStartTime" "$VMIOThreadEndTime"
  echo ""
  echo ""

  # IOMeter or IOBlazer or FIO
  echo "=IOMeter,IOBlazer, or FIO="
  cat $filename | grep -iE  'Starting IOBlazer|running ioblazer on|Starting IOMeter runs|Iometer output|starting fio|done running fio'
  echo ""
  echo ""

  # busreset, lunreset, targetreset (duration is 12hrs)
  echo "=Busreset, Lunreset, Targetreset (duration is 12hrs)="
  cat $filename | grep -iE  'starting device reset|Starting controller reset'
  echo "Last busreset, lunreset, and targetrest"
  cat $filename | grep -iE 'Running busreset' | tail -n 1
  cat $filename | grep -iE 'Running lunreset' | tail -n 1
  cat $filename | grep -iE 'Running targetreset' | tail -n 1
  echo ""
  printf "busreset count: "
  grep -c 'Running busreset' $filename
  printf "lunreset count: "
  grep -c 'Running lunreset' $filename
  printf "targetreset count: "
  grep -c 'Running targetreset' $filename
  echo ""
   
  ResetStartTime="$(cat $filename | grep -iE  'starting device reset|Starting controller reset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
   
  printf "BusReset time: "
  lastBusReset="$(cat $filename | grep -iE 'Running busreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastBusReset"
   
  printf "LunReset time: "
  lastLunReset="$(cat $filename | grep -iE 'Running lunreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastLunReset"

  printf "TargetReset time: "
  lastTargetReset="$(cat $filename | grep -iE 'Running targetreset' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  timediff "$ResetStartTime" "$lastTargetReset"

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
  cat $filename | grep -iE 'vsan.iocert.ctrlr_reset_af_c1...............................COMPLETED|vsan.iocert.ctrlr_reset_af_c2...............................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: af-reset.sh <filename>"
  echo ""
  echo "               example: sh af-reset.sh test-vpx.vsan.iocert.ctrlr_reset.log"
  echo ""
fi
