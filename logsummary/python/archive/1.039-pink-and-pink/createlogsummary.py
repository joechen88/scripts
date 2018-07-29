#!/usr/bin/python
#version 0.36
import scandir, os, subprocess, re



testVPX = r"test-vpx.vsan.*"
summaryCTRL = r"summary-ctrl(.*)"
summary = []
summaryForHTML = []
currentDir=""
dateTimeHTML = []
testVPXcompletion = []



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

def writeSummaryToHTML(summary):
    
    testVPXstatus = ""

    Html_file = open("summary.html","w")
    html_start = """
            <!DOCTYPE html>
            <html>
            <head>
            <style>
            table {
                font-family: Helvetica;

                border-collapse: collapse;
                width: 100%;
            }


            td, th {
                border: 1px solid #FFF5EE;
                text-align: left;
                padding: 6px;
            }

            tr:nth-child(even) {
                background-color: #FFF5EE;
            }

            tr:hover {
                background: #FBBBB9;
            }

            a:link {
                color: blac;
                background-color: transparent;
                text-decoration: none;
            }

            a:visited {
                color: orange;
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
                <th>Test name</th>
                <th>Date/Time</th>
                <th>Test Status</th>
                <th>Link</th>
                <th>Full Path</th>

              </tr>
            """
    # add / increment html links for each test accordingly        
    Html_file.write(html_start)

    for i in range(0, len(summaryForHTML)):
        # summaryFotHTML: Testname, Location, filename, Path+File
	# Note: currently using | to separte the data, there could be a possibility that the dir 
	#       might contain a | character, in that case, use to another delimiter
	#
        testvpx = summaryForHTML[i].split('|')[0]
        tmptestVPXstatus = testVPXcompletion[i]
        summaryFile = summaryForHTML[i].split('|')[2]
        pathFile = summaryForHTML[i].split('|')[3]



        # Need to find out the subdirectory for relative path in HTML,
        # take original path subtract currentPath and get the different of that.   
        #    ie   abc/foo    is orginal directory
        #         abc/foo/hello/output.txt is the current directory + file
        #         abc/foo/hello - abc/foo = hello  
        #         relative of that would be   ./hello/output.txt
        pattern = currentDir + "/"
	#pattern = re.compile(currentDir+"/")
        subDirFileRelative = re.sub(pattern,'', pathFile)


        #read testVPXstatus
        if ".....COMPLETED" in tmptestVPXstatus or "RAID1COMPLETED" in tmptestVPXstatus:
            testVPXstatus = "COMPLETED"
        elif ".....CLEANFAIL" in tmptestVPXstatus:
            testVPXstatus = "CLEANFAILED"
        elif ".....FAIL" in tmptestVPXstatus:
            testVPXstatus = "FAILED"
        else:
            testVPXstatus="UNKNOWN"
 

        html_str2 = """
               <tr>
                <td>""" + testvpx + """</td>
                <td>""" + dateTimeHTML[i] + """</td>
                <td>""" + testVPXstatus +"""</td>
                <td>""" + "<a href=\"./" + subDirFileRelative + "\">" + "link" +"""</a> </td>
                <td>""" + pathFile + """</td>
              </tr>
            """
        Html_file.write(html_str2)
        # add / increment ends here

    html_str3 = """                    

            </table>

            </body>
            </html>
            """

    

    Html_file.write(html_str3)
    Html_file.close()


def genLogsummary(currentPath, testname, ts, output):
    print "Found: " + testname
    print "Generating logsummary for " + testname  

    #cd into the directory with double quote around it in case for special characters or spaces 
    cmdline('cd ' + '"' + currentPath + '"' + ' ; logsummary.py -f ' + testname + ' -t '+ ts +' > ' + output)
    print "Location: " + currentPath

    #set path + filename content into variable
    pathFile = currentPath + "/" + output 

    #find patterns and strip it, ie  summary-ctrl_getinfo_c1.txt -> ctrlr_getInfo 
    pattern = re.compile(r'summary-ctrlr_|_c1|_c2|.txt')
    tn = re.sub(pattern,'', output)

    #update content into summary 
    summary.append(tn + " : " + pathFile + "\n")
    print "\n"

    #collect summary for HTML only
    summaryForHTML.append(tn + "|" + currentPath + "|" + output + "|" + pathFile )

    #get Date/Time for HTML only
    tmpDateTime = cmdline("cat " + "'" + currentPath + "'" + "/" + testname + " | head -1 | awk '{print $1,$2}' ")
    dateTimeHTML.append(tmpDateTime)

    #get completion status in testvpx file for HTML only
    tmpComplete = cmdline("cat " + "'" + currentPath + "'" + "/" + output + " | grep -iE 'completed \(' ")
    testVPXcompletion.append(tmpComplete)


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
