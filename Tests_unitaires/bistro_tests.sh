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
    local result="Test calcul: $MAGENTA$1$RESET : "

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

test_return_value ()
{
    total=$(echo "$total+1" | bc -l)
    local result="Test return value: $MAGENTA$1$RESET : "

    echo -e "$2" | ${bin_name} > .log/got/"$1".txt

    if [[ $? == 84 ]]; then
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


test_suite ()
{
    echo -e "Starting ${BLUE}${BOLD}${UNDERLINE}$1$RESET tests suite"
}


test_suite "Calculs"

test_calc "basic addition" "1+1"

echo ""
test_suite "Return value"

test_return_value "single letter" "a"
test_return_value "addition with letter" "a+A"
test_return_value "multiple letters with digits" "adqkdjqlsdj777"
test_return_value "basic fail" "1+1"

display_result
