#!/bin/bash
if [[ -z $1 ]]; then
    printf "Provide a valid user\n\n"
    exit
fi
TRUE_USER=$(cat /etc/trueuserowners | cut -d: -f1 | grep $1)
if [[ -z $TRUE_USER ]]; then
    printf "Can't locate user '$1' on the server.\n\n"
    exit
fi


if [[ $1 == "root" ]]; then
    printf "You can also use 'whmlogin', it's already integrated with cPanel servers.\n\n"
    whmapi1 create_user_session user=root service=whostmgrd | grep url: | sed 's/ //g' | sed 's/url:/WHM\ Temp\ URL:\ /'
    printf "\n"
fi
# Checking if account is suspended
SUSP=$(ls -al /var/cpanel/suspended/ | awk '{print $NF}' | sed 1,2d | sed 1d | grep $1)

if [[ -z $SUSP ]]; then
    printf "Account provided is currently suspended \nReason: `cat /var/cpanel/suspended/$1`\n\n"
    exit
fi

# Checking if account is reseller

RESELLER=$(cat /var/cpanel/resellers  | cut -d: -f1 | grep $1)

if [[ -z $RESELLER ]]; then
   whmapi1 create_user_session user=$1 service=cpaneld | grep url: | sed 's/ //g' | sed 's/url:/cPanel\ Temp\ URL:\ /'
else
    whmapi1 create_user_session user=$1 service=cpaneld | grep url: | sed 's/ //g' | sed 's/url:/cPanel\ Temp\ URL:\ /'
    printf "\n"
    whmapi1 create_user_session user=$1 service=whostmgrd | grep url: | sed 's/ //g' | sed 's/url:/WHM\ Temp\ URL:\ /'
fi
