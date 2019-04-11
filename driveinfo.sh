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


driveInfo() {

   vdq -qH | grep -iE "$1" ; vdq -qH | grep -A 5 -iE "$1" | grep -iE "State|IsSSD|iscapacity" ; \
   esxcfg-scsidevs -l | grep -A 7 -iE "$1" | grep -iE "Model|Size"

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
