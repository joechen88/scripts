#!/bin/bash

###################################################################################################################################
# 
#   DESCRIPTION : Collect esx disk info, vsan disk/domObject, disk info from hp utility, and remove diskgroup in ESX
#
#   NOTE:
#   SSHPass is a tiny utility, which allows you to provide the ssh password without using the prompt.
#   This will very helpful for scripting.
#
#   Installing on Ubuntu
#
#   apt-get install sshpass
#
#   Installing on OS X
#
#   Installing on OS X is tricky, since there is no official build for it. Before you get started, you need install xcode and command line tools.
#   Installing with Homebrew
#
#   Homebrew does not allow you to install sshpass by default. But you can use the following unofficial brew package for that.
#
#   brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
#
#   -JC
####################################################################################################################################

#color
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
nc=`tput sgr0`   #no color

USER=$1
HOST=$2
TOOLTYPE=$3

usage()
{
cat << EOF

Usage: hostvsan-util.sh <username> <esx-host> <Option>

Description: Obtain esx disk info, vsan disk/domObject, disk info from vendor utility, check expiration on ESX host, 
             get driver info and remove diskgroup in ESX

Option: hp, removedg, getdriverinfo, chkexp, 10gignic

EOF
}

hp()
{
  CMD1="cmmds-tool find --format json -t DOM_OBJECT"
  CMD2="cmmds-tool find --format json -t DISK"
  CMD3="vdq -i"
  CMD4="vdq -q"
  CMD5="esxcfg-scsidevs -c"
  CMD6="esxcfg-scsidevs -l"
  CMD7="/opt/hp/hpssacli/bin/hpssacli controller all show "
  printf "Enter password for the host: "
  read -s password

  echo ""  
  echo ""
  echo "${red}VSAN PERSPECTIVE.......${nc}"
  echo ""
  echo ""

  echo "${blue}>>> VSAN - DOM_OBJECT INFO <<<${nc}"
  echo ""
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD1
  echo ""

  echo "${blue}>>> VSAN - DISK INFO <<<${nc}"
  echo ""
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD2
  echo ""

  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo "${red}ESX DISK INFO.......${nc}"
  echo ""
  echo ""

  echo "${blue}>>> vdq -i <<<${nc}"
  echo ""
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD3
  echo ""

  echo "${blue}>>> vdq -q <<<${nc}"
  echo ""
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD4
  echo ""
  echo ""

  echo "${blue}>>> esxcfg-scsidevs -c <<<${nc}"
  echo ""
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD5
  echo ""
  echo ""
  
  echo "${blue}>>> esxcfg-scsidevs -l <<<${nc}"
  echo "" 
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD6
  echo ""

  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo "${red}HP TOOL........${nc}"
  echo ""  
  echo ""

  echo "${blue}>>> hpssacli disk show config <<<${nc}"
  SLOTNUM="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD7 | awk '{print $6}' | sed -n 2p)"
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "/opt/hp/hpssacli/bin/hpssacli controller slot=$SLOTNUM show config"
  echo ""

  echo "${blue}>>> hpssacli disk show  <<<${nc}"
  SLOTNUM="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD7 | awk '{print $6}' | sed -n 2p)"
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "/opt/hp/hpssacli/bin/hpssacli controller slot=$SLOTNUM show"
  echo ""

  echo "${blue}>>> hpssacli physicaldrive show all <<<${nc}"
  SLOTNUM="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD7 | awk '{print $6}' | sed -n 2p)"
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "/opt/hp/hpssacli/bin/hpssacli controller slot=$SLOTNUM physicaldrive all show"
  echo ""

  echo "${blue}>>> hpssacli disk physicaldrive show detail <<<${nc}"
  SLOTNUM="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $CMD7 | awk '{print $6}' | sed -n 2p)"
  sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "/opt/hp/hpssacli/bin/hpssacli controller slot=$SLOTNUM physicaldrive all show detail"
  echo ""

}

chkexp()
{
   echo ""
   printf "Enter password for the host: "
   read -s password
   echo ""
   echo ""
   echo "Check Expiration..."
   echo ""
   chkExp='vim-cmd vimsvc/license --show | grep -iE "name|date|expiration|Product Version|fileversion"'
   sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $chkExp
}

removeESXHostDG()
{
   echo ""
   printf "Enter password for the host: "
   read -s password
   echo ""
   echo ""
   echo "Check diskgroup info"
   echo ""
   sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST vdq -i
   vdqcmd="vdq -i | grep -i 'ssd'"
   chkNumOfDG="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST vdq -i | grep -c 'SSD')"
   echo $chkNumOfDG
   if [ $chkNumOfDG -eq 1 ]; then
     DGINFOTMP="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $vdqcmd)"
     DGINFO="$(echo $DGINFOTMP | awk '{print $3}' | cut -d, -f1)" 
     echo ""
     echo "$DGINFO to be removed"
     sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "esxcli vsan storage remove -s $DGINFO" 
     echo ""
     echo "Check diskgroup info"
     sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST vdq -i
   else
     counter=1
     while [ $counter -le $chkNumOfDG ]; do
       vdqcmd="vdq -i | grep -i 'ssd'| sed -n 1p"
       DGINFOTMP="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $vdqcmd)"
       DGINFO="$(echo $DGINFOTMP | awk '{print $3}' | cut -d, -f1)"
       echo ""
       echo "$DGINFO to be removed"
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "esxcli vsan storage remove -s $DGINFO"
       echo ""
       echo "Check diskgroup info"
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST vdq -i		
       let counter++
     done
   fi

   chkNumOfDG="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST vdq -i | grep -c 'SSD')"
   if [ $chkNumOfDG -ne 0 ]; then
       devs=$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "esxcfg-scsidevs -c" | grep 'naa.*' | awk '{ORS=" "} {print $3}')
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "for i in $devs; do partedUtil getptbl \$i; done"
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "for i in $devs; do  partedUtil mklabel \$i gpt; done"
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "for i in $devs ; do  partedUtil getptbl \$i; done"
   fi
}

getdriverinfo()
{
    echo ""
    printf "Enter password for the host: "
    read -s password
    echo ""
    echo ""
    echo "Driver info"
    echo ""
    sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcfg-scsidevs -a | grep -iE "lsi_msgpt3|megaraid_sas|lsi_mr3|hpsa|aacraid|nhpsa|nvme"'
    echo ""
    cmd='esxcfg-scsidevs -a | grep -iE "lsi_msgpt3|megaraid_sas|lsi_mr3|hpsa|aacraid|nhpsa|nvme" | awk "{print \$2}"'
    driverName="$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST $cmd)"
    for i in $driverName
    do
      echo " Driver: " $i
      sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST "vmkload_mod -s $i | grep -iE 'version|input file'"
      echo ""
    done
    echo ""
    echo "Modules load at boot time:"
    sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcfg-module -q | grep -iE "lsi_msgpt3|megaraid_sas|lsi_mr3|hpsa|aacraid|nhpsa|nvme"' 
    echo ""
}

10gignic()
{
    echo ""
    printf "Enter password for the host: "
    read -s password
    echo ""
    echo ""
    echo "10gig NIC info"
    echo ""
    #get a count of all 10gig nics
    get10gigNicCount=$(sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST  'esxcfg-nics -l | grep -i "10000Mbps" | wc -l')
    echo ""
    if [ $get10gigNicCount -eq 1 ]; then
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST esxcfg-nics -l | grep -i "10000Mbps"
       echo ""
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network ip interface list'
       echo ""
       echo "------"
       echo ""
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network ip interface ipv4 get'
       echo ""
       echo "------"
       echo ""
       sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network vswitch standard list'
    else
       c=1
       while [ $c -le $get10gigNicCount ]; do
         sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST esxcfg-nics -l | grep -i "10000Mbps" | sed -n ${c}p
         echo ""
         let c++
       done
         echo ""
         sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network ip interface list' 
         echo ""
         echo "------"
         echo ""
         sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network ip interface ipv4 get' 
         echo ""
         echo "------"
         echo ""
         sshpass -p $password ssh -o "StrictHostKeyChecking no" $USER@$HOST 'esxcli network vswitch standard list'
       
    fi
}

if [ $# -eq 3 ]; then
  if [ "hp" == "$TOOLTYPE" ] || [ "HP" == "$TOOLTYPE" ]; then
        hp
  fi

  if [ "removedg" == "$TOOLTYPE" ] || [ "REMOVEDG" == "$TOOLTYPE" ]; then
        removeESXHostDG
  fi 

  if [ "chkexp" == "$TOOLTYPE" ] || [ "CHKEXP" == "$TOOLTYPE" ]; then
        chkexp
  fi

  if [ "getdriverinfo" == "$TOOLTYPE" ] || [ "GETDRIVERINFO" == "$TOOLTYPE" ]; then
        getdriverinfo
  fi
 
  if [ "10gignic" == "$TOOLTYPE" ] || [ "10GIGNIC" == "$TOOLTYPE" ]; then
        10gignic
  fi
else
  usage
  exit 1
fi 
