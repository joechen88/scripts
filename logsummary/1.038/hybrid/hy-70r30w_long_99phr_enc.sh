#!/bin/sh
VERSION=1.038

###############################################################################
#
# Log summary for hy-70r30w_long_99phr_enc
#
# Functions:
#   Collect a summary for 70r30w_long_99phr_enc test.
#
###############################################################################

filename=$1



timediff()
{
   calctime.py "$1" "$2"
}

filename=$1

if [ "$filename" == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log" ]; then

  echo ""
  echo "                                    ======================================================================"
  echo "                                                Hybrid 70r30w long 99phr enc test (8:33 hrs max)"
  echo "                                    ======================================================================"
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
  echo ""
  echo ""

  # Errors
  echo "=Errors="
  cat $filename | grep -A 3 -i "ERROR" 
  echo ""
  echo ""
  echo ""
  
  # Traceback
  echo "=Traceback="
  sed -n '/Traceback/,/:[0-9][0-9]:[0-9][0-9]/p' $filename  
  echo ""
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
  echo ""

  # 16 VMs + VM size
  echo "=VMs + VM size ( 16 ) ="
  cat $filename | grep -iE  'Adding data'  | head -16
  echo ""
  printf "VM count: "
  grep -iEc 'Adding data' $filename
  echo ""
  echo ""


  # IP
  echo "=IP address ( 16 )="
  cat $filename | grep -iE  'got IP' | head -16
  echo ""
  printf "IP count: "
  grep -iEc 'got IP' $filename
  echo ""
  echo ""


  # Deploying VMs start time
  echo "=Deploying VMs time="
  cat $filename | grep -iE  "Deploying VMs" | head -1
  echo ""
  echo ""


  # ALL VMs Deployed time
  echo "=All VMs deployed time="
  cat $filename | grep -iE  "All VMs deployed" | head -1
  echo ""
  echo ""


  # number of DD
  echo "=DD info="
  cat $filename | grep -iE  'dd if=/dev/zero' | head -16
  echo ""
  echo ""


  # WB usuage
  echo "=WB Usage="
  cat $filename | grep -iE  'WB usage at' | head -1
  echo ""
  echo ""



  # FIO
  echo "=FIO="
  cat $filename | grep -iE  'Starting FIO runs|RunFIOTest: All VM IO threads are completed'
  echo ""
  echo ""
  echo ""

  # Encryption
  echo "=Encryption="
  cat $filename | grep -iE 'Software Encryption setup started...|Verifying whether encryptionEnabled field is|Finished Software Encryption setup...'
  echo ""
  echo ""

  # 70r30w 99phr Hit rate encryption test
  echo "=70r30w 99phr encryption test (4hrs)="
  cat $filename | grep -iE  'Starting test vsan.iocert.ctrlr_70r30w_long_99phr_enc|vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1..................COMPLETED|vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2..................COMPLETED'
  StartTime70r30w99="$(cat $filename | grep -iE 'Starting test vsan.iocert.ctrlr_70r30w_long_99phr_enc' | tail -n 1 | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w99="$(cat $filename | grep -iE 'vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1..................COMPLETED|vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2..................COMPLETED' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w99" "$EndTime70r30w99"  
  echo ""
  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  cat $filename | grep -iE  'Vsan Encryption disabled successfully|Finished Encryption cleanup'
  echo ""
  echo ""
  echo ""

  # status
  echo "=Status="
  cat $filename | grep -iE 'vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1..................COMPLETED|vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2..................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-70r30w_long_99phr_enc.sh <filename>"
  echo ""
  echo "               example: sh hy-70r30w_long_99phr_enc.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log"
  echo ""
fi





