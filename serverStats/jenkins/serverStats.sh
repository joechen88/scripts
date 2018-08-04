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
echo "<b>Memory usage:</b>" >> ${thePath}server-stats.html
echo "<br>" >> ${thePath}server-stats.html
free -h >> ${thePath}server-stats.html
echo "<br><br>" >> ${thePath}server-stats.html
echo "<b>TOP status:</b>" >> ${thePath}server-stats.html
top -c -b -n 1 -u jenkins >> ${thePath}server-stats.html
echo "</pre>" >> ${thePath}server-stats.html
echo "</body>" >> ${thePath}server-stats.html
echo "</html>" >> ${thePath}server-stats.html

}

getServerStats "$thePath"
