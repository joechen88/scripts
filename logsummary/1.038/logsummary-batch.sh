#!/bin/bash

# check if logsummary directory exist in HOME

if [ ! -d ~/logsummary ]; then
   echo ""
   echo ""
   echo " Usage: execute logsummary-batch.sh in directory where all the text-vpx logs are located"
   echo "" 
   echo "  Note: Make sure "logsummary" is in your home directory !!! "       
   echo "                        ie.  ~/logsummary"
   echo ""
   exit
else
   echo ""
   echo " ~/logsummary exist! ........ [ OK ] " 
   echo ""
fi

# get a copy of the original PATH
originalPath=$PATH

#set logsummary path to existing PATH
#
# Note: ensure to put logsummary in your home directory.  ie.  ~/
#
export PATH=$PATH:~/logsummary:~/logsummary/allflash:~/logsummary/hotplug:~/logsummary/hybrid

echo ""
echo "Add PATH: "
echo $PATH
echo ""
echo ""
echo ""

# allflash - performance --------------------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log"
  af-0r100w_long_4k.sh test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log > summary-0r100w_long_4k_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log" ]; then 
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log"
  af-0r100w_long_4k.sh test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log > summary-0r100w_long_4k_af_c2.txt 
  echo ""
fi
  
if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log"
  af-0r100w_long_64k.sh test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log > summary-0r100w_long_64k_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log"
  af-0r100w_long_64k.sh test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log > summary-0r100w_long_64k_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log"
  af-70r30w_long_50gb.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log > summary-70r30w_long_50gb_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log"
  af-70r30w_long_50gb.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log > summary-70r30w_long_50gb_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log"
  af-70r30w_long_mdCap.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log > summary-70r30w_long_mdCap_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log"
  af-70r30w_long_mdCap.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log > summary-70r30w_long_mdCap_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log"
  af-100r0w_long.sh test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log > summary-100r0w_long_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log"
  af-100r0w_long.sh test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log > summary-100r0w_long_af_c2.txt
  echo ""
fi


if [ -f "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log"
  af-data-integrity.sh test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log > summary-ctrlr_data_integrity_af_c1.log
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log"
  af-data-integrity.sh test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log > summary-ctrlr_data_integrity_af_c2.log
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log"
  af-ctrlr_70r30w_long_mdCap_enc.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log > summary-ctrlr_70r30w_long_mdCap_enc_af_c1.log
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log"
  af-ctrlr_70r30w_long_mdCap_enc.sh test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log > summary-ctrlr_70r30w_long_mdCap_enc_af_c2.log
  echo ""
fi

# allflash - reset -------------------------------------------------------#

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af.log"
  af-reset.sh test-vpx.vsan.iocert.ctrlr_reset_af.log > summary-ctrlr_reset_af.txt
  echo ""
fi


if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af_c1.log"
  af-reset.sh test-vpx.vsan.iocert.ctrlr_reset_af_c1.log > summary-ctrlr_reset_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af_c2.log"
  af-reset.sh test-vpx.vsan.iocert.ctrlr_reset_af_c2.log > summary-ctrlr_reset_af_c2.txt
  echo ""
fi


# allflash - short_IO -------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c1.log"
  af-short_io.sh test-vpx.vsan.iocert.ctrlr_short_io_c1.log > summary-ctrlr_short_io_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c2.log"
  af-short_io.sh test-vpx.vsan.iocert.ctrlr_short_io_c2.log > summary-ctrlr_short_io_c2.txt
  echo ""
fi


# allflash - 7day ------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log"
  af-7day.sh test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log > summary-7day_stress_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log"
  af-7day.sh test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log > summary-7day_stress_af_c2.txt 
  echo ""
fi


# allflash and hybrid - shorts ------------------------------------------------------------------------ #

if [ -f "test-vpx.vsan.iocert.ctrl_0r100w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_0r100w_short.log"
  af-0r100w_short.sh test-vpx.vsan.iocert.ctrl_0r100w_short.log > summary-ctrl_0r100w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_10r90w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_10r90w_short.log"
  af-10r90w_short.sh test-vpx.vsan.iocert.ctrl_10r90w_short.log > summary-ctrl_10r90w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_30r70w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_30r70w_short.log"
  af-30r70w_short.sh test-vpx.vsan.iocert.ctrl_30r70w_short.log > summary-ctrl_30r70w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_50r50w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_50r50w_short.log"
  af-50r50w_short.sh test-vpx.vsan.iocert.ctrl_50r50w_short.log > summary-ctrl_50r50w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_70r30w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_70r30w_short.log"
  af-70r30w_short.sh test-vpx.vsan.iocert.ctrl_70r30w_short.log > summary-ctrl_70r30w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_90r10w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_90r10w_short.log"
  af-90r10w_short.sh test-vpx.vsan.iocert.ctrl_90r10w_short.log > summary-ctrl_90r10w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_100r0w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_100r0w_short.log"
  af-100r0w_short.sh test-vpx.vsan.iocert.ctrl_100r0w_short.log > summary-ctrl_100r0w_short.txt
  echo ""
fi


# hybrid - combinedLong ------------------------------------------------------------------------ #

if [ -f "test-vpx.vsan.iocert.ctrl_combined_long_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_combined_long_c1.log"
  hy-combinedlong.sh test-vpx.vsan.iocert.ctrl_combined_long_c1.log > summary-ctrl_combined_long_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_combined_long_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_combined_long_c2.log"
  hy-combinedlong.sh test-vpx.vsan.iocert.ctrl_combined_long_c2.log > summary-ctrl_combined_long_c2.txt
  echo ""
fi


# hybrid - reset ------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_reset.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset.log"
  hy-reset.sh test-vpx.vsan.iocert.ctrlr_reset.log > summary-ctrlr_reset.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_c1.log"
  hy-reset.sh test-vpx.vsan.iocert.ctrlr_reset_c1.log > summary-ctrlr_reset_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_c2.log"
  hy-reset.sh test-vpx.vsan.iocert.ctrlr_reset_c2.log > summary-ctrlr_reset_c2.txt	
  echo ""
fi

# hybrid - shortIO ----------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c1.log"
  hy-short_io.sh test-vpx.vsan.iocert.ctrlr_short_io_c1.log > summary-ctrlr_short_io_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c2.log"
  hy-short_io.sh test-vpx.vsan.iocert.ctrlr_short_io_c2.log > summary-ctrlr_short_io_c2.txt
  echo ""
fi

# hybrid - 7day -------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log"
  hy-7day.sh test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log > summary-ctrlr_7day_stress_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log"
  hy-7day.sh test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log > summary-ctrlr_7day_stress_c2.txt
  echo ""
fi


# Hotplug 
if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log"
  hotplug-diskRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log > summary-diskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log"
  hotplug-diskRemoveReinsertUnplanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log > summary-diskRemoveReinsertUnplanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log"
  hotplug-diskRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log > summary-af_diskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log"
  hotplug-diskRemoveReinsertUnplanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log > summary-af_diskRemoveReinsertUnplanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertPlanned_RAID1.log"
  hotplug-SSDRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertPlanned_RAID1.log > summary-SSDDiskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertUnPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertUnPlanned_RAID1.log"
  hotplug-SSDRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertUnPlanned_RAID1.log > summary-SSDDiskRemoveReinsertUnPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertPlanned_RAID1.log"
  hotplug-MagneticDiskRemoveReinsertPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertPlanned_RAID1.log > summary-magneticDiskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertUnPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertUnPlanned_RAID1.log"
  hotplug-MagneticDiskRemoveReinsertUnPlanned.sh test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertUnPlanned_RAID1.log > summary-magneticDiskRemoveReinsertUnPlanned.txt
  echo ""
fi


#remove logsummary path
PATH=$originalPath
export PATH=$PATH
echo ""
echo "Revert PATH"
echo $PATH
echo ""
