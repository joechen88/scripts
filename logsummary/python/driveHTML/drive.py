import os,sys,re

drivelink = []
htmlContent = []
newList = []
ssdout = []
hddout = []

def ssd(drive, html):
	#new ssd.txt - collect productID from the new ssd list
	with open(drive, 'r') as readFile:
		for i in readFile:
			drivelink.append(i.split("\n")[0])

	#DriveHTML - collect ssd productID from the drive.html
	with open(html, 'r') as readHtml:
		for j in readHtml:
			if "=ssd" in j:
				#will strip out the links ; ie. productid=39963
				htmlContent.append("productid" + j.split("productid")[1].split("\"")[0])

	#if there's new productID, add to newList
	for i in drivelink:
		if i.split("&")[1].split()[0] not in htmlContent:
			newList.append(i)
	#
	#  add html tags into each new item
	#  FORMAT for SSD:
	#  0-link,  1-Model, 2-ID, 3-Device Type, 4-form factor, 5-interface speed, 6-Performance, 7-Capacity
	#
	for j in newList:
		ssdout.append( "<tr style=\"\">\n<td><a href=\"" + j.split("\t")[0] + "\">" + j.split("\t")[1] + " " + j.split("\t")[2]  \
						+ "</a></td>\n" + "<td>" + j.split("\t")[7] + "GB</td>\n" + "<td>" + j.split("\t")[4] + "</td>" + "\n<td>" \
						+ j.split("\t")[3] +"</td>\n" + "<td>" + j.split("\t")[5] + "G</td>\n" + "<td>" + j.split("\t")[6] + "</td>" )

	print "Number of new items for SSD: ",
	print len(newList)
	print ""

	if len(newList) > 0:
		# write to file
		writeSSD = open("ssdout.txt","w")
		print "Writing to file...."
		for k in ssdout:
			writeSSD.write(k)
		writeSSD.close()
		print "File: ssdout.txt"


def hdd(drive, html):
	#new hdd.txt - collect productID from the new hdd list
	with open(drive, 'r') as readFile:
		for i in readFile:
			drivelink.append(i.split("\n")[0])

	#DriveHTML - collect hdd productID from the drive.html
	with open(html, 'r') as readHtml:
		for j in readHtml:
			if "=hdd" in j:
				#will strip out the links ; ie. productid=39963
				htmlContent.append("productid" + j.split("productid")[1].split("\"")[0])

	for i in drivelink:
		if i.split("&")[1].split()[0] not in htmlContent:
			newList.append(i)

	#
	#  add html tags into each new item
	#  FORMAT for HDD:
	#  0-link,  1-Model, 2-ID, 3-Device Type(sas), 4-form factor(2.5"), 5-interface speed, 6-DriveFormat (512), 7-RPM, 8-Capacity
	#
	for j in newList:
		hddout.append( "<tr style=\"\">\n<td><a href=\"" + j.split("\t")[0] + "\">" + j.split("\t")[1] + " " + j.split("\t")[2] \
						+ "</a>" + " ( " + j.split("\t")[6] + " ) " +"</td>\n" + "<td>" + j.split("\t")[8] + " GB</td>\n" \
						+ "<td>" + j.split("\t")[3] + "</td>" + "\n<td>" + j.split("\t")[5] + "k</td>\n" + "<td>" \
						+ j.split("\t")[7] + "</td>\n" + "<td>" + j.split("\t")[4] + "</td>\n</tr>" )

	print "Number of new items for HDD: ",
	print len(newList)
	print ""

	if len(newList) > 0:
		#write to file
		writeHDD = open("hddout.txt", 'w')
		for i in hddout:
			writeHDD.write(i)
		writeHDD.close()
		print "File: hddout.txt"


def main():
	selection = sys.argv[1]
	drive = sys.argv[2]
	html = sys.argv[3]

	if selection == "ssd" or selection == "hdd":

		if selection == "ssd":
			ssd(drive, html)

		if selection == "hdd":
			hdd(drive, html)
	else:
		print ""
		print "Usage:  python drive.py {hdd/sdd} text-file Drives.html"
		print ""


if __name__ == "__main__":
	main()
