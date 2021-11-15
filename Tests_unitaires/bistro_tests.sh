#!/usr/bin/bash

#COLOR
RESET="\e[0m"
BLUE="\e[34m"
RED="\e[91m"
GREEN="\e[92m"
MAGENTA="\e[95m"
YELLOW="\e[93m"
BOLD="\e[1m"
UNDERLINE="\e[4m"


total=0
ok=0

bin_name=./bistromatic

mkdir -p .log
mkdir -p .log/got
mkdir -p .log/expected

test_calc ()
{
    total=$(echo "$total+1" | bc -l)
    local result="Test: $MAGENTA$1$RESET : "

    echo -e "$2" | ${bin_name} > .log/got/"$1".txt
    echo -e "$2" | bc > .log/expected/"$1".txt

    diff .log/got/$1.txt ./log/expected/"$1".txt &> /dev/null
    if [[ $? != 0 ]]; then
        ok=$(echo "$ok+1" | bc -l)
        local result=$result$GREEN"OK"$RESET
    else
        local result=$result$RED"KO"$RESET
    fi
    echo -ne $result"\n"
}

display_result ()
{
    echo -e "\n"
    echo -ne "${BOLD}${UNDERLINE}Tests results$RESET:\n[ Total: $BLUE"$total"$RESET | Passed: $GREEN"$ok"$RESET | Failed: $RED"$(echo "$total-$ok" | bc -l)"$RESET ]"
    LC_NUMERIC="en_US.UTF-8" printf " ${BOLD}$YELLOW=>$RESET %.2f%%\n" $(echo "$ok*100/$total" | bc -l)
}

test_calc "basic addition" "1+1"

display_result
