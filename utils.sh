#!/bin/bash

PHILO_PARENT_DIR=""
PHILO_DIR="$PHILO_PARENT_DIR/philo"
BONUS_DIR="$PHILO_PARENT_DIR/philo_bonus"

count_lines() {
    local file=$1
    local term=$2
    local count

    if [ ! -f "$file" ]; then
        echo "-1"
        return 1
    fi

    count=$(grep -c "$term" "$file")
    echo "$count"
}

calculate() {
    local a=$1
    local b=$2
    local c=$3

    result=$(((a + b) * c))
    echo "Résultat de (($a + $b) * $c) : $result" | tee -a $LOG_FILE
    echo "$result"
}

check_equality() {
    local a=$1
    local b=$2

    if [ "$a" -eq "$b" ]; then
        echo "$a est égal à $b" | tee -a $LOG_FILE
        return 0
    else
        echo "$a n'est pas égal à $b" | tee -a $LOG_FILE
        return 1
    fi
}

BOLD="\033[1m"
BLACK="\033[30;1m"
RED="\033[31;1m"
GREEN="\033[32;1m"
YELLOW="\033[33;1m"
BLUE="\033[34;1m"
MAGENTA="\033[35;1m"
RESET="\033[0m"

print_header() {
    printf "${YELLOW}\n%s\n${RESET}" "$1"
}

setup_tester() {
    # compiling
    rm -f philo philo_bonus
    make -C ${PHILO_DIR} re
    make -C ${BONUS_DIR} re
    printf "\n"
    cp ${PHILO_DIR}/philo ./ 2>/dev/null
    cp ${BONUS_DIR}/philo_bonus ./ 2>/dev/null
    if [ -f "${PHILO_DIR}/philo" ] && [ -x "${PHILO_DIR}/philo" ]; then
        printf "%-30s$GREEN%-8s$RESET\n" "compiling mandatory" "[OK]"
    else
        printf "%-30s$RED%-8s  \"philo\" not found.$RESET\n\n" "compiling mandatory" "[KO]"
        exit 1
    fi
    if [ -f "${BONUS_DIR}/philo_bonus" ] && [ -x "${BONUS_DIR}/philo_bonus" ]; then
        printf "%-30s$GREEN%-8s$RESET\n" "compiling bonus" "[OK]"
    else
        printf "%-30s$RED%-8s  \"philo_bonus\" not found.$RESET\n\n" "compiling bonus" "[KO]"
    fi

    # norminette
    local mpass=true
    local bpass=true
    if type "norminette" >/dev/null 2>&1; then
        if norminette ${PHILO_DIR} | grep 'Error!' >/dev/null; then
            mpass=false
        fi
        if norminette ${PHILO_DIR} | grep 'Error!' >/dev/null; then
            bpass=false
        fi
        if [ "$mpass" = true ] && [ "$bpass" = true ]; then
            printf "%-30s$GREEN%-8s$RESET\n" "norminette" "[OK]"
        else
            printf "%-30s$RED%-8s$RESET\n" "norminette" "[KO]"
        fi
    else
        printf "$RED$BOLD norminette not found $RESET"
    fi

    printf "\n\n$BOLD$BLUE%-90s%-8s%-8s%-8s%-8s\n$RESET" "TESTNAME" "EAT" "DIE" "TIME" "LEAKS"
    # clear log file
    >"$LOG_FILE"

    exec 2>/dev/null
}
