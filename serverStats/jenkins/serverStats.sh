#!/bin/bash

thePath=$1

getServerStats(){

echo "<head> <meta http-equiv="refresh" content="5"> </head>" > ${thePath}server-stats.html
echo "<html>" >> ${thePath}server-stats.html
echo "<body>" >> ${thePath}server-stats.html
echo "<b>Hostname:   </b>" >> ${thePath}server-stats.html
hostname >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<pre>" >> ${thePath}server-stats.html
echo "<b>jenkin's process: </b>" >> ${thePath}server-stats.html
ps au | grep -iE "jenkins" | grep -iEv "grep" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>misc process: </b>" >> ${thePath}server-stats.html
ps aux | grep -iE "vsanhol-nfs-array|nimbus" | grep -iEv "grep --color|grep -iE vsanhol-nfs-array|nimbus" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Zombie process:</b>" >> ${thePath}server-stats.html
ps aux | grep -w defunct | grep -iEv "grep --color=auto|grep -w defunct" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Memory usage:</b>" >> ${thePath}server-stats.html
echo "<br>" >> ${thePath}server-stats.html
free -h >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>TOP status:</b>" >> ${thePath}server-stats.html
top -b -n 1 | head -7 >> ${thePath}server-stats.html
echo ""  >> ${thePath}server-stats.html
ps aux | grep -iE "jenkins" | grep -iEv "grep -iE jenkins" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Storage:</b>" >> ${thePath}server-stats.html
df -h | grep -iE "dm-0|vsan-cert|Filesystem" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "</pre>" >> ${thePath}server-stats.html
echo "</body>" >> ${thePath}server-stats.html
echo "</html>" >> ${thePath}server-stats.html

}

getServerStats "$thePath"
