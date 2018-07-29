#!/bin/sh
VERSION=0.1

#
#   calculate the number of hours between 2 dates
#    
#   application needed: http://www.fresse.org/dateutils/
#
#           example : jc-timediff.sh 2016-03-24 18:30:25 2016-03-25 06:28:33
#

date1=$1
time1=$2

date2=$3
time2=$4

datediff ${date1}T${time1} ${date2}T${time2} -f '%dd %Hh %Mm %Ss'
