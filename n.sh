#!/bin/bash



TESTNAME="${commonPath1}100r0w_short.py,${commonPath1}0r100w_short.py,${commonPath1}10r90w_short.py,\
${commonPath1}30r70w_short.py,${commonPath1}50r50w_short.py,${commonPath1}70r30w_short.py,${commonPath1}90r10w_short.py"

IFS=', '; read -ra shortTests <<< $TESTNAME



for ((j=0; j<${#shortTests[@]}; j++))
do
    TEST_FOR_ESX1=${shortTests[$j]}
    printf "$j: $TEST_FOR_ESX1 \n"
done
