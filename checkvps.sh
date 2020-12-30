#!/bin/bash
#####################################################
#                                                   #
# VPS Data retrieve.                                #
#                                                   #
# Made by Vitor S. (vitor.silveira@hostpapa.com)    #
#                                                   #
#####################################################

NC="\033[0m"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
BROWN="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
LIGHTGREY="\033[0;37m"
BLACKGREY="\033[1;30m"
LIGHTRED="\033[1;31m"
LIGHTGREEN="\033[1;32m"
YELLOW="\033[1;33m"
LIGHTBLUE="\033[1;34m"
LIGHTPURPLE="\033[1;35m"
LIGHTCYAN="\033[1;36m"
WHITE="\033[1;37m"

#####################################################
#                    EXECUTION                      #
#####################################################

_execution() {
    CPANEL_ACCTS=$(cat /etc/trueuserdomains  | cut -d: -f2 | sed 's/ //g' |wc -l)
    CPANEL_ACCTS_NAMES=$(for item in $(cat /etc/trueuserdomains  | cut -d: -f2 | sed 's/ //g'); do printf "\t\t- ${CYAN}$item$NC\n"; done)
    DISK_LIMIT=$(df -h / | tail -1 | awk '{print $2}')
    DISK_USAGE=$(df -h / | tail -1 | awk '{print $3}')
    DISK_AVAILABLE=$(df -h / | tail -1 | awk '{print $4}')
    RAM_LIMIT=$(echo "scale=2; $(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}') / 1024^2" | bc | awk '{print int($1+0.5)}')
    RAM_CUSAGE=$(free -h | awk '{print $3}' | sed 1d | head -1)
    CPANEL_LICENSE_CHECK=$(curl -s https://verify.cpanel.net/app/verify?ip=`hostname -i` | grep '<td align="center">' | sed 1,2d | sed 3,4d | sed 2d | cut -d\> -f2 | cut -d\< -f1)
    
    if [[ $CPANEL_LICENSE_CHECK == "cPanel Admin Cloud" ]]; then
        CPANEL_NUMER_MAX="5 accounts at max"
        elif [[ $CPANEL_LICENSE_CHECK == "cPanel Solo Cloud" ]]; then
        CPANEL_NUMER_MAX="1 account at max"
        elif [[ $CPANEL_LICENSE_CHECK == "cPanel Pro Cloud" ]]; then
        CPANEL_NUMER_MAX="30 accounts at max"
    fi
    printf "
Current cPanel License: $CYAN$CPANEL_LICENSE_CHECK$NC | $CYAN$CPANEL_NUMER_MAX$NC
           Details for: $CYAN`hostname`$NC
             RAM Limit: ${CYAN}$RAM_LIMIT GB $NC
     Current RAM Usage: ${CYAN}$RAM_CUSAGE $NC
            Disk Usage: ${CYAN}$DISK_USAGE$NC
            Disk Limit: ${CYAN}$DISK_LIMIT$NC
        Disk Available: ${CYAN}$DISK_AVAILABLE$NC

       cPanel Accounts: ${CYAN}$CPANEL_ACCTS$NC
$CPANEL_ACCTS_NAMES
"

}



_execution
