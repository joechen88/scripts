#!/bin/sh
#
# This script runs Workbench VA in the nimbus.
#

PROG=`basename $0`

TMP_VAOS_FILE=/tmp/$$-vaos
GUEST_VAOS_PATH=/opt/vmware/etc/init.d/vaos

TMP_WB_VMWARE_PROXY_PREFS=/tmp/$$-proxy.prefs
cat > $TMP_WB_VMWARE_PROXY_PREFS << EOF
eclipse.preferences.version=1
nonProxiedHosts=10.*|*.vmware.com|localhost|127.0.0.1
org.eclipse.core.net.hasMigrated=true
proxyData/HTTP/hasAuth=false
proxyData/HTTP/host=proxy.vmware.com
proxyData/HTTP/port=3128
proxyData/HTTPS/hasAuth=false
proxyData/HTTPS/host=proxy.vmware.com
proxyData/HTTPS/port=3128
systemProxiesEnabled=false
EOF

PATH=/build/apps/bin:${PATH}
export PATH

NIMBUS_POD=vsan-cert-02
nimbus_rvc=/mts/git/bin/nimbus-rvc
nimbus_ovfdeploy=/mts/git/bin/nimbus-ovfdeploy

BUILD=""
LEASE=7
NAME=""
PLUGIN_BUILD=""

while [ $# -ge 2 ]
do
   case "$1" in
      -h|--help) cat <<EOF
$PROG [flags] buildNumber
Flags that take arguments:
-l/--lease: Start out with this number of days lease on this machine.
-n/--name: use this as the machines name.

Sample commands:
$PROG workBench-Build vsanPlugin-Build
$PROG 3342675
$PROG --name t1 3342675
$PROG -n devkit -l 3 sb-3342675

After running this command, look for files named name-date.log and
name-date.txt.  The txt file hold commands useful to managing the
created WB VMs.
EOF
      exit 0
      ;;
      -l|--lease)
         shift
         LEASE=$1
         ;;
      -n|--name)
         shift
         NAME=$1
         ;;
      -*)
         echo "Not implemented: $1" >&2
         exit 1
         ;;
      *)
         #if [ -n "$BUILD" ]
         #then
         #   echo "Multiple build numbers are specified." >&2
         #   exit 1
         #fi
         BUILD=$1
	 PLUGIN_BUILD=$2
         ;;
   esac
   shift
done

echo "WB Build = " $BUILD
echo "Plugin Build = " $PLUGIN_BUILD

# Validate the build
if [ "$BUILD" = "" ]
then
   echo "No build is specified." >&2
   exit 1
fi

echo $BUILD | grep -e '\(sb-\|ob-\|\)[0-9][0-9][0-9][0-9]*' > /dev/null
if [ $? != 0 ]
then
   echo "The build must be ob-number, sb-number, or number." >&2
   exit 1
fi

case "$BUILD" in
   sb*|ob*)
      KIND=`echo $BUILD | awk -F- '{print $1}'`
      BUILDNUM=`echo $BUILD | awk -F- '{print $2}'`
      ;;
   *)
      KIND=ob
      BUILDNUM=$BUILD
      ;;
esac
KIND_OPT="-k $KIND"

case "$PLUGIN_BUILD" in
   sb*|ob*)
      PLUGIN_KIND=`echo $PLUGIN_BUILD | awk -F- '{print $1}'`
      PLUGIN_BUILDNUM=`echo $PLUGIN_BUILD | awk -F- '{print $2}'`
      ;;
   *)
      PLUGIN_KIND=ob
      PLUGIN_BUILDNUM=$PLUGIN_BUILD
      ;;
esac
PLUGIN_KIND_OPT="-k $PLUGIN_KIND"



echo "WORKBENCH BUILD = " $BUILDNUM
echo "PLUGIN BUILD = " $PLUGIN_BUILDNUM
# Find the ovf file for WBVA
OVFFILE=`bld $KIND_OPT find ${BUILDNUM} | grep -e 'VMware-Workbench-.*_OVF10.ovf$'`
echo "OVF FILE = " $OVFFILE

PLUGIN_FILE=`bld $PLUGIN_KIND_OPT find ${PLUGIN_BUILDNUM} | grep -e UpdateSite-Vsanio67`
echo "Plugin File = " $PLUGIN_FILE
#exit 1

if [ x$OVFFILE = "x" ]
then
   echo "Could not find the VMWB ovf file for the build ${KIND}-${BUILDNUM}." >&2
   exit 1
fi

if [ ! -f $OVFFILE ]
then
   # Try replacing /build with /bldmnt.
   OVFFILE=`echo $OVFFILE | sed -e 's/^\/build\//\/bldmnt\//'`
   if [ ! -f $OVFFILE ]
   then
      echo "Could not find the VMWB ovf file for the build ${K}-${BUILDNUM}." >&2
      exit 1
   fi
fi


# ID is the name of this VM.  Use name if set, use build if set,
# use release if set, and use date if none of the above are set.

if [ "$NAME" != "" ]
then
   ID=$NAME
else
   ID=$BUILD
fi


BASE="${ID}"

#
# Ensure that log file is uniq.
#
TODAY=`date +%d%H%M%S`
LOG="$BASE-$TODAY.log"
REPORT="$BASE-$TODAY.txt"
while [ -f $LOG -o -f $REPORT ]
do
   sleep 1
   TODAY=`date +%d%H%M%S`
   LOG="$BASE-$TODAY.log"
   REPORT="$BASE-$TODAY.txt"
done


#echo "ID is $ID LEASE is $LEASE NAME is $NAME BASE is $BASE"

echo "Creating an WB $BUILD (for use in Workbench release testing) on Nimbus"
echo "Summary will be in $REPORT. Full log will be in $LOG."

echo "" 
echo "WB Created For Workbench Testing" 
echo "" 
echo "Notes: " 
echo "* All these WB hosts have $LEASE day leases (starting "`date +%b-%d`")." 
echo "* All these WB hosts have standard user/passwd: root/ca....w " 

echo "" 
echo "Using build ${KIND}-$BUILDNUM"  

echo "Creating WB"

WBNAME="${ID}-$TODAY"
echo "NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_ovfdeploy --lease=$LEASE $WBNAME $OVFFILE "

NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_ovfdeploy --lease=$LEASE $WBNAME $OVFFILE 
#LOG=akothari-002-23000308.log
#WBNAME=akothari-002-23000308

if [ $? != 0 ]
then
   echo "Failed to nimbus-ovfdeploy. "
   exit 1
fi

IP=`sed -n -e 's/^.*IPv4 is \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' $LOG`

if [ "$IP" = "" ]
then
   echo "nimbus-ovfdeply failed!"
   echo "Look in $LOG for details."
   exit 1
fi
echo "IP is " $IP

echo "Getting VM path."

#NIMBUS_POD=`sed -n -e 's/.*To manage this VM use "NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=\([^ ]*\) .*$/\1/p' $LOG`

echo "NIMBUS-POD = " $NIMBUS_POD
if [ -z "$NIMBUS_POD" ]
then
   echo "Could not find NIMBUS pod."
   exit 1
fi
RVCVMPATH=`NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_rvc -c quit | grep $WBNAME | awk '{print "/"$2}' | head -1`

if [ "$RVCVMPATH" = "" ]
then
   echo "No VM path find, so exiting."
   exit 1
fi
echo "VM path in RVC is $RVCVMPATH"

echo "Configuring and rebooting VM"
NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_rvc \
            -c "vm_guest.authenticate --username root --password vmware $RVCVMPATH"  \
            -c "vm_guest.download_file --guest-path $GUEST_VAOS_PATH --local-path $TMP_VAOS_FILE $RVCVMPATH" \
            -c "quit" >> $LOG
echo "Done Configuring"

if [ ! -f $TMP_VAOS_FILE ]
then
   echo "Could not download the vaos file: $TMP_VAOS_FILE"
   exit 1
fi

echo "TMP VAOS FILE = " $TMP_VAOS_FILE

sed -i -e 's/^\(  *\)askuser .*/\1:/' \
       -e 's/^\(  *\)getuserlang$/\1:/' \
       -e 's#^\(  *\)\(\[ -f $FLAG_BOOT_SCRIPT -a -f $FIRSTBOOT_SCRIPT \]\).*#\1if \2\n\1then\n\1SED_LINE\n\1sh $FIRSTBOOT_SCRIPT\n\1fi#' \
       $TMP_VAOS_FILE

sed -i -e 's#SED_LINE#sed -i -e '"'"'/Run\ launcheclipse\ script/ased\ -i\ -e\\\ '"'"'"'"'"'"'"'"s/needInput\\\ =\\\ prompt/needInput\\\ =\\\ False:/"'"'"'"'"'"'"'"\ '-e\\\ '"'"'"'"'"'"'"'"'s/if\\\ prompt:/if\\\ False:/'"'"'"'"'"'"'"'"'\\\ /var/tmp/extras/launcheclipse.py'"'"' $FIRSTBOOT_SCRIPT#'\
       $TMP_VAOS_FILE

#
# Upload the modified vaos file, reboot the VM, and change WB size to 8GB
#
echo "Upload VAOS File"
NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_rvc \
            -c "vm_guest.authenticate --username root --password vmware $RVCVMPATH"  \
            -c "vm_guest.upload_file --guest-path $GUEST_VAOS_PATH --local-path $TMP_VAOS_FILE --overwrite --permissions 755 $RVCVMPATH" \
            -c "vm_guest.start_program --program-path /sbin/poweroff $RVCVMPATH" -c "vm.wait_for_shutdown $RVCVMPATH" \
            -c "vm.modify_memory -s 8192 $RVCVMPATH" \
            -c "vm.on $RVCVMPATH" -c "vm.ip $RVCVMPATH" \
            -c "quit" 

#
# Add VMware proxy settings to Workbench Eclipse
#
echo "Add VMware Proxy"
NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_rvc \
            -c "vm_guest.authenticate --username root --password vmware $RVCVMPATH"  \
            -c "vm_guest.start_program --program-path /bin/mkdir  --arguments /opt/vmware/vide/eclipse/configuration/.settings $RVCVMPATH" \
            -c "vm_guest.upload_file --guest-path /opt/vmware/vide/eclipse/configuration/.settings/org.eclipse.core.net.prefs --local-path $TMP_WB_VMWARE_PROXY_PREFS --permissions 755 $RVCVMPATH" \
            -c "quit" 


echo "Add vsanPlugin File"
NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=$NIMBUS_POD $nimbus_rvc \
            -c "vm_guest.authenticate --username root --password vmware $RVCVMPATH"  \
	    -c "vm_guest.start_program --program-path='/bin/mkdir' --arguments='-p /tmp/WB-plugin' $RVCVMPATH" \
            -c "vm_guest.upload_file --guest-path /tmp/WB-plugin/UpdateSite-Vsanio-$PLUGIN_BUILD.zip --local-path $PLUGIN_FILE --permissions 755 $RVCVMPATH" \
            -c "vm_guest.start_program --program-path='/usr/bin/unzip' --arguments='/tmp/WB-plugin/UpdateSite-Vsanio-$PLUGIN_BUILD.zip' --working-directory='/tmp/WB-plugin' $RVCVMPATH" \
            -c "quit" 

echo "DONE"


echo "Created an WB box $IP $WBNAME" 

echo "" 
echo "Commands to destroy these VAs:" 
grep "You can kill the VM with" $LOG | awk -F\" '{print $2;}' 

echo "" 
echo "Commands to extend these VAs:" 
grep "You can kill the VM with" $LOG | awk -F\" '{print "echo \"y\" | " $2;}' | sed "s#kill#--lease 7 extend_lease#" 

# clean
rm -f $TMP_WB_VMWARE_PROXY_PREFS $TMP_VAOS_FILE
