#!/bin/bash

#
#   create-pxe-cfg.sh will generate a pxe-cfg file w/ a timestamp and store it in /vsanhol-nfs-array/vsancert-pxe-cfg location
#       
#   Usage: create-pxe-cfg.sh IP-address hostname gateway netmask vmnic nameserver timestamp 
#

USERNAME=$1
IPADDR=$2
HN=$3
GW=$4
NETMASK=$5
VMNIC=$6
NAMESERVER=$7
TIMESTAMP=$8

cat >> /vsanhol-nfs-array/vsancert-pxe-cfg/pxe-cfg-${USERNAME}-${TIMESTAMP} << EOF 
#Accept the VMware End User License Agreement 
vmaccepteula 
# Set the root password for the DCUI and Tech Support Mode
rootpw ca\$hc0w
# Choose the first discovered disk to install onto
install --firstdisk=usb,esx,local,remote --ignoressd --overwritevmfs --novmfsondisk
#--overwritevmfs --novmfsondisk
#--preservevmfs
# Set the network to DHCP on the first network adapater
network --bootproto=static --ip=${IPADDR} --gateway=${GW} --netmask=${NETMASK} --hostname=${HN} --device=${VMNIC} --addvmportgroup=1 --nameserver=${NAMESERVER}
%post --interpreter=python --ignorefailure=true
import time
import os
stampFile = open('/finished.stamp', mode='w')
stampFile.write( time.asctime() )
os.system("localcli network firewall set -e false")
EOF

printf "\nkickstart file created in /vsanhol-nfs-array/vsancert-pxe-cfg/pxe-cfg-${USERNAME}-${TIMESTAMP} \n\n"
