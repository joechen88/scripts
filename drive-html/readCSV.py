import csv,sys

def hdd(csvfile):
#
# 	for HDD: 0-link,    1-Model,     2-ID,    3-Device Type(sas),   4-form factor(2.5"),    5-interface speed,   6-DriveFormat (512),     7-RPM,     8-Capacity
#

    with open(csvfile) as myFile:
        reader = csv.DictReader(myFile)
        for row in reader:
            print(row[''] + "\t" +
    	      row['Model '] + "\t" +
    	      row['Id'] + "\t" +
    	      row['Device Type '] + "\t" +
    	      row['FormFactor'] + "\t" +
    	      row['Interface Speed'] + "\t" +
    	      row['Drivce Format'] + "\t" +
    	      row['RPM'] + "\t" +
    	      row['Capacity'] )
    	#print(row)


def ssd(csvfile):
#
# 	for SSD: 0-link,  1-Model,  2-ID,  3-Device Type,  4-form factor,  5-interface speed,  6-Performance,  7-Capacity
#

    with open(csvfile) as myFile:
        reader = csv.DictReader(myFile)
        for row in reader:
            print(row[''] + "\t" +
    	      row['Model '] + "\t" +
    	      row['ID'] + "\t" +
    	      row['Device Type '] + "\t" +
    	      row['FormFactor'] + "\t" +
    	      row['Interface Speed'] + "\t" +
    	      row['Performance Class'] + "\t" +
    	      row['Capacity'] )

    	    #print(row)



def main():
    selection = sys.argv[1]
    csvfile = sys.argv[2]

    if selection == "ssd" or selection == "hdd":

        if selection == "ssd":
            ssd(csvfile)

    	if selection == "hdd":
    		hdd(csvfile)

    else:
        print("\nUsage:  python readCSV.py {hdd/sdd} csv-file \n")


if __name__ == "__main__":
	main()
