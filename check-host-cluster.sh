#!/bin/sh
VERSION=0.1
####################################################################################################################################################
#
#   check esx host whether or not if cluster is enabled
#
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
#
#####################################################################################################################################################


USER=root
HOSTS="
prme-stsao-001.eng.vmware.com
prme-stsao-002.eng.vmware.com
prme-stsao-003.eng.vmware.com
prme-stsao-004.eng.vmware.com
prme-stsao-005.eng.vmware.com
prme-stsao-006.eng.vmware.com
prme-stsao-007.eng.vmware.com
prme-stsao-008.eng.vmware.com
prme-stsao-009.eng.vmware.com
prme-stsao-010.eng.vmware.com
prme-stsao-011.eng.vmware.com
prme-stsao-012.eng.vmware.com
prme-stsao-013.eng.vmware.com
prme-stsao-014.eng.vmware.com
prme-stsao-015.eng.vmware.com
prme-stsao-016.eng.vmware.com
prme-stsao-017.eng.vmware.com
prme-stsao-018.eng.vmware.com
prme-stsao-019.eng.vmware.com
prme-stsao-020.eng.vmware.com
prme-stsao-021.eng.vmware.com
prme-stsao-022.eng.vmware.com
prme-stsao-023.eng.vmware.com
prme-stsao-024.eng.vmware.com
prme-stsao-025.eng.vmware.com
prme-stsao-026.eng.vmware.com
prme-stsao-027.eng.vmware.com
prme-stsao-028.eng.vmware.com
prme-stsao-029.eng.vmware.com
prme-stsao-030.eng.vmware.com
prme-stsao-031.eng.vmware.com
prme-stsao-032.eng.vmware.com
prme-stsao-033.eng.vmware.com
prme-stsao-034.eng.vmware.com
prme-stsao-035.eng.vmware.com
prme-stsao-036.eng.vmware.com
prme-stsao-037.eng.vmware.com
prme-stsao-038.eng.vmware.com
prme-stsao-039.eng.vmware.com
prme-stsao-040.eng.vmware.com
prme-stsao-041.eng.vmware.com
prme-stsao-042.eng.vmware.com
prme-stsao-043.eng.vmware.com
prme-stsao-044.eng.vmware.com
prme-stsao-045.eng.vmware.com
prme-stsao-046.eng.vmware.com
prme-stsao-047.eng.vmware.com
prme-stsao-048.eng.vmware.com
prme-stsao-049.eng.vmware.com
prme-stsao-050.eng.vmware.com
prme-stsao-051.eng.vmware.com
prme-stsao-052.eng.vmware.com
prme-stsao-053.eng.vmware.com
prme-stsao-054.eng.vmware.com
prme-stsao-055.eng.vmware.com
prme-stsao-056.eng.vmware.com
prme-stsao-057.eng.vmware.com
prme-stsao-058.eng.vmware.com
prme-stsao-059.eng.vmware.com
prme-stsao-060.eng.vmware.com
prme-stsao-061.eng.vmware.com
prme-stsao-062.eng.vmware.com
prme-stsao-063.eng.vmware.com
prme-stsao-064.eng.vmware.com
prme-stsao-065.eng.vmware.com
prme-stsao-066.eng.vmware.com
prme-stsao-067.eng.vmware.com
prme-stsao-068.eng.vmware.com
prme-stsao-069.eng.vmware.com
prme-stsao-070.eng.vmware.com
prme-stsao-071.eng.vmware.com
prme-stsao-072.eng.vmware.com
prme-stsao-073.eng.vmware.com
prme-stsao-074.eng.vmware.com
prme-stsao-075.eng.vmware.com
prme-stsao-076.eng.vmware.com
prme-stsao-077.eng.vmware.com
prme-stsao-078.eng.vmware.com
prme-stsao-079.eng.vmware.com
prme-stsao-080.eng.vmware.com
prme-stsao-081.eng.vmware.com
prme-stsao-082.eng.vmware.com
prme-stsao-083.eng.vmware.com
prme-stsao-084.eng.vmware.com
prme-stsao-085.eng.vmware.com
prme-stsao-086.eng.vmware.com
prme-stsao-087.eng.vmware.com
prme-stsao-088.eng.vmware.com
prme-stsao-089.eng.vmware.com
prme-stsao-090.eng.vmware.com
prme-stsao-091.eng.vmware.com
prme-stsao-092.eng.vmware.com
prme-stsao-093.eng.vmware.com
prme-stsao-094.eng.vmware.com
prme-stsao-095.eng.vmware.com
prme-stsao-096.eng.vmware.com
prme-stsao-097.eng.vmware.com
prme-stsao-098.eng.vmware.com
prme-stsao-099.eng.vmware.com
prme-stsao-100.eng.vmware.com
"

#check for cluster
CMD="esxcli vsan cluster get"

#
# The ssh command allows you to use "-oStrictHostKeyChecking=[yes|no]" 
# command line option to enable or disable ssh host key checking.
#
SSHKEYS="-oStrictHostKeyChecking=no"

#stty -echo  # disable echo - password will not be displayed as you enter it 
#read -p "Please enter password for the hosts: " password
#stty echo

printf "Enter the password: "
read -s password

echo ""
echo ""
echo "Checking for available hosts..."
echo ""


echo ""

for HOST in $HOSTS
do
  echo $HOST
  sshpass -p $password ssh $SSHKEYS $USER@$HOST $CMD
  echo ""
  
done
