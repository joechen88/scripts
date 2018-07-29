#!/usr/bin/python
#version 1.043
# lightgreen and lightblue theme
import scandir, os, subprocess, re, datetime



testVPX = r"test-vpx.vsan.*"
summaryCTRL = r"summary-ctrl(.*)"
summary = []
summaryForHTML = []
currentDir=""
dateTimeHTML = []
testVPXcompletion = []
vendorUtilGetinfo = []
testVPXpathFile = []

AFconfig=[ 'getInfo_c1', 'getInfo_c2', '100r0w_long_af_c1', '100r0w_long_af_c2', '70r30w_long_mdCap_af_c1', '70r30w_long_mdCap_af_c2', 'short_io_c1', '70r30w_long_mdCap_enc_af_c1', 
           'short_io_c2', '10r90w_short', '100r0w_short', '50r50w_short', '0r100w_short', '70r30w_short', '90r10w_short', '30r70w_short', '70r30w_long_mdCap_enc_af_c2', 
           '70r30w_long_50gb_af_c1', '70r30w_long_50gb_af_c2', '0r100w_long_4k_af_c1', '0r100w_long_4k_af_c2', 
           '7day_stress_af_c1', '7day_stress_af_c2', '0r100w_long_64k_af_c1', '0r100w_long_64k_af_c2', 'reset_af_c1', 'reset_af_c2',
           'data_integrity_af_c1', 'data_integrity_af_c2' ]   

HYconfig=['getInfo_c1', 'getInfo_c2', '30r70w_short', '0r100w_short', '100r0w_short', '50r50w_short', '90r10w_short', '70r30w_short', '10r90w_short', 
          'short_io_c1', 'short_io_c2', '7day_stress_c1', '7day_stress_c2', 'combined_long_c1', 'combined_long_c2', 'reset_c1', 'reset_c2',
          '70r30w_long_99phr_enc_c1', '70r30w_long_99phr_enc_c2']
HotPlug=['diskRemoveReinsertPlanned', 'diskRemoveReinsertUnplanned']
sanityResult = []
IOCertVER = ""
FoundMode = False
modeStatus = ""
getHostname = []




#
#   pipe it to use linux command
#
def cmdline(command):
	process = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	return process.communicate()[0]


def writeSummaryToFile(summary):
        with open("summary.txt", "wb") as s:
                s.write("\n")
                s.write("LogSummary location:")
                s.write("\n\n")
                for i in summary: 
                        s.write(i)

def checkMode(testname):
    #
    # If test is in one of the list elements, it will return the Mode accordinginly
    #
    tmpHY = ['7day_stress_c1', '7day_stress_c2', 'combined_long_c1', 'combined_long_c2', 'reset_c1', 'reset_c2', '70r30w_long_99phr_enc_c1', '70r30w_long_99phr_enc_c2']
        
    tmpAF = ['100r0w_long_af_c1', '100r0w_long_af_c2', '70r30w_long_mdCap_af_c1', '70r30w_long_mdCap_af_c2', 'reset_af_c1', 'reset_af_c2',
             '70r30w_long_50gb_af_c1', '70r30w_long_50gb_af_c2', '0r100w_long_4k_af_c1', '0r100w_long_4k_af_c2', 
             '7day_stress_af_c1', '7day_stress_af_c2', '0r100w_long_64k_af_c1', '0r100w_long_64k_af_c2', '70r30w_long_mdCap_enc_af_c1',
             '70r30w_long_mdCap_enc_af_c2', 'data_integrity_af_c1', 'data_integrity_af_c2']


    # determine the Mode if it's Hybrid or Allflash but going through the list
    if testname in tmpAF:
        modeOutput = "ALLFLASH"
        return modeOutput
    elif testname in tmpHY:
        modeOutput = "HYBRID"
        return modeOutput
    else:
        modeOutput = ""
        return modeOutput


#
# pass in all the completed entries for SanityChecking
#
def TestSanityCheck(sr, iocertver):
    global HYconfig, AFconfig
    tmpHYconfig = []
    tmpAFconfig = []

    #pattern = re.compile(r'_c1|_c2')
    # pattern is used to get rid of _c1 and _c2
    pattern = "_c1|_c2"

    #check IOcert version, enter MODE accordingly, go through the Config list, and remove the entry with a complete.  
    if float(iocertver) >= 4.039:
        if modeStatus == "HYBRID":
            #search and remove entries in the HYConfig list
            for i in sr:
                if i in HYconfig:
                    HYconfig.remove(i)

            # remaining items are the missing test
            # do some cleanup in the string for each item removing _c1 and _c2
            for j in HYconfig:
                tmpHYconfig.append(re.sub(pattern,'', j))

            #Once we get the delta, over tmpHYconfig back to HYconfig 
            HYconfig = sorted(set(tmpHYconfig))



        if modeStatus == "ALLFLASH":
            #search and remove entries in the HYConfig list
            for k in sr:
                if k in AFconfig:
                    AFconfig.remove(k)

            # remaining items are the missing test
            # do some cleanup in the string for each item, remove _c1 and _c2
            for j in AFconfig:
                tmpAFconfig.append(re.sub(pattern,'', j))


            #Once we get the delta, copy tmpHYconfig back to AFconfig 
            AFconfig = sorted(set(tmpAFconfig))



    elif float(iocertver) >= 3.018 and float(iocertver) <= 3.022:
    
        #IOcert 3.022 has everything except encryption and data-integrity
        tmpHY = '70r30w_long_99phr_enc_c1'
        HYconfig.remove(tmpHY)
        tmpHY = '70r30w_long_99phr_enc_c2'
        HYconfig.remove(tmpHY)

        tmpAF = '70r30w_long_mdCap_enc_af_c1'
        AFconfig.remove(tmpAF)
        tmpAF = '70r30w_long_mdCap_enc_af_c2'
        AFconfig.remove(tmpAF)
        tmpAF = 'data_integrity_af_c1'
        AFconfig.remove(tmpAF)
        tmpAF = 'data_integrity_af_c2'
        AFconfig.remove(tmpAF)

        if modeStatus == "HYBRID":

            #search and remove entries in the HYConfig list
            for i in sr:
                if i in HYconfig:
                    HYconfig.remove(i)

            # remaining items are the missing test
            # do some cleanup in the string for each item removing _c1 and _c2
            for j in HYconfig:
                tmpHYconfig.append(re.sub(pattern,'', j))

            #Once we get the delta, over tmpHYconfig back to HYconfig 
            HYconfig = sorted(set(tmpHYconfig))

        if modeStatus == "ALLFLASH":
            #search and remove entries in the HYConfig list
            for i in sr:
                if i in AFconfig:
                    AFconfig.remove(i)

            # remaining items are the missing test
            # do some cleanup in the string for each item, remove _c1 and _c2
            for j in AFconfig:
                tmpAFconfig.append(re.sub(pattern,'', j))

            #Once we get the delta, copy tmpHYconfig back to AFconfig 
            AFconfig = sorted(set(tmpAFconfig))


    #elif float(IOCertVER) == 2.048:
    elif float(iocertver) >= 2.038 and float(iocertver) <= 2.048:

        #IOcert 3.022 has everything except encryption, data-integrity, shortIO
        tmpHY = '70r30w_long_99phr_enc_c1'
        HYconfig.remove(tmpHY)
        tmpHY = '70r30w_long_99phr_enc_c2'
        HYconfig.remove(tmpHY)
        tmpHY = 'short_io_c1'
        HYconfig.remove(tmpHY)
        tmpHY = 'short_io_c2'
        HYconfig.remove(tmpHY)



        tmpAF = '70r30w_long_mdCap_enc_af_c1'
        AFconfig.remove(tmpAF)
        tmpAF = '70r30w_long_mdCap_enc_af_c2'
        AFconfig.remove(tmpAF)
        tmpAF = 'data_integrity_af_c1'
        AFconfig.remove(tmpAF)
        tmpAF = 'data_integrity_af_c2'
        AFconfig.remove(tmpAF)
        tmpAF = 'short_io_c1'
        AFconfig.remove(tmpAF)
        tmpAF = 'short_io_c2'
        AFconfig.remove(tmpAF)

        if modeStatus == "HYBRID":
            #search and remove entries in the HYConfig list
            for i in sr:
                if i in HYconfig:
                    HYconfig.remove(i)

            # remaining items are the missing test
            # do some cleanup in the string; for each item remove _c1 and _c2
            for j in HYconfig:
                tmpHYconfig.append(re.sub(pattern,'', j))

            #Once we get the delta, copy tmpHYconfig back to HYconfig 
            HYconfig = sorted(set(tmpHYconfig))

        if modeStatus == "ALLFLASH":
            #search and remove entries in the HYConfig list
            for i in sr:
                if i in AFconfig:
                    AFconfig.remove(i)

            # remaining items are the missing test
            # do some cleanup in the string for each item, remove _c1 and _c2
            for j in AFconfig:
                tmpAFconfig.append(re.sub(pattern,'', j))

            #Once we get the delta, copy tmpHYconfig back to AFconfig 
            AFconfig = sorted(set(tmpAFconfig))








def writeSummaryToHTML(summary):
    global FoundMode, modeStatus
    missingTest = []
    vmkernelFolder=""

    todayDate = datetime.datetime.now()

    testVPXstatus = ""
    FW = ""
    vendorUtil =""

    Html_file = open("summary.html","w")
    html_start = """
            <!DOCTYPE html>
            <html>
            <head>
            <style>
            table {
                font-family: Helvetica;
                font-size: 70%;
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
                color: green;
                background-color: transparent;
                text-decoration: none;
            }

            a:visited {
                color: grey;
                background-color: transparent;
                text-decoration: none;
            }

            a:hover {
                color: black;
                background-color: transparent;
                text-decoration: none;
            }

            a:active {
                color: black
                background-color: transparent;
                text-decoration: none;
            }

            </style>
            </head>
            <body>
            <h3>LogSumary Links</h3>
            <table>
                <tr>
                    """ 
    Html_file.write(html_start)

      
    for j in range(0, len(summaryForHTML)):
    # summaryFotHTML: Testname, Location, filename, Path+File
    # Note: currently using | to separte the data, there could be a possibility that the dir 
    #       might contain a | character, in that case, use to another delimiter
    #
        testvpx = summaryForHTML[j].split('|')[0]


        # Find Mode (HYBRID or ALLFLASH) - only ONCE
        if FoundMode is False:
            #run TestSanity Checking
            modeStatus = checkMode(testvpx)
            if modeStatus == "":
                FoundMode = False
            else:
                FoundMode = True


        #test that are COMPLETED, will add to sanityResult; will use in Test Sanity Checking later
        if "......COMPLETED" in testVPXcompletion[j] or "RAID1COMPLETED" in testVPXcompletion[j]:
            sanityResult.append(testvpx)


    TestSanityCheck(sanityResult, IOCertVER)  


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

    if modeStatus == "HYBRID":
        missingTest = HYconfig
    if modeStatus == "ALLFLASH":
        missingTest = AFconfig

    html_str5 = """ 
                    <th bgcolor="#A0CFEC">Mode: """ + modeStatus + """ </th>
                    <th bgcolor="#A0CFEC">IOCert Test Suite: """ + IOCertVER + """ </th>
                    <th bgcolor="#A0CFEC">LogSummary created on: """ + todayDate.strftime("%m-%d-%Y") + """ </th>
                </tr>
            </table>
            <table> 
                <tr>
                    <td style="font-weight:bold" bgcolor="#CCCCFF">Test not completed / missing:</td>

                """ 
    Html_file.write(html_str5)

    # populate any missing tests
    for i in missingTest:
        html_str6 = """
        <td bgcolor="#CCCCFF">""" + i + """</td>        
                """
        Html_file.write(html_str6)


    html_str3 = """ 

              </tr>
            </table>
            <table>
              <tr>
                <th bgcolor="#A0CFEC">Test name</th>
                <th bgcolor="#A0CFEC">Date/Time</th>
                <th bgcolor="#A0CFEC">FW Version</th>
                <th bgcolor="#A0CFEC">Vendor Utility</th>
                <th bgcolor="#A0CFEC">Test Status</td>
                <th bgcolor="#A0CFEC">LogSummary</th>
                <th bgcolor="#A0CFEC">Test VPX</th>
                <th bgcolor="#A0CFEC">VMKernel dir</th>
                <th bgcolor="#A0CFEC">Full Path</th>
              </tr>
            """
    # add / increment html links for each test accordingly        
    Html_file.write(html_str3)

    for i in range(0, len(summaryForHTML)):
    # summaryFotHTML: Testname, Location, filename, Path+File
	# Note: currently using | to separte the data, there could be a possibility that the dir 
	#       might contain a | character, in that case, use to another delimiter
	#
        testvpx = summaryForHTML[i].split('|')[0]
        testVPXlocation = summaryForHTML[i].split('|')[1]
        summaryFile = summaryForHTML[i].split('|')[2]
        pathFile = summaryForHTML[i].split('|')[3]



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


        #read testVPXstatus ; if COMPLETED then add testname into sanityResult variable for test Sanity Checking
        if "......COMPLETED" in testVPXcompletion[i] or "RAID1COMPLETED" in testVPXcompletion[i]:
            testVPXstatus = "COMPLETED"
        elif ".....CLEANFAIL" in testVPXcompletion[i]:
            testVPXstatus = "CLEANFAIL"
        elif ".....FAIL" in  testVPXcompletion[i]:
            testVPXstatus = "FAIL"
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


    #
    # Get VMKernel directories
    # From the location where test-vpx exists, scan for directory followed by the Host
    #   that directory will equal to vmkernelFolder
    #
        pattern = currentDir + "/"
        for root,dirs,files in scandir.walk(testVPXlocation):

            #scan for test-vpx.vsan* files
            for j in dirs:
                if j.startswith(getHostname[i][:-1]):
                    tmpvmkernelFolder = testVPXlocation + "/" + j
                    vmkernelFolder = re.sub(pattern,'', tmpvmkernelFolder)
 

        html_str4 = """
               <tr>
                <td>""" + testvpx + """</td>
                <td>""" + dateTimeHTML[i] + """</td>
                <td>""" + vendorUtilGetinfo[i] +"""</td>     
                <td>""" + vendorUtil + """</td>
                <td>""" + testVPXstatus + """</td>
                <td>""" + "<a href=\"./" + subDirFileRelative + "\">" + "summary file" +"""</a> </td>
                <td>""" + "<a href=\"./" + subTestVPXrelative + "\">" + "test-vpx file" +"""</a> </td>
                <td>""" + "<a href=\"./" + vmkernelFolder  + "\">" + "dir" + """</a> </td>
                <td style="text-align:left">""" + pathFile + """</td>
              </tr>
            """
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
    global IOCertVER,getHostname


    print "Found: " + testname
    print "Generating logsummary for " + testname  

    #cd into the directory with double quote around it in case for special characters or spaces 
    cmdline('cd ' + '"' + currentPath + '"' + ' ; logsummary.py -f ' + testname + ' -t '+ ts +' > ' + output)
    print "Location: " + currentPath

    #set path + filename content into variable
    pathFile = currentPath + "/" + output 

    #find patterns and strip it, ie  summary-ctrl_getinfo_c1.txt -> ctrlr_getInfo 
    pattern = re.compile(r'summary-ctrlr_|summary-ctrlr-|.txt')
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
    tmpComplete = cmdline("cat " + "'" + currentPath + "'" + "/" + testname + " | grep -iE 'COMPLETED \(|...cleanfail|...........fail' ")
    testVPXcompletion.append(tmpComplete)

    #get firmware version or firmware revision for HTML only
    tmpvendorUtilGetinfo = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + "| grep -iE 'firmware version|firmware revision' | sort | uniq")
    vendorUtilGetinfo.append(tmpvendorUtilGetinfo)

    #get IOcert version for sanityChecking
    IOCertVER = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " | grep -iE 'Test version' | awk '{print $7}'")

    #get Hostname ; will need it for vmkernel directory ; sed is to remove the period
    tmpHN = cmdline('cat ' + '"' + currentPath + '"' + "/" + testname + " |  grep -iE 'Hosts reserved' | awk '{print $9}' | sed 's/.$//'")
    getHostname.append(tmpHN)



def runLogSummary(currentPath, testname):

                # getinfo ----------------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log", "getinfo", "summary-ctrlr_getInfo_c1.txt")
                        #print "Found: " + testname
                        #print "Generating logsummary for " + testname 
                        #cmdline('cd ' + currentPath + ' ; getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c1.log > summary-ctrlr_getInfo_c1.txt')
                        #pathFile = currentPath + "/" + "summary-ctrlr_getInfo_c1.txt" + "\n"
                        #pattern = re.compile(r'summary-ctrl_|_c1|_c2|summary-|.txt')
                        #tn = re.sub(pattern,'', 'summary-ctrlr_getInfo_c1.txt')
                        #summary.append(tn + ": " + pathFile + "\n")
                        #print "Location: " + currentPath
                        #print "\n"

                if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log", "getinfo", "summary-ctrlr_getInfo_c2.txt")                        
                        #print "Found: " + testname
                        #print "Generating logsummary for " + testname 
                        #cmdline('cd ' + currentPath + ' ; getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c2.log > summary-ctrlr_getInfo_c2.txt')
                        #pathFile = currentPath + "/" + "summary-ctrlr_getInfo_c2.txt" + "\n"
                        #pattern = re.compile(r'summary-ctrl_|_c1|_c2|summary-|.txt')
                        #tn = re.sub(pattern,'', 'summary-ctrlr_getInfo_c2.txt')
                        #summary.append(tn + ": " + pathFile + "\n")
                        #print "Location: " + currentPath
                        #print "\n"

                # allflash - performance -------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log", "4k","summary-ctrlr-0r100w_long_4k_af_c1.txt")
                        
                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log", "4k","summary-ctrlr-0r100w_long_4k_af_c2.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log", "64k","summary-ctrlr-0r100w_long_64k_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log", "64k","summary-ctrlr-0r100w_long_64k_af_c2.txt")

                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log", "50gb","summary-ctrlr-70r30w_long_50gb_af_c1.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log", "50gb","summary-ctrlr-70r30w_long_50gb_af_c2.txt")


                if testname =="test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log", "mdCap","summary-ctrlr-70r30w_long_mdCap_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log", "mdCap","summary-ctrlr-70r30w_long_mdCap_af_c2.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log", "af-100r0w", "summary-ctrlr-100r0w_long_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log", "af-100r0w", "summary-ctrlr-100r0w_long_af_c2.txt")


                # allflash - reset -------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_reset_af.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af.log", "reset", "summary-ctrlr_reset_af.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af_c1.log", "reset", "summary-ctrlr_reset_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_af_c2.log", "reset", "summary-ctrlr_reset_af_c2.txt")

                
                # allflash - short_IO --------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c1.log", "shortio", "summary-ctrlr_short_io_c1.txt")

                if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c2.log", "shortio", "summary-ctrlr_short_io_c2.txt")
  

                # allflash encryption---------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c1.log", "af-enc", "summary-ctrlr_70r30w_long_mdCap_enc_af_c1.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_enc_af_c2.log", "af-enc", "summary-ctrlr_70r30w_long_mdCap_enc_af_c2.txt")

                
                # hybrid encryption-----------------------------------------------------------------------------        
                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c1.log", "hy-enc", "summary-ctrlr_70r30w_long_99phr_enc_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_99phr_enc_c2.log", "hy-enc", "summary-ctrlr_70r30w_long_99phr_enc_c2.txt")


                # allflash - data-integrity --------------------------------------------------------------------- 
                if testname == "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c1.log", "af-data-integrity", "summary-ctrlr_data_integrity_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_data_integrity_af_c2.log", "af-data-integrity", "summary-ctrlr_data_integrity_af_c2.txt")

                
                # allflash - 7day -------------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log", "7day", "summary-ctrlr_7day_stress_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log", "7day", "summary-ctrlr_7day_stress_af_c2.txt")


                # allflash and hybrid - shorts ------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrl_0r100w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_0r100w_short.log", "short", "summary-ctrlr_0r100w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_10r90w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_10r90w_short.log", "short", "summary-ctrlr_10r90w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_30r70w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_30r70w_short.log", "short", "summary-ctrlr_30r70w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_50r50w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_50r50w_short.log", "short", "summary-ctrlr_50r50w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_70r30w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_70r30w_short.log", "short", "summary-ctrlr_70r30w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_90r10w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_90r10w_short.log", "short", "summary-ctrlr_90r10w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_100r0w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_100r0w_short.log", "short", "summary-ctrlr_100r0w_short.txt")


                # hybrid - combinedLong ------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c1.log", "combinedLong","summary-ctrlr_combined_long_c1.txt")

                if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c2.log", "combinedLong","summary-ctrlr_combined_long_c2.txt")


                # hybrid - reset -------------------------------------------------------------------------------

                if testname == "test-vpx.vsan.iocert.ctrlr_reset.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset.log", "reset", "summary-ctrlr_reset.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_reset_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_c1.log", "reset", "summary-ctrlr_reset_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_reset_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_reset_c2.log", "reset", "summary-ctrlr_reset_c2.txt")

                
                # hybrid - shortIO -----------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c1.log", "shortio", "summary-ctrlr_short_io_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_short_io_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_short_io_c2.log", "shortio", "summary-ctrlr_short_io_c2.txt")


                # hybrid - 7day --------------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_c1.log", "7day", "summary-ctrlr_7day_stress_c1.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_c2.log", "7day", "summary-ctrlr_7day_stress_c2.txt")
                        
                # Hotplug --------------------------------------------------------------------------------------        
                if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertPlanned_RAID1.log", "hp-planned", "summary-ctrlr_diskRemoveReinsertPlanned.txt")


                if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.diskRemoveReinsertUnplanned_RAID1.log", "hp-unplanned", "summary-ctrlr_diskRemoveReinsertUnplanned.txt")


                if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertPlanned_RAID1.log", "hp-planned", "summary-ctrlr_diskRemoveReinsertPlanned.txt")


                if testname == "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.fvt.test.lsom.diskmanagement.af_diskRemoveReinsertUnplanned_RAID1.log", "hp-unplanned", "summary-ctrlr_diskRemoveReinsertUnplanned.txt")

                        


        
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
                print "\nSummary.txt has been generated"
                writeSummaryToHTML(sorted(set(summary)))
                print "\nSummary.html has been generated"


        else:
                print ""
                print " Note: Please copy logsummary.py in /usr/local/bin"
                print ""


if __name__ == "__main__":
	main()
