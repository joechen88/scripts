#!/bin/bash

#while ! ssh root@prme-stsao-031.eng.vmware.com true; do
#    sleep 5
#done; echo "Host is back up at $(date)!"


rebootHostStatus (){
        ssh -q root@prme-stsao-031.eng.vmware.com exit
        checkStatus=$(echo $?)
	until [ $checkStatus -eq 0 ]
	do
                echo "Waiting for host to be back online..."
		sleep 5
		ssh -q root@prme-stsao-031.eng.vmware.com exit
                checkStatus=$(echo $?)
	done
        echo -e "\n\n =================== \n"
        echo -e " Host is up!!! \n"
        echo -e " =================== \n"

}

rebootHostStatus


