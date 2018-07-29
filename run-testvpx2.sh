#!/bin/bash


TESTVPX=""
numOfHost=0
commonPath="vsan/iocert/ctrlr_"

# get test that runs on c1 and c2
checkTest() {
if [ $1 == "Getinfo" ];then
  TESTVPX="${commonPath}getInfo_c1.py,${commonPath}getInfo_c2.py"
  numOfHost=2
elif [ $1 == "CombineLong" ];then
  TESTVPX="${commonPath}combined_long_c1.py,{commonPath}combined_long_c2.py"
  numOfHost=2
elif [ $1 == "70r30w_long_99phr_enc" ]; then
  TESTVPX="${commonPath}70r30w_long_99phr_enc_c1.py,${commonPath}70r30w_long_99phr_enc_c2.py"
  numOfHost=2
elif [ $1 ==  "Reset-HY" ]; then
  TESTVPX="${commonPath}reset_c1.py,${commonPath}reset_c2.py"
  numOfHost=2
elif [ $1 == "ShortIO-HY" ]; then
  TESTVPX="${commonPath}short_timeout_io_c1.py,${commonPath}short_timeout_io_c2.py"
  numOfHost=2
elif [ $1 == "Stress-HY" ]; then
  TESTVPX="${commonPath}stress_c1.py,${commonPath}stress_c2.py"
  numOfHost=2
elif [ $1 == "100r0w_long_af" ]; then
  TESTVPX="${commonPath}100r0w_long_af_c1.py,${commonPath}100r0w_long_af_c2.py"
  numOfHost=2
elif [ $1 == "0r100w_long_4k_af" ]; then
  TESTVPX="${commonPath}0r100w_long_4k_af_c1.py,${commonPath}0r100w_long_4k_af_c2.py"
  numOfHost=2
elif [ $1 == "0r100w_long_64k_af" ]; then
  TESTVPX="${commonPath}0r100w_long_64k_af_c1.py,${commonPath}0r100w_long_64k_af_c2.py"
  numOfHost=2
elif [ $1 == "70r30w_long_50gb_af" ]; then
  TESTVPX="${commonPath}70r30w_long_50gb_af_c1.py,${commonPath}70r30w_long_50gb_af_af_c2.py"
  numOfHost=2
elif [ $1 == "70r30w_long_mdCap_af" ]; then
  TESTVPX="${commonPath}70r30w_long_mdCap_af_c1.py,${commonPath}70r30w_long_mdCap_af_c2.py"
  numOfHost=2
elif [ $1 == "70r30w_long_mdCap_enc_af" ]; then
  TESTVPX="${commonPath}70r30w_long_mdCap_enc_af_c1.py,${commonPath}70r30w_long_mdCap_enc_af_af_c2.py"
  numOfHost=2
elif [ $1 == "Reset-AF" ]; then
  TESTVPX="${commonPath}reset_af_c1.py,${commonPath}reset_af_c2.py"
  numOfHost=2
elif [ $1 == "Data_integrity_af" ]; then
  TESTVPX="${commonPath}data_integrity_af_c1.py,${commonPath}data_integrity_af_c2.py"
  numOfHost=2
elif [ $1 == "Stress-AF" ]; then
  TESTVPX="${commonPath}stress_af_c1.py,${commonPath}stress_af_af_c2.py"
  numOfHost=2
elif [ $1 == "Stress-AF" ]; then
  TESTVPX="${commonPath}short_timeout_io_af_c1.py,${commonPath}short_timeout_io_af_c2.py"
  numOfHost=2
elif [ $1 == "All_short_tests" ]; then
  TESTVPX="${commonPath}100r0w_short.py,${commonPath}0r100w_short.py,${commonPath}10r90w_short.py,${commonPath}30r70w_short.py,${commonPath}50r50w_short.py,${commonPath}70r30w_short.py,${commonPath}90r10w_short.py"
  IFS=', '; read -ra shortTests <<< $TESTVPX
  numOfHost=1
elif [ $1 == "100r0w_short" ]; then
  TESTVPX="${commonPath}100r0w_short.py"
  numOfHost=1
elif [ $1 == "0r100w_short" ]; then
  TESTVPX="${commonPath}0r100w_short.py"
  numOfHost=1
elif [ $1 == "10r90w_short" ]; then
  TESTVPX="${commonPath}10r90w_short.py"
  numOfHost=1
elif [ $1 == "30r70w_short" ]; then
  TESTVPX="${commonPath}30r70w_short.py"
  numOfHost=1
elif [ $1 == "50r50w_short" ]; then
  TESTVPX="${commonPath}50r50w_short.py"
  numOfHost=1
elif [ $1 == "70r30w_short" ]; then
  TESTVPX="${commonPath}70r30w_short.py"
  numOfHost=1
elif [ $1 == "90r10w_short" ]; then
  TESTVPX="${commonPath}90r10w_short.py"
  numOfHost=1
else
  TESTVPX=""
  numOfHost=0
fi
}

echo ""
abc="90r10w_short,100r0w_short,All_short_tests,Getinfo,CombineLong,Reset-HY,70r30w_long_99phr_enc,Stress-HY,Stress-AF"
echo "abc string: $abc"
printf "\n\n"


# extract each test and store it in an array
IFS=', '; read -ra array <<< $abc

# kick off each test on both hosts one at a time
for i in "${array[@]}"
do
  checkTest $i

  if [ $numOfHost = 2 ]; then
    TEST_FOR_ESX1=$(echo $TESTVPX | cut -d' ' -f1)
    TEST_FOR_ESX2=$(echo $TESTVPX | cut -d' ' -f2)
    echo "run  testvpx -i $TEST_FOR_ESX1,$TEST_FOR_ESX2  on ESX1 and ESX2....etc "
    echo "run on both hosts: $numOfHost"
    echo ""
  elif [ $numOfHost = 1 ]; then
    if [ $i == "all_short_tests" ]; then
       for ((j=0; j<${#shortTests[@]}; j++))
       do
          TEST_FOR_ESX1=${shortTests[$j]}
          echo "run testvpx -i $TEST_FOR_ESX1 ESX1 only"
          echo "run on both hosts: $numOfHost"
          echo ""
       done
    else
       TEST_FOR_ESX1=$(echo $TESTVPX)
       echo "joe::"
       echo "run testvpx -i $TEST_FOR_ESX1 ESX1 only"
       echo "run on both hosts: $numOfHost"
       echo ""
    fi
  else
    echo "cannot find tests"

  fi
done
