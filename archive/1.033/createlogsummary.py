#!/usr/bin/python
#version 0.31
import scandir, os, subprocess, re



testVPX = r"test-vpx.vsan.*"
summaryCTRL = r"summary-ctrl(.*)"
summary = []


#
#   pipe it to use linux command
#
def cmdline(command):
	process = subprocess.Popen(command,stdout=subprocess.PIPE,shell=True)
	return process.communicate()[0]


def writeSummaryToFile(summary):
        with open("summary.txt", "wb") as s:
                s.write("\n")
                s.write("LogSummary location:")
                s.write("\n\n")
                for i in summary: 
                        s.write(i)


def genLogsummary(currentPath, testname, ts, output):
	print "Found: " + testname
        print "Generating logsummary for " + testname  
	cmdline('cd ' + currentPath + ' ; logsummary.py -f ' + testname + ' -t '+ ts +' > ' + output)
        print "Location: " + currentPath

        #store content into summary
        pathFile = currentPath + "/" + output + "\n"
        pattern = re.compile(r'summary-ctrl_|_c1|_c2|summary-|.txt')
        tn = re.sub(pattern,'', output)
        summary.append(tn + ": " + pathFile + "\n")
	print "\n"

def runLogSummary(currentPath, testname):

                # getinfo ----------------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c1.log":
                        print "Found: " + testname
                        print "Generating logsummary for " + testname 
                        cmdline('cd ' + currentPath + ' ; getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c1.log > summary-ctrlr_getInfo_c1.txt')
                        pathFile = currentPath + "/" + "summary-ctrlr_getInfo_c1.txt" + "\n"
                        pattern = re.compile(r'summary-ctrl_|_c1|_c2|summary-|.txt')
                        tn = re.sub(pattern,'', 'summary-ctrlr_getInfo_c1.txt')
                        summary.append(tn + ": " + pathFile + "\n")
                        print "Location: " + currentPath
                        print "\n"

                if testname == "test-vpx.vsan.iocert.ctrlr_getInfo_c2.log":
                        print "Found: " + testname
                        print "Generating logsummary for " + testname 
                        cmdline('cd ' + currentPath + ' ; getinfo.sh test-vpx.vsan.iocert.ctrlr_getInfo_c2.log > summary-ctrlr_getInfo_c2.txt')
                        pathFile = currentPath + "/" + "summary-ctrlr_getInfo_c2.txt" + "\n"
                        pattern = re.compile(r'summary-ctrl_|_c1|_c2|summary-|.txt')
                        tn = re.sub(pattern,'', 'summary-ctrlr_getInfo_c2.txt')
                        summary.append(tn + ": " + pathFile + "\n")
                        print "Location: " + currentPath
                        print "\n"

                # allflash - performance -------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c1.log", "4k","summary-0r100w_long_4k_af_c1.txt")
                        
                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_4k_af_c2.log", "4k","summary-0r100w_long_4k_af_c2.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c1.log", "64k","summary-0r100w_long_64k_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_0r100w_long_64k_af_c2.log", "64k","summary-0r100w_long_64k_af_c2.txt")

                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c1.log", "50gb","summary-70r30w_long_50gb_af_c1.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_50gb_af_c2.log", "50gb","summary-70r30w_long_50gb_af_c2.txt")


                if testname =="test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c1.log", "mdCap","summary-70r30w_long_mdCap_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_70r30w_long_mdCap_af_c2.log", "mdCap","summary-70r30w_long_mdCap_af_c2.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c1.log", "af-100r0w", "summary-100r0w_long_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_100r0w_long_af_c2.log", "af-100r0w", "summary-100r0w_long_af_c2.txt")


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
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c1.log", "7day", "summary-7day_stress_af_c1.txt")


                if testname == "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrlr_7day_stress_af_c2.log", "7day", "summary-7day_stress_af_c2.txt")


                # allflash and hybrid - shorts ------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrl_0r100w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_0r100w_short.log", "short", "summary-ctrl_0r100w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_10r90w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_10r90w_short.log", "short", "summary-ctrl_10r90w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_30r70w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_30r70w_short.log", "short", "summary-ctrl_30r70w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_50r50w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_50r50w_short.log", "short", "summary-ctrl_50r50w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_70r30w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_70r30w_short.log", "short", "summary-ctrl_70r30w_short.txt")


                if testname == "test-vpx.vsan.iocert.ctrl_90r10w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_90r10w_short.log", "short", "summary-ctrl_90r10w_short.txt")

                        
                if testname == "test-vpx.vsan.iocert.ctrl_100r0w_short.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_100r0w_short.log", "short", "summary-ctrl_100r0w_short.txt")


                # hybrid - combinedLong ------------------------------------------------------------------------
                if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c1.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c1.log", "combinedLong","summary-ctrl_combined_long_c1.txt")

                if testname == "test-vpx.vsan.iocert.ctrl_combined_long_c2.log":
                        genLogsummary(currentPath, "test-vpx.vsan.iocert.ctrl_combined_long_c2.log", "combinedLong","summary-ctrl_combined_long_c2.txt")


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

        # check if logsummary.py file exist
        if os.path.isfile("/usr/local/bin/logsummary.py"):
                print "\n\nlogsummary.py exist! ........ [ OK ] \n\n"

                print "\n\nPlease allow some time to scan the directory... \n\n"

                currentDir = os.getcwd()

                for root, dirs, files in scandir.walk(currentDir, topdown=True):
                        curPath = root

                        for fname in files:
                                if re.match(testVPX, fname):
                                        runLogSummary(curPath, fname)



                #write to file; using set to get rid of duplicates in a sorted order
                print "Writing to File... \n"
                writeSummaryToFile(sorted(set(summary)))
                print "\nSummary.txt has been generated"

        else:
                print ""
                print " Note: Please copy logsummary.py in /usr/local/bin"
                print ""


if __name__ == "__main__":
	main()
