#!/bin/bash

dbcpath=$1

echo "Current OB-builds in PXEDEPLOY/pxeinstall dir:"
echo "======="
find $dbcpath -maxdepth 1 -type d
echo "======="

chkISOCount=$(find $dbcpath/. -maxdepth 1 -type d -print| wc -l)

#
#  $chkISOCount-1 is needed bc find is treating ".." as a directory
#
if [[ $chkISOCount-1 -gt 3 ]]; then
    removeDir=$(cd $dbcpath && ls -t1 | tail -n 1)
    echo -e "Remove \"$removeDir\" dir\n"
    rm -rf $removeDir
else
    printf "\nCleanup is not needed since you have less than 3 OB-builds\n\n"
fi
