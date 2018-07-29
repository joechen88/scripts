#!/bin/bash
echo "Current OB-builds in PXEDEPLOY/pxeinstall dir:"
echo "======="
stat -l * | awk '{ print $10 }'
echo "======="

chkISOCount=$(find . -maxdepth 1 -type d -print| wc -l)

if [[ $chkISOCount-1 -gt 3 ]]; then
    removeDir=$(ls -t1 | tail -n 1)
    echo -e "Remove \"$removeDir\" dir\n"
    rm -rf $removeDir
else
    printf "\nCleanup is not needed since you have less than 3 OB-builds\n\n"
fi
