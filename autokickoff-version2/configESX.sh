#!/bin/bash

#
#   configESX.sh will tag capacity drives, install vendor utility, install driver, and install firmware
#
#   Usage: configESX.sh ESX_IP
#

PROG=`basename $0`

USERNAME=""
IPADDR=""
PASSWORD="ca\$hc0w"

usage() {
cat << EOF

   $PROG [flags]

   Flags that take arguments:
   -h|--help:
   -u|--username: ldap username
   -i|--ipaddress: IP



   Usage:

       $PROG -u <USERNAME> -i <ESX_IP> -t <TAGCAPACITY> -d <DRIVER> -v <VENDORUTILITY> -f <FIRMWARE>

EOF
}

while [ $# -ge 1 ]
do
  case "$1" in
   -h|--help)
      usage
      exit 0
      ;;
   -u|--username)
      shift
      USERNAME=$1
      ;;
   -i|--ipaddress)
      shift
      ESX_IP=$1
      ;;
   -t|--tagcapacity)
      shift
      TAGCAPACITY=$1
      ;;
   -ut|--untagcapacity)
      shift
      UNTAGCAPACITY=$1
      ;;
   -d|--driver)
      shift
      DRIVER=$1
      ;;
   -v|--vendorutility)
      shift
      VENDORUTILITY=$1
      ;;
   -f|--firmware)
      shift
      FIRMWARE=$1
      ;;
   -*)
      echo "Not implemented: $1" >&2
      exit 1
      ;;
   *)
      break
      exit 0
      ;;
  esac
  shift
done


tagCapacity() {
    printf "DRIVE(S) TO BE TAGGED AS CAPACITY: $TAGCAPACITY \n\n"
    counterForEachDrive=1;
    echo ""
    IFS=', '; read -ra tagDrives <<< "$1"
    printf "\nTag drive(s) as Capacity: \n"
    for j in "${tagDrives[@]}"
    do
          printf "${counterForEachDrive}: $j \n"
          esxcli vsan storage tag add -d "$j" -t capacityFlash
          counterForEachDrive=$(expr $counterForEachDrive + 1)
    done
    echo -e "\n"
    echo -e "== Output from 'vdq -q' after tagging the drive(s) == \n"
    vdq -q | grep -iE "Name|IsCapacityFlash|size\(mb\)"
    echo -e "\n"
}

untagCapacity() {
    printf "DRIVE(S) TO BE UNTAGGED: $UNTAGCAPACITY \n\n"
    counterForEachDrive=1;
    echo ""
    IFS=', '; read -ra untagDrives <<< "$1"
    printf "\nUnTag drive(s): \n"
    for j in "${untagDrives[@]}"
    do
          printf "${counterForEachDrive}: $j \n"
          esxcli vsan storage tag remove -d "$j" -t capacityFlash
          counterForEachDrive=$(expr $counterForEachDrive + 1)
    done
    echo -e "\n"
    echo -e "== Output from 'vdq -q' after un-tagging the drive(s) == \n"
    vdq -q | grep -iE "Name|IsCapacityFlash|size\(mb\)"
    echo -e "\n"
}

printf "\n\n"

if [ ! -z $TAGCAPACITY ]; then
    # tag capacity
    tagCapacity "$TAGCAPACITY"
    echo -e "\n\n"
fi

if [ ! -z $UNTAGCAPACITY ]; then
    # tag capacity
    untagCapacity "$UNTAGCAPACITY"
    echo -e "\n\n"
fi


if [ ! -z $DRIVER ]; then
    printf "DRIVER URL PATH + VIB FILE: $DRIVER \n\n"
    echo ""
    printf "Download $DRIVER to /tmp \n"
    cd /tmp
    wget "${DRIVER}"
    driverNAME=$(echo $DRIVER | sed 's/.*\///' )
    printf "Install driver... \n"
    #esxcli software vib install -v /tmp/"${driverNAME}"

    #-d '$DRIVER' -v '$VENDORUTILITY' -t '$FIRMWARE''
else
    printf "No driver to be installed... \n\n"
fi
