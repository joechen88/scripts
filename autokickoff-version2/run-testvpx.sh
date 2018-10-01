#!/bin/bash
#   version=1.0
#   run-testvpx.sh - use to execute testvpx and will handle either 1 host or 2hosts
#
#   To add new test:
#       1. update HY_TESTS or AF_TESTS  - are used for sanity check purpose; in case mixed Config tests are selected
#       2. update checkTest()  as that has the mapping for each test
#




PROG=`basename $0`

ESX_IP=""
ESX_IP2=""
VC_IP=""
NUM_OF_CACHE=""
NUM_OF_CAPACITY=""
NUM_OF_CACHE2=""
NUM_OF_CAPACITY2=""
LOG_LOCATION=""
CONFIG_MODE=""
NUMBER_OF_ESX=""
DEFAULT_TESTVPX_LOCATION=""
TESTVPX=""
KMS=""

#TESTNAME is used in for name mapping
TESTNAME=""
commonPath="vsan/iocert/ctrlr_"
commonPath1="vsan/iocert/ctrl_"

# extract each test and store it in an array - Will be be used for two ESX hosts Config
#IFS=', '; read -ra arrayTestvpx <<< $TESTVPX
numOfHost=0

numOfIncorrectTest=0

#
# ALL_HYBRID_TESTS are used to run FULL testing
# ALL_HYBRID_TESTS are used to run FULL testing
#
ALL_HYBRID_TESTS="Getinfo,All_short_tests,CombineLong,70r30w_long_99phr_enc,Reset-HY,\
ShortIO-HY,Stress-HY"

ALL_AF_TESTS="Getinfo,All_short_tests,100r0w_long_af,0r100w_long_4k_af,0r100w_long_64k_af,\
70r30w_long_50gb_af,70r30w_long_mdCap_af,70r30w_long_mdCap_enc_af,Reset-AF,Data_integrity_af,\
ShortIO-AF,Stress-AF"


#
#  AF_TESTS and HY_TESTS are used for sanity checking purpose
#
HY_TESTS="CombineLong,70r30w_long_99phr_enc,Reset-HY,ShortIO-HY,Stress-HY,Log-Compaction-HY"
AF_TESTS="100r0w_long_af,0r100w_long_4k_af,0r100w_long_64k_af,\
70r30w_long_50gb_af,70r30w_long_mdCap_af,70r30w_long_mdCap_enc_af,Reset-AF,Data_integrity_af,\
ShortIO-AF,Stress-AF,ctrlr_100r0w_long_64k_af_c1,ctrlr_70r30w_long_64k_af_c1,Log-Compaction-af"


displayTest(){
    echo ""
    printf "\nConfig mode: $CONFIG_MODE \n\n"
    IFS=', '; read -ra displayTestNames <<< "$1"
    printf "\nYou have selected: \n"
    for j in "${displayTestNames[@]}"
    do
          printf "$j \n"
    done
    echo -e "\n\n"
}


#sanityCheck - in case if incorrect tests are selected
sanityCheck() {
    IFS=', '; read -ra sanityChk <<< "$1"
    echo ""
    for k in "${sanityChk[@]}"
    do
	if grep -q $k <<< "$2"; then
            numOfIncorrectTest=$((numOfIncorrectTest+1))
            if [ $numOfIncorrectTest -eq 1 ]; then
                displayTest "$1"
                printf "Following test(s) you have selected will not work for $CONFIG_MODE: \n"
            fi
	    printf "$k \n"
        fi
    done
}


usage() {
cat << EOF


    $PROG [flags]

    Flags that take arguments:
    -h|--help:
    -e|--esxhost: IP for ESX host1
    -e2|--esxhost2: IP for ESX host2
    -v|--vsphereip: IP for vSphere host
    -c|--cache: Number of Cache for host1
    -c2|--cache2: Number of Cache for host2
    -p|--capacity: Number of Capacity for host1
    -p2|--capacity2: Number of Capacity for host2
    -p|--capacity: Number of Capacity
    -l|--loglocation: Log Location path
    -k|--kms: KMS IP
    -m|--configmode: hybrid or allflash
    -n|--numofesx: Number of ESX host ( max: 2 )
    -t|--testvpx: Specify IOCert test ie. vsan/iocert/ctrlr_getInfo_c1.py,vsan/iocert/ctrl_100r0w_short.py
    -d|--testvpxlocation: testvpx location

    Usage:

        $PROG <ESX_IP> <VC_IP> <NUM_OF_CACHE> <NUM_OF_CAPACITY> <LOG_LOCATION> <hybrid/allflash> <NUM_OF_ESX_HOST> <TESTVPX DIR>

        $PROG -e 192.168.0.1 -v 192.168.0.2 -c 1 -p 2 -l /workspace/manual.d -m allflash -n 1 -d /manual_run/vpx/tests

        To run specific test:  ie. vsan/iocert/ctrlr_getInfo_c1.py and vsan/iocert/ctrl_100r0w_short.py

        $PROG -e 192.168.0.1 -v 192.168.0.2 -c 1 -p 2 -l /workspace/manual.d -m allflash -n 1 -d /manual_run/vpx/tests -t vsan/iocert/ctrlr_getInfo_c1.py,vsan/iocert/ctrl_100r0w_short.py

EOF
}


# get test that runs on c1 and c2, except for short tests.
checkTest() {
if [ "$1" == "Getinfo" ];then
  TESTNAME="${commonPath}getInfo_c1.py,${commonPath}getInfo_c2.py"
  numOfHost=2
elif [ "$1" == "CombineLong" ];then
  TESTNAME="${commonPath1}combined_long_c1.py,${commonPath1}combined_long_c2.py"
  numOfHost=2
elif [ "$1" == "70r30w_long_99phr_enc" ]; then
  TESTNAME="${commonPath}70r30w_long_99phr_enc_c1.py,${commonPath}70r30w_long_99phr_enc_c2.py"
  numOfHost=2
elif [ "$1" ==  "Reset-HY" ]; then
  TESTNAME="${commonPath}reset_c1.py,${commonPath}reset_c2.py"
  numOfHost=2
elif [ "$1" == "ShortIO-HY" ]; then
  TESTNAME="${commonPath}short_timeout_io_c1.py,${commonPath}short_timeout_io_c2.py"
  numOfHost=2
elif [ "$1" == "Stress-HY" ]; then
  TESTNAME="${commonPath}stress_c1.py,${commonPath}stress_c2.py"
  numOfHost=2
elif [ "$1" == "Log-Compaction-HY" ]; then
  TESTNAME="${commonPath}log_compaction_c1.py,${commonPath}log_compaction_c2.py"
  numOfHost=2
elif [ "$1" == "100r0w_long_af" ]; then
  TESTNAME="${commonPath}100r0w_long_af_c1.py,${commonPath}100r0w_long_af_c2.py"
  numOfHost=2
elif [ "$1" == "0r100w_long_4k_af" ]; then
  TESTNAME="${commonPath}0r100w_long_4k_af_c1.py,${commonPath}0r100w_long_4k_af_c2.py"
  numOfHost=2
elif [ "$1" == "0r100w_long_64k_af" ]; then
  TESTNAME="${commonPath}0r100w_long_64k_af_c1.py,${commonPath}0r100w_long_64k_af_c2.py"
  numOfHost=2
elif [ "$1" == "70r30w_long_50gb_af" ]; then
  TESTNAME="${commonPath}70r30w_long_50gb_af_c1.py,${commonPath}70r30w_long_50gb_af_c2.py"
  numOfHost=2
elif [ "$1" == "70r30w_long_mdCap_af" ]; then
  TESTNAME="${commonPath}70r30w_long_mdCap_af_c1.py,${commonPath}70r30w_long_mdCap_af_c2.py"
  numOfHost=2
elif [ "$1" == "70r30w_long_mdCap_enc_af" ]; then
  TESTNAME="${commonPath}70r30w_long_mdCap_enc_af_c1.py,${commonPath}70r30w_long_mdCap_enc_af_c2.py"
  numOfHost=2
elif [ "$1" == "Reset-AF" ]; then
  TESTNAME="${commonPath}reset_af_c1.py,${commonPath}reset_af_c2.py"
  numOfHost=2
elif [ "$1" == "Data_integrity_af" ]; then
  TESTNAME="${commonPath}data_integrity_af_c1.py,${commonPath}data_integrity_af_c2.py"
  numOfHost=2
elif [ "$1" == "Stress-AF" ]; then
  TESTNAME="${commonPath}stress_af_c1.py,${commonPath}stress_af_c2.py"
  numOfHost=2
elif [ "$1" == "ShortIO-AF" ]; then
  TESTNAME="${commonPath}short_timeout_io_af_c1.py,${commonPath}short_timeout_io_af_c2.py"
  numOfHost=2
elif [ "$1" == "Log-Compaction-af" ]; then
  TESTNAME="${commonPath}log_compaction_c1.py,${commonPath}log_compaction_c2.py"
  numOfHost=2
elif [ "$1" == "All_short_tests" ]; then
  TESTNAME="${commonPath1}100r0w_short.py,${commonPath1}0r100w_short.py,${commonPath1}10r90w_short.py,\
${commonPath1}30r70w_short.py,${commonPath1}50r50w_short.py,${commonPath1}70r30w_short.py,${commonPath1}90r10w_short.py"
  IFS=', '; read -ra shortTests <<< $TESTNAME
  numOfHost=1
elif [ "$1" == "100r0w_short" ]; then
  TESTNAME="${commonPath1}100r0w_short.py"
  numOfHost=1
elif [ "$1" == "0r100w_short" ]; then
  TESTNAME="${commonPath1}0r100w_short.py"
  numOfHost=1
elif [ "$1" == "10r90w_short" ]; then
  TESTNAME="${commonPath1}10r90w_short.py"
  numOfHost=1
elif [ "$1" == "30r70w_short" ]; then
  TESTNAME="${commonPath1}30r70w_short.py"
  numOfHost=1
elif [ "$1" == "50r50w_short" ]; then
  TESTNAME="${commonPath1}50r50w_short.py"
  numOfHost=1
elif [ "$1" == "70r30w_short" ]; then
  TESTNAME="${commonPath1}70r30w_short.py"
  numOfHost=1
elif [ "$1" == "90r10w_short" ]; then
  TESTNAME="${commonPath1}90r10w_short.py"
  numOfHost=1
elif [ "$1" == "ctrlr_100r0w_long_64k_af_c1" ]; then
  TESTNAME="${commonPath}100r0w_long_64k_af_c1.py"
  numOfHost=1
elif [ "$1" == "ctrlr_70r30w_long_64k_af_c1" ]; then
  TESTNAME="${commonPath}70r30w_long_64k_af_c1.py"
  numOfHost=1
else
  TESTNAME=""
  numOfHost=0
fi
}

#
# testVPXcommand is responsible to execute testvpx
# "$1" - testname
# "$2" - number of host to run test on
# "$3" - test folder for logs; ie. /workspace/manual.d/getInfo
testVPXcommand(){
if [ $2 -eq 1 ]; then
     echo ""
     set -x
     $DEFAULT_TESTVPX_LOCATION/test-vpx -i "$1" --esx-hosts=$ESX_IP --vc-host=$VC_IP \
--vc-user='administrator@vsphere.local' --vc-pwd='Admin!23' --esx-user=root --esx-pwd='ca$hc0w' \
--log-dir=$LOG_LOCATION/$3 -x host1_ip=$ESX_IP -x host2_ip=$ESX_IP -x config1_cache=$NUM_OF_CACHE \
-x config2_cache=$NUM_OF_CACHE -x config1_capacity=$NUM_OF_CAPACITY -x config2_capacity=$NUM_OF_CAPACITY
     set +x
elif [ $2 -eq 2 ]; then
     echo ""
     set -x
     $DEFAULT_TESTVPX_LOCATION/test-vpx -i "$1" --esx-hosts=$ESX_IP,$ESX_IP2 --vc-host=$VC_IP \
--vc-user='administrator@vsphere.local' --vc-pwd='Admin!23' --esx-user=root --esx-pwd='ca$hc0w' \
--log-dir=$LOG_LOCATION/$3 -x host1_ip=$ESX_IP -x host2_ip=$ESX_IP2 -x config1_cache=$NUM_OF_CACHE \
-x config2_cache=$NUM_OF_CACHE2 -x config1_capacity=$NUM_OF_CAPACITY -x config2_capacity=$NUM_OF_CAPACITY2
     set +x
fi
}


encryptionTest(){
if [ $2 -eq 1 ]; then
     echo ""
     set -x
     $DEFAULT_TESTVPX_LOCATION/test-vpx -i "$1" --esx-hosts=$ESX_IP --vc-host=$VC_IP \
--vc-user='administrator@vsphere.local' --vc-pwd='Admin!23' --esx-user=root --esx-pwd='ca$hc0w' \
--log-dir=$LOG_LOCATION/$3 --kms-host=$KMS -x host1_ip=$ESX_IP -x host2_ip=$ESX_IP -x config1_cache=$NUM_OF_CACHE \
-x config2_cache=$NUM_OF_CACHE -x config1_capacity=$NUM_OF_CAPACITY -x config2_capacity=$NUM_OF_CAPACITY
     set +x
elif [ $2 -eq 2 ]; then
     echo ""
     set -x
     $DEFAULT_TESTVPX_LOCATION/test-vpx -i "$1" --esx-hosts=$ESX_IP,$ESX_IP2 --vc-host=$VC_IP \
--vc-user='administrator@vsphere.local' --vc-pwd='Admin!23' --esx-user=root --esx-pwd='ca$hc0w' \
--log-dir=$LOG_LOCATION/$3 --kms-host=$KMS -x host1_ip=$ESX_IP -x host2_ip=$ESX_IP2 -x config1_cache=$NUM_OF_CACHE \
-x config2_cache=$NUM_OF_CACHE2 -x config1_capacity=$NUM_OF_CAPACITY -x config2_capacity=$NUM_OF_CAPACITY2
     set +x
fi
}




#
#  Our testvpx framework execute tests randomly in a series.  This is fine on a single host
#  It is not guarantee that the test will simultaneously when execute tests on both hosts.
#  RunTest() will execute testVPX command and determine if it should run on 1 host or 2 hosts
#
#  all tests except encryption test will call testVPXcommand method to execute each test accordingly
#          test will make a directory if testDir does not exist first
#          testVPXcommand <testname-with-mapping-either-1host-or-2host> <number-of-esx-host> <testname>
#
#   encryptTest need to handle slightly different as that has KMS
#
#   2 scenarios:
#         2 hosts: handle encryptionTest, All_short_tests, and all the rest of the tests
#                  All_short_tests and individual short test will only run on 1 host
#
#          1 host: handle encryptionTest, All_short_tests, and all the rest of the tests
#
#
runTest() {

IFS=', '; read -ra arrayTestvpx <<< "$1"
if [ $NUMBER_OF_ESX -eq 2 ]; then
    # kick off each test one at at time on both hosts
    for i in "${arrayTestvpx[@]}"
    do
        checkTest $i
        makeDir $i
        printf "\nNumber of test(s) to be executed: ${#arrayTestvpx[@]} \n\n"
        if [ $numOfHost -eq 2 ]; then
           TEST_FOR_ESX1=$(echo $TESTNAME | cut -d' ' -f1)
           TEST_FOR_ESX2=$(echo $TESTNAME | cut -d' ' -f2)
           if [ $i == "70r30w_long_mdCap_enc_af" ] || [ $i == "70r30w_long_99phr_enc" ]; then
                encryptionTest "$TEST_FOR_ESX1,$TEST_FOR_ESX2" "2" "$i"
           else
                testVPXcommand "$TEST_FOR_ESX1,$TEST_FOR_ESX2" "2" "$i"
           fi
       elif [ $numOfHost -eq 1 ]; then
           # handle ALL-shortTests on 1 host
           if [ $i == "All_short_tests" ]; then
               for ((j=0; j<${#shortTests[@]}; j++))
               do
                   TEST_FOR_ESX1=${shortTests[$j]}
                   TestDirForEachShortTest=$(echo $TEST_FOR_ESX1 | sed 's/vsan\/iocert\/ctrl_//g' | sed 's/.py//g')
                   makeDir "$TestDirForEachShortTest"
                   testVPXcommand "$TEST_FOR_ESX1" "1" "$TestDirForEachShortTest"
               done
           else
               # handle individual short test
               TEST_FOR_ESX1=$(echo $TESTNAME)
               testVPXcommand "$TEST_FOR_ESX1" "1" "$i"
           fi
        else
           echo "cannot find tests"
        fi
    done
elif [ $NUMBER_OF_ESX -eq 1 ]; then
    # kick off each test on 1 host
    for i in "${arrayTestvpx[@]}"
    do
        checkTest $i
        makeDir $i
        printf "\nNumber of test(s) to be executed: ${#arrayTestvpx[@]} \n\n"
        TEST_FOR_ESX1=$(echo $TESTNAME | cut -d' ' -f1)
        if [ $i == "70r30w_long_mdCap_enc_af" ] || [ $i == "70r30w_long_99phr_enc" ]; then
            encryptionTest "$TEST_FOR_ESX1" "1" "$i"
        # handle all shortTests on 1 host
        elif [ "$i" == "All_short_tests" ]; then
            for ((j=0; j<${#shortTests[@]}; j++))
            do
                TEST_FOR_ESX1=${shortTests[$j]}
                
                # strip out vsan/iocert/ctrlr_ and .py in $TEST_FOR_ESX1 to make TestDir
                TestDirForEachShortTest=$(echo $TEST_FOR_ESX1 | sed 's/vsan\/iocert\/ctrl_//g' | sed 's/.py//g')
                makeDir "All_short_tests/$TestDirForEachShortTest"
                testVPXcommand "$TEST_FOR_ESX1" "1" "All_short_tests/$TestDirForEachShortTest"
            done
        else
            testVPXcommand "$TEST_FOR_ESX1" "1" "$i"
       
        fi
    done
#    # kick off each test on 1 host
#    for i in "${arrayTestvpx[@]}"
#    do
#        checkTest $i
#        makeDir $i
#        printf "\nNumber of test(s) to be executed: ${#arrayTestvpx[@]} \n\n"
#        TEST_FOR_ESX1=$(echo $TESTNAME | cut -d' ' -f1)
#        if [ $i == "70r30w_long_mdCap_enc_af" ] || [ $i == "70r30w_long_99phr_enc" ]; then
#            encryptionTest "$TEST_FOR_ESX1" "1" "$i"
#        else
#            testVPXcommand "$TEST_FOR_ESX1" "1" "$i"
#        fi
#        # handle all shortTests on 1 host
#        if [ "$i" == "All_short_tests" ]; then
#            for ((j=1; j<${#shortTests[@]}; j++))
#            do
#                TEST_FOR_ESX1=${shortTests[$j]}
#                TestDirForEachShortTest=$(echo $TEST_FOR_ESX1 | sed 's/vsan\/iocert\/ctrl_//g' | sed 's/.py//g')
#                makeDir "All_short_tests/$TestDirForEachShortTest"
#                testVPXcommand "$TEST_FOR_ESX1" "1" "All_short_tests/$TestDirForEachShortTest"
#            done
#        fi
#    done

fi
}


makeDir() {
    #check if workspace directory exist
    if [ ! -d "$LOG_LOCATION/$1" ]; then
       mkdir -p $LOG_LOCATION/$1
    fi
}

AF1-Host() {
#if not empty, then run individual test
if [ ! -z "$1" ]; then
    displayTest "$1"
    runTest "$1"
else
    displayTest "$ALL_AF_TESTS"
    runTest "$ALL_AF_TESTS" "1"
fi
}

HY1-Host() {
if [ ! -z "$1" ]; then
    displayTest "$1"
    runTest "$1"
else
    displayTest "$ALL_HYBRID_TESTS"
    runTest "$ALL_HYBRID_TESTS" "1"
fi
}

AF2-Host() {
if [ ! -z "$1" ]; then
     displayTest "$1"
     runTest "$1" "2"
else
     displayTest "$ALL_HYBRID_TESTS"
     runTest "$ALL_AF_TESTS" "2"
fi
}


HY2-Host() {
if [ ! -z "$1" ]; then
     displayTest "$1"
     runTest "$1" "2"
else
     displayTest "$ALL_HYBRID_TESTS"
     runTest "$ALL_HYBRID_TESTS" "2"
fi
}


while [ $# -ge 1 ]
do
   case "$1" in
    -h|--help)
       usage
       exit 0
       ;;
    -e|--esxhost)
       shift
       ESX_IP=$1
       ;;
    -e2|--esxhost2)
       shift
       ESX_IP2=$1
       ;;
    -v|--vsphereip)
       shift
       VC_IP=$1
       ;;
    -c|--cache)
       shift
       NUM_OF_CACHE=$1
       ;;
    -p|--capacity)
       shift
       NUM_OF_CAPACITY=$1
       ;;
    -c2|--cache2)
       shift
       NUM_OF_CACHE2=$1
       ;;
    -p2|--capacity2)
       shift
       NUM_OF_CAPACITY2=$1
       ;;
    -l|--loglocation)
       shift
       LOG_LOCATION=$1
       ;;
    -k|--kms)
       shift
       KMS=$1
       ;;
    -m|--configmode)
       shift
       CONFIG_MODE=$1
       ;;
    -n|--numofesx)
       shift
       NUMBER_OF_ESX=$1
       ;;
    -t|--testvpx)
       shift
       TESTVPX=$1
       ;;
    -d|--testvpxlocation)
       shift
       DEFAULT_TESTVPX_LOCATION=$1
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


if [ $CONFIG_MODE == "allflash" ] && [ $NUMBER_OF_ESX == "1" ]; then

    echo "========================================"
    echo "Mode: $CONFIG_MODE"
    echo "Number of ESX host: $NUMBER_OF_ESX"
    echo "ESX IP: $ESX_IP"
    echo "Number of Cache: $NUM_OF_CACHE"
    echo "Number of Capacity: $NUM_OF_CAPACITY"
    echo "VC IP: $VC_IP"
    echo "Log location: $LOG_LOCATION"
    echo "TESTVPX location: $DEFAULT_TESTVPX_LOCATION "
    echo "========================================"
    echo ""
    echo "Execute test(s) on 1 ESX host.  [ ALL-Flash ]"
    echo ""
    sanityCheck $TESTVPX $HY_TESTS
    if [ $numOfIncorrectTest -eq 0 ]; then
         AF1-Host "$TESTVPX"
    else
         printf "\nPlease double-check your test selection(s) !!!! \n\n\n"
         exit
    fi
elif [ $CONFIG_MODE == "hybrid" ] && [ $NUMBER_OF_ESX == "1" ]; then

    echo "========================================"
    echo "Mode: $CONFIG_MODE"
    echo "Number of ESX host: $NUMBER_OF_ESX"
    echo "ESX IP: $ESX_IP"
    echo "Number of Cache: $NUM_OF_CACHE"
    echo "Number of Capacity: $NUM_OF_CAPACITY"
    echo "VC IP: $VC_IP"
    echo "KMS IP: $KMS"
    echo "Log location: $LOG_LOCATION"
    echo "TESTVPX location: $DEFAULT_TESTVPX_LOCATION "
    echo "========================================"
    echo ""
    echo "Execute test(s) on 1 ESX host.  [ Hybrid ]"
    echo ""
    sanityCheck $TESTVPX $AF_TESTS
    if [ $numOfIncorrectTest -eq 0 ]; then
         HY1-Host "$TESTVPX"
    else
         printf "\nPlease double-check your test selection(s) !!!! \n\n\n"
         exit
    fi
elif [ $CONFIG_MODE == "hybrid" ] && [ $NUMBER_OF_ESX == "2" ]; then

    echo "========================================"
    echo "Mode: $CONFIG_MODE"
    echo "Number of ESX host: $NUMBER_OF_ESX"
    echo "ESX IP: $ESX_IP"
    echo "Number of Cache for host1: $NUM_OF_CACHE"
    echo "Number of Capacity for host1: $NUM_OF_CAPACITY"
    echo "ESX2 IP: $ESX_IP2"
    echo "Number of Cache for host2: $NUM_OF_CACHE2"
    echo "Number of Capacity for host2: $NUM_OF_CAPACITY2"
    echo "VC IP: $VC_IP"
    echo "KMS IP: $KMS"
    echo "Log location: $LOG_LOCATION"
    echo "TESTVPX location: $DEFAULT_TESTVPX_LOCATION "
    echo "========================================"
    echo ""
    echo "Execute test(s) on 2 ESX hosts.  [ Hybrid ]"
    echo ""
    sanityCheck $TESTVPX $AF_TESTS
    if [ $numOfIncorrectTest -eq 0 ]; then
         HY2-Host "$TESTVPX"
    else
         printf "\nPlease double-check your test selection(s) !!!! \n\n\n"
         exit
    fi
elif [ $CONFIG_MODE == "allflash" ] && [ $NUMBER_OF_ESX == "2" ]; then

    echo "========================================"
    echo "Mode: $CONFIG_MODE"
    echo "Number of ESX host: $NUMBER_OF_ESX"
    echo "ESX1 IP: $ESX_IP"
    echo "Number of Cache for host1: $NUM_OF_CACHE"
    echo "Number of Capacity for host1: $NUM_OF_CAPACITY"
    echo "ESX2 IP: $ESX_IP2"
    echo "Number of Cache for host2: $NUM_OF_CACHE2"
    echo "Number of Capacity for host2: $NUM_OF_CAPACITY2"
    echo "VC IP: $VC_IP"
    echo "KMS IP: $KMS"
    echo "Log location: $LOG_LOCATION"
    echo "TESTVPX location: $DEFAULT_TESTVPX_LOCATION "
    echo "========================================"
    echo ""
    echo "Execute test(s) on 2 ESX hosts.  [ ALL-Flash ]"
    echo ""
    sanityCheck $TESTVPX $HY_TESTS
    if [ $numOfIncorrectTest -eq 0 ]; then
         AF2-Host "$TESTVPX"
    else
         printf "\nPlease double-check your test selection(s) !!!! \n\n\n"
         exit
    fi
else
    echo ""
    echo "     One or more fields are incorrect!!!"
    echo ""
    echo "     You entered"
    echo ""
    echo "     ========================================"
    echo "     Mode: $CONFIG_MODE"
    echo "     Number of ESX hosti (max 2) : $NUMBER_OF_ESX"
    echo "     ESX1 IP: $ESX_IP"
    echo "     Number of Cache for host1: $NUM_OF_CACHE"
    echo "     Number of Capacity for host1: $NUM_OF_CAPACITY"
    echo "     ESX2 IP: $ESX_IP2"
    echo "     Number of Cache for host2: $NUM_OF_CACHE2"
    echo "     Number of Capacity for host2: $NUM_OF_CAPACITY2"
    echo "     VC IP: $VC_IP"
    echo "     KMS IP: $KMS"
    echo "     Log location: $LOG_LOCATION"
    echo "     ========================================"
    echo ""
fi

#check if workspace directory exist
if [ ! -d "$LOG_LOCATION" ]; then
   mkdir -p $LOG_LOCATION
fi
