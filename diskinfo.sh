#!/bin/bash

usage()
{
cat << EOF

           Usage: sh driveinfo.sh <ad|dg>
                     ad = list all disks
                     dg = list disks from vsan diskgroup

                  example:
                         sh driveinfo.sh dg
EOF
}

#
#
#  replace carriage return w/ a TAB when issuing a grep -> awk 'ORS=NR%2?" ":"\n"' 
#  - get each drive, 
#
driveInfo() {

   vdq -qH | grep -iE "$1" | awk 'ORS=NR%2?" ":"\n"' ; \
   vdq -qH | grep -A 5 -iE "$1" | grep -iE "State" | awk 'ORS=NR%2?" ":"\n"' ; \
   vdq -qH | grep -A 5 -iE "$1" | grep -iE "IsSSD" | awk 'ORS=NR%2?" ":"\n"' ; \
   vdq -qH | grep -A 5 -iE "$1" | grep -iE "iscapacity" | awk 'ORS=NR%2?" ":"\n"' ; \
   esxcfg-scsidevs -l | grep -A 7 -iE "$1" | grep -iE "Model" | awk 'ORS=NR%2?" ":"\n"' ; 
   esxcfg-scsidevs -l | grep -A 7 -iE "$1" | grep -iE "size" | awk 'ORS=NR%2?" ":"\n"' ;  
   esxcfg-scsidevs -A | grep -iE "$1" | awk '{print $1}'
}


if [[ $# != 1 ]]; then
        usage
        exit 0
else

   IFS=$'\n'
   if [ $1 == "ad" ]; then
        driveInfoArray=$(vdq -qH | grep -iE "mpx|naa|t10" | awk '{print $2}')
   fi

   if [ $1 == "dg" ]; then
        esxcfg-scsidevs -a
        vdq -iH
        driveInfoArray=$(vdq -iH | grep -iE "ssd|md" | awk '{print $2}')
   fi
   #echo $driveInfoArray
   IFS=$'\n'
   j=1

   for i in `echo "$driveInfoArray"`
      do
           echo "--------------------" ;
           echo $j ;
           driveInfo $i ;
           echo "--------------------" ;
           let j++ ;
   done
fi

