#!/bin/bash

dbcAndPXEINSTALLpath=$1

echo "Current OB-builds in PXEDEPLOY dir:"
echo "======="
find $dbcAndPXEINSTALLpath/. -maxdepth 1 -type d
echo "======="

chkISOCount=$(find $dbcAndPXEINSTALLpath/. -maxdepth 1 -type d -print| wc -l)

#
#  If there are more than 5 PXE images, remove the oldest PXE image
#
#
#  $chkISOCount-1 is needed bc find is treating ".." as a directory
#
chkISOCount=$(($chkISOCount-1))
if [ $chkISOCount -gt 5 ]; then
    removeDir=$(cd $dbcAndPXEINSTALLpath && ls -t1 | tail -n 1)
    echo -e "Remove $dbcAndPXEINSTALLpath/$removeDir dir"
    rm -rf $dbcAndPXEINSTALLpath/$removeDir
else
    printf "\nCleanup is not needed since you have less than 5 OB-builds\n\n"
fi
