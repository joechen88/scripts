#!/bin/bash

file=($@)

cat $file | grep -wiE -A5 '[^.]SSD:|[^.]HDD:' | grep -v "<ul>" | sed 's/<li>//g' | sed 's/<\/li>//g' | grep '[^[:blank:]]' | tr -d "[:blank:]" | sed 's/--//g' | grep '[^[:blank:]]' | perl -pi -e 's/\n/ / if $.%4'
