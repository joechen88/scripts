#!/bin/bash

USERNAME=$1
timestamp=$2

echo "Installation completed.  Remove pxe-cfg-${USERNAME}-${timestamp} in /vsanhol-nfs-array/vsancert-pxe-cfg"
rm /vsanhol-nfs-array/vsancert-pxe-cfg/pxe-cfg-${USERNAME}-${timestamp}
