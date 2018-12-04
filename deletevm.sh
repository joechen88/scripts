#!/bin/bash

ESXHOST=$1
esxPW="ca\$hc0w"
USER="root"



cat << EOF > deleteVMs.sh
#!/bin/bash

for i in \$(vim-cmd vmsvc/getallvm | awk -F' ' '/[0-9]/{print \$1}'); do vim-cmd vmsvc/power.off \$i; vim-cmd vmsvc/unregister \$i; done
EOF

chmod 755 deleteVMs.sh

for i in $(echo $ESXHOST | tr ',' '\n')
do
   echo -e "\nCopy deleteVMs.sh script to $i \n"
   sshpass -p $esxPW scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ./deleteVMs.sh root@$i:/tmp 
   echo -e "\nDelete VMs in $i \n"
   sshpass -p $esxPW ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$i './tmp/deleteVMs.sh'
   echo -e "\nRemove deleteVMs.sh in $i \n"
   sshpass -p $esxPW ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$i 'rm /tmp/deleteVMs.sh'
done
rm deleteVMs.sh
