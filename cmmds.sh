#!/bin/bash


USER=$1
HOST=$2

usage()
{
cat << EOF

Description: Obtain DOM_OBJECT and DISK info to get a VSAN perspective

Usage: cmmds <username> <esx-host>

EOF
}

if [ $# -eq 2 ]; then

  CMD1="cmmds-tool find --format json -t DOM_OBJECT"
  CMD2="cmmds-tool find --format json -t DISK"

  echo ""
  echo ""
  echo "CMMDS – Cluster Monitoring, Membership, and Directory Service tool"
  echo ""

  printf "Enter password for the host: "
  read -s password
  echo ""  
  echo ""
  echo ">>> search for DOM_OBJECT <<<"
  echo ""
  sshpass -p $password ssh $USER@$HOST $CMD1
  echo ""
  echo ">>>  search for DISK <<<"
  echo ""
  sshpass -p $password ssh $USER@$HOST $CMD2
  echo ""
else
  usage
  exit 1
fi
  
