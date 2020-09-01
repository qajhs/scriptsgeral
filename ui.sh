#!/bin/bash
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

HELP_USAGE() {
printf "
Basic usage for ud:
  -d  |> specifying one domain result more clean                 usage: ud -d domain.com/subdomain.domain.com

  -dD |> specifying one domain, result will be more detailed     usage: ud -dD domain.com/subdomain.domain.com

  -u  |> specifying one username result more clean               usage: ud -u username

  -uD |> specifying one username, result will be more detailed   usage: ud -u username
"
}


function execcode {
if [[ -z $1 ]]; then
 printf "[$RED+$NC] Please provide a valid domain\n"
 exit
fi
# Variables
# Validating the domain provided
DOMAIN=$(echo $1 | tr A-Z a-z| cut -d ":" -f2 | sed 's/\///g')
CHECKING_WHO_OWNS=$(/scripts/whoowns $DOMAIN)
if [[ -z $CHECKING_WHO_OWNS ]]; then
   printf "[$RED+$NC] Can't find the domain inside the server.\n"
   exit
fi
# Find user
DOMAIN_USER=$(cat /etc/userdomains | grep ^${DOMAIN} | sed 's/ //g' | cut -d: -f2)

# Getting user datas
CONTACT_EMAIL=$(cat /var/cpanel/users/$DOMAIN_USER| grep ^CONTACTEMAIL= | cut -d\= -f2)
CREATED_DAY=$(cat /var/cpanel/users/$DOMAIN_USER | grep ^STARTDATE= | cut -d\= -f2)
CREATED_DAY_FORMATED=$(date -d @$CREATED_DAY +"%m/%d/%Y")
IP=$(cat /var/cpanel/users/$DOMAIN_USER | grep ^IP= | cut -d\= -f2)
THEME=$(cat /var/cpanel/users/$DOMAIN_USER | grep ^RS= | cut -d\= -f2)
PLAN=$(cat /var/cpanel/users/$DOMAIN_USER | grep ^PLAN= | cut -d\= -f2)
MAIN_DOMAIN=$(cpapi2 --user=$DOMAIN_USER DomainLookup getmaindomain | sed 's/ //g' | grep ^main_domain: | cut -d: -f2)
OWNER=$(cat /var/cpanel/users/$DOMAIN_USER | grep ^OWNER= | cut -d\= -f2)
INODES=$(find $(cat /etc/passwd | grep ^$DOMAIN_USER | rev | cut -d: -f2 | rev) | wc -l)
DOC_ROOT=$(cpapi2 --user=$DOMAIN_USER DomainLookup getdocroot domain=$DOMAIN | sed 's/ //g' | grep ^docroot: | cut -d: -f2)
DISK_USAGE=$(du -sh `cat /etc/passwd | grep ^$DOMAIN_USER | rev | cut -d: -f2 | rev` | awk '{print $1}')
SUBDOMAINS=$(for i in `cpapi2 --user=$DOMAIN_USER SubDomain listsubdomains | sed 's/ //g' | grep ^domain: | cut -d: -f2`; do echo "   Subdomain: $i"; done)
ADDON_DOMAINS=$(for i in `cpapi2 --user=$DOMAIN_USER AddonDomain listaddondomains | sed 's/ //g' | grep ^domain: | cut -d: -f2`; do echo "Addon Domain: $i"; done)
HOSTNAME=$(hostname)
USAGE_CPU=$(/usr/local/cpanel/bin/dcpumonview | grep $DOMAIN_USER | sed -r -e 's@^<tr bgcolor=#[[:xdigit:]]+><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td></tr>$@\3@' -e 's@^<tr><td>Top Process</td><td>(.*)</td><td colspan=3>(.*)</td></tr>$@\1 - \2@' | grep -v % | head -1)
USAGE_MYSQL=$(/usr/local/cpanel/bin/dcpumonview | grep $DOMAIN_USER | sed -r -e 's@^<tr bgcolor=#[[:xdigit:]]+><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td></tr>$@\5@' -e 's@^<tr><td>Top Process</td><td>(.*)</td><td colspan=3>(.*)</td></tr>$@\1 - \2@' | grep -v % | head -1)
USAGE_MEMORY=$(/usr/local/cpanel/bin/dcpumonview | grep $DOMAIN_USER | sed -r -e 's@^<tr bgcolor=#[[:xdigit:]]+><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td><td>(.*)</td></tr>$@\4@' -e 's@^<tr><td>Top Process</td><td>(.*)</td><td colspan=3>(.*)</td></tr>$@\1 - \2@' | grep -v % | head -1)
#########################################################
# Printing everything

printf "
      Server: $HOSTNAME
      Domain: $DOMAIN
      E-mail: $CONTACT_EMAIL
      Inodes: $INODES
    Doc root: $DOC_ROOT
  Disk Usage: $DISK_USAGE
 Main Domain: $MAIN_DOMAIN
 Created Day: $CREATED_DAY_FORMATED
        User: $DOMAIN_USER
       Owner: $OWNER
       Theme: $THEME
        Plan: $PLAN
          IP: $IP
"
if ! [[ -z $DETAILED ]]; then
if [[ -z $USAGE_MYSQL ]] && [[ -z $USAGE_MEMORY ]] && [[ -z $USAGE_CPU ]]; then
    USAGE_MYSQL="0.00"
    USAGE_MEMORY="0.00"
    USAGE_CPU="0.00"
fi
echo -e "

   CPU Usage: $USAGE_CPU
 MySQL Usage: $USAGE_MYSQL
Memory Usage: $USAGE_MEMORY
"
    if ! [[ -z $ADDON_DOMAINS ]]; then
echo "
$ADDON_DOMAINS
"
    fi
        if ! [[ -z $SUBDOMAINS ]]; then
echo "
$SUBDOMAINS
"
    fi
fi

}

case $1 in
  -d ) DETAILED=""; execcode "$2";;
  -dD ) DETAILED=1; execcode "$2";;
  *) echo "[$RED+$NC] Please provide a valid argument"; HELP_USAGE;exit;;
esac
