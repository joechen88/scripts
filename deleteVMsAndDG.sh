#!/bin/sh 


removeESXHostDG()
{
   echo ""
   echo ""
   echo "Check diskgroup info"
   echo ""
   vdq -i
   
   chkNumOfDG="$(vdq -i | grep -i 'ssd')"
   if [ -z "$chkNumOfDG" ]; then
      break;
   else
     echo $chkNumOfDG
     if [ $chkNumOfDG -eq 1 ]; then
       DGINFOTMP="$(vdq -i | grep -i 'ssd')"
       DGINFO="$(echo $DGINFOTMP | awk '{print $3}' | cut -d, -f1)"
       echo ""
       echo "$DGINFO to be removed"
       esxcli vsan storage remove -s $DGINFO
       echo ""
       echo "Check diskgroup info"
       vdq -i
     else
       counter=1
       while [ $counter -le $chkNumOfDG ]; do
         #vdqcmd="vdq -i | grep -i 'ssd'| sed -n 1p"
         DGINFOTMP="$(vdq -i | grep -i 'ssd'| sed -n 1p)"
         DGINFO="$(echo $DGINFOTMP | awk '{print $3}' | cut -d, -f1)"
         echo ""
         echo "$DGINFO to be removed"
         esxcli vsan storage remove -s $DGINFO
         echo ""
         echo "Check diskgroup info"
         vdq -i
         let counter++
       done
     fi
   fi

#   chkNumOfDG="$(vdq -i | grep -c 'SSD')"
#   if [ $chkNumOfDG -ne 0 ]; then
#       devs=$(esxcfg-scsidevs -c | grep 'naa.*' | awk '{ORS=" "} {print $3}')
#       for i in $devs; do partedUtil getptbl \$i; done
#       for i in $devs; do  partedUtil mklabel \$i gpt; done
#       for i in $devs ; do  partedUtil getptbl \$i; done
#   fi

}


for i in $(vim-cmd vmsvc/getallvm | awk -F' ' '/[0-9]/{print $1}'); do vim-cmd vmsvc/power.off $i; vim-cmd vmsvc/unregister $i; done

removeESXHostDG
