#!/bin/bash

# check if logsummary directory exist in HOME

if [ ! -f "/usr/local/bin/logsummary.py" ]; then
   echo ""
   echo ""
   echo " Usage: execute logsummary-batch.sh in directory where all the text-vpx logs are located"
   echo "" 
   echo "  Note: Make sure "logsummary.py" exist!!! "       
   echo "                        "
   echo ""
   exit
else
   echo ""
   echo " logsummary.py exist! ........ [ OK ] " 
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

# getinfo ------------------------------------------------------------------------------------------------------------

if [ -f "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_getInfo_c1.log"
  getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c1.log > summary-ctrlr_getInfo_c1.log
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_getInfo_c2.log"
  getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c2.log > summary-ctrlr_getInfo_c2.log
  echo ""
fi


# allflash - performance --------------------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log -t 4k > summary-0r100w_long_4k_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log" ]; then 
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log -t 4k > summary-0r100w_long_4k_af_c2.txt 
  echo ""
fi
  
if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log -t 64k > summary-0r100w_long_64k_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log -t 64k > summary-0r100w_long_64k_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log -t 50gb > summary-70r30w_long_50gb_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log -t 50gb > summary-70r30w_long_50gb_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log -t mdCap > summary-70r30w_long_mdCap_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log -t mdCap > summary-70r30w_long_mdCap_af_c2.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log > -t af-100r0w > summary-100r0w_long_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log -t af-100r0w > summary-100r0w_long_af_c2.txt
  echo ""
fi


# allflash - reset -------------------------------------------------------#

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset_af.log -t reset > summary-ctrlr_reset_af.txt
  echo ""
fi


if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset_af_c1.log -t reset > summary-ctrlr_reset_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset_af_c2.log -t reset > summary-ctrlr_reset_af_c2.txt
  echo ""
fi


# allflash - short_IO -------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_short_io_c1.log -t shortio > summary-ctrlr_short_io_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_short_io_c2.log -t shortio > summary-ctrlr_short_io_c2.txt
  echo ""
fi


# allflash encryption-----------------------------------------------------------------------------
if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log -t af-enc > summary-ctrlr_70r30w_long_mdCap_enc_af_c1.txt  
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log -t af-enc > summary-ctrlr_70r30w_long_mdCap_enc_af_c2.txt 
  echo ""
fi

# hybrid encryption-----------------------------------------------------------------------------
if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log -t hy-enc > summary-ctrlr_70r30w_long_99phr_enc_c1.txt  
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log -t hy-enc > summary-ctrlr_70r30w_long_99phr_enc_c2.txt 
  echo ""
fi


# allflash - data-integrity --------------------------------------------------------------------- 

if [ -f "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log -t af-data-integrity > summary-ctrlr_data_integrity_af_c1.txt  
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log -t af-data-integrity > summary-ctrlr_data_integrity_af_c2.txt  
  echo ""
fi


# allflash - 7day ------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log -t 7day > summary-7day_stress_af_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log -t 7day > summary-7day_stress_af_c2.txt 
  echo ""
fi


# allflash and hybrid - shorts ------------------------------------------------------------------------ #

if [ -f "test-vpx.vsan.iocert.ctrl_0r100w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_0r100w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_0r100w_short.log -t short > summary-ctrl_0r100w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_10r90w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_10r90w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_10r90w_short.log -t short > summary-ctrl_10r90w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_30r70w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_30r70w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_30r70w_short.log -t short > summary-ctrl_30r70w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_50r50w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_50r50w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_50r50w_short.log -t short > summary-ctrl_50r50w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_70r30w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_70r30w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_70r30w_short.log -t short > summary-ctrl_70r30w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_90r10w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_90r10w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_90r10w_short.log -t short > summary-ctrl_90r10w_short.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_100r0w_short.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_100r0w_short.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_100r0w_short.log -t short > summary-ctrl_100r0w_short.txt
  echo ""
fi


# hybrid - combinedLong ------------------------------------------------------------------------ #

if [ -f "test-vpx.vsan.iocert.ctrl_combined_long_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_combined_long_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_combined_long_c1.log -t combinedLong > summary-ctrl_combined_long_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrl_combined_long_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrl_combined_long_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrl_combined_long_c2.log -t combinedLong > summary-ctrl_combined_long_c2.txt
  echo ""
fi


# hybrid - reset ------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_reset.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset.log -t reset > summary-ctrlr_reset.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset_c1.log -t reset > summary-ctrlr_reset_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_reset_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_reset_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_reset_c2.log -t reset > summary-ctrlr_reset_c2.txt	
  echo ""
fi

# hybrid - shortIO ----------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_short_io_c1.log -t shortio > summary-ctrlr_short_io_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_short_io_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_short_io_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_short_io_c2.log -t shortio > summary-ctrlr_short_io_c2.txt
  echo ""
fi

# hybrid - 7day -------------------------------------------------------------------------------- #

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log -t 7day > summary-ctrlr_7day_stress_c1.txt
  echo ""
fi

if [ -f "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log" ]; then
  echo "Found test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log"
  logsummary.py -f test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log -t 7day > summary-ctrlr_7day_stress_c2.txt
  echo ""
fi


# Hotplug 
if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log"
  logsummary.py -f test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log -t hp-planned > summary-diskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log"
  logsummary.py -f test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log -t hp-unplanned > summary-diskRemoveReinsertUnplanned.txt
  echo ""
fi


if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log"
  logsummary.py -f test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log -t hp-planned > summary-diskRemoveReinsertPlanned.txt
  echo ""
fi

if [ -f "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log" ]; then
  echo "Found test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log"
  logsummary.py -f test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log -t hp-unplanned > summary-diskRemoveReinsertUnplanned.txt
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
