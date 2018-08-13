#
#  get ssd and hdd list
#
#

PROG=`basename $0`

HDD=""
SSD=""

usage() {
cat << EOF


    $PROG [flags]

    Flags that take arguments:
    -h|--help:

    Usage:

        $PROG -d hdd.csv -s ssd.csv

        [ Note: first download hdd.csv and ssd.csv from https://www.vmware.com/resources/compatibility/search.php?deviceCategory=vsanio ]


EOF
}

while [ $# -ge 0 ]
do
   case "$1" in
    -h|--help)
       usage
       exit 0
       ;;
    -d|--hdd)
       shift
       HDD=$1
       ;;
    -s|--ssd)
       shift
       SSD=$1
       ;;
    -*)
       echo "Not implemented: $1" >&2
       exit 1
       ;;
    *)
       break
       exit 0
       ;;
   esac
   shift
done

getHDD(){

    python readCSV.py hdd $HDD > hdd.txt
    python drive.py hdd hdd.txt drives.html
}

getSSD(){
    python readCSV.py ssd $SSD > ssd.txt
    python drive.py ssd ssd.txt drives.html
}


getHDD
getSSD
