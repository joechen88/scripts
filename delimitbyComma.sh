#!/bin/sh

text="Hello,World,Questions,Answers,bash shell,script"

IFS=','
for i in `echo "$text"`
	do echo $i;
done


# =====
#    another example
#

# #!/bin/sh

# #oldifs="$IFS"
# IFS=$'\n'
# driveInfoArray=$(vdq -qH | grep -iE "mpx|naa|t10" | awk '{print $2}')
# #IFS="$oldifs"
# echo $driveInfoArray
# IFS=","
# for i in `echo "$driveInfoArray"`
#    do
#        echo $i
# done
