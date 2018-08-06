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
echo "<b>current process: </b>" >> ${thePath}server-stats.html
ps au | grep -iEv "root" | grep -iEv "ps au" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Zombie process:</b>" >> ${thePath}server-stats.html
ps aux | grep -w defunct | grep -iEv "grep --color=auto|grep -w defunct" >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Memory usage:</b>" >> ${thePath}server-stats.html
echo "<br>" >> ${thePath}server-stats.html
free -h >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>TOP status:</b>" >> ${thePath}server-stats.html
top -c -b -n 1 | head -7 >> ${thePath}server-stats.html
echo "" >> ${thePath}server-stats.html
ps au | grep -iEv "grep --color=auto cron">> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>Storage:</b>" >> ${thePath}server-stats.html
df -h | grep -iE "sda1|vsan-cert|Filesystem" >> ${thePath}server-stats.html
echo "</pre>" >> ${thePath}server-stats.html
echo "</body>" >> ${thePath}server-stats.html
echo "</html>" >> ${thePath}server-stats.html

}

getServerStats "$thePath"
