joechen-centos test $ vi test-arnav-help.py 

import argparse, re, os, subprocess


def cmdline(command):
        process = subprocess.Popen(command,stdout=subprocess.PIPE,shell=True)
        return process.communicate()[0]

def main():
        pattern1 = '"s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|B]//g"'
        pattern2 = '"s/\\x1B\([m|B]//g"'

        #os.system("./hy-combinedLong.sh test-vpx.vsan.iocert.ctrl_combined_long_c1.log | sed -r " + pattern1 + "| sed -r " + pattern2 + " > out.txt")
        out_file = open("out.txt", "w")
        subprocess.call(["bash", "hy-combinedLong.sh", "test-vpx.vsan.iocert.ctrl_combined_long_c1.log", "|", "sed", "-r", pattern1 ,"|","sed", "-r", pattern2], stdout= out_file )
if __name__ == '__main__':
        main()





---------------------------------------------------------------------


import datetime
from dateutil.relativedelta import relativedelta

a = '2014-05-06 12:00:56'
b = '2013-03-06 16:08:22'

start = datetime.datetime.strptime(a, '%Y-%m-%d %H:%M:%S')
ends = datetime.datetime.strptime(b, '%Y-%m-%d %H:%M:%S')

diff = relativedelta(start, ends)

>>> print "The difference is %d year %d month %d days %d hours %d minutes" % (diff.years, diff.months, diff.days, diff.hours, diff.minutes)
The difference is 1 year 1 month 29 days 19 hours 52 minutes