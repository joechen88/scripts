#!/bin/sh

VERSION=1.036

###############################################################################
#.
# Log summary for hy-7day
#
# Functions:
#   Collect a summary for 7day test.
#
# Note: Dateutils are a bunch of tools that revolve around fiddling with dates and times
#       http://www.fresse.org/dateutils/
#
#       Install on linux 
#       
#        Download dateutils-0.4.0.tar.xz, configure, make, make install
#
#       Install on mac
#
#        brew install dateutils 
###############################################################################

filename=$1


timediff()
{
   python calctime.py "$1" "$2"
}


if [ "$filename" == "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log" ] || [ "$filename" == "test-vpx.vsan.iocert.ctrlr_7day_stress.log" ]; then

  echo ""
  echo "                                    ==========================================="
  echo "                                          7day (174 hrs max or 7.25 days)"
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

  #16 VMs + VM size
  echo "=16 VMs + VM size="
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


  # Dynamo or ioblazer OIO
  echo "=Dynamo or IOBlazer="
  cat $filename | grep -iE  'Running dynamo|Running ioblazer'
  echo ""
  echo ""

  # Test cycles
  echo "=Number of test days="
  cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day'
  echo ""
  d11="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '1,1!d' | cut -d, -f1)"
  d12="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '2,2!d' | cut -d, -f1)"
  printf "day1: "
  timediff "$d11" "$d12"
  d21="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '3,3!d' | cut -d, -f1)"
  d22="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '4,4!d' | cut -d, -f1)"
  printf "day2: "
  timediff "$d21" "$d22"
  d31="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '5,5!d' | cut -d, -f1)"
  d32="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '6,6!d' | cut -d, -f1)"
  printf "day3: "
  timediff "$d31" "$d32"
  d41="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '7,7!d' | cut -d, -f1)"
  d42="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '8,8!d' | cut -d, -f1)"
  printf "day4: "
  timediff "$d41" "$d42"
  d51="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '9,9!d' | cut -d, -f1)"
  d52="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '10,10!d' | cut -d, -f1)"
  printf "day5: "
  timediff "$d51" "$d52"
  d61="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '11,11!d' | cut -d, -f1)"
  d62="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '12,12!d' | cut -d, -f1)"
  printf "day6: "
  timediff "$d61" "$d62"
  d71="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '13,13!d' | cut -d, -f1)"
  d72="$(cat $filename | grep -iE  'Starting iometer for a day|iometer run complete|starting ioblazer for a day|ioblazer run complete|Starting FIO runs|RunIoForDays: IO for day' | sed '14,14!d' | cut -d, -f1)"
  printf "day7: "
  timediff "$d71" "$d72"

  echo ""
  echo ""

  # cleanup
  echo "=Cleanup="
  cat $filename | grep -iE  'DestroyVms|destroyallvms|removeallvsandisks'
  cat $filename | grep -iE  'Cleaning up any VSAN config'
  echo ""
  echo ""

  # status
  echo "=status="
  cat $filename | grep -iE 'vsan.iocert.ctrlr_7day_stress_c1............................COMPLETED|vsan.iocert.ctrlr_7day_stress_c2............................COMPLETED|vsan.iocert.ctrlr_7day_stress...............................COMPLETED'
  echo ""
  echo ""
else
  echo ""
  echo "  Usage: hy-7day.sh <filename>"
  echo ""
  echo "               example: sh hy-7day.sh test-vpx.vsan.iocert_7day_c1.log"
  echo ""
fi
