#!/bin/bash
#version 0.50

deviceMaxQD=""

filename=$@
printf "\n"
echo "                                                         =============================================================== "
echo "                                                                                       Getinfo "
echo "                                                         =============================================================== "

printf "\n\n\n"
printf "Filename: "
echo $filename

printf "\n\n\n\n"
echo "=Host="
host=$(cat $filename | grep -iE "hosts reserved" | awk '{print $9}')
host=${host%?}    # %? to remove the last character in a variable
echo $host


printf "\n\n\n\n"
echo "=ESX version="
cat $filename | grep -iE "esx version" | sort | uniq


printf "\n\n\n\n"
echo "=Consumed disks"
cat $filename | grep -iE "consumed"


printf "\n\n\n\n"
echo "=Server info="
cat $filename | grep -iE  "server vendor name|server product name" | sed 's/-//g' | grep '[^[:blank:]]' | sed 's/==>/:/g' | perl -p -e 's/\n/\t\t\t\t/ if $.%2' | sort | uniq

printf "\n\n\n\n"
echo "=Controller="
cat $filename | grep -iE sas.500 | sort | uniq


printf "\n\n\n\n"
echo "=Controller Driver + VID:DID:SDID:SVID + queuedepth="
cat $filename | grep -i -B 4 "QDepth Current:Max" | sed 's/--//g'  | grep '[^[:blank:]]' | grep -iEv "Please see vendor utility output" | sed 's/        ==>/:/g' | sed 's/  ==>/:/g' |perl -p -e 's/\n/\t\t\t/ if $.%4' 

printf "\n\n\n\n"
echo "=Firmware / Firmware package version="
cat $filename | grep -iE  "firmware version|firmware package build" | sort | uniq


printf "\n\n\n\n"
echo "=Drives / expander / device queuedepth info="
deviceMaxQD=$(cat $filename | grep -wiE "[^.]Device Max Queue Depth:" | head -1)

if [[ "$deviceMaxQD" != "" ]]; then
        cat $filename | grep -wE  '[^.]Display|[^.]Size:|[^.]Vendor: |[^.]Model:|[^.]Device Max Queue Depth:'  |  perl -p -e 's/\n/ / if $.%4' | sort | uniq
else
	cat $filename | grep -wiE  '[^.]Device|[^.]Size:|[^.]Display|[^.]Vendor:|[^.]Model:'  | grep -iv "RunCmdOverSSHAndLog" | perl -p -e 's/\n/ / if $.%4' | sort | uniq
fi



printf "\n\n\n\n"
echo "=Disk Mapping="
cat $filename  | grep -iE "diskmapping"


printf "\n\n\n\n"
echo "=Drive In-Use for VSAN="
cat $filename | grep -B 5 -iE "in-use for vsan" | sed 's/--//g' | grep '[^[:blank:]]' | grep -viE "RunCmdOverSSHAndLog|ispdl" | perl -p -e 's/\n/ / if $.%4' | sort | uniq
echo ""
printf "Drive (In-Use for VSAN) Count: "
cat $filename | grep -B 5 -iE "in-use for vsan" | sed 's/--//g' | grep '[^[:blank:]]' | grep -viE "RunCmdOverSSHAndLog|ispdl" | perl -p -e 's/\n/ / if $.%4' | sort | uniq | grep -ic "in-use for vsan"


printf "\n\n\n\n"
echo "=Drive with partitions="
#cat $filename | grep -B 5 -iE "Has Partitions" | sed 's/--//g' | grep '[^[:blank:]]' | grep -viE "RunCmdOverSSHAndLog|ispdl" | perl -p -e 's/\n/ / if $.%5'  | sort | uniq
cat $filename | grep -A5 -B5 -iE "has partitions" | grep -iE "Name:|State:|Reason:" |  perl -p -e 's/\n/ / if $.%3' | sort | uniq
echo ""
printf "Drive (with partitions) Count: "
cat $filename | grep -A5 -B5 -iE "has partitions" | grep -iE "Name:|State:|Reason:" |  perl -p -e 's/\n/ / if $.%3' | sort | uniq | grep -iEc "has partitions" 


printf "\n\n\n\n"
echo "=Bootbank=" 
cat $filename | grep -i -A 8  bootbank


