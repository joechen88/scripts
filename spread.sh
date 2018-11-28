#!/bin/bash


links -dump http://www.vegasinsider.com/college-football/matchups/ | grep "[3-5][1-9][0-9]" | grep --color  -iE "31%|32%|33%|34%|35%|36%|37%|38%|39%|40%|41%|42%|43%|44%"
