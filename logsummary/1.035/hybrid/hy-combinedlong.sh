#!/bin/sh
VERSION=1.035

###############################################################################
#
# Log summary for hy-combinedLong
#
# Functions:
#   Collect a summary for CombinedLong test.
#
###############################################################################

filename=$1



timediff()
{
   calctime.py "$1" "$2"
}

filename=$1

if [ "$filename" == "test-vpx.vsan.iocert.ctrl_combined_long_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrl_combined_long_c2.log" ]; then

  echo ""
  echo "                                    ======================================================"
  echo "                                                 CombinedLong test (75hrs max)"
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
  echo "=16 VMs + VM size ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  'Adding data'  | head -16
  echo ""
  echo "=16 VMs + VM size ( for 100phr w/ checksum )="
  cat $filename | grep -iE  'Adding data'  | tail -16
  echo ""
  echo ""
  echo ""


  # IP
  echo "=IP address ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  'got IP' | head -16
  echo ""
  echo "=IP address ( for 100phr w/ checksum )="
  cat $filename | grep -iE  'got IP' | tail -16
  echo ""
  echo ""
  echo ""


  # Deploying VMs start time
  echo "=Deploying VMs time ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  "Deploying VMs" | head -1
  echo ""
  echo "=Deploying VMs time ( for 100phr w/ checksum )="
  cat $filename | grep -iE  "Deploying VMs" | tail -1
  echo ""
  echo ""
  echo ""


  # ALL VMs Deployed time
  echo "=All VMs deployed time ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  "All VMs deployed" | head -1
  echo ""
  echo "=All VMs deployed time ( for 100phr w/ checksum )="
  cat $filename | grep -iE  "All VMs deployed" | tail -1
  echo ""
  echo ""
  echo ""


  # number of DD
  echo "=DD info ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  'dd if=/dev/zero' | head -16
  echo ""
  echo "=DD info ( for 100phr w/ checksum )="
  cat $filename | grep -iE  'dd if=/dev/zero' | tail -16
  echo ""
  echo ""
  echo ""


  # WB usuage
  echo "=WB Usage ( for 100r, 95phr, 99phr, 100phr, 100w )="
  cat $filename | grep -iE  'WB usage at' | head -1
  echo ""
  echo "=WB Usage ( for 100phr w/ checksum )="
  cat $filename | grep -iE  'WB usage at' | tail -1
  echo ""
  echo ""
  echo ""



  # Dynamo or IOBlazer or FIO
  echo "=IOMeter, Dynamo, IOBlazer, FIO="
  cat $filename | grep -iE  'Starting IOMeter runs|Iometer output|Running dynamo|running ioblazer|Starting FIO runs|RunFIOTest: All VM IO threads are completed'
  echo ""
  echo ""
  echo ""

  # 100r test
  echo "=100r test (3hr)="
  cat $filename | grep -iE  'Starting 100r test|100r test complete|Starting 100r0w test|100r0w test complete'
  StartTime100r="$(cat $filename | grep -iE 'Starting 100r test|Starting 100r0w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime100r="$(cat $filename | grep -iE '100r test complete|100r0w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime100r" "$EndTime100r" 
  echo ""
  echo ""
  echo ""

  # 70r30w 100% Hit rate test
  echo "=70r30w 100% test (4hrs)="
  cat $filename | grep -iE  'Starting 70r30w 100% hit rate|70r30w 100% hit rate test complete|Starting 70r30w test|70r30w test complete'
  StartTime70r30w100="$(cat $filename | grep -iE 'Starting 70r30w 100% hit rate|Starting 70r30w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w100="$(cat $filename | grep -iE '70r30w 100% hit rate test complete|70r30w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w100" "$EndTime70r30w100"
  echo ""
  echo ""
  echo ""

  # 70r30w 99% Hit rate test
  echo "=70r30w 99% test (4hrs)="
  cat $filename | grep -iE  'Starting 70r30w 99% hit rate|70r30w 99% hit rate test complete'
  StartTime70r30w99="$(cat $filename | grep -iE 'Starting 70r30w 99% hit rate' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w99="$(cat $filename | grep -iE '70r30w 99% hit rate test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w99" "$EndTime70r30w99"  
  echo ""
  echo ""
  echo ""

  #
  # 70r30w 95% Hit rate test
  echo "=70r30w 95% test(4hrs)="
  cat $filename | grep -iE  'Starting 70r30w 95% hit rate|70r30w 95% hit rate test complete'
  StartTime70r30w95="$(cat $filename | grep -iE 'Starting 70r30w 95% hit rate' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30w95="$(cat $filename | grep -iE '70r30w 95% hit rate test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30w95" "$EndTime70r30w95"
  echo ""
  echo ""
  echo ""

  # 100w test
  echo "=100w test (3 hrs)="
  cat $filename | grep -iE  'Starting 100w test|100w test complete|Starting 0r100w test|0r100w test complete'
  StartTime100w="$(cat $filename | grep -iE 'Starting 100w test|Starting 0r100w test' | sed '1,1!d' | cut -d, -f1)"
  EndTime100w="$(cat $filename | grep -iE '100w test complete|0r100w test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime100w" "$EndTime100w"
  echo ""
  echo ""
  echo ""


  # 70r30w 100% Hit rate with checksum test
  echo "=70r30w 100% Hit rate with checksum test (4 hrs)="
  cat $filename | grep -iE  'Starting 70r30w 100%  hit rate checksum|70r30w 100%  hit rate checksum test complete'
  StartTime70r30wChecksum="$(cat $filename | grep -iE 'Starting 70r30w 100%  hit rate checksum' | sed '1,1!d' | cut -d, -f1)"
  EndTime70r30wChecksum="$(cat $filename | grep -iE '70r30w 100%  hit rate checksum test complete' | sed '1,1!d' | cut -d, -f1)"
  echo ""
  printf "Completion time: "
  timediff "$StartTime70r30wChecksum" "$EndTime70r30wChecksum"
  echo ""
  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""
  echo ""
  echo ""

  # status
  echo "=Status="
  cat $filename | grep -iE 'vsan.iocert.ctrl_combined_long_c1...........................COMPLETED|vsan.iocert.ctrl_combined_long_c2...........................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "	Usage: hy-combinedlong.sh <filename>"
  echo ""
  echo "               example: sh hy-combinedlong.sh test-vpx.vsan.iocert.ctrl_combined_long_c1.log"
  echo ""
fi





