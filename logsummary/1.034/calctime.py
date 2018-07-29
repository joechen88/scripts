#!/usr/bin/env python
import subprocess, datetime, sys
from dateutil import relativedelta

def timeDiff(dateTime1, dateTime2):
	#dateTime1 = dateTime1[:-1]
	#dateTime2 = dateTime2[:-1]
        
	# extract yy-mm-dd hh-mm-ss, only grab yy-mm-dd
	# then validate date format and return a boolean
	d1 = dateTime1.strip().split()
	d2 = dateTime2.strip().split()
        try:
           d1_check = cmdline("echo " + d1[0] + " | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'")
        except Exception as e:
           print ("unable to calculate time")
           return
        try:
           d2_check = cmdline("echo " + d2[0] + " | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'")
        except Exception as e:
           print ("unable to calculate time")
           return 

 	d1_check = d1_check[:-1]
 	d2_check = d2_check[:-1]
  	if d1_check and d2_check == "1":
	   startDateTime = datetime.datetime.strptime(dateTime1, '%Y-%m-%d %H:%M:%S')
	   endDateTime = datetime.datetime.strptime(dateTime2, '%Y-%m-%d %H:%M:%S')
	   diff = relativedelta.relativedelta(endDateTime, startDateTime)
	   print "%dd %dh %dm %ds" % (diff.days, diff.hours, diff.minutes, diff.seconds)
	else:
	   print ("unable to calculate time")

def cmdline(command):
	process = subprocess.Popen(command,stdout=subprocess.PIPE,shell=True)	
	return process.communicate()[0]

def main():
            try:
		datetime1 = sys.argv[1]
		datetime2 = sys.argv[2]
		timeDiff(datetime1, datetime2)
            except ValueError:
                print ("unable to calculate time")

if __name__ == '__main__':
	main()
