
#!/bin/bash
# Version 0.10
#
#  Run this script in the parent location.  This script will traverse each test directory and execute logsummary-batch2.sh 
#  when test-vpx file is found. 
#

printf "\n\n"
echo "Please allow some time to scan the directory..."
echo ""

#getinfo 

find . -name "*getInfo*" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 


# allflash ------------------------------------------------------
find . -iname "*0r100w_long_4k_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*0r100w_long_64k_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*70r30w_long_50gb_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*70r30w_long_mdCap_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*100r0w_long_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*reset_af.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*reset_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*70r30w_long_mdCap_enc_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*data_integrity_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*7day_stress_af*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 

#--------------------------------------------------------------



# shortIO test only for hybrid and allflash -------------------
find . -iname "*short_io*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 

#--------------------------------------------------------------


# short test only for hybrid and allflash ---------------------
find . -iname "*0r100w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*10r90w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*30r70w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*50r50w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*70r30w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*90r10w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*100r0w_short.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 

#--------------------------------------------------------------


# hybrid -----------------------------------------------------
find . -iname "*70r30w_long_99phr_enc*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*combined_long_c1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*reset.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*reset*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "*7day_stress*.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 

#--------------------------------------------------------------



#HotPlug ------------------------------------------------------
find . -iname "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
find . -iname "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.lo" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.SSDDiskRemoveReinsertUnPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 
#find . -name "test-vpx.vsan.fvt.test.lsom.diskmanagement.magneticDiskRemoveReinsertUnPlanned_RAID1.log" -execdir sh -c  "pwd {} && logsummary-batch2.sh" ';'  | sort | uniq 

