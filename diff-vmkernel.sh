#!/bin/bash

DATE1=$1 
TIME1=$2
DATE2=$3
TIME2=$4
T="T"
FIRSTDT=$DATE1$T$TIME1
SECONDDT=$DATE2$T$TIME2

usage()
{
cat << EOF

           Usage: ./diff-vmkernel.sh <first-date-time> <second-date-time>  vmkernel-full.log  <output_filename>
                  If filename not provided, output file will default to "vmkernel_TMP.log"

EOF
}

if [[ $# -lt 5 ]] || [[ $# -gt 6 ]]; then
	usage
	exit 0

elif [[ $# -eq 5 ]]; then
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
		awk '$0 >= "'${FIRSTDT}'" && $0 <= "'${SECONDDT}'"' $5 > vmkernel_TMP-${FIRSTDT}-${SECONDDT}.log
		printf "\n\n"
		echo " Truncate vmkernel log to specific date/time"
		echo ""
		echo "        Date/Time: $FIRSTDT"
		echo "        Date/Time: $SECONDDT"
		printf "     File created: vmkernel_TMP-<date-time>-<date-time>.log"
		printf "\n             Size: "
		du -h vmkernel_TMP-${FIRSTDT}-${SECONDDT}.log | awk '{print $1}'
		printf "\n\n"
	else
		usage
		exit 0
	fi

else 
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
		awk '$0 >= "'${FIRSTDT}'" && $0 <= "'${SECONDDT}'"' $5 > $6
		printf "\n\n"
		echo " Truncate vmkernel log to specific date/time"
		echo ""
		echo "        Date/Time: $FIRSTDT"
		echo "        Date/Time: $SECONDDT"
		printf "     File created: $6"
		printf "\n             Size: "
		du -h $6 | awk '{print $1}'
		printf "\n\n"
	else
		usage
		exit 0
	fi
fi
