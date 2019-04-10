#!/bin/sh

text="Hello,World,Questions,Answers,bash shell,script"

IFS=','
for i in `echo "$text"`
	do echo $i;
done
