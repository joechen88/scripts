#!/usr/bin/python
# -*- coding: utf-8 -*-
#version 1.062
import argparse, re, os, subprocess, datetime, sys, fnmatch, scandir
from dateutil import relativedelta
from optparse import OptionParser
import sys
import string

test = ""
testVer = ""
hostName = ""
esxWBtime = ""
esxVersion = ""
serverVendorName = ""
serverProductName = ""
controller = ""
driverName = []
driverVersion = []
viddidsvidsdid = []
controllerQueueDepth = []
deviceSN = []
modelNumber = []
Model = []
firmwareRevision = []
deviceQueueDepth = ""
DisplayName = []
DriveSize = []
deviceQueueDepth = []
revision = []
DriveModel = []
firmware = []
firmwareRev = []
entireTest = []
addDisk = []
errorMSG = []
diskScrubber = []
traceBackMSG = []
consumedDisk = []
diskMapping = []
ipAddress = []
deployVMtime = ""
allVMDeployedtime = ""
ddInfo = []
diskHealthCheck = []
VMIOThread = []
wbUsage = []
hy100r = []
hy100w = []
hy95phr = []
hy99phr = []
hy100phr = []
hy100phrchksum = []
encryptionMSG = []
hyEncryptionMSG = []
startFIOendFIO = []
shortio = []
resetStart = []
lunReset = []
busReset = []
targetReset = []
numOfDayFor7day = []
AFperf = []  # for 100r0w, 4k, 64k, mdCap, 50gb
dataIntegrityTime = []
cleanup = []
status = ""
testName = ""
hpLED = []
hpShortSummary = []
hpMidSummary = []
reSyncTime = []
hpFullSummary = []
hpHighLevelSummary = []
hpComplete = ""
driveExpDevQD = []
diskResult = []
Name = []
vsanUUID = []
State = []
isCapacity = []
bootbank = []
tmpDiskResults = []
ctrlDetail = []
tmpCtrlDetail = []
esxcfgscsidevsA = []
FdsOpenMaxRetries = []
sharedVMFS = []


###############################################################################
#
#   Calculate time
#
###############################################################################
def timeDiff(dateTime1, dateTime2):
    # chop off the string up to yy-mm-dd hh-mm-ss
    dateTime1 = dateTime1.split(",", 1)[0]
    dateTime2 = dateTime2.split(",", 1)[0]

    # extract yy-mm-dd hh-mm-ss, only grab yy-mm-dd
    # then validate date format and return a boolean
    d1 = dateTime1.strip().split()
    d2 = dateTime2.strip().split()

    d1 = dateTime1.strip().split()
    d2 = dateTime2.strip().split()
    d1_check = cmdline(
        "echo " + d1[0] +
        " | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'")
    d2_check = cmdline(
        "echo " + d2[0] +
        " | grep -c '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$'")

    d1_check = d1_check[:-1]
    d2_check = d2_check[:-1]

    if d1_check and d2_check == "1":
        startDateTime = datetime.datetime.strptime(dateTime1,
                                                   '%Y-%m-%d %H:%M:%S')
        endDateTime = datetime.datetime.strptime(dateTime2,
                                                 '%Y-%m-%d %H:%M:%S')
        diff = relativedelta.relativedelta(endDateTime, startDateTime)
        print "%dd %dh %dm %ds" % (diff.days, diff.hours, diff.minutes,
                                   diff.seconds)
    else:
        print("unable to calculate time")


#
#   pipe it to use linux command
#
def cmdline(command):
    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    return process.communicate()[0]


def getHDDstats(test, hn, numOfHost):

    endSSDHDD = False
    ssdHDD = []
    driveinfo = []

    num = 0
    p = os.path.join(os.getcwd(), 'traces')
    for root, dirs, files in scandir.walk(p):
        for x in fnmatch.filter(dirs, test):
            statsFile = p + "/" + x + "/stats.html"

            # sometimes there will be multiple traces folders ; read stats.html to find out the IP to match the test-vpx
            a = "cat " + statsFile + " | grep -iE 'ESX host' | awk '{print $3}' "
            chkhostname = cmdline(a)
            chkhostname = chkhostname[:-1]

            if chkhostname == hn:

                if num < numOfHost:  # will only output hdd details on different host

                    #using hdd-stat.sh bashscript
                    #b = "hdd-stats.sh " + statsFile

                    #open stats.html file, college SSD and HDD info
                    readFile = open(statsFile, "r")
                    for line in readFile:

                        mtchSSDHDD = re.match("(.*)SSD:|(.*)HDD:", line)
                        if mtchSSDHDD or endSSDHDD:
                            ssdHDD.append(line)
                            if mtchSSDHDD:
                                endSSDHDD = True
                            elif re.match(r'(.*)<li>', line):
                                endSSDHDD = False

                    #remove \n from from all the elements
                    ssdHDD = map(lambda s: s.strip(), ssdHDD)

                    #iterate the elements in groups of 5, convert it into string, then put it driveinfo
                    for i in groupElements(ssdHDD, 5):
                        # merge the tuple into a string, then insert it back to driveinfo
                        i = ''.join(i)
                        driveinfo.append(i)

                    #get rid of the html tags
                    for y in driveinfo:
                        y = y.replace(r'</li>', '')
                        y = y.replace(r'<ul><li>', '   ')
                        print y

                    num = num + 1
                    readFile.close()


def printTest(test):
    if len(test) >= 1:
        for y, x in enumerate(test):
            print x,
        else:
            print ""


def printCompletionTime(test, index1, index2):
    print "Completion time: ",
    if len(test) >= 1:
        timeDiff(test[index1], test[index2])
    else:
        print ""

    print "\n"


def groupElements(iterable, groupsize):
    return map(None, *[iter(iterable)] * groupsize)


def GetInfo(testName, hostName):
    global ctrlDetail, tmpCtrlDetail
    tmpDiskResult = []
    totaldrives = 0
    cache = 0
    capacity = 0

    print "=Host="
    print hostName
    print "\n\n"

    print "=ESX Version="
    print esxVersion
    print "\n\n"

    print "=Consumed Disk="
    for y, x in enumerate(consumedDisk):
        print x
    print "\n\n"

    print "=Server info="

    a = ''.join(serverVendorName.split('==>'))
    print "Server Vendor Name: " + a.split("\t")[1],
    b = ''.join(serverProductName.split('==>'))
    print "Server Product Name: " + b.split("\t")[1]
    print "\n\n"

    print "=Controller="
    print controller
    print "\n\n"

    print "=Controller Driver + VID:DID:SDID:SVID + queuedepth="

    #
    #  To find how many controller or nvme:   cat getinfo.log | grep -iE '\"driverName\"'
    #

    for i in range(0, len(driverName)):
        tmpCtrlDetail.append(
            "Driver: " + driverName[i] + " -" + driverVersion[i] + "   ,   " +
            "vid:did svid:sdid: " + viddidsvidsdid[i] + "   ,   " +
            "Controller Qdepth: " + controllerQueueDepth[i])

    k = 0
    if len(deviceSN) > 0:
        for j in range(0, len(driverName)):
            if "nvme" in tmpCtrlDetail[j]:
                tmpCtrlDetail[
                    j] = tmpCtrlDetail[j] + "  ,  " + modelNumber[k] + "  ,  " + deviceSN[k] + "  ,  " + firmwareRevision[k]
                k = k + 1

    #sort detail
    ctrlDetail = sorted(tmpCtrlDetail)

    for j, k in enumerate(ctrlDetail):
        print j + 1,
        print "  " + k

    print "\n\n\n"

    print "=Controller firmware / Controller firmware package version="
    for iFirmware in sorted(set(firmware)):
        print iFirmware,

    print "\n\n\n"

    print "=NVMe firmware revision / Drive firmware revision="
    for ifirmwareRev in sorted(set(firmwareRev)):
        print ifirmwareRev,
    print "\n\n\n"

    print "=Drive info="

    esxcfgscsidevsA.remove('esxcfg-scsidevs -c\n')
    esxcfgscsidevsA.remove('esxcfg-scsidevs -c\n')
    esxcfgscsidevsA.remove('esxcfg-scsidevs -A\n')
    esxcfgscsidevsA.remove('esxcfg-scsidevs -A\n')

    for d in sorted(set(esxcfgscsidevsA)):
        print d,

    print "\n\n\n"

    print "=Drives / expander / device queuedepth info="

    # Device Queue Depth are sometimes listed and sometimes not

    #Model Number
    if len(modelNumber) > 0:
        if len(modelNumber) < len(DisplayName):
            for j in range(0, len(DisplayName)):
                if len(deviceQueueDepth) > 0:
                    tmpDiskResults.append(
                        Model[j].split('\n')[0] + DisplayName[j].split('\n')[0]
                        + DriveSize[j].split('\n')[0] + revision[j].split(
                            '\n')[0] + deviceQueueDepth[j].split('\n')[0])
                else:
                    if len(revision) > 0:
                        tmpDiskResults.append(Model[j].split('\n')[0] +
                                              DisplayName[j].split('\n')[0] +
                                              DriveSize[j].split('\n')[0] +
                                              revision[j].split('\n')[0])
                    else:
                        tmpDiskResults.append(Model[j].split('\n')[0] +
                                              DisplayName[j].split('\n')[0] +
                                              DriveSize[j].split('\n')[0])
        else:
            for j in range(0, len(modelNumber) + 1):
                if len(deviceQueueDepth) > 0:
                    tmpDiskResults.append(
                        Model[j].split('\n')[0] + DisplayName[j].split('\n')[0]
                        + DriveSize[j].split('\n')[0] + revision[j].split(
                            '\n')[0] + deviceQueueDepth[j].split('\n')[0])
                else:
                    if len(revision) > 0:
                        tmpDiskResults.append(Model[j].split('\n')[0] +
                                              DisplayName[j].split('\n')[0] +
                                              DriveSize[j].split('\n')[0] +
                                              revision[j].split('\n')[0])
                    else:
                        tmpDiskResults.append(Model[j].split('\n')[0] +
                                              DisplayName[j].split('\n')[0] +
                                              DriveSize[j].split('\n')[0])

    #Model
    elif len(Model) > 0:
        for j in range(0, len(Model)):
            if len(deviceQueueDepth) > 0:
                tmpDiskResults.append(
                    Model[j].split('\n')[0] + DisplayName[j].split('\n')[0] +
                    DriveSize[j].split('\n')[0] + revision[j].split('\n')[0] +
                    deviceQueueDepth[j].split('\n')[0])
            else:
                if len(revision) > 0:
                    tmpDiskResults.append(Model[j].split('\n')[0] +
                                          DisplayName[j].split('\n')[0] +
                                          DriveSize[j].split('\n')[0] +
                                          revision[j].split('\n')[0])
                else:
                    tmpDiskResults.append(Model[j].split('\n')[0] +
                                          DisplayName[j].split('\n')[0] +
                                          DriveSize[j].split('\n')[0])

    for n, m in enumerate(sorted(set(tmpDiskResults))):
        print n + 1,
        print m

    print "\n\n\n"

    printDiskMapping()

    print "=Drive In-Use for VSAN="
    for j in range(0, len(diskResult)):
        if len(diskResult) > 0:
            tmpDiskResult.append(diskResult[j].split('\n')[0] + Name[j].split(
                '\n')[0] + vsanUUID[j].split('\n')[0] + State[j].split('\n')[0]
                                 + isCapacity[j].split('\n')[0])

    #display all Drives in-use for vsan
    tmpDR = sorted(set(tmpDiskResult))

    #print tmpDiskResult
    for l in tmpDR:
        if "In-use for VSAN" in l:
            print l

    print ""
    print "Drive (In-Use for VSAN) Count: ",
    k = 0
    for x in range(0, len(tmpDR)):
        k += State[x].count("In-use for VSAN")
    print k
    print "\n\n\n"

    IneligibleCount = 0
    #display all drives Ineligible for use by VSAN
    print "=Drive with partitions="

    for j in tmpDR:
        if "Ineligible for use by VSAN" in j:
            print j
            IneligibleCount += j.count("Ineligible for use by VSAN")

    print ""
    print "Drive (with partitions) Count: ",
    print IneligibleCount
    print "\n\n\n\n"

    print "=Bootbank="
    for b in bootbank:
        print b,
    print "\n\n\n\n"

    print "=Status="
    print status


def printDiskMapping():
    print "Diskgroups:"
    print "------"
    totaldrives = 0
    cache = 0
    capacity = 0

    chkNumDiskMapping = 0
    DiskMappingIndex = 0
    for i in range(0, len(diskMapping)):
        if "DiskMapping[0]" in diskMapping[i]:
            chkNumDiskMapping += 1
            diskMappingIndex = i

    if chkNumDiskMapping == 1:
        for x in diskMapping:
            # all drives w/ SAS or SATA
            if "naa" in x.split("MDs:")[0] and "naa" in x.split("MDs:")[1]:
                print x.split("MDs:")[0].count(
                    "naa"), "+",  #count all the drives for SSD (left side)
                print x.split("MDs:")[1].count(
                    "naa"),  #count all the drives for MDs (right side)
                print " -> " + x,
                cache += x.split("MDs:")[0].count("naa")
                capacity += x.split("MDs:")[1].count("naa")
                totaldrives += x.count("naa")

            # NVMe for cache and capacity sas or sata
            if "NVMe" in x.split("MDs:")[0] and "naa" in x.split("MDs:")[1]:
                print x.split("MDs:")[0].count(
                    "t10.NVMe"
                ), "+",  #count all the drives for NVMe (left side)
                print x.split("MDs:")[1].count(
                    "naa"),  #count all the drives for MDs (right side)
                print " -> " + x,
                cache += x.split("MDs:")[0].count("t10.NVMe")
                capacity += x.split("MDs:")[1].count("naa")
                totaldrives += x.count("t10.NVMe")
                totaldrives += x.count("naa")

            # NVMe for cache and capacity NVMe
            if "NVMe" in x.split("MDs:")[0] and "NVMe" in x.split("MDs:")[1]:
                print x.split("MDs:")[0].count(
                    "t10.NVMe"
                ), "+",  #count all the drives for NVMe (left side)
                print x.split("MDs:")[1].count(
                    "t10.NVMe"),  #count all the drives for NVMe (right side)
                print " -> " + x,
                cache += x.split("MDs:")[0].count("t10.NVMe")
                capacity += x.split("MDs:")[1].count("t10.NVMe")
                totaldrives += x.count("t10.NVMe")

    elif chkNumDiskMapping == 2:
        for x in range(diskMappingIndex, len(diskMapping)):
            # all drives w/ SAS or SATA
            if "naa" in diskMapping[x].split(
                    "MDs:")[0] and "naa" in diskMapping[x].split("MDs:")[1]:
                print diskMapping[x].split("MDs:")[0].count(
                    "naa"), "+",  #count all the drives for SSD (left side)
                print diskMapping[x].split("MDs:")[1].count(
                    "naa"),  #count all the drives for MDs (right side)
                print " -> " + diskMapping[x],
                cache += diskMapping[x].split("MDs:")[0].count("naa")
                capacity += diskMapping[x].split("MDs:")[1].count("naa")
                totaldrives += diskMapping[x].count("naa")

            # NVMe for cache and capacity sas or sata
            if "NVMe" in diskMapping[x].split(
                    "MDs:")[0] and "naa" in diskMapping[x].split("MDs:")[1]:
                print diskMapping[x].split("MDs:")[0].count(
                    "t10.NVMe"
                ), "+",  #count all the drives for NVMe (left side)
                print diskMapping[x].split("MDs:")[1].count(
                    "naa"),  #count all the drives for MDs (right side)
                print " -> " + diskMapping[x],
                cache += diskMapping[x].split("MDs:")[0].count("t10.NVMe")
                capacity += diskMapping[x].split("MDs:")[1].count("naa")
                totaldrives += diskMapping[x].count("t10.NVMe")
                totaldrives += diskMapping[x].count("naa")

            # NVMe for cache and capacity NVMe
            if "NVMe" in diskMapping[x].split(
                    "MDs:")[0] and "NVMe" in diskMapping[x].split("MDs:")[1]:
                print diskMapping[x].split("MDs:")[0].count(
                    "t10.NVMe"
                ), "+",  #count all the drives for NVMe (left side)
                print diskMapping[x].split("MDs:")[1].count(
                    "t10.NVMe"),  #count all the drives for NVMe (right side)
                print " -> " + diskMapping[x],
                cache += diskMapping[x].split("MDs:")[0].count("t10.NVMe")
                capacity += diskMapping[x].split("MDs:")[1].count("t10.NVMe")
                totaldrives += diskMapping[x].count("t10.NVMe")

    print "------"
    print "Cache: ",
    print cache
    print "Capacity: ",
    print capacity
    print ""
    print "Total drives: ", totaldrives
    print "\n\n\n"


# display Summary
def displaySummary(testName, hostName, test, testVer, deployVMtime,
                   allVMDeployedtime, status, hpComplete):

    print "=Test Name="
    print test
    print "\n"

    print "=Test Start/End time="
    print "Start: ",
    print entireTest[0].split(",", 1)[0]
    print "  End: ",
    print entireTest[-1].split(",", 1)[0]
    print "Total: ",
    timeDiff(entireTest[0], entireTest[-1])
    print "\n"

    print "=IOCert Version="
    print testVer
    print "\n"

    print "=HostName="
    print hostName
    print "\n\n"

    print "=ESX Version="
    esxver = cmdline(
        "cat traces/*/stats.html | grep -iE 'VMware ESXi' | awk '{ print $1,$2,$3,$4 }' | sort | uniq "
    )
    print esxver
    print "\n\n"

    print "=WorkBench/ESX time="
    print esxWBtime
    print "\n\n"

    #Hotplug planned, unplanned
    if testName == "hp-planned" or testName == "hp-unplanned":
        print "=LED INFO="
        for y, x in enumerate(hpLED):
            print x,

        print "\n"

        print "=Short Summary="
        for y, x in enumerate(hpShortSummary):
            print x,

        print "\n"

        print "=Mid Summary="
        for y, x in enumerate(hpMidSummary):
            print x,

        print "\n"

        #
        # Go through hpMidSummary list to get "Found the user prompt" and "Found all the component"
        #
        line1 = None
        string1 = 'Please reinsert/plug the following unplugged disks to'
        line2 = None
        line3 = None
        string2 = 'Found the user prompt file'
        string3 = 'Found all the components'

        for line in hpMidSummary:
            if not line1 and string1 in line:
                line1 = line

            if line1 and not line2 and string2 in line:
                line2 = line

            if line2 and string3 in line:
                line3 = line
                reSyncTime.append(line2)
                reSyncTime.append(line3)
                line1 = None
                line2 = None
                line3 = None

        print "=================================="
        print ""
        print "MD re-sync time: ",
        if len(reSyncTime) - 2 == 2:
            timeDiff(reSyncTime[0], reSyncTime[1])
        else:
            # This is used if only MD completed, but not SSD
            if len(reSyncTime) == 2:
                timeDiff(reSyncTime[0], reSyncTime[1])

        print "SSD re-sync time: ",
        if len(reSyncTime) == 4:
            timeDiff(reSyncTime[2], reSyncTime[3])
        print ""
        print "=================================="

        print ""
        print ""
        # full re-sync summary
        print "=Full Re-sync summary="
        print ""
        print "			0 - FIRST		4 - INITIALIZED		8 - RESYNCHING		12 - TRANSIENT"
        print "			1 - NONE		5 - ACTIVE		9 - DEGRADED		13 - LAST "
        print "			2 - NEED_CONFIG		6 - ABSENT	       10 - RECONFIGURING"
        print "			3 - INITIALIZE		7 - STALE	       11 - CLEANUP"
        print ""

        printTest(hpFullSummary)

        # high level summary
        print "=high level summary="
        print "\n"
        printTest(hpHighLevelSummary)
        print "\n"

        print "=Cleanup="
        printTest(cleanup)
        print "\n"

        print "=Status="
        print hpComplete

    #allflash and Hybrid tests
    else:
        print("=Error=")
        for k, i in enumerate(errorMSG):
            if not i in traceBackMSG:
                print i,
        #printTest(errorMSG)

        print "\n\n\n"

        print "=Traceback="
        printTest(traceBackMSG)

        print "\n"

        if testName == "reset" or testName == "7day":
            print "=FIO Error="
            fioError = cmdline("cat fio/*/* | grep -B2 -A2 -iE 'error='")
            print fioError

        print "\n"
        print "=Disk Info="
        print "Consumed disks:"
        print ""
        print ""
        for y, x in enumerate(consumedDisk):
            print x
        print ""

        printDiskMapping()

        print "=Hard disk info="
        if testName == "short":
            getHDDstats("ctrl*", hostName, 1)

        if testName == "combinedLong":
            getHDDstats("70r30w_95*", hostName, 1)

        if testName == "reset":
            getHDDstats("ctrlr_reset*", hostName, 1)

        if testName == "7day":
            getHDDstats("ctrlr_7day_stress*", hostName, 1)

        if testName == "stress":
            getHDDstats("ctrlr_stress*", hostName, 1)

        if testName == "hy-enc":
            getHDDstats("70r30w*", hostName, 1)

        if testName == "shortio":
            getHDDstats("ctrlr_short_io-*", hostName, 1)

        if testName == "af-100r0w":
            getHDDstats("100r0w*", hostName, 1)

        if testName == "4k" or testName == "64k":
            getHDDstats("0r100w_*", hostName, 1)

        if testName == "mdCap" or testName == "50gb" or testName == "af-enc":
            getHDDstats("70r30w_*", hostName, 1)

        if testName == "af-data-integrity":
            getHDDstats("ctrlr_data_integrity_af*", hostName, 1)

        print "\n\n\n"
        print "=VM + VM size="
        print ''.join(addDisk)
        print "Count: ",
        print len(addDisk)

        print "\n\n"

        print "=IP Address="
        print ''.join(ipAddress)
        print "Count:",
        print len(ipAddress)

        print "\n"
        print "=Deploying VMs time="
        print deployVMtime + "\n\n"

        print "=All VMs deployed time="
        print allVMDeployedtime + "\n\n"

        print "=DD info="
        printTest(ddInfo)
        if len(ddInfo) >= 1:
            print "DD time: ",
            timeDiff(ddInfo[0], ddInfo[-1])

        print "\n\n"

        print "=WB Usage="
        printTest(wbUsage)
        print "\n"

        #diskHealth check and VM IO Thread for HY/AF Reset / HY/AF 7day
        if testName == "reset" or testName == "7day":

            print "=DiskHealth Time (duration is 12hrs)="
            for y, x in enumerate(diskHealthCheck):
                print x,

            print ""
            print "DiskHealth completion time: ",
            if len(diskHealthCheck) == 2:
                timeDiff(diskHealthCheck[0], diskHealthCheck[1])

            print "\n\n\n"
            print "=VMIOThread Time (duration is 12hrs)="
            printTest(VMIOThread)

            print "VMIOThread",
            printCompletionTime(VMIOThread, 0, -1)

        print "\n"

        count = 0
        # FIO
        if testName == "af-data-integrity":
            print "=FIO="
            printTest(startFIOendFIO)
            print ""
            for i in range(0, len(startFIOendFIO)):
                if "Done running FIO on" in startFIOendFIO[i]:
                    count += 1

            print "Total number of VMs w/ completed FIO: ",
            print count
            print ""
            printTest(dataIntegrityTime)

            if dataIntegrityTime:
                print "FIO (write) completion time: ",
                if len(dataIntegrityTime) >= 2:
                    timeDiff(dataIntegrityTime[0], dataIntegrityTime[1])
                print "FIO (read) completion time: ",
                if len(dataIntegrityTime) == 4:
                    timeDiff(dataIntegrityTime[2], dataIntegrityTime[3])
        #ShortIO
        elif testName == "shortio":
            print "=FIO (duration 4hrs each)="
            printTest(startFIOendFIO)
            print ""
            for i in range(0, len(startFIOendFIO)):
                if "Done running FIO on" in startFIOendFIO[i]:
                    count += 1

            print "Total number of VMs w/ completed FIO: ",
            print count
            print ""
            try:
                print "First FIO thread:"
                print shortio[0],
                print shortio[2]

                print "First FIO completion time: ",
                timeDiff(shortio[0], shortio[2])
                print "\n"
                print "Second FIO thread: "
                print shortio[1],
                print shortio[3]

                print "Second FIO completion time: ",
                timeDiff(shortio[1], shortio[3])
            except:
                print "cannot compute"

        else:
            print "=FIO="
            printTest(startFIOendFIO)
            print ""
            for i in range(0, len(startFIOendFIO)):
                if "Done running FIO on" in startFIOendFIO[i]:
                    count += 1

            print "Total number of VMs w/ completed FIO: ",
            print count
            print ""
            printCompletionTime(startFIOendFIO, 0, -1)

        print ""

        #Hybrid CombinedLong: 100r, 100w, 95phr, 99phr, 100phr, 100phr with checksum
        if testName == "combinedLong":
            print "=100r test (3hr)="
            printTest(hy100r)
            printCompletionTime(hy100r, 0, 1)

            print "=100w test (3hrs)="
            printTest(hy100w)
            printCompletionTime(hy100w, 0, 1)

            print "=70r30w 95% test (4hrs)="
            printTest(hy95phr)
            printCompletionTime(hy95phr, 0, 1)

            print "=70r30w 99% test (4hrs)="
            printTest(hy99phr)
            printCompletionTime(hy99phr, 0, 1)

            print "=70r30w 100% test (4hrs)="
            printTest(hy100phr)
            printCompletionTime(hy100phr, 0, 1)

            print "=70r30w 100% with checksum test (4hrs)="
            printTest(hy100phrchksum)
            printCompletionTime(hy100phrchksum, 0, 1)

        if testName == "af-enc":
            print "=Encryption info="
            printTest(encryptionMSG)
            print "AF Encryption",
            printCompletionTime(encryptionMSG, 0, -1)

        if testName == "hy-enc":
            print "=70r30w 99phr encryption test (4hrs)="
            printTest(hyEncryptionMSG)
            print "HY Encryption",
            printCompletionTime(hyEncryptionMSG, 0, -1)

        if testName == "af-data-integrity":
            print "\n\n"
            print "=DiskScrubber info="
            if len(diskScrubber) >= 1:
                printTest(diskScrubber)

        if testName == "af-100r0w":
            print("=100r test (1 hr)=")
            printTest(AFperf)

        if testName == "4k":
            print("=100w long 4k test (4 hrs)=")
            printTest(AFperf)

        if testName == "64k":
            print("=100w long 4k test (2 hrs)=")
            printTest(AFperf)

        if testName == "50gb":
            print("=70r30w long 50gb test (1 hr)=")
            printTest(AFperf)

        if testName == "mdCap":
            print("=70r30w long mdCap test (4 hrs)=")
            printTest(AFperf)

        if testName == "short":
            print("=IOBlazer or FIO (duration ~22.22mins)=")
            printTest(AFperf)

        if testName == "reset":
            print "=Busreset, Lunreset, Targetreset (duration is 12hrs)="
            print resetStart[0]
            print "Last busreset, lunreset, and targetrest"

            if len(busReset) >= 1:
                print busReset[-1],
            if len(lunReset) >= 1:
                print lunReset[-1],
            if len(targetReset) >= 1:
                print targetReset[-1],

            print "\n"
            print "busReset count: ",
            print len(busReset)
            print "lunReset count: ",
            print len(lunReset)
            print "targetReset count: ",
            print len(targetReset)

            print ""

            print "busReset time: ",
            if len(busReset) >= 1:
                timeDiff(resetStart[0], busReset[-1])
            else:
                print ""
            print "lunReset time: ",
            if len(lunReset) >= 1:
                timeDiff(resetStart[0], lunReset[-1])
            else:
                print ""
            if len(targetReset) >= 1:
                print "targetReset time: ",
                timeDiff(resetStart[0], targetReset[-1])

            print "\n"

        if testName == "sharedvmfs":
            print "=shortIO script process ID="
            for y, x in enumerate(sharedVMFS):
                print x,

            print "\n"


        if testName == "7day":
            print "=Number of test days="
            for y, x in enumerate(numOfDayFor7day):
                print x,

            print "\n"

            #print each day
            print "Day1: ",
            if 2 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[0], numOfDayFor7day[1])
            else:
                print "cannot compute"
            print "Day2: ",
            if 4 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[2], numOfDayFor7day[3])
            else:
                print "cannot compute"
            print "Day3: ",
            if 6 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[4], numOfDayFor7day[5])
            else:
                print "cannot compute"
            print "Day4: ",
            if 8 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[6], numOfDayFor7day[7])
            else:
                print "cannot compute"
            print "Day5: ",
            if 10 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[8], numOfDayFor7day[9])
            else:
                print "cannot compute"
            print "Day6: ",
            if 12 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[10], numOfDayFor7day[11])
            else:
                print "cannot compute"
            print "Day7: ",
            if 14 <= len(numOfDayFor7day):
                timeDiff(numOfDayFor7day[12], numOfDayFor7day[13])
            else:
                print "cannot compute"

        print "\n"


        print "=DiskGroup deletion timeout (workaround)="
        printTest(FdsOpenMaxRetries)
        print "\n\n"


        print "=Cleanup="
        printTest(cleanup)

        print "\n\n"

        print "=Status="
        print status


def heading_bar():
	return " " * 46 + "=" * 54 + "\n"

def banner(lst_str):
    middle_sec = ""
    for str in lst_str:
        middle_sec += " " * 46 + string.center(str, 54, " ") + "\n"
    return "{}{}{}\n\n".format(heading_bar(),
		  middle_sec,
          heading_bar())

#
#   Collect log summary
#
def collectLogs(filename, testName):

    in_a_traceback = False
    in_a_ERROR = False
    in_a_bootbank = False
    in_scsidev = False
    global testVer
    global hpComplete
    global errorMSG
    global traceBackMSG
    global status
    global deployVMtime
    global hostName
    global allVMDeployedtime
    global esxWBtime
    global esxVersion
    global consumedDisk
    global serverVendorName
    global serverProductName
    global controller
    global driverName, driverVersion, viddidsvidsdid, controllerQueueDepth,\
	 	deviceSN, modelNumber, Model, firmwareRevision
    global firmware, firmRev
    global deviceQueueDepth, DisplayName, DriveSize, DriveModel, revision
    global diskResult, Name, vsanUUID, State, isCapacity, bootbank
    global tmpDiskResults
    global sharedVMFS

    readFile = open(filename, "r")

    testname_description_map = {
        "getinfo": ["GetInfo"],
        "4k": ["AF 0r100w_long_4k test (8hrs max)"],
        "64k": ["AF 0r100w_long_64k test (6hrs max)"],
        "af-100r0w": ["AF af-100r0w_long test (4hrs max)"],
        "50gb": ["AF 70r30w long 50gb test (2hrs max)"],
        "mdCap": ["AF 70r30w long mdCap test (10hrs max)"],
        "reset": ["AF/HY Reset test (24hrs max)"],
        "7day": ["AF/HY 7day (174 hrs max or 7.25 days)"],
        "stress": ["AF/HY Stress test (20 hrs max)"],
        "af-data-integrity": ["AF data-integrity (20hrs hrs max)"],
        "af-enc": ["AF 70r30w_long_mdCap_enc test (10hrs max)"],
        "shortio": ["AF/HY Short IO test (8hrs max)"],
        "short": ["Allflash/Hybrid short tests (50mins max per test)",
            "0r100w, 10r90w, 30r70w, 50r50w",
            "90r10w, 70r30w, or 100r0w"],
        "combinedLong": ["CombinedLong test (75hrs max)"],
        "hy-enc": ["Hybrid 70r30w long 99phr enc test (8:33 hrs max)"],
        "hp-planned": ["diskRemoveReinsertPlanned test"],
        "hp-unplanned": ["diskRemoveReinsertUnplanned test"],
        "sharedvmfs": ["AF/HY SharedVMFS vsanDatastore (24hrs max)"]
    }

    print(banner(testname_description_map[testName]))


# read through the test-vpx file and collect data

    for line in readFile:

        entireTest.append(line)

        if re.match("(.*)ESX Version", line):
            esxVersion = line.split("ESX Version         ==>")[1].strip()

        if re.match("(.*)Server Vendor Name", line):
            serverVendorName = line

        if re.match("(.*)Server Product Name", line):
            serverProductName = line

        if re.match("(.*)sas.5(.*)", line):
            controller = line

        if re.match("(.*)Importing", line):
            test = line.split()[5]

        #if re.match("(.*)Driver Name", line):
        if re.match('(.*)Driver Name         ==>', line):
            driverName.append(
                line.split("\n")[0].replace('Driver Name         ==>',
                                            '    Driver Name:').split("\t")[1])

        if re.match("(.*)Driver Version      ==>", line):
            if "b'Version" in line:
                driverVersion.append(
                    line.split("\n")[0].replace(
                        r'Driver Version      ==>	 Version:', '').split("\t")[
                            1])
            else:
                driverVersion.append(
                    line.split("\n")[0].replace(
                        'Driver Version      ==>	 Version:', '').split("\t")[
                            0])

        if re.match("(.*)VID:DID SVID:SDID   ==>", line):
            viddidsvidsdid.append(
                line.split("\n")[0].replace('VID:DID SVID:SDID   ==>',
                                            ' VID:DID SVID:SDID:').split("\t")[
                                                1])

        if re.match("(.*)QDepth Current:Max  ==>", line):
            controllerQueueDepth.append(
                line.split("\n")[0].replace('QDepth Current:Max  ==>', '')
                .split("\t")[1])

        if re.match("(.*)  Serial Number:", line):
            deviceSN.append(line.split("\n")[0])

        if re.match("(.*)  Model Number:", line):
            modelNumber.append(line.split("\n")[0].replace("\t", "").strip())

        if re.match("(.*)  Model:", line):
            Model.append(line.split("\n")[0])

        if re.match("(.*)  Firmware Revision:", line):
            firmwareRevision.append(line.split("\n")[0])

        mtchScsiDev = re.match(r'esxcfg-scsidevs -A', line)
        if mtchScsiDev or in_scsidev:
            esxcfgscsidevsA.append(line)
            if mtchScsiDev:
                in_scsidev = True
            elif re.match(r'esxcfg-scsidevs -c', line):
                in_scsidev = False

            esxcfgscsidevsA.append(line)

        if re.match("(.*)Firmware Version|(.*)Firmware Package", line):
            firmware.append(line)

        if re.match("(.*)Firmware Revision", line):
            firmwareRev.append(line)

        if re.match(r'(.*)  Display Name: ', line):
            DisplayName.append(line)

        if re.match(r'(.*)  Revision: ', line):
            revision.append(line)

        if re.match(r"(.*)  Size:", line):
            DriveSize.append(line)

        if re.match(r"(.*)  Model Number:", line):
            DriveModel.append(line)

        if re.match(r"(.*)  Device Max Queue Depth:", line):
            deviceQueueDepth.append(line)

        if re.match(r"(.*)  DiskResult", line):
            diskResult.append(line)

        if re.match(r"(.*)  Name: ", line):
            Name.append(line)

        if re.match(r"(.*)  VSANUUID", line):
            vsanUUID.append(line)

        if re.match(r"(.*)  State", line):
            State.append(line)

        if re.match(r"(.*)IsCapacityFlash", line):
            isCapacity.append(line)

        mtchBootbank = re.match(r"(.*)vmkfstools -Ph", line)
        if mtchBootbank or in_a_bootbank:
            bootbank.append(line)
            if mtchBootbank:
                in_a_bootbank = True
            elif re.match(r'Is', line):
                in_a_bootbank = False

        if re.match("(.*)Test version", line):
            testVer = line.split()[6]

        if re.match("(.*)host.py::IsReachable", line):
            hostName = line.split()[5]

        mtchErr = re.match(r"(.*)ERROR.*", line)
        if mtchErr or in_a_ERROR:
            errorMSG.append(line)
            if mtchErr:
                in_a_ERROR = True


#			elif re.match(r'^}$', line):
            elif re.match(r'\d{4}[-/]\d{2}[-/]\d{2}', line):
                in_a_ERROR = False

        mtch = re.match(r"Traceback.*|(.*)Test exception:", line)
        if mtch or in_a_traceback:
            traceBackMSG.append(line)
            if mtch:
                in_a_traceback = True
            #elif re.match(r'^}$', line):
            elif re.match(r'\d{4}[-/]\d{2}[-/]\d{2}', line):
                in_a_traceback = False

        if re.match("(.*)(C||)onsumed", line):
            consumedDisk.append(line)

        if re.match("(.*)ESX Date", line):
            esxWBtime = line

        if re.match("(.*)DiskMapping\[", line):
            diskMapping.append(line)

        if re.match("(.*)Adding data", line):
            addDisk.append(line)

        if re.match("(.*)got IP", line):
            ipAddress.append(line)

        if re.match("(.*)Deploying VMs", line):
            deployVMtime = line

        if re.match("(.*)All VMs deployed", line):
            allVMDeployedtime = line

        if re.match("(.*)Error.*", line):
            diskScrubber.append(line)

        if re.match("(.*)(dd if=|Done running dd on host)", line):
            ddInfo.append(line)

        if re.match(
                "(.*)(DiskHealthCheckThread: Starting "
                "CheckDiskHealth|DiskHealthCheckThread: CheckDiskHealth thread "
                "completed)", line):
            diskHealthCheck.append(line)

        if re.match(
                "(.*)(VMIOThread: Starting IO On all vms|VMIOThread: VM IO Thread completed)",
                line):
            VMIOThread.append(line)

        if re.match("(.*)WB usage at", line):
            wbUsage.append(line)

        if re.match(
                "(.*)Starting 100r test|(.*)Starting 100r0w test|(.*)100r test "
                "complete|(.*)100r0w test complete", line):
            hy100r.append(line)

        if re.match(
                "(.*)Starting 100w test|(.*)Starting 0r100w test|(.*)100w "
                "test complete|(.*)0r100w test complete", line):
            hy100w.append(line)

        if re.match(
                "(.*)Starting 70r30w 95% hit rate|(.*)70r30w 95% hit rate test complete",
                line):
            hy95phr.append(line)

        if re.match(
                "(.*)Starting 70r30w 99% hit rate|(.*)70r30w 99% hit rate test complete",
                line):
            hy99phr.append(line)

        if re.match(
                "(.*)Starting 70r30w 100% hit rate|(.*)70r30w 100% hit rate test complete",
                line):
            hy100phr.append(line)

        if re.match(
                "(.*)Starting 70r30w 100%  hit rate checksum|(.*)70r30w 100%  hit rate checksum test complete",
                line):
            hy100phrchksum.append(line)

        if re.match(
                "(.*)Starting FIO runs|(.*)All VM IO threads are completed",
                line):
            shortio.append(line)

        if re.match(
                "(.*)Software Encryption setup started...|"
                "(.*)Verifying whether encryptionEnabled field is|(.*)Finished Software Encryption setup...",
                line):
            encryptionMSG.append(line)

        if re.match(
                "(.*)Verifying whether encryptionEnabled field is True|(.*)Enabling Encryption "
                "through API completed successfully|(.*)Current Encryption Status is: "
                "False|(.*)Encryption disabled successfully",
                line):
            hyEncryptionMSG.append(line)

        if re.match(
                "(.*)(Starting IOBlazer|Starting FIO runs|Done running FIO)",
                line):
            startFIOendFIO.append(line)

        if re.match(
                "(.*)(Starting test|Starting IOBlazer|............COMPLETED)",
                line):
            AFperf.append(line)

        if re.match("(.*)(Starting FIO runs|All VM IO threads are completed)",
                    line):
            dataIntegrityTime.append(line)

        if re.match("(.*)(short IO Script process ID|stop short IO script)",
                    line):
            sharedVMFS.append(line)

        if re.match("(.*)(starting device reset|Starting controller reset)",
                    line):
            resetStart.append(line)

        if re.match("(.*)(Running busreset)", line):
            busReset.append(line)

        if re.match("(.*)(Running lunreset)", line):
            lunReset.append(line)

        if re.match("(.*)(Running targetreset)", line):
            targetReset.append(line)

        if re.match(
                "(.*)(Starting iometer for a day|iometer run complete|starting "
                "ioblazer for a day|ioblazer run complete|Starting FIO "
                "runs|RunIoForDays: IO for day)", line):
            numOfDayFor7day.append(line)

        if re.match("(.*)LED on host", line):
            hpLED.append(line)

        if re.match("(.*)STARTING TEST: PLANNED:|(.*)COMPLETED TEST: PLANNED:",
                    line):
            hpShortSummary.append(line)

        if re.match(
                "(.*)Found the user prompt|(.*)Please reinsert|(.*)Found all "
                "the components|(\s*)expected State ABSENT|(\s*)expected "
                "State ACTIVE|(\s*)expected State DEGRADED",
                line):
            hpMidSummary.append(line)
            #for _ in range(1):                          # find the matching string, and trailing Context
            #hpMidSummary.append(readFile.next())

        if re.match(
                "(.*)Simple component state|(.*)Found the user "
                "prompt|(.*)Please reinsert|(.*)Found all the "
                "components|(\s*)expected State ABSENT|(\s*)expected State "
                "ACTIVE|(\s*)expected State DEGRADED",
                line):
            hpFullSummary.append(line)

        if re.match("(.*)RAID1COMPLETED", line):
            hpComplete = line

        if re.match("(.*)diskManagementGeneralTest", line):
            hpHighLevelSummary.append(line)

        if re.match("(.*)FdsOpenMaxRetries", line):
            FdsOpenMaxRetries.append(line)

        if re.match(
                "(.*)(DestroyAllVMsInCluster|DestoryAllVMsInCluster|"
				"Cleaning up any VSAN|Cleaning|Deleting all|Done cleaning)",
                line):
            cleanup.append(line)

        if re.match("(.*)......COMPLETED|(.*).....CLEANFAIL|(.*).......FAIL",
                    line):
            status = line

    readFile.close()

    if testName == "getinfo":
        GetInfo(testName, hostName)
    else:
        displaySummary(testName, hostName, test, testVer, deployVMtime,
                       allVMDeployedtime, status, hpComplete)


def main():
    parser = OptionParser("LogSummary")
    parser.add_option(
        '-f',
        '--file-name',
        dest='fname',
        help="The name of the"
        " log file you are trying to summarize.")
    parser.add_option(
        '-t',
        '--test-name',
        dest='tname',
        help="Test Name: "
        "short, af-100r0w, 4k, 64k, mdCap, 50gb, 7day, stress, reset, shortio, "
        "af-data-integrity, af-enc, hy-enc, combinedLong, hp-planned, "
        "hp-unplanned, getinfo, sharedvmfs")
    opt, args = parser.parse_args()
    if not opt.fname or not opt.tname:
        print("Invalid arguments.")
        exit(1)
    collectLogs(opt.fname, opt.tname)


if __name__ == "__main__":
    main()
