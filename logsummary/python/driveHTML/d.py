
import os,sys,re

drivelink = []

def main():
	drive = sys.argv[1]
	with open(drive, 'r') as readFile:
		for i in readFile:
			drivelink.append(i.split("\n")[0])
	#FIeld info:
	# 0 - Product , 1 - Model , 2 - Device Type , 3 - Part number, 4 - Vendor , 5 -FormFactor,
	# 6 - interface Speed, 7 - Performance Class, 8 - Tier, 9- TBW Endurance, 10 - Flash Technology
	# 11 - Capacity, 12 -IODevice, 12 - ID , 13-link
	for k in drivelink:
		print k.split("\t")[1] + "\t",
		print k.split("\t")[2] + "\t",
		print k.split("\t")[4]

if __name__ == "__main__":
	main()
