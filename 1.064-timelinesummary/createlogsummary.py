#!/usr/bin/python
#version 1.064
# lightgreen and lightblue theme
import scandir, os, subprocess, re, datetime, fnmatch



testVPX = r"test-vpx.vsan.*"
summaryCTRL = r"summary-ctrl(.*)"
summary = []
summaryForHTML = []
currentDir=""
dateTimeHTML = []
testVPXcompletion = []
vendorUtilGetinfo = []
testVPXpathFile = []

sanityResult = []
IOCertVER = ""
FoundMode = False
modeStatus = ""
getHostname = []
vmkerneldir = ""
DG = []




#
#   pipe it to use linux command
#
def cmdline(command):
	process = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	return process.communicate()[0]


def writeSummaryToFile(summary):
        with open("timeline-path.txt", "wb") as s:
                s.write("\n")
                s.write("LogSummary location:")
                s.write("\n\n")
                for i in summary:
                        s.write(i)

def checkMode(testname):
    #
    # If test is in one of the list elements, it will return the Mode accordinginly
    #
    tmpHY = ['7day_stress_c1', '7day_stress_c2', 'combined_long_c1', 'combined_long_c2',
             'reset_c1', 'reset_c2', '70r30w_long_99phr_enc_c1', '70r30w_long_99phr_enc_c2',
             'stress_c1', 'stress_c2', 'sharedVmfs_boot_vsanDatastore_af_c1',
             'sharedVmfs_boot_vsanDatastore_af_c2',
             'diskRemoveReinsertPlanned', 'diskRemoveReinsertUnplanned']

    tmpAF = ['100r0w_long_af_c1', '100r0w_long_af_c2', '70r30w_long_mdCap_af_c1',
             '70r30w_long_mdCap_af_c2', 'reset_af_c1', 'reset_af_c2',
             '70r30w_long_50gb_af_c1', '70r30w_long_50gb_af_c2', '0r100w_long_4k_af_c1',
             '0r100w_long_4k_af_c2', '7day_stress_af_c1', '7day_stress_af_c2',
             'stress_af_c1', 'stress_af_c2', 'sharedVmfs_boot_vsanDatastore_c1',
             'sharedVmfs_boot_vsanDatastore_c2'
             '0r100w_long_64k_af_c1', '0r100w_long_64k_af_c2', '70r30w_long_mdCap_enc_af_c1',
             '70r30w_long_mdCap_enc_af_c2', 'data_integrity_af_c1', 'data_integrity_af_c2',
             'af_diskRemoveReinsertPlanned', 'af_diskRemoveReinsertUnplanned']

    # determine the Mode if it's Hybrid or Allflash
    if testname in tmpAF:
        modeOutput = "ALLFLASH"
        return modeOutput
    elif testname in tmpHY:
        modeOutput = "HYBRID"
        return modeOutput
    else:
        modeOutput = ""
        return modeOutput



def getTestName(tn):
    if tn == "30r70w_short" or tn == "0r100w_short" or tn == "100r0w_short" \
        or tn == "50r50w_short" or tn == "90r10w_short" or tn == "70r30w_short" \
        or tn == "10r90w_short":
        return "ctrl*"

    if tn == "combined_long_c1" or tn == "combined_long_c2":
        return "70r30w_95*"

    if tn == "reset_c1" or tn == "reset_c2" or tn == "reset_af_c1" or tn == "reset_af_c2":
        return "ctrlr_reset*"

    if tn == "short_io_c1" or tn == "short_io_c2":
        return "ctrlr_short_io-*"

    if tn == "stress_c1" or tn == "stress_c2" \
        or tn == "stress_af_c1" or tn == "stress_af_c2":
        return "ctrlr_stress*"

    if tn == "7day_stress_c1" or tn == "7day_stress_c2" \
        or tn == "7day_stress_af_c1" or tn == "7day_stress_af_c2":
        return "ctrlr_7day_stress*"

    if tn == "sharedVmfs_boot_vsanDatastore_c1" or tn == "sharedVmfs_boot_vsanDatastore_c2" \
        or tn == "sharedVmfs_boot_vsanDatastore_af_c1" or tn == "sharedVmfs_boot_vsanDatastore_af_c2":
        return "ctrlr_sharedVmfs_boot_vsanDatastore*"

    if tn == "short_timeout_io_c1" or tn == "short_timeout_io_c2" \
        or tn == "short_timeout_io_af_c1" or tn == "short_timeout_io_af_c2":
        return "ctrlr_short_timeout_io*"

    if tn == "70r30w_long_99phr_enc_c1" or tn == "70r30w_long_99phr_enc_c2":
        return "70r30w*"

    if tn == "100r0w_long_af_c1" or tn == "100r0w_long_af_c2":
        return "100r0w*"

    if tn == "0r100w_long_4k_af_c1" or tn == "0r100w_long_4k_af_c2" \
        or tn == "0r100w_long_64k_af_c1" or tn == "0r100w_long_64k_af_c2":
        return "0r100w_*"

    if tn == "70r30w_long_mdCap_af_c1" or tn == "70r30w_long_mdCap_af_c2" \
        or tn == "70r30w_long_mdCap_enc_af_c1" or tn == "70r30w_long_mdCap_enc_af_c2" \
        or tn == "70r30w_long_50gb_af_c1" or tn == "70r30w_long_50gb_af_c2":
        return "70r30w_*"

    if tn == "data_integrity_af_c1" or tn == "data_integrity_af_c2":
        return "ctrlr_data_integrity_af*"

    if tn == "diskRemoveReinsertPlanned" or tn == "diskRemoveReinsertUnplanned" \
        or tn == "af_diskRemoveReinsertPlanned" or tn == "af_diskRemoveReinsertUnplanned":
        return "*diskRemove*"

    if tn == "log_compaction_c1" or tn == "log_compaction_c2":
        return "ctrlr_log_compaction_*"



def statsDir(test, testvpxlocation, hn, numOfHost):
    num=0
    p = os.path.join(testvpxlocation, 'traces')
    t = getTestName(test)

    for root, dirs, files in scandir.walk(p):
	for x in fnmatch.filter(dirs, t):
            statsFile = p + "/" + x + "/stats.html"
            # sometimes there will be multiple traces folders ; read stats.html to find out the IP to match the test-vpx
            a = "cat " + statsFile + " | grep -iE 'ESX host' | awk '{print $3}' "
            chkhostname = cmdline(a)
            chkhostname = chkhostname[:-1]

            if chkhostname == hn:
                if num < numOfHost:     # will only output hdd details on different host
                    if test == "combined_long_c1" or test == "combined_long_c2" \
                        or test == "7day_stress_c1" or test == "7day_stress_c2" \
                        or test == "7day_stress_af_c1" or test == "7day_stress_af_c2" \
			or test == "sharedVmfs_boot_vsanDatastore_af_c1" or test == "sharedVmfs_boot_vsanDatastore_af_c2" \
			or test == "sharedVmfs_boot_vsanDatastore_c1" or test == "sharedVmfs_boot_vsanDatastore_c2":
                        num=num+1
                        return p
                    else:
                        num=num+1
                        return statsFile



def writeSummaryToHTML(summary):
    global FoundMode, modeStatus, vmkerneldir
    missingTest = []
    vmkernelFolder = ""
    summaryContent = {}     # will use this to sort by timestamp


    todayDate = datetime.datetime.now()

    testVPXstatus = ""
    FW = ""
    vendorUtil =""
    count = 0


    for i in range(0, len(summaryForHTML)):
    # summaryFotHTML: Testname, Location, filename, Path+File
    # Note: currently using | to separte the data, there could be a possibility that the dir
    #       might contain a | character, in that case, use to another delimiter
    #
        testvpx = summaryForHTML[i].split('|')[0]
        testVPXlocation = summaryForHTML[i].split('|')[1]
        summaryFile = summaryForHTML[i].split('|')[2]
        pathFile = summaryForHTML[i].split('|')[3]

        hn = getHostname[i].split("\n")[0]
        TMPstatsHTML = statsDir(testvpx, testVPXlocation, hn, 1)

        # Need to find out the subdirectory for relative path in HTML,
        # take currentPath subtract the originalPath to get the difference.
        #    ie1   abc/foo    is orginal directory
        #          abc/foo/hello/output.txt is the current directory + file
        #          relative of that would be   ./hello/output.txt
        #    ie2   abc/foo/hello - abc/foo = hello

        # currentDir is the "parent directory" where you issue createlogsummary.py
        pattern = currentDir + "/"

        #current dir subtract original directory for summary file
        subDirFileRelative = re.sub(pattern,'', pathFile)
        #current dir subtract original directory for testVPX file
        subTestVPXrelative = re.sub(pattern,'', testVPXpathFile[i])
        #current dir subtract original directory for statsHTML
        #statsHTML = re.sub(pattern,'', TMPstatsHTML)


        if TMPstatsHTML == None:
            statsHTML = ''
            statsHTMLlink = ''
        else:
         # combinedLong and 7day have multiple statsDir hence we are only getting dir path
         #current dir subtract original directory for statsHTML
            statsHTML = re.sub(pattern,'', TMPstatsHTML)
            #statsHTML
            if testvpx == "combined_long_c1" or testvpx == "combined_long_c2":
                  statsHTMLlink = 'dir'

            if testvpx == "7day_stress_c1" or testvpx == "7day_stress_c2" \
                or testvpx == "7day_stress_af_c1" or testvpx == "7day_stress_af_c2":
                  statsHTMLlink = 'dir'

            if testvpx == "log_compaction_c1" or testvpx == "log_compaction_c2":
                  statsHTMLlink = 'dir'
            else:
                statsHTMLlink = 'stats-html'



        #read testVPXstatus ; if COMPLETED then add testname into sanityResult variable for test Sanity Checking
        if "......COMPLETED" in testVPXcompletion[i] or "RAID1COMPLETED" in testVPXcompletion[i]:
            testVPXstatus = "COMPLETED"
        elif ".....CLEANFAIL" in testVPXcompletion[i]:
            testVPXstatus = "CLEANFAIL"
        elif ".....FAIL" in  testVPXcompletion[i]:
            testVPXstatus = "FAIL"
        elif ".....SETUPFAIL" in testVPXcompletion[i]:
            testVPXstatus = "SETUPFAIL"
        else:
            testVPXstatus="UNKNOWN"


        #check if vendor utility is installed
        if vendorUtilGetinfo[i]:
            if "Firmware Version" in vendorUtilGetinfo[i]:
                vendorUtil = "Yes"
            else:
                vendorUtil = " "

            fw = vendorUtilGetinfo[i]
        else:
            vendorUtil = " "
            fw = " "


    # Get VMKernel directories
    # From the location where test-vpx lives, check if vmkernel dir exist
    #    if exist, added path and set vmkerneldir -> dir
    #    if not, ( no link )
        # start from scanning in test-vpx location where c1 and c2 live
        dirResult = checkDir(testVPXlocation, getHostname[i].split("\n")[0])
        if dirResult == None:
            vmkerneldir = ''
            vmkernelFolder = ''
        else:
            vmkernelFolder = "./" + dirResult
            vmkerneldir = 'dir'


        #popular data into a list
        TMPsummaryContent = [ testvpx, testVPXstatus, subDirFileRelative, subTestVPXrelative, \
                                statsHTML, statsHTMLlink, vmkernelFolder, vmkerneldir, \
                                vendorUtilGetinfo[i], vendorUtil, hn, DG[i] ]
        #each timestamp will have its own list of data
        summaryContent[dateTimeHTML[i]] = TMPsummaryContent


    Html_file = open("timeline-summary.html","w")
    html_start = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
            <style>
            html {
                 font-family: -apple-system, BlinkMacSystemFont,
                              "Segoe UI", "Roboto", "Oxygen",
                              "Ubuntu", "Cantarell", "Fira Sans",
                              "Droid Sans", "Helvetica Neue", sans-serif;
            }
            table {
                border-collapse: collapse;
                width: 100%;
            }


            td, th {
                border: 1px solid #F0F8FF;
                text-align: center;
                padding: 6px;
            }

            tr:nth-child(even) {
                background-color: #F0F8FF;
            }

            tr:hover {
                background: #B5EAAA;
            }

            a:link {
                color: #663399;
                background-color: transparent;
                text-decoration: none;
            }

            a:visited {
                color: grey;
                background-color: transparent;
                text-decoration: none;
            }

            a:hover {
                color: white;
                background-color: transparent;
                text-decoration: none;
            }

            a:active {
                color: black
                background-color: transparent;
                text-decoration: none;
            }

            ::-moz-selection { /* Code for Firefox */
                color: black;
                background: lightblue;
            }

            ::selection {
                color: black;
                background: lightblue;
            }

            </style>
            </head>
            <body>
            <h3>Timeline Links</h3>
            <table>
                <tr>
                    """
    Html_file.write(html_start)

    tmpSanity = {}
    flipped = {}
    for j in range(0, len(summaryForHTML)):
    # summaryFotHTML: Testname, Location, filename, Path+File
    # Note: currently using | to separte the data, there could be a possibility that the dir
    #       might contain a | character, in that case, use to another delimiter
    #
        testvpx = summaryForHTML[j].split('|')[0]
        testVPXlocation = summaryForHTML[i].split('|')[1]


        # Find Mode (HYBRID or ALLFLASH) - only ONCE
        if FoundMode is False:
            modeStatus = checkMode(testvpx)

            if modeStatus == "":
                FoundMode = False
            else:
                FoundMode = True


        #test that are COMPLETED, will add to sanityResult; will use in Test Sanity Checking later
        if "......COMPLETED" in testVPXcompletion[j] or "RAID1COMPLETED" in testVPXcompletion[j]:
            tmpSanity[testvpx]=testVPXlocation


    #find Dictionary keys w/ duplicate values
    for key, value in tmpSanity.items():
        if value not in flipped:
            flipped[value] = [key]
        else:
            flipped[value].append(key)

    #if c1 and c2 have the same directory, test is a PASS ; except for short and hotplug as they have only 1
    for key, value in flipped.items():
        for i in value:
            if len(value) >= 2:
                sanityResult.append(i)
            elif i == "100r0w_short" or i == "10r90w_short" or i == "30r70w_short" \
                or i == "50r50w_short" or i == "70r30w_short" or i == "0r100w_short" \
                or i == "90r10w_short":
                sanityResult.append(i)


    html_str5 = """
            </table>
            <table>
                <tr>
                    <th bgcolor="#B5EAAA"></th>
                </tr>
            </table>
            <table>
                <tr>
                """
    Html_file.write(html_str5)

    html_str5 = """
                    <th bgcolor="#A0CFEC">Mode: """ + modeStatus + """ </th>
                    <th bgcolor="#A0CFEC">IOCert Test Suite: """ + IOCertVER + """ </th>
                    <th bgcolor="#A0CFEC">Timeline summary created on: """ + todayDate.strftime("%m-%d-%Y") + """ </th>
                </tr>
            </table> """
    Html_file.write(html_str5)

    html_str3 = """
            <table>
                <tr>
                <th bgcolor="#A0CFEC"></th>
                <th bgcolor="#A0CFEC">Testname</th>
                <th bgcolor="#A0CFEC">Date / Time</th>
                <th bgcolor="#A0CFEC">Hostname / IP</th>
                <th bgcolor="#A0CFEC">Diskgroup(s)</th>
                <th bgcolor="#A0CFEC">Test Status</td>
                <th bgcolor="#A0CFEC">LogSummary</th>
                <th bgcolor="#A0CFEC">Test VPX</th>
                <th bgcolor="#A0CFEC">Stats</th>
                <th bgcolor="#A0CFEC">VMKernel dir</th>
                <th bgcolor="#A0CFEC">Controller FW Version</th>
                <th bgcolor="#A0CFEC">Vendor Utility</th></tr>"""

    # add / increment html links for each test accordingly
    Html_file.write(html_str3)



#
# summarContest-> 0) testvpx ,1) testVPXstatus, 2) subDirFileRelative, 3) subTestVPXrelative, 4) statsHTML,
#                 5) statsHTMLlink,6) vmkernelFolder, 7)vmkerneldir, 8)vendorUtilGetinfo[i], 9) vendorUtil
#                 10) hostname 11) DG
#
    keylist = summaryContent.keys()
    keylist.sort()
    for key in keylist:
        count += 1
        #print "%s: %s" % (key, summaryContent[key])
        ddateTime = key
        for j in range(0, len(summaryContent[key])):
            if j == 0:
                ttestvpx = summaryContent[key][j]
            if j == 1:
                ttestVPXstatus = summaryContent[key][j]
            if j == 2:
                ssubDirFileRelative = summaryContent[key][j]
            if j == 3:
                ssubTestVPXrelative = summaryContent[key][j]
            if j == 4:
                sstatsHTML = summaryContent[key][j]
            if j == 5:
                sstatsHTMLlink = summaryContent[key][j]
            if j == 6:
                vvmkernelFolder = summaryContent[key][j]
            if j == 7:
                vvmkerneldir = summaryContent[key][j]
            if j == 8:
                vvendorUtilGetinfo = summaryContent[key][j]
            if j == 9:
                vvendorUtil = summaryContent[key][j]
            if j == 10:
                hhn = summaryContent[key][j]
            if j == 11:
                diskgroup = summaryContent[key][j]


        html_str4 = """
               <tr>
                <td>""" + str(count) + """</td>
                <td>""" + ttestvpx + """</td>
                <td>""" + ddateTime + """</td>
                <td>""" + str(hhn) + """ </td>
                <td>""" + diskgroup + """ </td>
                <td>""" + ttestVPXstatus + """</td>
                <td>""" + "<a href=\"./" + ssubDirFileRelative + "\">" + "summary file" + """</a> </td>
                <td>""" + "<a href=\"./" + ssubTestVPXrelative + "\">" + "test-vpx file" + """</a> </td>
                <td>""" + "<a href=\"./" + sstatsHTML + "\">" + sstatsHTMLlink + """</a> </td>
                <td>""" + "<a href=\"./" + str(vvmkernelFolder)  + "\">" + str(vvmkerneldir) + """</a> </td>
                <td>""" + str(vvendorUtilGetinfo) +"""</td>
                <td>""" + str(vvendorUtil) + """</td></tr>"""

            #<td style="text-align:left">""" + pathFile + """</td>
        Html_file.write(html_str4)
        # add html field ends here

    html_str7 = """
            </tr>
            </table>
            <table>
            </body>
            </html>
            """
    Html_file.write(html_str7)
    Html_file.close()


def genLogsummary(currentPath, testname, ts, output):
    global IOCertVER,getHostname,DG


    print "Found: " + testname
    print "Generating logsummary for " + testname

    #cd into the directory with double quote around it in case for special characters or spaces
    cmdline('cd ' + '"' + currentPath + '"' + ' ; logsummary.py -f ' + testname + ' -t '+ ts +' > ' + output)
    print "Location: " + currentPath

    #set path + filename content into variable
    pathFile = currentPath + "/" + output

    #find patterns and strip it, ie  summary-ctrl_getinfo_c1.txt -> ctrlr_getInfo
    pattern = re.compile(r'summary-ctrlr_|summary-ctrlr-|.txt|.log|_RAID1')
    tn = re.sub(pattern,'', output)

    #update content into summary
    summary.append(tn + " : " + pathFile + "\n")
    print "\n"

    #collect summary for HTML only : testname, testvpxPath, summaryFilename, and fullPath+summaryfilename
    summaryForHTML.append(tn + "|" + currentPath + "|" + output + "|" + pathFile )

    #get testvpx file
    testVPXpathFile.append(currentPath+"/"+testname)

    #get Date/Time for HTML only
    tmpDateTime = cmdline("cat " + "'" + currentPath + "'" + "/" + testname + " | head -1 | awk '{print $1,$2}' ")
    dateTimeHTML.append(tmpDateTime)

    #get completion status in testvpx file for HTML only
    tmpComplete = cmdline("cat " + "'" + currentPath + "'" + "/" + testname + " \
                | grep -iE 'COMPLETED \(|...cleanfail|...........fail|......SETUPFAIL' ")
    testVPXcompletion.append(tmpComplete)

    #get firmware version or firmware revision for HTML only
    tmpvendorUtilGetinfo = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + "| grep -iE 'firmware version' | sort | uniq")
    vendorUtilGetinfo.append(tmpvendorUtilGetinfo)

    #get IOcert version for sanityChecking
    IOCertVER = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " \
                    | grep -iE 'Test version' | awk '{print $7}'")

    #get Hostname ; will need it for vmkernel directory ; sed is to remove the period
    tmpHN = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " |  \
                    grep -iE 'Hosts reserved' | awk '{print $9}' | sed 's/.$//'")
    getHostname.append(tmpHN)

    #get DG
    expectedHost = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " \
                            |  grep -iE 'matched with Configuration' | awk '{print $9}' ")
    cache = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " |  \
                    grep -iE 'Expected config " + expectedHost.split("\n")[0] + " Cache' | awk '{print $10}' ")
    capacity = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " | \
            grep -iE 'Expected config " + expectedHost.split("\n")[0] + " Capacity' | awk '{print $10}' ")

    DG.append(cache + "+ " + capacity)



def checkDir(testVPXlocation, hn):

    for root,dirs,files in scandir.walk(testVPXlocation):
        for j in dirs:
            if re.search(r'\b'+ hn +'\W', j) or hn in j:
                # need to convert that to relative path
                pattern = currentDir + "/"
                tmpvmkernelFolder = testVPXlocation + "/" + j
                vmkernelFolder = re.sub(pattern,'', tmpvmkernelFolder)
                return vmkernelFolder



#
#  genLogsummary by calling logsummary.py to create log summary for each test
#       need currentPath, actual test-vpx file for c1 and c2
#             testname when executing through logsummary.py and the output
#
def runLogSummary(currentPath, testname):

	# getinfo ----------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log", \
                        "getinfo", "summary-ctrlr_getInfo_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log", \
                    "getinfo", "summary-ctrlr_getInfo_c2.txt")

	# allflash - performance -------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log", \
                                "4k","summary-ctrlr-0r100w_long_4k_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log", \
                                "4k","summary-ctrlr-0r100w_long_4k_af_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log", \
                                "64k","summary-ctrlr-0r100w_long_64k_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log", \
                                "64k","summary-ctrlr-0r100w_long_64k_af_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log", \
                                "50gb","summary-ctrlr-70r30w_long_50gb_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log", \
                                "50gb","summary-ctrlr-70r30w_long_50gb_af_c2.txt")

	if testname =="test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log", \
                                "mdCap","summary-ctrlr-70r30w_long_mdCap_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log", \
                                "mdCap","summary-ctrlr-70r30w_long_mdCap_af_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log", \
                                "af-100r0w", "summary-ctrlr-100r0w_long_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log", \
                                "af-100r0w", "summary-ctrlr-100r0w_long_af_c2.txt")

	# allflash - reset -------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_reset_af.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af.log", \
                                "reset", "summary-ctrlr_reset_af.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log", \
                                "reset", "summary-ctrlr_reset_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log", \
                                "reset", "summary-ctrlr_reset_af_c2.txt")

	# hybrid and allflash - short_IO ---------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c1.log", \
                                "shortio", "summary-ctrlr_short_io_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c2.log", \
                                "shortio", "summary-ctrlr_short_io_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_short_timeout_io_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_timeout_io_c1.log", \
                                "shortio", "summary-ctrlr_short_timeout_io_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_short_timeout_io_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_timeout_io_c2.log", \
                                "shortio", "summary-ctrlr_short_timeout_io_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_short_timeout_io_af_c1.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_timeout_io_af_c1.log", \
                                "shortio", "summary-ctrlr_short_timeout_io_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_short_timeout_io_af_c2.log":
		genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_timeout_io_af_c2.log", \
                                "shortio", "summary-ctrlr_short_timeout_io_af_c2.txt")


	# hybrid and allflash - short_IO with VMFS ---------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_af_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_af_c1.log", \
                                "sharedvmfs", "summary-ctrlr_sharedVmfs_boot_vsanDatastore_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_af_c2.log", \
                                "sharedvmfs", "summary-ctrlr_sharedVmfs_boot_vsanDatastore_af_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_c1.log", \
                                "sharedvmfs", "summary-ctrlr_sharedVmfs_boot_vsanDatastore_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_sharedVmfs_boot_vsanDatastore_c2.log", \
                                "sharedvmfs", "summary-ctrlr_sharedVmfs_boot_vsanDatastore_c2.txt")
	# allflash encryption---------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log", \
                                "af-enc", "summary-ctrlr_70r30w_long_mdCap_enc_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log", \
                                "af-enc", "summary-ctrlr_70r30w_long_mdCap_enc_af_c2.txt")

	# hybrid encryption-----------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log", \
                                "hy-enc", "summary-ctrlr_70r30w_long_99phr_enc_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log", \
                                "hy-enc", "summary-ctrlr_70r30w_long_99phr_enc_c2.txt")

	# allflash - data-integrity ---------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log", \
                                "af-data-integrity", "summary-ctrlr_data_integrity_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log", \
                                "af-data-integrity", "summary-ctrlr_data_integrity_af_c2.txt")

	# allflash - 7day -------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log", \
                                "7day", "summary-ctrlr_7day_stress_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log", \
                                "7day", "summary-ctrlr_7day_stress_af_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_stress_af_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_stress_af_c1.log", \
                                "stress", "summary-ctrlr_stress_af_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_stress_af_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_stress_af_c2.log", \
                                "stress", "summary-ctrlr_stress_af_c2.txt")

	# allflash and hybrid - shorts ------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrl_0r100w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_0r100w_short.log", \
                                "short", "summary-ctrlr_0r100w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_10r90w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_10r90w_short.log", \
                                "short", "summary-ctrlr_10r90w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_30r70w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_30r70w_short.log", \
                                "short", "summary-ctrlr_30r70w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_50r50w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_50r50w_short.log", \
                                "short", "summary-ctrlr_50r50w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_70r30w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_70r30w_short.log", \
                                "short", "summary-ctrlr_70r30w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_90r10w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_90r10w_short.log", \
                                "short", "summary-ctrlr_90r10w_short.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_100r0w_short.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_100r0w_short.log", \
                                "short", "summary-ctrlr_100r0w_short.txt")

	# hybrid - combinedLong ------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c1.log", \
                                "combinedLong","summary-ctrlr_combined_long_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c2.log", \
                                "combinedLong","summary-ctrlr_combined_long_c2.txt")

	# hybrid - reset -------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_reset.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset.log", \
                                "reset", "summary-ctrlr_reset.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_reset_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_c1.log", \
                                "reset", "summary-ctrlr_reset_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_reset_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_c2.log", \
                                "reset", "summary-ctrlr_reset_c2.txt")

	# hybrid - 7day --------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log", \
                                "7day", "summary-ctrlr_7day_stress_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log", \
                                "7day", "summary-ctrlr_7day_stress_c2.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_stress_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_stress_c1.log", \
                                "stress", "summary-ctrlr_stress_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_stress_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_stress_c2.log", \
                                "stress", "summary-ctrlr_stress_c2.txt")

    # Log Compaction -------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.iocert.ctrlr_log_compaction_c1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_log_compaction_c1.log", \
                                "log-compaction", "summary-ctrlr_log_compaction_c1.txt")

	if testname == "test-vpx.vsan.iocert.ctrlr_log_compaction_c2.log":
	    genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_log_compaction_c2.log", \
                                "log-compaction", "summary-ctrlr_log_compaction_c2.txt")

	# Hotplug --------------------------------------------------------------------------------------
	if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log", \
                                "hp-planned", "summary-ctrlr_diskRemoveReinsertPlanned.txt")

	if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log", \
                                "hp-unplanned", "summary-ctrlr_diskRemoveReinsertUnplanned.txt")

	if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log", \
                                "hp-planned", "summary-ctrlr_af_diskRemoveReinsertPlanned.txt")

	if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log":
	    genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log", \
                                "hp-unplanned", "summary-ctrlr_af_diskRemoveReinsertUnplanned.txt")



def main():

    global currentDir

    # check if logsummary.py file exist
    if os.path.isfile("/usr/local/bin/logsummary.py"):
            print "\n\nlogsummary.py exist! ........ [ OK ] \n\n"

            print "\n\nPlease allow some time to scan directories... \n\n"

            #start scanning from the current location
            currentDir = os.getcwd()

            #traverse the directory from Top to bottom
            for root, dirs, files in scandir.walk(currentDir, topdown=True):
                    curPath = root

                    # scan files
                    for fname in files:

                            #scan for test-vpx.vsan* files
                            if re.match(testVPX, fname):
                                    runLogSummary(curPath, fname)



            #write to file; using set to get rid of duplicates in a sorted order
            print "Writing to File... \n"
            writeSummaryToFile(sorted(set(summary)))
            print "\ntimeline-summary.txt has been generated"
            writeSummaryToHTML(sorted(set(summary)))
            print "\ntimeline-summary.html has been generated"


    else:
            print ""
            print " Note: Please copy logsummary.py in /usr/local/bin"
            print ""


if __name__ == "__main__":
	main()
