#!/bin/bash

usage()
{
cat << EOF

Log-summary

OPTIONS:
   -t      <type of test>
   -f      <vpx-host1-log-file or vpx-host2-log-file>

   <type of test>
   Hybrid:   hy-0r100w_short, hy-100r0w_short, hy-30r70w_short, hy-50r50w_short, hy-70r30w_short
             hy-7day, hy-90r10w_short, hy-combinedlong, hy-reset
  
   AllFlash: af-0r100w_long_4k, af-0r100w_long_64k, af-100r0w_long, af-70r30w_long_50gb
             af-70r30w_long_mdCap, af-7day, af-reset, af-0r100w_short, af-100r0w_short,
             af-10r90w_short, af-30r70w_short, af-50r50w_short, af-70r30w_short, af-90r10w_short 

   hotplug:  hotplug-MagneticDiskRemoveReinsertPlanned, hotplug-MagneticDiskRemoveReinsertUnplanned
             hotplug-SSDRemoveReinsertPlanned, hotplug-SSDRemoveReinsertUnplanned,
             hotplug-diskRemoveReinsertPlanned, hotplug-diskRemoveReinsertUnplanned                            
   

   Example 

      Usage: log-summary.sh -t hy-7day -f test-vpx.vsan.iocert_7day_stress_af_c1.log

EOF
}

if ( ! getopts "t:f:?:" option); then
  usage
  exit 1
else
  while getopts "t:n:f:" option;
  do
        case $option
        in
           t) 
             TESTTYPE=$OPTARG
             ;;
           f) 
             FILENAME=$OPTARG
             ;;
           ?) 
             usage
             exit 1
             ;;
        esac
  done

  if [ "$TESTTYPE" == "hybrid" ] && [ "$TESTAPP" == "70r30w" ]; then
     echo " hybrid & 70r30w " + $FILENAME 
  fi
fi
